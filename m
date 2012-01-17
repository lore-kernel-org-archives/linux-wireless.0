Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:40527 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2AQSJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 13:09:02 -0500
Subject: [PATCH v3 3/8] ath6kl: add ATH6KL_CONF_UART_DEBUG
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 20:08:56 +0200
Message-ID: <20120117180856.29995.25607.stgit@localhost6.localdomain6> (sfid-20120117_190906_493022_01D68971)
In-Reply-To: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
References: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ATH6KL_CONF_UART_DEBUG which is set whenever uart_debug module
parameter is enabled. This way we can keep the uart_debug parameter
static when core.c file is introduced.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index a75c09e..5b48ed4 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -195,6 +195,7 @@ struct ath6kl_fw_ie {
 #define ATH6KL_CONF_ENABLE_11N			BIT(2)
 #define ATH6KL_CONF_ENABLE_TX_BURST		BIT(3)
 #define ATH6KL_CONF_SUSPEND_CUTPOWER		BIT(4)
+#define ATH6KL_CONF_UART_DEBUG			BIT(5)
 
 enum wlan_low_pwr_state {
 	WLAN_POWER_STATE_ON,
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6baa855..911e2df 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -466,7 +466,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	u8 fw_iftype, fw_mode = 0, fw_submode = 0;
 	int i, status;
 
-	param = uart_debug;
+	param = !!(ar->conf_flags & ATH6KL_CONF_UART_DEBUG);
 	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
 			     HI_ITEM(hi_serial_enable)), (u8 *)&param, 4)) {
 		ath6kl_err("bmi_write_memory for uart debug failed\n");
@@ -1679,6 +1679,9 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (suspend_cutpower)
 		ar->conf_flags |= ATH6KL_CONF_SUSPEND_CUTPOWER;
 
+	if (uart_debug)
+		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
+
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
 			    WIPHY_FLAG_HAVE_AP_SME |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |

