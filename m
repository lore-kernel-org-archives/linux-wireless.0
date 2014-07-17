Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43888 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaGQOOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:16 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so7721908wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:15 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/15] mac80211: add TDLS QoS param IE on setup-confirm
Date: Thu, 17 Jul 2014 17:14:24 +0300
Message-Id: <1405606471-30128-9-git-send-email-arik@wizery.com> (sfid-20140717_161426_773545_CCEC573A)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When TDLS QoS is supported by the the peer and the local card, add
the WMM parameter IE to the setup-confirm frame. Take the QoS settings
from the current AP, or if unsupported, use the default values from
the specification. This behavior is mandated by IEEE802.11-2012 section
10.22.4.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  20 ++++++++
 net/mac80211/tdls.c       | 124 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 75d17e1..63ab3873 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1001,6 +1001,26 @@ struct ieee80211_vendor_ie {
 	u8 oui_type;
 } __packed;
 
+struct ieee80211_wmm_ac_param {
+	u8 aci_aifsn; /* AIFSN, ACM, ACI */
+	u8 cw; /* ECWmin, ECWmax (CW = 2^ECW - 1) */
+	__le16 txop_limit;
+} __packed;
+
+struct ieee80211_wmm_param_ie {
+	u8 element_id; /* Element ID: 221 (0xdd); */
+	u8 len; /* Length: 24 */
+	/* required fields for WMM version 1 */
+	u8 oui[3]; /* 00:50:f2 */
+	u8 oui_type; /* 2 */
+	u8 oui_subtype; /* 1 */
+	u8 version; /* 1 for WMM version 1.0 */
+	u8 qos_info; /* AP/STA specific QoS info */
+	u8 reserved; /* 0 */
+	/* AC_BE, AC_BK, AC_VI, AC_VO */
+	struct ieee80211_wmm_ac_param ac[4];
+} __packed;
+
 /* Control frames */
 struct ieee80211_rts {
 	__le16 frame_control;
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index bfd8fc4..72eebea 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/ieee80211.h>
+#include <linux/log2.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -93,6 +94,74 @@ static void ieee80211_tdls_add_link_ie(struct ieee80211_sub_if_data *sdata,
 	memcpy(lnkid->resp_sta, rsp_addr, ETH_ALEN);
 }
 
+/* translate numbering in the WMM parameter IE to the mac80211 notation */
+static enum ieee80211_ac_numbers ieee80211_ac_from_wmm(int ac)
+{
+	switch (ac) {
+	default:
+		WARN_ON_ONCE(1);
+	case 0:
+		return IEEE80211_AC_BE;
+	case 1:
+		return IEEE80211_AC_BK;
+	case 2:
+		return IEEE80211_AC_VI;
+	case 3:
+		return IEEE80211_AC_VO;
+	}
+}
+
+static u8 ieee80211_wmm_aci_aifsn(int aifsn, bool acm, int aci)
+{
+	u8 ret;
+
+	ret = aifsn & 0x0f;
+	if (acm)
+		ret |= 0x10;
+	ret |= (aci << 5) & 0x60;
+	return ret;
+}
+
+static u8 ieee80211_wmm_ecw(u16 cw_min, u16 cw_max)
+{
+	return ((ilog2(cw_min + 1) << 0x0) & 0x0f) |
+	       ((ilog2(cw_max + 1) << 0x4) & 0xf0);
+}
+
+static void ieee80211_tdls_add_wmm_param_ie(struct ieee80211_sub_if_data *sdata,
+					    struct sk_buff *skb)
+{
+	struct ieee80211_wmm_param_ie *wmm;
+	struct ieee80211_tx_queue_params *txq;
+	int i;
+
+	wmm = (void *)skb_put(skb, sizeof(*wmm));
+	memset(wmm, 0, sizeof(*wmm));
+
+	wmm->element_id = WLAN_EID_VENDOR_SPECIFIC;
+	wmm->len = sizeof(*wmm) - 2;
+
+	wmm->oui[0] = 0x00; /* Microsoft OUI 00:50:F2 */
+	wmm->oui[1] = 0x50;
+	wmm->oui[2] = 0xf2;
+	wmm->oui_type = 2; /* WME */
+	wmm->oui_subtype = 1; /* WME param */
+	wmm->version = 1; /* WME ver */
+	wmm->qos_info = 0; /* U-APSD not in use */
+
+	/*
+	 * Use the EDCA parameters defined for the BSS, or default if the AP
+	 * doesn't support it, as mandated by 802.11-2012 section 10.22.4
+	 */
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		txq = &sdata->tx_conf[ieee80211_ac_from_wmm(i)];
+		wmm->ac[i].aci_aifsn = ieee80211_wmm_aci_aifsn(txq->aifs,
+							       txq->acm, i);
+		wmm->ac[i].cw = ieee80211_wmm_ecw(txq->cw_min, txq->cw_max);
+		wmm->ac[i].txop_limit = cpu_to_le16(txq->txop);
+	}
+}
+
 static void
 ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
@@ -165,6 +234,56 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 }
 
+static void
+ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
+				 struct sk_buff *skb, const u8 *peer,
+				 bool initiator, const u8 *extra_ies,
+				 size_t extra_ies_len)
+{
+	struct ieee80211_local *local = sdata->local;
+	size_t offset = 0, noffset;
+	struct sta_info *sta;
+	u8 *pos;
+
+	rcu_read_lock();
+
+	sta = sta_info_get(sdata, peer);
+	if (WARN_ON_ONCE(!sta)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	/* add any custom IEs that go before the QoS IE */
+	if (extra_ies_len) {
+		static const u8 before_qos[] = {
+			WLAN_EID_RSN,
+		};
+		noffset = ieee80211_ie_split(extra_ies, extra_ies_len,
+					     before_qos,
+					     ARRAY_SIZE(before_qos),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	/* add the QoS param IE if both the peer and we support it */
+	if (local->hw.queues >= IEEE80211_NUM_ACS &&
+	    test_sta_flag(sta, WLAN_STA_WME))
+		ieee80211_tdls_add_wmm_param_ie(sdata, skb);
+
+	/* add any remaining IEs */
+	if (extra_ies_len) {
+		noffset = extra_ies_len;
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+	}
+
+	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
+
+	rcu_read_unlock();
+}
+
 static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
 				   u8 action_code, u16 status_code,
@@ -183,6 +302,11 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 							   extra_ies_len);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
+		if (status_code == 0)
+			ieee80211_tdls_add_setup_cfm_ies(sdata, skb, peer,
+							 initiator, extra_ies,
+							 extra_ies_len);
+		break;
 	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
 		if (extra_ies_len)
-- 
1.9.1

