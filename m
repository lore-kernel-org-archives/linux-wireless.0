Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44113 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab1D3PQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 11:16:20 -0400
Received: by fxm17 with SMTP id 17so3002388fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 08:16:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 30 Apr 2011 15:24:30 +0200
Subject: [PATCH] mac80211: consolidate MIC failure report handling
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, coelho@ti.com,
	arik@wizery.com
Message-Id: <E1QGBu4-0004S0-G9@debian64.daheim> (sfid-20110430_171632_333832_313DE37F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mac80211 handles MIC failures differently
depending on whenever they are detected by the stack's
own software crypto or when are handed down from the
driver.

This patch tries to unify both by moving the special
branch out of mac80211 rx hotpath and into into the
software crypto part. This has the advantage that we
can run a few more sanity checks on the data and verify
if the key type was TKIP. This is very handy because
several devices generate false postive MIC failure
reports. Like carl9170, ath9k and wl12xx:
<http://www.spinics.net/lists/linux-wireless/msg68494.html>
"mac80211: report MIC failure for truncated packets in AP mode"

Cc: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
On Mon, 2011-04-12 at 11:58 +0200, Johannes Berg wrote:
> Also, I think we should run some actual TKIP testing :-)
define "actual" :-D

I've done some testing [with and without the patch] with the
help of tkip_mic_test and I can report that I was notified and
kicked both times in the same situations.
---
 net/mac80211/rx.c  |   47 ---------------------------------------
 net/mac80211/wpa.c |   62 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 48 insertions(+), 61 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 599fa90..13a6697 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2368,47 +2368,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
-static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,
-					    struct ieee80211_rx_data *rx)
-{
-	int keyidx;
-	unsigned int hdrlen;
-
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	if (rx->skb->len >= hdrlen + 4)
-		keyidx = rx->skb->data[hdrlen + 3] >> 6;
-	else
-		keyidx = -1;
-
-	if (!rx->sta) {
-		/*
-		 * Some hardware seem to generate incorrect Michael MIC
-		 * reports; ignore them to avoid triggering countermeasures.
-		 */
-		return;
-	}
-
-	if (!ieee80211_has_protected(hdr->frame_control))
-		return;
-
-	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
-		/*
-		 * APs with pairwise keys should never receive Michael MIC
-		 * errors for non-zero keyidx because these are reserved for
-		 * group keys and only the AP is sending real multicast
-		 * frames in the BSS.
-		 */
-		return;
-	}
-
-	if (!ieee80211_is_data(hdr->frame_control) &&
-	    !ieee80211_is_auth(hdr->frame_control))
-		return;
-
-	mac80211_ev_michael_mic_failure(rx->sdata, keyidx, hdr, NULL,
-					GFP_ATOMIC);
-}
-
 /* TODO: use IEEE80211_RX_FRAGMENTED */
 static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 					struct ieee80211_rate *rate)
@@ -2752,12 +2711,6 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 	if (!prepares)
 		return false;
 
-	if (status->flag & RX_FLAG_MMIC_ERROR) {
-		if (status->rx_flags & IEEE80211_RX_RA_MATCH)
-			ieee80211_rx_michael_mic_report(hdr, rx);
-		return false;
-	}
-
 	if (!consume) {
 		skb = skb_copy(skb, GFP_ATOMIC);
 		if (!skb) {
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index f1765de..9dc3b5f 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -87,42 +87,76 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
-	/* No way to verify the MIC if the hardware stripped it */
-	if (status->flag & RX_FLAG_MMIC_STRIPPED)
+	/*
+	 * it makes no sense to check for MIC errors on anything other
+	 * than data frames.
+	 */
+	if (!ieee80211_is_data_present(hdr->frame_control))
+		return RX_CONTINUE;
+
+	/*
+	 * No way to verify the MIC if the hardware stripped it or
+	 * the IV with the key index. In this case we have solely rely
+	 * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
+	 * MIC failure report.
+	 */
+	if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
+		if (status->flag & RX_FLAG_MMIC_ERROR)
+			goto mic_fail;
+
+		if (!(status->flag & RX_FLAG_IV_STRIPPED))
+			goto update_iv;
+
 		return RX_CONTINUE;
+	}
 
+	/*
+	 * Some hardware seems to generate Michael MIC failure reports; even
+	 * though, the frame was not encrypted with TKIP and therefore has no
+	 * MIC. Ignore the flag them to avoid triggering countermeasures.
+	 */
 	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP ||
-	    !ieee80211_has_protected(hdr->frame_control) ||
-	    !ieee80211_is_data_present(hdr->frame_control))
+	    !(status->flag & RX_FLAG_DECRYPTED))
 		return RX_CONTINUE;
 
+	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && rx->key->conf.keyidx) {
+		/*
+		 * APs with pairwise keys should never receive Michael MIC
+		 * errors for non-zero keyidx because these are reserved for
+		 * group keys and only the AP is sending real multicast
+		 * frames in the BSS. (
+		 */
+		return RX_DROP_UNUSABLE;
+	}
+
+	if (status->flag & RX_FLAG_MMIC_ERROR)
+		goto mic_fail;
+
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len < hdrlen + MICHAEL_MIC_LEN)
 		return RX_DROP_UNUSABLE;
 
 	data = skb->data + hdrlen;
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
-
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
 	michael_mic(key, hdr, data, data_len, mic);
-	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0) {
-		if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-			return RX_DROP_UNUSABLE;
-
-		mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
-						(void *) skb->data, NULL,
-						GFP_ATOMIC);
-		return RX_DROP_UNUSABLE;
-	}
+	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
+		goto mic_fail;
 
 	/* remove Michael MIC from payload */
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
+update_iv:
 	/* update IV in key information to be able to detect replays */
 	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
 	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
+
+mic_fail:
+	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
+					(void *) skb->data, NULL, GFP_ATOMIC);
+	return RX_DROP_UNUSABLE;
 }
 
 
-- 
1.7.4.4

