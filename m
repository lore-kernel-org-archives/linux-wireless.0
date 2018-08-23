Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:6039 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbeHWPQn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:43 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 4/9] wil6210: set edma variables only for Talyn-MB devices
Date: Thu, 23 Aug 2018 14:47:08 +0300
Message-Id: <1535024833-15178-5-git-send-email-merez@codeaurora.org> (sfid-20180823_134727_450979_B704D1BA)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use_rx_hw_reordering is already set to true in wil_set_capabilities
for Talyn-MB devices. Remove its setting from wil_priv_init to
prevent its activation for older chips.
Similarly, move the setting of use_compressed_rx_status to
wil_set_capabilities.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c     | 2 --
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8820cee..827df1c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -653,8 +653,6 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	/* edma configuration can be updated via debugfs before allocation */
 	wil->num_rx_status_rings = WIL_DEFAULT_NUM_RX_STATUS_RINGS;
-	wil->use_compressed_rx_status = true;
-	wil->use_rx_hw_reordering = true;
 	wil->tx_status_ring_order = WIL_TX_SRING_SIZE_ORDER_DEFAULT;
 
 	/* Rx status ring size should be bigger than the number of RX buffers
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 89119e7..c8c6613 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -108,6 +108,7 @@ int wil_set_capabilities(struct wil6210_priv *wil)
 		set_bit(hw_capa_no_flash, wil->hw_capa);
 		wil->use_enhanced_dma_hw = true;
 		wil->use_rx_hw_reordering = true;
+		wil->use_compressed_rx_status = true;
 		wil_fw_name = ftm_mode ? WIL_FW_NAME_FTM_TALYN :
 			      WIL_FW_NAME_TALYN;
 		if (wil_fw_verify_file_exists(wil, wil_fw_name))
-- 
1.9.1
