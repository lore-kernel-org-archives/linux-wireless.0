Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46063 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759656AbaCUAGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 20:06:09 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Fix getting stats from firmware.
Date: Thu, 20 Mar 2014 17:05:24 -0700
Message-Id: <1395360324-20433-1-git-send-email-greearb@candelatech.com> (sfid-20140321_010620_275409_1B8F43DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Make the request command object the right size so that
firmware will not just throw it away.
Tested customized and upstream firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index fa1b9e0..4946471 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2766,6 +2766,11 @@ enum wmi_stats_id {
 	WMI_REQUEST_AP_STAT	= 0x02
 };
 
+struct wlan_inst_rssi_args {
+	__le16 cfg_retry_count;
+	__le16 retry_count;
+};
+
 struct wmi_request_stats_cmd {
 	__le32 stats_id;
 
@@ -2773,6 +2778,12 @@ struct wmi_request_stats_cmd {
 	 * Space to add parameters like
 	 * peer mac addr
 	 */
+	__le32 vdev_id;
+	/* peer MAC address */
+	struct wmi_mac_addr peer_macaddr;
+
+	/* Instantaneous RSSI arguments */
+	struct wlan_inst_rssi_args inst_rssi_args;
 } __packed;
 
 /* Suspend option */
-- 
1.7.11.7

