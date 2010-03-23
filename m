Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0CWMtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 08:49:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: add interface for disabling/enabling QoS
Date: Tue, 23 Mar 2010 13:46:56 +0100
Message-Id: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add BSS_CHANGE_QOS and bss_conf->qos_disabled flags to pass to drivers
when want to disable QoS (aka WMM, WME).

When AP do not provide QoS parameters, we should assume that it not
supporting QoS and we should not send QoS frames to it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/mlme.c    |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45d7d44..0315ffc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -144,6 +144,7 @@ struct ieee80211_low_level_stats {
  *	new beacon (beaconing modes)
  * @BSS_CHANGED_BEACON_ENABLED: Beaconing should be
  *	enabled/disabled (beaconing modes)
+ * @BSS_CHANGED_QOS: QoS should be enabled/disabled
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -156,6 +157,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BSSID		= 1<<7,
 	BSS_CHANGED_BEACON		= 1<<8,
 	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
+	BSS_CHANGED_QOS			= 1<<10,
 };
 
 /**
@@ -183,6 +185,7 @@ enum ieee80211_bss_change {
  *	the current band.
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
+ * @qos_disabled: whether QoS (aka WMM) should be disabled or not
  * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
  *	This field is only valid when the channel type is one of the HT types.
  */
@@ -196,6 +199,7 @@ struct ieee80211_bss_conf {
 	bool use_short_preamble;
 	bool use_short_slot;
 	bool enable_beacon;
+	bool qos_disabled;
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..8bd2b05 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1129,8 +1129,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	if (elems.wmm_param)
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
-	else
-		ieee80211_set_wmm_default(sdata);
+	else {
+		changed |= BSS_CHANGED_QOS;
+		bss_conf->qos_disabled = true;
+	}
 
 	local->oper_channel = wk->chan;
 
-- 
1.6.6

