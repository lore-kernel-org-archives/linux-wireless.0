Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:61569 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbbA3Js1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:48:27 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so26125513wev.12
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:48:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/4] ath10k: add more wmi fw stat defines
Date: Fri, 30 Jan 2015 10:47:23 +0100
Message-Id: <1422611244-20767-4-git-send-email-michal.kazior@tieto.com> (sfid-20150130_104833_663553_3F46371F)
In-Reply-To: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New qca6174 wmi-tlv firmware revisions support
more stat event bits.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h   | 10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f0a6b93..33f36ee 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -395,7 +395,7 @@ static int ath10k_debug_fw_stats_request(struct ath10k *ar)
 
 		reinit_completion(&ar->debug.fw_stats_complete);
 
-		ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
+		ret = ath10k_wmi_request_stats(ar, WMI_STAT_PEER);
 		if (ret) {
 			ath10k_warn(ar, "could not request stats (%d)\n", ret);
 			return ret;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 20ce360..0eb0959 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3057,8 +3057,12 @@ struct wmi_pdev_stats_peer {
 } __packed;
 
 enum wmi_stats_id {
-	WMI_REQUEST_PEER_STAT	= 0x01,
-	WMI_REQUEST_AP_STAT	= 0x02
+	WMI_STAT_PEER = BIT(0),
+	WMI_STAT_AP = BIT(1),
+	WMI_STAT_PDEV = BIT(2),
+	WMI_STAT_VDEV = BIT(3),
+	WMI_STAT_BCNFLT = BIT(4),
+	WMI_STAT_VDEV_RATE = BIT(5),
 };
 
 struct wlan_inst_rssi_args {
@@ -3093,7 +3097,7 @@ struct wmi_pdev_suspend_cmd {
 } __packed;
 
 struct wmi_stats_event {
-	__le32 stats_id; /* %WMI_REQUEST_ */
+	__le32 stats_id; /* WMI_STAT_ */
 	/*
 	 * number of pdev stats event structures
 	 * (wmi_pdev_stats) 0 or 1
-- 
1.8.5.3

