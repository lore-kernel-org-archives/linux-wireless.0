Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:55022 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYLVPKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 10:10:55 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1943872rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 07:10:54 -0800 (PST)
Date: Mon, 22 Dec 2008 20:44:24 -0800
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Enhancements to dynamic power save.
Message-ID: <20081223044424.GC11534@myhost.users.atheros.com> (sfid-20081222_161107_710545_E957B4A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables mac80211 to send a null frame and also to
check for tim in the beacon if power save is enabled.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   41 ++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/scan.c        |    2 +-
 net/mac80211/wext.c        |   13 +++++++++----
 4 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f3eec98..2038498 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -986,6 +986,9 @@ u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
+void ieee80211_send_nullfunc(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
+			     int powersave);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b23e62b..ca22718 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -568,6 +568,30 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	}
 }
 
+static bool check_tim(struct ieee802_11_elems *elems, u16 aid, bool *is_mc)
+{
+	u8 mask;
+	u8 index, indexn1, indexn2;
+	struct ieee80211_tim_ie *tim = (struct ieee80211_tim_ie *) elems->tim;
+
+	aid &= 0x3fff;
+	index = aid / 8;
+	mask  = 1 << (aid & 7);
+
+	if (tim->bitmap_ctrl & 0x01)
+		*is_mc = true;
+
+	indexn1 = tim->bitmap_ctrl & 0xfe;
+	indexn2 = elems->tim_len + indexn1 - 4;
+
+	if (index < indexn1 || index > indexn2)
+		return false;
+
+	index -= indexn1;
+
+	return !!(tim->virtual_map[index] & mask);
+}
+
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 					   u16 capab, bool erp_valid, u8 erp)
 {
@@ -752,6 +776,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(local->dynamic_ps_timeout));
 		else {
+			ieee80211_send_nullfunc(local, sdata, 1);
 			conf->flags |= IEEE80211_CONF_PS;
 			ieee80211_hw_config(local,
 					    IEEE80211_CONF_CHANGE_PS);
@@ -1729,7 +1754,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
-	bool erp_valid;
+	bool erp_valid, directed_tim, is_mc = false;
 	u8 erp_value = 0;
 
 	/* Process beacon from the current BSS */
@@ -1752,6 +1777,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
+	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
+		directed_tim = check_tim(&elems, ifsta->aid, &is_mc);
+
+		if (directed_tim || is_mc) {
+			if (local->hw.conf.flags && IEEE80211_CONF_PS) {
+				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+				ieee80211_hw_config(local,
+						IEEE80211_CONF_CHANGE_PS);
+				ieee80211_send_nullfunc(local, sdata, 0);
+			}
+		}
+	}
 
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		erp_valid = true;
@@ -2651,10 +2688,12 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local,
 			     dynamic_ps_enable_work);
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
+	ieee80211_send_nullfunc(local, sdata, 1);
 	local->hw.conf.flags |= IEEE80211_CONF_PS;
 
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f5c7c33..a2caeed 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -395,7 +395,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	return RX_QUEUED;
 }
 
-static void ieee80211_send_nullfunc(struct ieee80211_local *local,
+void ieee80211_send_nullfunc(struct ieee80211_local *local,
 				    struct ieee80211_sub_if_data *sdata,
 				    int powersave)
 {
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 673c5d7..6470614 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -871,12 +871,17 @@ set:
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(local->dynamic_ps_timeout));
 		else {
-			if (local->powersave)
+			if (local->powersave) {
+				ieee80211_send_nullfunc(local, sdata, 1);
 				conf->flags |= IEEE80211_CONF_PS;
-			else
+				ret = ieee80211_hw_config(local,
+						IEEE80211_CONF_CHANGE_PS);
+			} else {
 				conf->flags &= ~IEEE80211_CONF_PS;
-			ret = ieee80211_hw_config(local,
-					IEEE80211_CONF_CHANGE_PS);
+				ret = ieee80211_hw_config(local,
+						IEEE80211_CONF_CHANGE_PS);
+				ieee80211_send_nullfunc(local, sdata, 0);
+			}
 		}
 	}
 
-- 
1.6.0.1

