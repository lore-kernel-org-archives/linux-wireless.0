Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45350 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727599AbeHaMiE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:11 +0300
Message-Id: <20180831083130.15525-10-luca@coelho.fi> (sfid-20180831_103155_573128_7D703B85)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 09/28] mac80211: pass the TWT support bits in extended caps to the driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The Target Wake Time is a feature define in 11ah but has
been enhanced in 802.11ax. 802.11ax D3.0 defines in 9.4.2.27
two bits in the Extended Capabilities IE that the low level
driver needs to be aware of: bits 77 and 78.

Through those bits, the AP can advertise if it supports the
feature. Since those bits are present in the HE Cap as well,
we can set the capability bits in the Extended
Capabilities IE based on what is advertised in the HE Cap IE.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 4 ++++
 include/net/mac80211.h    | 6 ++++++
 net/mac80211/cfg.c        | 7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 17ea51d088ae..0c9d6d0a9d47 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2633,6 +2633,10 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA9_FTM_INITIATOR	BIT(7)
 
+/* Defines support for TWT Requester and TWT Responder */
+#define WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT	BIT(5)
+#define WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT	BIT(6)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 03e1dfd311f7..06e596215abc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1844,6 +1844,10 @@ struct ieee80211_sta_rates {
  *	unlimited.
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
+ * @twt_req_support: indicates whether the STA advertised support for TWT
+ *	requester in the Extended Capabilities element.
+ * @twt_resp_support: indicates whether the STA advertised support for TWT
+ *	responder in the Extended Capabilities element.
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
  *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
  */
@@ -1885,6 +1889,8 @@ struct ieee80211_sta {
 	u16 max_amsdu_len;
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
+	bool twt_req_support;
+	bool twt_resp_support;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1813c6f148bb..884b2b29d2a2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1332,6 +1332,13 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		}
 	}
 
+	if (params->ext_capab_len >= 10) {
+		sta->sta.twt_req_support = params->ext_capab[9] &
+			WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT;
+		sta->sta.twt_resp_support = params->ext_capab[9] &
+			WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT;
+	}
+
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID
 	 * only when creating a new station entry
-- 
2.18.0
