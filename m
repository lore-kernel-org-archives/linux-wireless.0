Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53950 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbcEKRCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:44 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 13/21] ath10k: Document cycle count related counters.
Date: Wed, 11 May 2016 10:02:25 -0700
Message-Id: <1462986153-16318-14-git-send-email-greearb@candelatech.com> (sfid-20160511_192231_294360_EB75FBAE)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They are not necessarily named in an intuitive manner,
so at least add some comments to help the next person.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 8 ++++----
 drivers/net/wireless/ath/ath10k/wmi.h  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e7c228a..91b1f95 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -189,10 +189,10 @@ struct ath10k_fw_stats_pdev {
 
 	/* PDEV stats */
 	s32 ch_noise_floor;
-	u32 tx_frame_count;
-	u32 rx_frame_count;
-	u32 rx_clear_count;
-	u32 cycle_count;
+	u32 tx_frame_count; /* Cycles spent transmitting frames */
+	u32 rx_frame_count; /* Cycles spent receiving frames */
+	u32 rx_clear_count; /* Total channel busy time, evidently */
+	u32 cycle_count; /* Total on-channel time */
 	u32 phy_err_count;
 	u32 chan_tx_power;
 	u32 ack_rx_bad;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 8d9b5b3..91c7df5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4208,10 +4208,10 @@ struct wmi_10_2_stats_event {
  */
 struct wmi_pdev_stats_base {
 	__le32 chan_nf;
-	__le32 tx_frame_count;
-	__le32 rx_frame_count;
-	__le32 rx_clear_count;
-	__le32 cycle_count;
+	__le32 tx_frame_count; /* Cycles spent transmitting frames */
+	__le32 rx_frame_count; /* Cycles spent receiving frames */
+	__le32 rx_clear_count; /* Total channel busy time, evidently */
+	__le32 cycle_count; /* Total on-channel time */
 	__le32 phy_err_count;
 	__le32 chan_tx_pwr;
 } __packed;
-- 
2.4.3

