Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24365 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2BTNi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 08:38:27 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Maintain the listen interval per VIF specific
Date: Mon, 20 Feb 2012 19:08:07 +0530
Message-ID: <1329745088-23800-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120220_143849_784264_FFAA8359)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Firmware has the option to support the listen interval
per vif specific. Fix this.

Listen interval can be set by the TUs or by the number
of beacons. Current code enables the user to configure
the listen interval in the unit of 'number of beacons'
using debugfs entry "listen_interval". Going forward,
we need to alter the listen interval in the unit of TUs
to get good power numbers while going to WOW suspend/resume.

Allowing the user to change the listen interval in
the unit of "number of beacons"  in debugfs and changing
listen interval in wow suspend/resume in the unit of
time (TUs) would lead us to confuse.

This patch make sures the listen interval is changed only
in the unit of time (TUs).

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 +
 drivers/net/wireless/ath/ath6kl/core.c     |    2 --
 drivers/net/wireless/ath/ath6kl/core.h     |    6 +++---
 drivers/net/wireless/ath/ath6kl/debug.c    |   15 ++++++++++-----
 drivers/net/wireless/ath/ath6kl/main.c     |    6 ++----
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 003f320..6e02a2b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2943,6 +2943,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->wdev.iftype = type;
 	vif->fw_vif_idx = fw_vif_idx;
 	vif->nw_type = vif->next_mode = nw_type;
+	vif->listen_intvl_t = ATH6KL_DEFAULT_LISTEN_INTVAL;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0)
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 37c92a1..0db5c73 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -264,9 +264,7 @@ struct ath6kl *ath6kl_core_create(struct device *dev)
 	clear_bit(SKIP_SCAN, &ar->flag);
 	clear_bit(DESTROY_IN_PROGRESS, &ar->flag);
 
-	ar->listen_intvl_b = A_DEFAULT_LISTEN_INTERVAL;
 	ar->tx_pwr = 0;
-
 	ar->intra_bss = 1;
 	ar->lrssi_roam_threshold = DEF_LRSSI_ROAM_THRESHOLD;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 808253e..78f53c0 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -60,8 +60,6 @@
 #define MAX_DEFAULT_SEND_QUEUE_DEPTH      (MAX_DEF_COOKIE_NUM / WMM_NUM_AC)
 
 #define DISCON_TIMER_INTVAL               10000  /* in msec */
-#define A_DEFAULT_LISTEN_INTERVAL         1      /* beacon intervals */
-#define A_MAX_WOW_LISTEN_INTERVAL         1000
 
 /* includes also the null byte */
 #define ATH6KL_FIRMWARE_MAGIC               "QCA-ATH6KL"
@@ -184,6 +182,8 @@ struct ath6kl_fw_ie {
 
 #define MBOX_YIELD_LIMIT 99
 
+#define ATH6KL_DEFAULT_LISTEN_INTVAL	100 /* in TUs */
+
 /* configuration lags */
 /*
  * ATH6KL_CONF_IGNORE_ERP_BARKER: Ignore the barker premable in
@@ -495,6 +495,7 @@ struct ath6kl_vif {
 	bool probe_req_report;
 	u16 next_chan;
 	u16 assoc_bss_beacon_int;
+	u16 listen_intvl_t;
 	u8 assoc_bss_dtim_period;
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
@@ -554,7 +555,6 @@ struct ath6kl {
 	u8 avail_idx_map;
 	spinlock_t lock;
 	struct semaphore sem;
-	u16 listen_intvl_b;
 	u8 lrssi_roam_threshold;
 	struct ath6kl_version version;
 	u32 target_type;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 3d0713d..3092686 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1628,12 +1628,12 @@ static ssize_t ath6kl_listen_int_write(struct file *file,
 	if (kstrtou16(buf, 0, &listen_interval))
 		return -EINVAL;
 
-	if ((listen_interval < 1) || (listen_interval > 50))
+	if ((listen_interval < 15) || (listen_interval > 3000))
 		return -EINVAL;
 
-	ar->listen_intvl_b = listen_interval;
-	ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx, 0,
-				      ar->listen_intvl_b);
+	vif->listen_intvl_t = listen_interval;
+	ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
+				      vif->listen_intvl_t, 0);
 
 	return count;
 }
@@ -1643,10 +1643,15 @@ static ssize_t ath6kl_listen_int_read(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
+	struct ath6kl_vif *vif;
 	char buf[32];
 	int len;
 
-	len = scnprintf(buf, sizeof(buf), "%u\n", ar->listen_intvl_b);
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	len = scnprintf(buf, sizeof(buf), "%u\n", vif->listen_intvl_t);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d463a18..23a8027 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -589,11 +589,9 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 	memcpy(vif->bssid, bssid, sizeof(vif->bssid));
 	vif->bss_ch = channel;
 
-	if ((vif->nw_type == INFRA_NETWORK)) {
-		ar->listen_intvl_b = listen_int;
+	if ((vif->nw_type == INFRA_NETWORK))
 		ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
-					      0, ar->listen_intvl_b);
-	}
+					      vif->listen_intvl_t, 0);
 
 	netif_wake_queue(vif->ndev);
 
-- 
1.7.1

