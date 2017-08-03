Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45841 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdHCNZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 09:25:48 -0400
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 2/9] wil6210: allow configuring scan timers
Date: Thu,  3 Aug 2017 16:25:32 +0300
Message-Id: <1501766739-31996-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170803_152550_539050_1CE7B951)
In-Reply-To: <1501766739-31996-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501766739-31996-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Allow setting scan timeout and scan dwell time
through module parameters.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 17 ++++++++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 +-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 77af749..d079533 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -26,6 +26,14 @@
 module_param(disable_ap_sme, bool, 0444);
 MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
 
+static uint scan_dwell_time  = WMI_SCAN_DWELL_TIME_MS;
+module_param(scan_dwell_time, uint, 0644);
+MODULE_PARM_DESC(scan_dwell_time, " Scan dwell time (msec)");
+
+static uint scan_timeout = WIL6210_SCAN_TO_SEC;
+module_param(scan_timeout, uint, 0644);
+MODULE_PARM_DESC(scan_timeout, " Scan timeout (seconds)");
+
 #define CHAN60G(_channel, _flags) {				\
 	.band			= NL80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
@@ -528,8 +536,9 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 
 	(void)wil_p2p_stop_discovery(wil);
 
-	wil_dbg_misc(wil, "Start scan_request 0x%p\n", request);
-	wil_dbg_misc(wil, "SSID count: %d", request->n_ssids);
+	wil_dbg_misc(wil,
+		     "Start scan_request 0x%p, dwell_time %dms, timeout %dsec, SSID count %d\n",
+		     request, scan_dwell_time, scan_timeout, request->n_ssids);
 
 	for (i = 0; i < request->n_ssids; i++) {
 		wil_dbg_misc(wil, "SSID[%d]", i);
@@ -550,10 +559,12 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	}
 
 	wil->scan_request = request;
-	mod_timer(&wil->scan_timer, jiffies + WIL6210_SCAN_TO);
+	mod_timer(&wil->scan_timer,
+		  jiffies + msecs_to_jiffies(1000U * scan_timeout));
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd.scan_type = WMI_ACTIVE_SCAN;
+	cmd.cmd.dwell_time = cpu_to_le32(scan_dwell_time);
 	cmd.cmd.num_channels = 0;
 	n = min(request->n_channels, 4U);
 	for (i = 0; i < n; i++) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d085ccf..ac32284 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -112,7 +112,7 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT (500) /* usec */
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
-#define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
+#define WIL6210_SCAN_TO_SEC		10
 #define WIL6210_DISCONNECT_TO_MS (2000)
 #define WIL6210_RX_HIGH_TRSH_INIT		(0)
 #define WIL6210_RX_HIGH_TRSH_DEFAULT \
-- 
1.9.1
