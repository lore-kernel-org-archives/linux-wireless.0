Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46510 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaCUSr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 14:47:58 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath10k:  Fix getting stats from firmware.
Date: Fri, 21 Mar 2014 11:47:22 -0700
Message-Id: <1395427642-30884-1-git-send-email-greearb@candelatech.com> (sfid-20140321_194803_011238_93D7A00D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Tested on 10.x firmware, and others report it at least
makes older firmware no more broken than it already was.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Remove spurious comment.

 drivers/net/wireless/ath/ath10k/wmi.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index fa1b9e0..c11f49a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2766,13 +2766,20 @@ enum wmi_stats_id {
 	WMI_REQUEST_AP_STAT	= 0x02
 };
 
+struct wlan_inst_rssi_args {
+	__le16 cfg_retry_count;
+	__le16 retry_count;
+};
+
 struct wmi_request_stats_cmd {
 	__le32 stats_id;
 
-	/*
-	 * Space to add parameters like
-	 * peer mac addr
-	 */
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

