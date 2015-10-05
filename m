Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56868 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbbJELk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:40:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, <stable@vger.kernel.org>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 14:40:43 +0300
Message-Id: <1444045246-9946-5-git-send-email-luca@coelho.fi> (sfid-20151005_134103_231188_2AEA2AE6)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 5/8] iwlwifi: fix firmware filename for 3160
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The MODULE_FIRMWARE() for 3160 should be using the 7260 version as
it's done in the device configuration struct instead of referencing
IWL3160_UCODE_API_OK which doesn't even exist.

Cc: <stable@vger.kernel.org> [3.8+]
Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 6951aba..3fb327d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -348,6 +348,6 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 };
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
+MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-- 
2.5.3

