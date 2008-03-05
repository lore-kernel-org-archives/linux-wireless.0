Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13213 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbYCECKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/11] iwlwifi: add struct iwl_cfg
Date: Tue,  4 Mar 2008 18:09:30 -0800
Message-Id: <1204682972-26004-10-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021129_009418_989FDA86)
In-Reply-To: <1204682972-26004-9-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-7-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-8-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch introduces struct iwl_cfg. struct iwl_cfg defines static
configuration for each device type and sku. It is passed as driver_data
to the bus probe function.
This patch also introduce new common header file iwl-core.h
which will represent core functionality of iwlwifi driver

3945ABG uses separate iwl-3945-dev.h header file for now

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-core.h |   80 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   19 ++++++-
 drivers/net/wireless/iwlwifi/iwl-3945.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   10 +++-
 drivers/net/wireless/iwlwifi/iwl-4965.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h      |   81 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   35 ++---------
 drivers/net/wireless/iwlwifi/iwl4965-base.c  |   11 +++-
 8 files changed, 203 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-core.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-core.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-core.h b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
new file mode 100644
index 0000000..bc12f97
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
@@ -0,0 +1,80 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#ifndef __iwl_3945_dev_h__
+#define __iwl_3945_dev_h__
+
+#define IWL_PCI_DEVICE(dev, subdev, cfg) \
+	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
+	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
+	.driver_data = (kernel_ulong_t)&(cfg)
+
+#define IWL_SKU_G       0x1
+#define IWL_SKU_A       0x2
+
+struct iwl_3945_cfg {
+	const char *name;
+	const char *fw_name;
+	unsigned int sku;
+};
+
+#endif /* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0fca356..b909764 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -39,6 +39,7 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 
+#include "iwl-3945-core.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 #include "iwl-3945-rs.h"
@@ -2523,9 +2524,23 @@ void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv)
 	cancel_delayed_work(&priv->thermal_periodic);
 }
 
+static struct iwl_3945_cfg iwl3945_bg_cfg = {
+	.name = "3945BG",
+	.sku = IWL_SKU_G,
+};
+
+static struct iwl_3945_cfg iwl3945_abg_cfg = {
+	.name = "3945ABG",
+	.sku = IWL_SKU_A|IWL_SKU_G,
+};
+
 struct pci_device_id iwl3945_hw_card_ids[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4222)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4227)},
+	{IWL_PCI_DEVICE(0x4222, 0x1005, iwl3945_bg_cfg)},
+	{IWL_PCI_DEVICE(0x4222, 0x1034, iwl3945_bg_cfg)},
+	{IWL_PCI_DEVICE(0x4222, 0x1044, iwl3945_bg_cfg)},
+	{IWL_PCI_DEVICE(0x4227, 0x1014, iwl3945_bg_cfg)},
+	{IWL_PCI_DEVICE(0x4222, PCI_ANY_ID, iwl3945_abg_cfg)},
+	{IWL_PCI_DEVICE(0x4227, PCI_ANY_ID, iwl3945_abg_cfg)},
 	{0}
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 1701e0b..fa89da2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -682,6 +682,7 @@ struct iwl3945_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
+	struct iwl_3945_cfg *cfg; /* device configuration */
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
@@ -820,7 +821,6 @@ struct iwl3945_priv {
 	int is_open;
 
 	u8 mac80211_registered;
-	int is_abg;
 
 	u32 notif_missed_beacons;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2da1533..8cf1b9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
+#include "iwl-core.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
@@ -4820,9 +4821,14 @@ void iwl4965_hw_cancel_deferred_work(struct iwl4965_priv *priv)
 	cancel_delayed_work(&priv->init_alive_start);
 }
 
+static struct iwl_cfg iwl4965_agn_cfg = {
+	.name = "4965AGN",
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+};
+
 struct pci_device_id iwl4965_hw_card_ids[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4229)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4230)},
