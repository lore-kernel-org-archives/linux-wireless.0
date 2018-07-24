Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:25495 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388453AbeGXIt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:49:58 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 06/19] wil6210: support Talyn specific FW file
Date: Tue, 24 Jul 2018 10:44:27 +0300
Message-Id: <1532418280-5849-7-git-send-email-merez@codeaurora.org> (sfid-20180724_094512_199678_FADD28AA)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW file name for Talyn device is different from the default name.
This patch searches for Talyn specific FW file name and fallback
to the default FW file in case it is not present.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 8 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 8b148cb..7192d9a 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -93,6 +93,10 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 		if (wil_r(wil, RGF_USER_OTP_HW_RD_MACHINE_1) &
 		    BIT_NO_FLASH_INDICATION)
 			set_bit(hw_capa_no_flash, wil->hw_capa);
+		wil_fw_name = ftm_mode ? WIL_FW_NAME_FTM_TALYN :
+			      WIL_FW_NAME_TALYN;
+		if (wil_fw_verify_file_exists(wil, wil_fw_name))
+			wil->wil_fw_name = wil_fw_name;
 		break;
 	case JTAG_DEV_ID_TALYN_MB:
 		wil->hw_name = "Talyn-MB";
@@ -104,6 +108,10 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 		set_bit(hw_capa_no_flash, wil->hw_capa);
 		wil->use_enhanced_dma_hw = true;
 		wil->use_rx_hw_reordering = true;
+		wil_fw_name = ftm_mode ? WIL_FW_NAME_FTM_TALYN :
+			      WIL_FW_NAME_TALYN;
+		if (wil_fw_verify_file_exists(wil, wil_fw_name))
+			wil->wil_fw_name = wil_fw_name;
 		break;
 	default:
 		wil_err(wil, "Unknown board hardware, chip_id 0x%08x, chip_revision 0x%08x\n",
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b06cba5..00719a0 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -50,6 +50,9 @@
 #define WIL_FW_NAME_SPARROW_PLUS "wil6210_sparrow_plus.fw"
 #define WIL_FW_NAME_FTM_SPARROW_PLUS "wil6210_sparrow_plus_ftm.fw"
 
+#define WIL_FW_NAME_TALYN "wil6436.fw"
+#define WIL_FW_NAME_FTM_TALYN "wil6436_ftm.fw"
+
 #define WIL_BOARD_FILE_NAME "wil6210.brd" /* board & radio parameters */
 
 #define WIL_DEFAULT_BUS_REQUEST_KBPS 128000 /* ~1Gbps */
-- 
1.9.1
