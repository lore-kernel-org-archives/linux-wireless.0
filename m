Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42478 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcBDUps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 15:45:48 -0500
From: Alan Liu <alanliu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath10k-devel@qca.qualcomm.com>,
	<ath10k-tieto.external@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v4] Add max_tx_power member to set max transmission power for WLAN.RM.2.0 firmware. 
Date: Thu, 4 Feb 2016 12:45:35 -0800
Message-ID: <1454618735-10153-1-git-send-email-alanliu@qca.qualcomm.com> (sfid-20160204_214551_698382_DCB9B19C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WLAN.RM.2.0 firmware use max_tx_power instead of using
max_reg_power to set transmission power. The tx power was about -50dbm, after
 applying this change, it become -32dbm.

Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 drivers/net/wireless/ath/ath10k/wmi.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e6d6b42..b3997b5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1569,7 +1569,7 @@ void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 	ch->max_power = arg->max_power;
 	ch->reg_power = arg->max_reg_power;
 	ch->antenna_max = arg->max_antenna_gain;
-
+	ch->max_tx_power = arg->max_power;
 	/* mode & flags share storage */
 	ch->mode = arg->mode;
 	ch->flags |= __cpu_to_le32(flags);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0d4efc9..a56cf27 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1709,6 +1709,7 @@ struct wmi_channel {
 		__le32 reginfo1;
 		struct {
 			u8 antenna_max;
+			u8 max_tx_power;
 		} __packed;
 	} __packed;
 } __packed;
-- 
1.9.1

