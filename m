Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56849 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbbDNPEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:04:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 04/11] mac80211: extend fast-xmit for more ciphers
Date: Tue, 14 Apr 2015 17:03:42 +0200
Message-Id: <1429023829-3991-5-git-send-email-johannes@sipsolutions.net> (sfid-20150414_170435_040173_186B72BB)
In-Reply-To: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
References: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When crypto is offloaded then in some cases it's all handled
by the device, and in others only some space for the IV must
be reserved in the frame. Handle both of these cases in the
fast-xmit path, up to a limit of 18 bytes of space for IVs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.h | 10 +++++++---
 net/mac80211/tx.c       | 40 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e365f6213702..1d4c73818c54 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -239,6 +239,8 @@ struct sta_ampdu_mlme {
 /* Value to indicate no TID reservation */
 #define IEEE80211_TID_UNRESERVED	0xff
 
+#define IEEE80211_FAST_XMIT_MAX_IV	18
+
 /**
  * struct ieee80211_fast_tx - TX fastpath information
  * @key: key to use for hw crypto
@@ -250,15 +252,17 @@ struct sta_ampdu_mlme {
  * @band: band this will be transmitted on, for tx_info
  * @rcu_head: RCU head to free this struct
  *
- * Try to keep this struct small so it fits into a single cacheline.
+ * This struct is small enough so that the common case (maximum crypto
+ * header length of 8 like for CCMP/GCMP) fits into a single 64-byte
+ * cache line.
  */
 struct ieee80211_fast_tx {
 	struct ieee80211_key *key;
-	u8 hdr[30 + 2 + IEEE80211_CCMP_HDR_LEN +
-	       sizeof(rfc1042_header)];
 	u8 hdr_len;
 	u8 sa_offs, da_offs, pn_offs;
 	u8 band;
+	u8 hdr[30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
+	       sizeof(rfc1042_header)];
 
 	struct rcu_head rcu_head;
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 86d64bd11c01..02aafe1cc121 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2519,10 +2519,11 @@ void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
 	if (!build.key)
 		build.key = rcu_access_pointer(sdata->default_unicast_key);
 	if (build.key) {
-		bool gen_iv, iv_spc;
+		bool gen_iv, iv_spc, mmic;
 
 		gen_iv = build.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV;
 		iv_spc = build.key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+		mmic = build.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC;
 
 		/* don't handle software crypto */
 		if (!(build.key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
@@ -2551,9 +2552,42 @@ void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
 			if (gen_iv || iv_spc)
 				build.hdr_len += IEEE80211_GCMP_HDR_LEN;
 			break;
-		default:
-			/* don't do fast-xmit for these ciphers (yet) */
+		case WLAN_CIPHER_SUITE_TKIP:
+			/* cannot handle MMIC or IV generation in xmit-fast */
+			if (mmic || gen_iv)
+				return;
+			if (iv_spc)
+				build.hdr_len += IEEE80211_TKIP_IV_LEN;
+			break;
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			/* cannot handle IV generation in fast-xmit */
+			if (gen_iv)
+				return;
+			if (iv_spc)
+				build.hdr_len += IEEE80211_WEP_IV_LEN;
+			break;
+		case WLAN_CIPHER_SUITE_AES_CMAC:
+		case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+			WARN(1,
+			     "management cipher suite 0x%x enabled for data\n",
+			     build.key->conf.cipher);
 			return;
+		default:
+			/* we don't know how to generate IVs for this at all */
+			if (WARN_ON(gen_iv))
+				return;
+			/* pure hardware keys are OK, of course */
+			if (!(build.key->flags & KEY_FLAG_CIPHER_SCHEME))
+				break;
+			/* cipher scheme might require space allocation */
+			if (iv_spc &&
+			    build.key->conf.iv_len > IEEE80211_FAST_XMIT_MAX_IV)
+				return;
+			if (iv_spc)
+				build.hdr_len += build.key->conf.iv_len;
 		}
 
 		fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-- 
2.1.4

