Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:55507 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923AbcHBMmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:42:23 -0400
From: Baole Ni <baolex.ni@intel.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, m.chehab@samsung.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
	baolex.ni@intel.com, shivanib134@gmail.com, punitvara@gmail.com,
	joseph.bisch@gmail.com, bhaktipriya96@gmail.com
Subject: [PATCH 0954/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 20:02:21 +0800
Message-Id: <20160802120221.13644-1-baolex.ni@intel.com> (sfid-20160802_144240_814600_724A8931)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/staging/rtl8723au/os_dep/os_intfs.c | 66 ++++++++++++++---------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index b8848c2..eac8edc 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -53,7 +53,7 @@ static int rtw_ips_mode = IPS_NORMAL;
 
 static int rtw_smart_ps = 2;
 
-module_param(rtw_ips_mode, int, 0644);
+module_param(rtw_ips_mode, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rtw_ips_mode, "The default IPS mode");
 
 static int rtw_long_retry_lmt = 7;
@@ -112,62 +112,62 @@ static int rtw_80211d;
 
 static int rtw_regulatory_id = 0xff;/*  Regulatory tab id, 0xff = follow efuse's setting */
 
-module_param(rtw_regulatory_id, int, 0644);
+module_param(rtw_regulatory_id, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 static char *ifname = "wlan%d";
-module_param(ifname, charp, 0644);
+module_param(ifname, charp, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(ifname, "The default name to allocate for first interface");
 
 static char *if2name = "wlan%d";
-module_param(if2name, charp, 0644);
+module_param(if2name, charp, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(if2name, "The default name to allocate for second interface");
 
-module_param(rtw_channel_plan, int, 0644);
-module_param(rtw_chip_version, int, 0644);
-module_param(rtw_rfintfs, int, 0644);
-module_param(rtw_channel, int, 0644);
-module_param(rtw_wmm_enable, int, 0644);
-module_param(rtw_vrtl_carrier_sense, int, 0644);
-module_param(rtw_vcs_type, int, 0644);
-module_param(rtw_busy_thresh, int, 0644);
-module_param(rtw_ht_enable, int, 0644);
-module_param(rtw_cbw40_enable, int, 0644);
-module_param(rtw_ampdu_enable, int, 0644);
-module_param(rtw_rx_stbc, int, 0644);
-module_param(rtw_ampdu_amsdu, int, 0644);
+module_param(rtw_channel_plan, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_chip_version, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_rfintfs, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_channel, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_wmm_enable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_vrtl_carrier_sense, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_vcs_type, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_busy_thresh, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_ht_enable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_cbw40_enable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_ampdu_enable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_rx_stbc, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_ampdu_amsdu, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
-module_param(rtw_lowrate_two_xmit, int, 0644);
+module_param(rtw_lowrate_two_xmit, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
-module_param(rtw_rf_config, int, 0644);
-module_param(rtw_power_mgnt, int, 0644);
-module_param(rtw_smart_ps, int, 0644);
-module_param(rtw_low_power, int, 0644);
-module_param(rtw_wifi_spec, int, 0644);
+module_param(rtw_rf_config, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_power_mgnt, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_smart_ps, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_low_power, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_wifi_spec, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
-module_param(rtw_antdiv_cfg, int, 0644);
+module_param(rtw_antdiv_cfg, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
-module_param(rtw_enusbss, int, 0644);
-module_param(rtw_hwpdn_mode, int, 0644);
-module_param(rtw_hwpwrp_detect, int, 0644);
+module_param(rtw_enusbss, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_hwpdn_mode, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+module_param(rtw_hwpwrp_detect, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
-module_param(rtw_hw_wps_pbc, int, 0644);
+module_param(rtw_hw_wps_pbc, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 
 static uint rtw_max_roaming_times = 2;
-module_param(rtw_max_roaming_times, uint, 0644);
+module_param(rtw_max_roaming_times, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rtw_max_roaming_times, "The max roaming times to try");
 
-module_param(rtw_80211d, int, 0644);
+module_param(rtw_80211d, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rtw_80211d, "Enable 802.11d mechanism");
 
 #ifdef CONFIG_8723AU_BT_COEXIST
-module_param(rtw_btcoex_enable, int, 0644);
+module_param(rtw_btcoex_enable, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rtw_btcoex_enable, "Enable BT co-existence mechanism");
 #endif
 
 static uint rtw_notch_filter;
-module_param(rtw_notch_filter, uint, 0644);
+module_param(rtw_notch_filter, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rtw_notch_filter, "0:Disable, 1:Enable, 2:Enable only for P2P");
-module_param_named(debug, rtw_debug, int, 0444);
+module_param_named(debug, rtw_debug, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug, "Set debug level (1-9) (default 1)");
 
 static int netdev_close(struct net_device *pnetdev);
-- 
2.9.2

