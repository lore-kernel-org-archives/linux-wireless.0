Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59009 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2EHTxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:53:49 -0400
Received: by werb10 with SMTP id b10so2233621wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 12:53:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] mac80211: fix network header location when adding encryption headers
Date: Tue,  8 May 2012 22:53:40 +0300
Message-Id: <1336506821-23709-1-git-send-email-arik@wizery.com> (sfid-20120508_215353_437601_AE1B27DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the location of the network header when adding encryption
specific headers to a skb. This allows low-level drivers to use the
(now correct) location of the network header.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/wep.c |    1 +
 net/mac80211/wpa.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 7aa31bb..7cb8d83 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -104,6 +104,7 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, WEP_IV_LEN);
 	memmove(newhdr, newhdr + WEP_IV_LEN, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) + WEP_IV_LEN);
 	ieee80211_wep_get_iv(local, keylen, keyidx, newhdr + hdrlen);
 	return newhdr + hdrlen;
 }
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0ae23c6..9aef9f8 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -202,6 +202,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	pos = skb_push(skb, TKIP_IV_LEN);
 	memmove(pos, pos + TKIP_IV_LEN, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) + TKIP_IV_LEN);
 	pos += hdrlen;
 
 	/* Increase IV for the frame */
@@ -422,6 +423,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	pos = skb_push(skb, CCMP_HDR_LEN);
 	memmove(pos, pos + CCMP_HDR_LEN, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) + CCMP_HDR_LEN);
 
 	/* the HW only needs room for the IV, but not the actual IV */
 	if (info->control.hw_key &&
-- 
1.7.9.5