+	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
 	{0}
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index a782c45..0bfd1b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -967,6 +967,7 @@ struct iwl4965_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
+	struct iwl_cfg *cfg;
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
@@ -1126,7 +1127,6 @@ struct iwl4965_priv {
 	int is_open;
 
 	u8 mac80211_registered;
-	int is_abg;
 
 	u32 notif_missed_beacons;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
new file mode 100644
index 0000000..e6449af
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -0,0 +1,81 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#ifndef __iwl_core_h__
+#define __iwl_core_h__
+
+#define IWL_PCI_DEVICE(dev, subdev, cfg) \
+	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
+	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
+	.driver_data = (kernel_ulong_t)&(cfg)
+
+#define IWL_SKU_G       0x1
+#define IWL_SKU_A       0x2
+#define IWL_SKU_N       0x8
+
+struct iwl_cfg {
+	const char *name;
+	const char *fw_name;
+	unsigned int sku;
+};
+
+#endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cc71bdc..0cdc7f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -46,6 +46,7 @@
 
 #include <asm/div64.h>
 
+#include "iwl-3945-core.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 
@@ -5267,12 +5268,13 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 				 geo_ch->flags);
 	}
 
-	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) && priv->is_abg) {
+	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
+	     priv->cfg->sku & IWL_SKU_A) {
 		printk(KERN_INFO DRV_NAME
 		       ": Incorrectly detected BG card as ABG.  Please send "
 		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
 		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
-		priv->is_abg = 0;
+		 priv->cfg->sku &= ~IWL_SKU_A;
 	}
 
 	printk(KERN_INFO DRV_NAME
@@ -8067,9 +8069,9 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
-	u32 pci_id;
 	struct iwl3945_priv *priv;
 	struct ieee80211_hw *hw;
+	struct iwl_3945_cfg *cfg = (struct iwl_3945_cfg *)(ent->driver_data);
 	int i;
 	DECLARE_MAC_BUF(mac);
 
@@ -8105,6 +8107,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->hw = hw;
 
 	priv->pci_dev = pdev;
+	priv->cfg = cfg;
 
 	/* Select antenna (may be helpful if only one antenna is connected) */
 	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
@@ -8194,32 +8197,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->iw_mode = IEEE80211_IF_TYPE_STA;
 
-	pci_id =
-	    (priv->pci_dev->device << 16) | priv->pci_dev->subsystem_device;
-
-	switch (pci_id) {
-	case 0x42221005:	/* 0x4222 0x8086 0x1005 is BG SKU */
-	case 0x42221034:	/* 0x4222 0x8086 0x1034 is BG SKU */
-	case 0x42271014:	/* 0x4227 0x8086 0x1014 is BG SKU */
-	case 0x42221044:	/* 0x4222 0x8086 0x1044 is BG SKU */
-		priv->is_abg = 0;
-		break;
-
-	/*
-	 * Rest are assumed ABG SKU -- if this is not the
-	 * case then the card will get the wrong 'Detected'
-	 * line in the kernel log however the code that
-	 * initializes the GEO table will detect no A-band
-	 * channels and remove the is_abg mask.
-	 */
-	default:
-		priv->is_abg = 1;
-		break;
-	}
-
 	printk(KERN_INFO DRV_NAME
-	       ": Detected Intel PRO/Wireless 3945%sBG Network Connection\n",
-	       priv->is_abg ? "A" : "");
+		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
 
 	/* Device-specific setup */
 	if (iwl3945_hw_set_hw_setting(priv)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0c60f59..af97e0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -45,6 +45,7 @@
 
 #include <asm/div64.h>
 
+#include "iwl-core.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
@@ -5663,12 +5664,13 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 				 geo_ch->flags);
 	}
 
-	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) && priv->is_abg) {
+	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
+	     priv->cfg->sku & IWL_SKU_A) {
 		printk(KERN_INFO DRV_NAME
 		       ": Incorrectly detected BG card as ABG.  Please send "
 		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
 		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
-		priv->is_abg = 0;
+		priv->cfg->sku &= ~IWL_SKU_A;
 	}
 
 	printk(KERN_INFO DRV_NAME
@@ -8613,6 +8615,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	int err = 0;
 	struct iwl4965_priv *priv;
 	struct ieee80211_hw *hw;
+	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	int i;
 	DECLARE_MAC_BUF(mac);
 
@@ -8646,6 +8649,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv = hw->priv;
 	priv->hw = hw;
+	priv->cfg = cfg;
 
 	priv->pci_dev = pdev;
 	priv->antenna = (enum iwl4965_antenna)iwl4965_param_antenna;
@@ -8748,8 +8752,9 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Choose which receivers/antennas to use */
 	iwl4965_set_rxon_chain(priv);
 
+
 	printk(KERN_INFO DRV_NAME
-	       ": Detected Intel Wireless WiFi Link 4965AGN\n");
+		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
 
 	/* Device-specific setup */
 	if (iwl4965_hw_set_hw_setting(priv)) {
-- 
1.5.3.4

