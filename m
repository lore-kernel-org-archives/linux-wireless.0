Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64254 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbaJUQEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:04:55 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so1749016wgg.18
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 09:04:53 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/8] iwlwifi: 8000: fix string given to MODULE_FIRMWARE
Date: Tue, 21 Oct 2014 19:04:33 +0300
Message-Id: <1413907479-9073-2-git-send-email-egrumbach@gmail.com> (sfid-20141021_180544_191521_2C31CCA5)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

I changed the string but forgot to update the fix also to
MODULE_FIRMWARE().

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index e435148..d2b7234 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -82,7 +82,8 @@
 #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
 
 #define IWL8000_FW_PRE "iwlwifi-8000"
-#define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE __stringify(api) ".ucode"
+#define IWL8000_MODULE_FIRMWARE(api) \
+	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
 #define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000.bin"
-- 
1.9.1

