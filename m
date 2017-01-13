Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34704 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751673AbdAMMkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:40:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Jan 2017 14:39:16 +0200
Message-Id: <20170113123919.30384-4-luca@coelho.fi> (sfid-20170113_134112_866550_AE5A7CBC)
In-Reply-To: <20170113123919.30384-1-luca@coelho.fi>
References: <20170113123919.30384-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 3/6] iwlwifi: fix double hyphen in MODULE_FIRMWARE for 8000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jürg Billeter <j@bitron.ch>

There is only a single hyphen between iwlwifi-8000C and the API version
in the firmware filename.

Fixes: e1ba684f762b ("iwlwifi: 8000: fix MODULE_FIRMWARE input")
Signed-off-by: Jürg Billeter <j@bitron.ch>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index d02ca1491d16..8d3e53fac1da 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -91,7 +91,7 @@
 
 #define IWL8000_FW_PRE "iwlwifi-8000C-"
 #define IWL8000_MODULE_FIRMWARE(api) \
-	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
+	IWL8000_FW_PRE __stringify(api) ".ucode"
 
 #define IWL8265_FW_PRE "iwlwifi-8265-"
 #define IWL8265_MODULE_FIRMWARE(api) \
-- 
2.11.0
