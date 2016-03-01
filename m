Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31382 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbcCARSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:32 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 05/15] wil6210: add support for discovery mode during scan
Date: Tue,  1 Mar 2016 19:18:08 +0200
Message-Id: <1456852698-26808-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181840_143944_F169D236)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add support for discovery mode during scan. When discovery mode
is active, station transmits special beacons while scanning.
This can optimize the scan mainly when there is only one AP/PCP
around.
Discovery mode is implicitly used by firmware during P2P search.
Since there is currently no use case where user space has a
reason to directly control discovery mode, we expose it only
through a debugfs flag.
Also fix name confusion in the wmi_scan_type enumeration.
The type previously called WMI_LONG_SCAN is actually
WMI_ACTIVE_SCAN.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 6 ++++++
 drivers/net/wireless/ath/wil6210/debugfs.c  | 6 ++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  | 1 +
 drivers/net/wireless/ath/wil6210/wmi.h      | 7 ++++---
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ddadda9..1ccf136 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -319,6 +319,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	mod_timer(&wil->scan_timer, jiffies + WIL6210_SCAN_TO);
 
 	memset(&cmd, 0, sizeof(cmd));
+	cmd.cmd.scan_type = WMI_ACTIVE_SCAN;
 	cmd.cmd.num_channels = 0;
 	n = min(request->n_channels, 4U);
 	for (i = 0; i < n; i++) {
@@ -346,6 +347,11 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	if (rc)
 		goto out;
 
+	if (wil->discovery_mode && cmd.cmd.scan_type == WMI_ACTIVE_SCAN) {
+		cmd.cmd.discovery_mode = 1;
+		wil_dbg_misc(wil, "active scan with discovery_mode=1\n");
+	}
+
 	rc = wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
 			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
 
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d80bb75..8b7e1fd 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -37,6 +37,7 @@ enum dbg_off_type {
 	doff_x32 = 1,
 	doff_ulong = 2,
 	doff_io32 = 3,
+	doff_u8 = 4
 };
 
 /* offset to "wil" */
@@ -346,6 +347,10 @@ static void wil6210_debugfs_init_offset(struct wil6210_priv *wil,
 							 tbl[i].mode, dbg,
 							 base + tbl[i].off);
 			break;
+		case doff_u8:
+			f = debugfs_create_u8(tbl[i].name, tbl[i].mode, dbg,
+					      base + tbl[i].off);
+			break;
 		default:
 			f = ERR_PTR(-EINVAL);
 		}
@@ -1522,6 +1527,7 @@ static const struct dbg_off dbg_wil_off[] = {
 	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
 	WIL_FIELD(recovery_count, S_IRUGO,		doff_u32),
 	WIL_FIELD(ap_isolate,	S_IRUGO,		doff_u32),
+	WIL_FIELD(discovery_mode, S_IRUGO | S_IWUSR,	doff_u8),
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 44ff040..f662f76 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -615,6 +615,7 @@ struct wil6210_priv {
 	/* debugfs */
 	struct dentry *debug;
 	struct debugfs_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
+	u8 discovery_mode;
 
 	void *platform_handle;
 	struct wil_platform_ops platform_ops;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 6e90e78..430a4c0 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -286,16 +286,17 @@ struct wmi_delete_cipher_key_cmd {
  * - WMI_SCAN_COMPLETE_EVENTID
  */
 enum wmi_scan_type {
-	WMI_LONG_SCAN		= 0,
+	WMI_ACTIVE_SCAN		= 0,
 	WMI_SHORT_SCAN		= 1,
 	WMI_PBC_SCAN		= 2,
 	WMI_DIRECT_SCAN		= 3,
-	WMI_ACTIVE_SCAN		= 4,
+	WMI_LONG_SCAN		= 4,
 };
 
 struct wmi_start_scan_cmd {
 	u8 direct_scan_mac_addr[6];
-	u8 reserved[2];
+	u8 discovery_mode;
+	u8 reserved;
 	__le32 home_dwell_time;	/* Max duration in the home channel(ms) */
 	__le32 force_scan_interval;	/* Time interval between scans (ms)*/
 	u8 scan_type;		/* wmi_scan_type */
-- 
1.8.5.2

