Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:37349 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbBQTIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 14:08:04 -0500
Received: by labpn19 with SMTP id pn19so37711913lab.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 11:08:02 -0800 (PST)
From: Denis Kirjanov <kda@linux-powerpc.org>
To: linux-wireless@vger.kernel.org
Cc: Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH] mac80211: rx: check for the skb_copy_bits() return value
Date: Tue, 17 Feb 2015 22:12:03 +0300
Message-Id: <1424200323-5488-1-git-send-email-kda@linux-powerpc.org> (sfid-20150217_200808_846005_9A0EF378)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 net/mac80211/rx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1101563..4d3ec94 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -685,7 +685,8 @@ static int iwl80211_get_cs_keyid(const struct ieee80211_cipher_scheme *cs,
 	if (skb->len < hdrlen + cs->hdr_len)
 		return -EINVAL;
 
-	skb_copy_bits(skb, hdrlen + cs->key_idx_off, &keyid, 1);
+	if (skb_copy_bits(skb, hdrlen + cs->key_idx_off, &keyid, 1))
+		return -EFAULT;
 	keyid &= cs->key_idx_mask;
 	keyid >>= cs->key_idx_shift;
 
@@ -1128,7 +1129,8 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 			if (rx->skb->len < hdrlen + 8)
 				return RX_DROP_MONITOR;
 
-			skb_copy_bits(rx->skb, hdrlen + 6, &ethertype, 2);
+			if (skb_copy_bits(rx->skb, hdrlen + 6, &ethertype, 2))
+				return RX_DROP_MONITOR;
 			if (ethertype == rx->sdata->control_port_protocol)
 				return RX_CONTINUE;
 		}
@@ -1614,7 +1616,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			 * no need to call ieee80211_wep_get_keyidx,
 			 * it verifies a bunch of things we've done already
 			 */
-			skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
+			if (skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1))
+				return RX_DROP_MONITOR;
 			keyidx = keyid >> 6;
 		}
 
-- 
2.1.3

