Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab2B0XTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/24] iwlwifi: introducing the drv object's flows
Date: Mon, 27 Feb 2012 14:07:28 -0800
Message-Id: <1330380468-17674-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002022_159166_8F01EE43)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Fetch the fw and spawn the op_mode. The op_mode that we need
to fetch is determined from the fw file.
Since the fw is fetched very early in the init flow, we can
determine what op_mode to spawn.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   10 ---
 drivers/net/wireless/iwlwifi/iwl-drv.c    |   94 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-drv.h    |  110 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c    |   22 ++-----
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 -
 6 files changed, 210 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-drv.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-drv.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 46622a0..afa0bb8 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -13,6 +13,7 @@ iwlwifi-objs		+= iwl-6000.o
 iwlwifi-objs		+= iwl-1000.o
 iwlwifi-objs		+= iwl-2000.o
 iwlwifi-objs		+= iwl-pci.o
+iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-trans.o
 iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d70dd6f..8bb97c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1331,16 +1331,6 @@ out:
 	return err;
 }
 
-int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
-		struct iwl_cfg *cfg)
-{
-	bus->shrd->cfg = cfg;
-
-	init_completion(&nic(bus)->request_firmware_complete);
-
-	return iwl_request_firmware(nic(bus), true);
-}
-
 void __devexit iwl_remove(struct iwl_priv * priv)
 {
 	wait_for_completion(&nic(priv)->request_firmware_complete);
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
new file mode 100644
index 0000000..49f7e70
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -0,0 +1,94 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+#include <linux/completion.h>
+
+#include "iwl-drv.h"
+#include "iwl-trans.h"
+#include "iwl-wifi.h"
+
+int iwl_drv_start(struct iwl_shared *shrd,
+		  struct iwl_trans *trans, struct iwl_cfg *cfg)
+{
+	int ret;
+
+	shrd->cfg = cfg;
+
+	shrd->nic = kzalloc(sizeof(*shrd->nic), GFP_KERNEL);
+	if (!shrd->nic) {
+		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_nic");
+		return -ENOMEM;
+	}
+	shrd->nic->shrd = shrd;
+
+	init_completion(&shrd->nic->request_firmware_complete);
+
+	ret = iwl_request_firmware(shrd->nic, true);
+
+	if (ret) {
+		dev_printk(KERN_ERR, trans->dev, "Couldn't request the fw");
+		kfree(shrd->nic);
+	}
+
+	return ret;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
new file mode 100644
index 0000000..c405451
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -0,0 +1,110 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
+#ifndef __iwl_drv_h__
+#define __iwl_drv_h__
+
+#include "iwl-shared.h"
+
+/**
+ * DOC: Driver system flows - drv component
+ *
+ * This component implements the system flows such as bus enumeration, bus
+ * removal. Bus dependent parts of system flows (such as iwl_pci_probe) are in
+ * bus specific files (transport files). This is the code that is common among
+ * different buses.
+ *
+ * This component is also in charge of managing the several implementations of
+ * the wifi flows: it will allow to have several fw API implementation. These
+ * different implementations will differ in the way they implement mac80211's
+ * handlers too.
+
+ * The init flow wrt to the drv component looks like this:
+ * 1) The bus specific component is called from module_init
+ * 2) The bus specific component registers the bus driver
+ * 3) The bus driver calls the probe function
+ * 4) The bus specific component configures the bus
+ * 5) The bus specific component calls to the drv bus agnostic part
+ *    (iwl_drv_start)
+ * 6) iwl_drv_start fetches the fw ASYNC, iwl_ucode_callback
+ * 7) iwl_ucode_callback parses the fw file
+ * 8) iwl_ucode_callback starts the wifi implementation to matches the fw
+ */
+
+/**
+ * iwl_drv_start - start the drv
+ *
+ * @shrd: the shrd area
+ * @trans_ops: the ops of the transport
+ * @cfg: device specific constants / virtual functions
+ *
+ * TODO: review the parameters given to this function
+ *
+ * starts the driver: fetches the firmware. This should be called by bus
+ * specific system flows implementations. For example, the bus specific probe
+ * function should do bus related operations only, and then call to this
+ * function.
+ */
+int iwl_drv_start(struct iwl_shared *shrd,
+		  struct iwl_trans *trans, struct iwl_cfg *cfg);
+
+#endif /* __iwl_drv_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 5190670..e269544 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -70,7 +70,7 @@
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "iwl-cfg.h"
-#include "iwl-wifi.h"
+#include "iwl-drv.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
@@ -283,34 +283,24 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bus->shrd->bus = bus;
 
-	/* temporarily create this here */
-	bus->shrd->nic = kzalloc(sizeof(*bus->shrd->nic), GFP_KERNEL);
-	if (!bus->shrd->nic) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "Couldn't allocate iwl_nic");
-		err = -ENOMEM;
-		goto out_free_bus;
-	}
-	/* and initialize it as well, temporarily */
-	bus->shrd->nic->shrd = bus->shrd;
 	pci_set_drvdata(pdev, bus);
 
 #ifdef CONFIG_IWLWIFI_IDI
 	trans(bus) = iwl_trans_idi_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
 		err = -ENOMEM;
-		goto out_free_nic;
+		goto out_free_bus;
 	}
 
-	err = iwl_probe(bus, &trans_ops_idi, cfg);
+	err = iwl_drv_start(bus->shrd, trans(bus), cfg);
 #else
 	trans(bus) = iwl_trans_pcie_alloc(bus->shrd, pdev, ent);
 	if (trans(bus) == NULL) {
 		err = -ENOMEM;
-		goto out_free_nic;
+		goto out_free_bus;
 	}
 
-	err = iwl_probe(bus, &trans_ops_pcie, cfg);
+	err = iwl_drv_start(bus->shrd, trans(bus), cfg);
 #endif
 	if (err)
 		goto out_free_trans;
@@ -320,8 +310,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_free_trans:
 	iwl_trans_free(trans(bus));
 	pci_set_drvdata(pdev, NULL);
-out_free_nic:
-	kfree(bus->shrd->nic);
 out_free_bus:
 	kfree(bus->shrd);
 	kfree(bus);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index cf593b0..d84beef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -535,8 +535,6 @@ enum iwl_rxon_context_id {
 int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 			  const struct iwl_trans_ops *trans_ops,
 			  struct iwl_cfg *cfg);
-int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
-		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
 struct iwl_device_cmd;
 int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
-- 
1.7.0.4

