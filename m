Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1DKQQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 12:16:33 -0400
Received: by bwz15 with SMTP id 15so4625742bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 09:16:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC v2] mac80211: consolidate MIC failure report handling
Date: Mon, 11 Apr 2011 18:16:22 +0200
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
References: <201104091234.27305.chunkeey@googlemail.com> <1302529173.6487.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1302529173.6487.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104111816.22932.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 April 2011 15:39:33 Johannes Berg wrote:
> On Sat, 2011-04-09 at 12:34 +0200, Christian Lamparter wrote:
> > diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
> > index f1765de..a2c18b6 100644
> > --- a/net/mac80211/wpa.c
> > +++ b/net/mac80211/wpa.c
> > @@ -87,33 +87,35 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
> >  	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
> >  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> >  
> > +	if (!ieee80211_has_protected(hdr->frame_control) ||
> > +	    !ieee80211_is_data_present(hdr->frame_control)) {
> > +		return RX_CONTINUE;
> > +	}
> 
> But is this check correct? What if the driver _completely_ pretends that the
> frame wasn't encrypted? Do we strictly require that it leaves the protected
> bit set?

OnT: It looks like this patch might also help to relieve ath9k & ath9k_htc of
some workarounds. see: 56363ddeeed "ath9k: fix spurious MIC failure reports".
(ath5k seems to be fine though?!)

BTW: what to do about this?
-       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
-               /*
-                * APs with pairwise keys should never receive Michael MIC
-                * errors for non-zero keyidx because these are reserved for
-                * group keys and only the AP is sending real multicast
-                * frames in the BSS.
-                */
-               return; [Drop Unusable]
-       }
for now, I've kept the code. But I'm not quite sure why, at least
I couldn't find the passage in the spec that says "GTK MIC failures in AP mode
can be ignored" [Although, 8.5.1 (see "196 hole")& 8.3.2.3 (last sentence)
hint in this direction]?

Regards,
	Christian
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
 
 
