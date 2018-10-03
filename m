Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3924C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 951E820835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:36:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 951E820835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbeJCOXY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:23:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56146 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeJCOXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:23:24 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1g7bha-00089U-E2; Wed, 03 Oct 2018 07:36:11 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
Date:   Wed,  3 Oct 2018 15:35:56 +0800
Message-Id: <20181003073556.28154-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181003073556.28154-1-kai.heng.feng@canonical.com>
References: <20181003073556.28154-1-kai.heng.feng@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

To avoid the firmware loading race between Bluetooth and WiFi on Intel
8260, load firmware exclusively when BT_INTEL is enabled.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cc8c53dc0ab6..bbd7e199e968 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -72,6 +72,10 @@
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
 
+#if IS_ENABLED(CONFIG_BT_INTEL)
+#include <linux/intel-wifi-bt.h>
+#endif
+
 #include "iwl-drv.h"
 #include "iwl-trans.h"
 #include "iwl-csr.h"
@@ -1335,6 +1339,10 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	bool hw_rfkill;
 	int ret;
 
+#if IS_ENABLED(CONFIG_BT_INTEL)
+	void (*firmware_lock_func)(void);
+	void (*firmware_unlock_func)(void);
+#endif
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
@@ -1401,8 +1409,37 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Load the given image to the HW */
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000) {
+#if IS_ENABLED(CONFIG_BT_INTEL)
+		firmware_lock_func = symbol_request(btintel_firmware_lock);
+		firmware_unlock_func = symbol_request(btintel_firmware_unlock);
+		if (!firmware_lock_func || !firmware_unlock_func) {
+			if (firmware_lock_func) {
+				symbol_put(btintel_firmware_lock);
+				firmware_lock_func = NULL;
+			}
+
+			if (firmware_unlock_func) {
+				symbol_put(btintel_firmware_unlock);
+				firmware_unlock_func = NULL;
+			}
+		}
+
+		if (firmware_lock_func)
+			firmware_lock_func();
+#endif
 		ret = iwl_pcie_load_given_ucode_8000(trans, fw);
+
+#if IS_ENABLED(CONFIG_BT_INTEL)
+		if (firmware_unlock_func) {
+			firmware_unlock_func();
+			symbol_put(btintel_firmware_lock);
+			firmware_lock_func = NULL;
+			symbol_put(btintel_firmware_unlock);
+			firmware_unlock_func = NULL;
+		}
+#endif
+	}
 	else
 		ret = iwl_pcie_load_given_ucode(trans, fw);
 
-- 
2.17.1

