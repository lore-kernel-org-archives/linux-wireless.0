Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXJYJWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:42 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/30] iwlwifi: using PCI_DEVICE macro
Date: Thu, 25 Oct 2007 17:15:32 +0800
Message-Id: <11933037674045-git-send-email-yi.zhu@intel.com> (sfid-20071025_104059_185556_B873B1C3)
In-Reply-To: <11933037663659-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

PCI_DEVICE macro is more concise when using defualt values
in device definitions

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 62b44a4..d4dc30d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2278,8 +2278,8 @@ void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 struct pci_device_id iwl_hw_card_ids[] = {
-	{0x8086, 0x4222, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x8086, 0x4227, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(0x8086, 0x4222)},
+	{PCI_DEVICE(0x8086, 0x4227)},
 	{0}
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4710f6e..f86a24e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4680,8 +4680,8 @@ void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 struct pci_device_id iwl_hw_card_ids[] = {
-	{0x8086, 0x4229, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x8086, 0x4230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_DEVICE(0x8086, 0x4229)},
+	{PCI_DEVICE(0x8086, 0x4230)},
 	{0}
 };
 
-- 
1.5.2
