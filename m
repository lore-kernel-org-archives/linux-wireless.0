Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36336 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751757AbdAWWTV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:19:21 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Date: Tue, 24 Jan 2017 00:03:39 +0200
Message-Id: <20170123220350.25305-15-luca@coelho.fi> (sfid-20170123_233339_485271_D71B1A75)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 14/25] iwlwifi: fix MODULE_FIRMWARE for 6030
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jürg Billeter <j@bitron.ch>

IWL6000G2B_UCODE_API_MAX is not defined. ucode_api_max of
IWL_DEVICE_6030 uses IWL6000G2_UCODE_API_MAX. Use this also for
MODULE_FIRMWARE.

Fixes: 9d9b21d1b616 ("iwlwifi: remove IWL_*_UCODE_API_OK")
Signed-off-by: Jürg Billeter <j@bitron.ch>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 0b9f6a7bc834..39335b7b0c16 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -371,4 +371,4 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-- 
2.11.0
