Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbaJVJiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 05:38:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix network header breakage during encryption
Date: Wed, 22 Oct 2014 12:33:45 +0300
Message-Id: <1413970425-5829-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141022_113825_417614_50EDBD8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When an IV is generated, only the MAC header is moved back. The network
header location remains the same relative to the skb head, as the new IV
is using headroom space that was reserved in advance.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/wep.c | 2 --
 net/mac80211/wpa.c | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 9181fb6..a4220e9 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -111,8 +111,6 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
 		return newhdr + hdrlen;
 
-	skb_set_network_header(skb, skb_network_offset(skb) +
-				    IEEE80211_WEP_IV_LEN);
 	ieee80211_wep_get_iv(local, keylen, keyidx, newhdr + hdrlen);
 	return newhdr + hdrlen;
 }
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 983527a..12398fde 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -209,8 +209,6 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	pos = skb_push(skb, IEEE80211_TKIP_IV_LEN);
 	memmove(pos, pos + IEEE80211_TKIP_IV_LEN, hdrlen);
-	skb_set_network_header(skb, skb_network_offset(skb) +
-				    IEEE80211_TKIP_IV_LEN);
 	pos += hdrlen;
 
 	/* the HW only needs room for the IV, but not the actual IV */
@@ -434,8 +432,6 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	pos = skb_push(skb, IEEE80211_CCMP_HDR_LEN);
 	memmove(pos, pos + IEEE80211_CCMP_HDR_LEN, hdrlen);
-	skb_set_network_header(skb, skb_network_offset(skb) +
-				    IEEE80211_CCMP_HDR_LEN);
 
 	/* the HW only needs room for the IV, but not the actual IV */
 	if (info->control.hw_key &&
@@ -575,7 +571,6 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 
 	pos = skb_push(skb, cs->hdr_len);
 	memmove(pos, pos + cs->hdr_len, hdrlen);
-	skb_set_network_header(skb, skb_network_offset(skb) + cs->hdr_len);
 
 	return TX_CONTINUE;
 }
-- 
1.9.1

