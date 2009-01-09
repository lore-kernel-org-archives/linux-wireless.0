Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60031 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZAIMqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:46:42 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 04:46:42 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2] mac80211: Handle power constraint level advertised in 11d+h beacon
Date: Fri, 9 Jan 2009 18:14:15 +0530
Message-ID: <1231505055-14411-1-git-send-email-vasanth@atheros.com> (sfid-20090109_134646_889854_DADCBFDA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses power constraint level while determining the maximum
transmit power, there by it makes sure that any power mitigation
requirement for the channel in the current regulatory domain is met.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/main.c        |   10 ++++++++--
 net/mac80211/mlme.c        |    9 +++++++++
 net/mac80211/spectmgmt.c   |   21 +++++++++++++++++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7ec1333..941cd8d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -703,6 +703,7 @@ struct ieee80211_local {
 	struct timer_list dynamic_ps_timer;
 
 	int user_power_level; /* in dBm */
+	int power_constr_level; /* in dBm */
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
@@ -966,6 +967,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
+void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
+				 u16 capab_info, u8 *pwr_constr_elem,
+				 u8 pwr_constr_elem_len);
 
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b55b997..27f313c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -214,10 +214,16 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
-	if (!local->user_power_level)
+	if (local->sw_scanning)
 		power = chan->max_power;
 	else
-		power = min(chan->max_power, local->user_power_level);
+		power = local->power_constr_level ?
+			(chan->max_power - local->power_constr_level) :
+			chan->max_power;
+
+	if (local->user_power_level)
+		power = min(power, local->user_power_level);
+
 	if (local->hw.conf.power_level != power) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
 		local->hw.conf.power_level = power;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d108c12..f45fcb5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -910,6 +910,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	config_changed |= IEEE80211_CONF_CHANGE_HT;
 
+	local->power_constr_level = 0;
+
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
@@ -1838,6 +1840,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		 * for the BSSID we are associated to */
 		regulatory_hint_11d(local->hw.wiphy,
 			elems.country_elem, elems.country_elem_len);
+
+		/* TODO: IBSS also needs this */
+		if (elems.pwr_constr_elem)
+			ieee80211_handle_pwr_constr(sdata,
+				le16_to_cpu(mgmt->u.probe_resp.capab_info),
+				elems.pwr_constr_elem,
+				elems.pwr_constr_elem_len);
 	}
 
 	ieee80211_bss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index f72bad6..b621e49 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -84,3 +84,24 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 			mgmt->sa, mgmt->bssid,
 			mgmt->u.action.u.measurement.dialog_token);
 }
+
+void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
+				 u16 capab_info, u8 *pwr_constr_elem,
+				 u8 pwr_constr_elem_len)
+{
+	struct ieee80211_conf *conf = &sdata->local->hw.conf;
+
+	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
+		return;
+
+	/* Power constraint IE length should be 1 octet */
+	if (pwr_constr_elem_len != 1)
+		return;
+
+	if ((*pwr_constr_elem <= conf->channel->max_power) &&
+	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
+		sdata->local->power_constr_level = *pwr_constr_elem;
+		ieee80211_hw_config(sdata->local, 0);
+	}
+}
+
-- 
1.5.5.1

