Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49448 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYLALoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:44:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 03:44:23 -0800
Date: Mon, 1 Dec 2008 17:17:54 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: Enhancements to dynamic power save.
Message-ID: <20081202011754.GA9382@myhost.users.atheros.com> (sfid-20081201_124427_646417_122C4B13)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is based on Kalle's initial RFC patches on dynamic power save.
Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
frame, it is appropriate to do it from mac80211. 
This patch enables mac80211 to send a null frame and also to
check for tim in the beacon if power save is enabled.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   40 ++++++++++++++++++++++++++++++++++++++--
 net/mac80211/scan.c        |    2 +-
 net/mac80211/wext.c        |   14 ++++++++++----
 4 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ac4779a..d9e3169 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -979,6 +979,9 @@ u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
 void ieee80211_ps_enable_work(struct work_struct *work);
 void ieee80211_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
+void ieee80211_send_nullfunc(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
+			     int powersave);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 437a180..dbc1577 100644
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
+	indexn1 = tim->bitmap_ctrl & 0xfe;
+	indexn2 = elems->tim_len + indexn1 - 4;
+
+	if (index < indexn1 || index > indexn2)
+		return false;
+
+	index -= indexn1;
+
+	if (tim->bitmap_ctrl & 0x01)
+		*is_mc = true;
+
+	return (bool)(tim->virtual_map[index] & mask);
+}
+
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 					   u16 capab, bool erp_valid, u8 erp)
 {
@@ -752,6 +776,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 				  msecs_to_jiffies(local->dynamic_ps_timeout));
 		else {
 			conf->flags |= IEEE80211_CONF_PS;
+			ieee80211_send_nullfunc(local, sdata, 1);
 			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 	}
@@ -1711,7 +1736,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
-	bool erp_valid;
+	bool erp_valid, directed_tim, is_mc = false;
 	u8 erp_value = 0;
 
 	/* Process beacon from the current BSS */
@@ -1734,6 +1759,15 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
+	directed_tim = check_tim(&elems, ifsta->aid, &is_mc);
+
+	if (directed_tim || is_mc) {
+		if (local->hw.conf.flags && IEEE80211_CONF_PS) {
+			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+			ieee80211_send_nullfunc(local, sdata, 0);
+		}
+	}
 
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		erp_valid = true;
@@ -2616,13 +2650,15 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 
 void ieee80211_ps_enable_work(struct work_struct *work)
 {
-	struct ieee80211_local *local = container_of(work,
+	struct ieee80211_local *local =	container_of(work,
 						     struct ieee80211_local,
 						     ps_enable_work);
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
 	if (local->hw.conf.flags && IEEE80211_CONF_PS)
 		return;
 
+	ieee80211_send_nullfunc(local, sdata, 1);
 	local->hw.conf.flags |= IEEE80211_CONF_PS;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 }
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
index 9e74e9f..254fb4e 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -985,12 +985,18 @@ set:
 	local->powersave = ps;
 
 	if (ifsta->flags && IEEE80211_STA_ASSOCIATED) {
-		if (local->powersave)
+		if (local->powersave) {
+			ieee80211_send_nullfunc(local, sdata, 1);
 			conf->flags |= IEEE80211_CONF_PS;
-		else
+			ret = ieee80211_hw_config(local,
+						  IEEE80211_CONF_CHANGE_PS);
+			}
+		else {
 			conf->flags &= ~IEEE80211_CONF_PS;
-
-		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+			ret = ieee80211_hw_config(local,
+						  IEEE80211_CONF_CHANGE_PS);
+			ieee80211_send_nullfunc(local, sdata, 0);
+		}
 	}
 	return ret;
 }
-- 
1.6.0.1

