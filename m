Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:52314 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2LEU6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:58:18 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so394910eaa.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:58:17 -0800 (PST)
Subject: [PATCH 11/12] iwlegacy: Use standard #defines for PCIe Capability
	ASPM fields
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 05 Dec 2012 13:58:16 -0700
Message-ID: <20121205205816.13851.86504.stgit@bhelgaas.mtv.corp.google.com> (sfid-20121205_215828_987298_98E7A93F)
In-Reply-To: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the standard #defines rather than creating local definitions for
PCIe Capability ASPM fields.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/iwlegacy/4965.h   |    4 ----
 drivers/net/wireless/iwlegacy/common.c |    5 ++---
 drivers/net/wireless/iwlegacy/common.h |    4 ----
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 2d092f3..1b15b0b 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -917,10 +917,6 @@ struct il4965_scd_bc_tbl {
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
-/* PCI register values */
-#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
-#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
-
 #define IL4965_DEFAULT_TX_RETRY  15
 
 /* EEPROM */
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 1811507..7e16d10 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1186,7 +1186,7 @@ il_power_initialize(struct il_priv *il)
 	u16 lctl;
 
 	pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
-	il->power_data.pci_pm = !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
+	il->power_data.pci_pm = !(lctl & PCI_EXP_LNKCTL_ASPM_L0S);
 
 	il->power_data.debug_sleep_level_override = -1;
 
@@ -4235,8 +4235,7 @@ il_apm_init(struct il_priv *il)
 	 */
 	if (il->cfg->set_l0s) {
 		pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
-		if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
-		    PCI_CFG_LINK_CTRL_VAL_L1_EN) {
+		if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
 			/* L1-ASPM enabled; disable(!) L0S  */
 			il_set_bit(il, CSR_GIO_REG,
 				   CSR_GIO_REG_VAL_L0S_ENABLED);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index c9a5022..e181f3b 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -2426,10 +2426,6 @@ struct il_tfd {
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
-/* PCI register values */
-#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
-#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
-
 struct il_rate_info {
 	u8 plcp;		/* uCode API:  RATE_6M_PLCP, etc. */
 	u8 plcp_siso;		/* uCode API:  RATE_SISO_6M_PLCP, etc. */

