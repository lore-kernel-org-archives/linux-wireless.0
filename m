Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245AbZKMT4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:46 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/16] iwlagn: power up device before initializing EEPROM
Date: Fri, 13 Nov 2009 11:56:32 -0800
Message-Id: <1258142198-3223-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

A recent change optimized the power usage by the device by only powering it
up during EEPROM load if it is required (for OTP devices). This change causes
an error on the 1000 series devices during module load.

The error looks as follows:
[ 1624.024524] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[ 1624.024527] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 1624.024711] iwlagn 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 1624.024749] iwlagn 0000:01:00.0: setting latency timer to 64
[ 1624.024909] iwlagn 0000:01:00.0: Detected Intel Wireless WiFi Link 1000 Series BGN REV=0x6C
[ 1624.081263] iwlagn 0000:01:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0x080003D8
[ 1624.092967] iwlagn 0000:01:00.0: OTP is empty
[ 1624.092988] iwlagn 0000:01:00.0: Unable to init EEPROM
[ 1624.093033] iwlagn 0000:01:00.0: PCI INT A disabled
[ 1624.093065] iwlagn: probe of 0000:01:00.0 failed with error -2

Adding a dump_stack() to where that error is printed shows the following:

[ 1624.024524] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[ 1624.024527] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 1624.024711] iwlagn 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 1624.024749] iwlagn 0000:01:00.0: setting latency timer to 64
[ 1624.024909] iwlagn 0000:01:00.0: Detected Intel Wireless WiFi Link 1000 Series BGN REV=0x6C
[ 1624.081263] iwlagn 0000:01:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0x080003D8
[ 1624.081263] Pid: 3073, comm: work_for_cpu Tainted: G        W 2.6.31.5 #4
[ 1624.081263] Call Trace:
[ 1624.081263]  [<ffffffffa02395db>] T.726+0x22b/0x420 [iwlcore]
[ 1624.081263]  [<ffffffffa023985a>] iwlcore_eeprom_acquire_semaphore+0x8a/0x190 [iwlcore]
[ 1624.081263]  [<ffffffff81110c94>] ? __kmalloc+0x194/0x1c0
[ 1624.081263]  [<ffffffffa02391f5>] ?  iwlcore_eeprom_verify_signature+0x25/0xf0 [iwlcore]
[ 1624.081263]  [<ffffffffa0239c67>] iwl_eeprom_init+0x107/0xf40 [iwlcore]
[ 1624.081263]  [<ffffffffa026ab9c>] ?  iwl_prepare_card_hw+0x11c/0x470 [iwlagn]
[ 1624.081263]  [<ffffffff8127e2a4>] ?  pci_bus_write_config_byte+0x64/0x80
[ 1624.081263]  [<ffffffffa026b1f8>] iwl_pci_probe+0x308/0xac0 [iwlagn]
[ 1624.081263]  [<ffffffff810710a0>] ? do_work_for_cpu+0x0/0x30
[ 1624.081263]  [<ffffffff81284912>] local_pci_probe+0x12/0x20
[ 1624.081263]  [<ffffffff810710b3>] do_work_for_cpu+0x13/0x30
[ 1624.081263]  [<ffffffff81075826>] kthread+0xa6/0xb0
[ 1624.081263]  [<ffffffff81012fea>] child_rip+0xa/0x20
[ 1624.081263]  [<ffffffff81075780>] ? kthread+0x0/0xb0
[ 1624.081263]  [<ffffffff81012fe0>] ? child_rip+0x0/0x20
[ 1624.092967] iwlagn 0000:01:00.0: OTP is empty
[ 1624.092988] iwlagn 0000:01:00.0: Unable to init EEPROM
[ 1624.093033] iwlagn 0000:01:00.0: PCI INT A disabled
[ 1624.093065] iwlagn: probe of 0000:01:00.0 failed with error -2

We know that the routines in this trace, iwlcore_eeprom_acquire_semaphore
and iwlcore_eeprom_verify_signature, only access CSR registers and thus do
not need the device to be awake if it is EEPROM. But for OTP it is required
for the device to be awake to read these registers. Ensure device is awake
before accessing these registers.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Ben Cahill <ben.m.cahill@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ac88ff0..3946e5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -518,6 +518,11 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	}
 	e = (u16 *)priv->eeprom;
 
+	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
+		/* OTP reads require powered-up chip */
+		priv->cfg->ops->lib->apm_ops.init(priv);
+	}
+
 	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
 	if (ret < 0) {
 		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
@@ -532,10 +537,8 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		ret = -ENOENT;
 		goto err;
 	}
-	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
-		/* OTP reads require powered-up chip */
-		priv->cfg->ops->lib->apm_ops.init(priv);
+	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
 		ret = iwl_init_otp_access(priv);
 		if (ret) {
-- 
1.5.6.3

