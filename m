Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYCMAIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:08:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Date: Wed, 12 Mar 2008 17:05:58 -0700
Message-Id: <1205366762-12828-2-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000851_674070_9791BFFD)
In-Reply-To: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes the mac80211 able to send a ready phase2 key to the low
level driver for TKIP encryption. Iwlwifi needs to get a phase2 key to
encrypt TX packets in HW.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/wpa.c     |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5ab6a35..a0c7cd7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -287,6 +287,7 @@ struct ieee80211_tx_control {
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
+	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
 	int type;	/* internal */
 };
 
@@ -586,11 +587,15 @@ enum ieee80211_key_alg {
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
+ * @IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY: This flag should be set by
+ *	the driver for a TKIP key if it requires a phase2 TX key generation
+ *	in SW. The key will be attached to each packet.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
+	IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY = 1<<3,
 };
 
 /**
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index db6b72b..ee9c5cf 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -224,6 +224,9 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 		/* hwaccel - with preallocated room for IV */
 		ieee80211_tkip_add_iv(pos, key);
 
+		if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
+			ieee80211_tkip_gen_rc4key(key, hdr->addr2,
+						tx->control->tkip_key);
 		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
 	}
-- 
1.5.3.4

