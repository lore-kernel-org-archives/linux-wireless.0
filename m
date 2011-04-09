Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35957 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1DIKee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 06:34:34 -0400
Received: by fxm17 with SMTP id 17so2768703fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Apr 2011 03:34:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: consolidate MIC failure report handling
Date: Sat, 9 Apr 2011 12:34:27 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104091234.27305.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mac80211 handles MIC failures differently
depending on whenever they are detected by the stack's
own software crypto or when are handed down from the
driver.

This patch tries to unify both by moving the special
"driver" branch out of mac80211 rx hotpath and into
into the software crypto part. This has also the
advantage that we can run a few more sanity checks
on the data and verify of example that the key type
was indeed TKIP.

BTW: why does the "driver" path check for _auth frames?
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fc2ff78..a1bef0f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2354,47 +2354,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
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
@@ -2738,12 +2697,6 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
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
index f1765de..a2c18b6 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -87,33 +87,35 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
+	if (!ieee80211_has_protected(hdr->frame_control) ||
+	    !ieee80211_is_data_present(hdr->frame_control)) {
+		return RX_CONTINUE;
+	}
+
 	/* No way to verify the MIC if the hardware stripped it */
-	if (status->flag & RX_FLAG_MMIC_STRIPPED)
+	if (status->flag & RX_FLAG_MMIC_STRIPPED) {
+		if (status->flag & RX_FLAG_MMIC_ERROR)
+			goto mic_fail;
+
 		return RX_CONTINUE;
+	}
 
-	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP ||
-	    !ieee80211_has_protected(hdr->frame_control) ||
-	    !ieee80211_is_data_present(hdr->frame_control))
+	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP)
 		return RX_CONTINUE;
 
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
@@ -123,6 +125,11 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
+
+mic_fail:
+	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
+					(void *) skb->data, NULL, GFP_ATOMIC);
+	return RX_DROP_UNUSABLE;
 }
 
 
