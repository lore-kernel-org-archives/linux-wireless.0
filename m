Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:47100 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2LEVFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 16:05:33 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so224474lbc.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 13:05:31 -0800 (PST)
Subject: [PATCH 09/12] iwlegacy: collapse wrapper for
	pcie_capability_read_word()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 05 Dec 2012 13:58:06 -0700
Message-ID: <20121205205806.13851.18014.stgit@bhelgaas.mtv.corp.google.com> (sfid-20121205_220535_883851_40AD5528)
In-Reply-To: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

il_pcie_link_ctl() has only one call site and no longer provides any useful
abstraction, so collapse it into the caller.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: "John W. Linville" <linville@tuxdriver.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/iwlegacy/common.c |    5 +++--
 drivers/net/wireless/iwlegacy/common.h |    8 --------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 318ed3c..1811507 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1183,8 +1183,9 @@ EXPORT_SYMBOL(il_power_update_mode);
 void
 il_power_initialize(struct il_priv *il)
 {
-	u16 lctl = il_pcie_link_ctl(il);
+	u16 lctl;
 
+	pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
 	il->power_data.pci_pm = !(lctl & PCI_CFG_LINK_CTRL_VAL_L0S_EN);
 
 	il->power_data.debug_sleep_level_override = -1;
@@ -4233,7 +4234,7 @@ il_apm_init(struct il_priv *il)
 	 *    power savings, even without L1.
 	 */
 	if (il->cfg->set_l0s) {
-		lctl = il_pcie_link_ctl(il);
+		pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
 		if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 		    PCI_CFG_LINK_CTRL_VAL_L1_EN) {
 			/* L1-ASPM enabled; disable(!) L0S  */
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index b4bb813..c9a5022 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1829,14 +1829,6 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd);
  * PCI						     *
  *****************************************************/
 
-static inline u16
-il_pcie_link_ctl(struct il_priv *il)
-{
-	u16 pci_lnk_ctl;
-	pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &pci_lnk_ctl);
-	return pci_lnk_ctl;
-}
-
 void il_bg_watchdog(unsigned long data);
 u32 il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval);
 __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,

