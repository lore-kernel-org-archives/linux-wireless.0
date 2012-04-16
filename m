Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10262 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2DPKl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 06:41:59 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Retain bg scan period value modified by the user
Date: Mon, 16 Apr 2012 16:09:56 +0530
Message-ID: <1334572797-6561-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120416_124202_923800_4C2E2AB6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Added a new member bg_scan_period in struct ath6kl_vif
to retain background scan period value configured via debugfs
entry 'bgscan_interval'. This backup is needed in schedule scan
path while configuring scan parameters.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c    |    7 +++++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c5e90d3..2088133 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3370,6 +3370,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->next_mode = nw_type;
 	vif->listen_intvl_t = ATH6KL_DEFAULT_LISTEN_INTVAL;
 	vif->bmiss_time_t = ATH6KL_DEFAULT_BMISS_TIME;
+	vif->bg_scan_period = 0;
 	vif->htcap.ht_enable = true;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 280f305..a97cb83 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -557,6 +557,7 @@ struct ath6kl_vif {
 	u16 assoc_bss_beacon_int;
 	u16 listen_intvl_t;
 	u16 bmiss_time_t;
+	u16 bg_scan_period;
 	u8 assoc_bss_dtim_period;
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index a62c976..fed3232 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1572,10 +1572,15 @@ static ssize_t ath6kl_bgscan_int_write(struct file *file,
 				size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
+	struct ath6kl_vif *vif;
 	u16 bgscan_int;
 	char buf[32];
 	ssize_t len;
 
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
@@ -1587,6 +1592,8 @@ static ssize_t ath6kl_bgscan_int_write(struct file *file,
 	if (bgscan_int == 0)
 		bgscan_int = 0xffff;
 
+	vif->bg_scan_period = bgscan_int;
+
 	ath6kl_wmi_scanparams_cmd(ar->wmi, 0, 0, 0, bgscan_int, 0, 0, 0, 3,
 				  0, 0, 0);
 
-- 
1.7.1

