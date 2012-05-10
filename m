Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59452 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab2EJKVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 06:21:15 -0400
Received: by bkcji2 with SMTP id ji2so1110657bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 03:21:14 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: fix network header location when adding encryption headers
Date: Thu, 10 May 2012 13:21:09 +0300
Message-Id: <1336645269-9044-1-git-send-email-arik@wizery.com> (sfid-20120510_122119_433630_8A7A82C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the location of the network header when adding encryption
specific headers to a skb. This allows low-level drivers to use the
(now correct) location of the network header.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
John - I'm resending this patch on its own as a v2, to separate it from
the previous series (with the netdev features patch). The netdev patch
will probably have some more back and forth.

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

