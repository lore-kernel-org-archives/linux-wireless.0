Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1HZGxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 44/60] iwlagn: iwl-pci doesn't include iwl-dev any more
Date: Thu, 25 Aug 2011 23:11:16 -0700
Message-Id: <1314339092-20797-45-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085343_761591_6B2E5984)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Move all the iwlXXX_abgn_cfg forward declaration to a separate file
so that iwl-pci.c doesn't need to include iwl-agn.h that includes
all iwl-dev.h
This allows to provide real encapsulation. Dereferencing iwl_priv
in the bus layer will now lead to a compilation error.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h    |   44 -----------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    5 -
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-pci.c    |    9 +-
 drivers/net/wireless/iwlwifi/iwl-pci.h    |  115 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    5 +
 10 files changed, 128 insertions(+), 56 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3368b8d..4766c3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -44,6 +44,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-shared.h"
+#include "iwl-pci.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 047c22b..75ded34 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -45,6 +45,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
 #include "iwl-shared.h"
+#include "iwl-pci.h"
 
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d2ef4be..7cb4d69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -47,6 +47,7 @@
 #include "iwl-5000-hw.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
+#include "iwl-pci.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 955a99c..2a98e65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,6 +46,7 @@
 #include "iwl-6000-hw.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
+#include "iwl-pci.h"
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3508c12..2b94a10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -65,50 +65,6 @@
 
 #include "iwl-dev.h"
 
-/* configuration for the _agn devices */
-extern struct iwl_cfg iwl5300_agn_cfg;
-extern struct iwl_cfg iwl5100_agn_cfg;
-extern struct iwl_cfg iwl5350_agn_cfg;
-extern struct iwl_cfg iwl5100_bgn_cfg;
-extern struct iwl_cfg iwl5100_abg_cfg;
-extern struct iwl_cfg iwl5150_agn_cfg;
-extern struct iwl_cfg iwl5150_abg_cfg;
-extern struct iwl_cfg iwl6005_2agn_cfg;
-extern struct iwl_cfg iwl6005_2abg_cfg;
-extern struct iwl_cfg iwl6005_2bg_cfg;
-extern struct iwl_cfg iwl6005_2agn_sff_cfg;
-extern struct iwl_cfg iwl1030_bgn_cfg;
-extern struct iwl_cfg iwl1030_bg_cfg;
-extern struct iwl_cfg iwl6030_2agn_cfg;
-extern struct iwl_cfg iwl6030_2abg_cfg;
-extern struct iwl_cfg iwl6030_2bgn_cfg;
-extern struct iwl_cfg iwl6030_2bg_cfg;
-extern struct iwl_cfg iwl6000i_2agn_cfg;
-extern struct iwl_cfg iwl6000i_2abg_cfg;
-extern struct iwl_cfg iwl6000i_2bg_cfg;
-extern struct iwl_cfg iwl6000_3agn_cfg;
-extern struct iwl_cfg iwl6050_2agn_cfg;
-extern struct iwl_cfg iwl6050_2abg_cfg;
-extern struct iwl_cfg iwl6150_bgn_cfg;
-extern struct iwl_cfg iwl6150_bg_cfg;
-extern struct iwl_cfg iwl1000_bgn_cfg;
-extern struct iwl_cfg iwl1000_bg_cfg;
-extern struct iwl_cfg iwl100_bgn_cfg;
-extern struct iwl_cfg iwl100_bg_cfg;
-extern struct iwl_cfg iwl130_bgn_cfg;
-extern struct iwl_cfg iwl130_bg_cfg;
-extern struct iwl_cfg iwl2000_2bgn_cfg;
-extern struct iwl_cfg iwl2000_2bg_cfg;
-extern struct iwl_cfg iwl2030_2bgn_cfg;
-extern struct iwl_cfg iwl2030_2bg_cfg;
-extern struct iwl_cfg iwl6035_2agn_cfg;
-extern struct iwl_cfg iwl6035_2abg_cfg;
-extern struct iwl_cfg iwl6035_2bg_cfg;
-extern struct iwl_cfg iwl105_bg_cfg;
-extern struct iwl_cfg iwl105_bgn_cfg;
-extern struct iwl_cfg iwl135_bg_cfg;
-extern struct iwl_cfg iwl135_bgn_cfg;
-
 extern struct ieee80211_ops iwlagn_hw_ops;
 
 int iwl_reset_ict(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c3bdba5..2ea8a2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -71,11 +71,6 @@
 struct iwl_host_cmd;
 struct iwl_cmd;
 
-
-#define IWLWIFI_VERSION "in-tree:"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
-#define DRV_AUTHOR     "<ilw@linux.intel.com>"
-
 #define TIME_UNIT		1024
 
 #define IWL_CMD(x) case x: return #x
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 711f2af..eb98df6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -51,8 +51,6 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 
-#define DRV_NAME        "iwlagn"
-
 struct iwl_tx_queue;
 
 /* CT-KILL constants */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 62c35a5..7210ff6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -64,13 +64,11 @@
 #include <linux/pci-aspm.h>
 
 #include "iwl-bus.h"
+#include "iwl-io.h"
 #include "iwl-shared.h"
-#include "iwl-agn.h"
 #include "iwl-trans.h"
-
-/* TODO: iwl_set_bit and friends should be implemented in bus layer
- * this would allow us not to include iwl-io.h here */
-#include "iwl-io.h"
+#include "iwl-csr.h"
+#include "iwl-pci.h"
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
@@ -95,6 +93,7 @@ static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
 {
 	int pos;
 	u16 pci_lnk_ctl;
+
 	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
 
 	pos = pci_pcie_cap(pci_dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.h b/drivers/net/wireless/iwlwifi/iwl-pci.h
new file mode 100644
index 0000000..be69276
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.h
@@ -0,0 +1,115 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
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
+#ifndef __iwl_pci_h__
+#define __iwl_pci_h__
+
+
+/* This file includes the declaration that are internal to the PCI
+ * implementation of the bus layer
+ */
+
+/* configuration for the _agn devices */
+extern struct iwl_cfg iwl5300_agn_cfg;
+extern struct iwl_cfg iwl5100_agn_cfg;
+extern struct iwl_cfg iwl5350_agn_cfg;
+extern struct iwl_cfg iwl5100_bgn_cfg;
+extern struct iwl_cfg iwl5100_abg_cfg;
+extern struct iwl_cfg iwl5150_agn_cfg;
+extern struct iwl_cfg iwl5150_abg_cfg;
+extern struct iwl_cfg iwl6005_2agn_cfg;
+extern struct iwl_cfg iwl6005_2abg_cfg;
+extern struct iwl_cfg iwl6005_2bg_cfg;
+extern struct iwl_cfg iwl6005_2agn_sff_cfg;
+extern struct iwl_cfg iwl1030_bgn_cfg;
+extern struct iwl_cfg iwl1030_bg_cfg;
+extern struct iwl_cfg iwl6030_2agn_cfg;
+extern struct iwl_cfg iwl6030_2abg_cfg;
+extern struct iwl_cfg iwl6030_2bgn_cfg;
+extern struct iwl_cfg iwl6030_2bg_cfg;
+extern struct iwl_cfg iwl6000i_2agn_cfg;
+extern struct iwl_cfg iwl6000i_2abg_cfg;
+extern struct iwl_cfg iwl6000i_2bg_cfg;
+extern struct iwl_cfg iwl6000_3agn_cfg;
+extern struct iwl_cfg iwl6050_2agn_cfg;
+extern struct iwl_cfg iwl6050_2abg_cfg;
+extern struct iwl_cfg iwl6150_bgn_cfg;
+extern struct iwl_cfg iwl6150_bg_cfg;
+extern struct iwl_cfg iwl1000_bgn_cfg;
+extern struct iwl_cfg iwl1000_bg_cfg;
+extern struct iwl_cfg iwl100_bgn_cfg;
+extern struct iwl_cfg iwl100_bg_cfg;
+extern struct iwl_cfg iwl130_bgn_cfg;
+extern struct iwl_cfg iwl130_bg_cfg;
+extern struct iwl_cfg iwl2000_2bgn_cfg;
+extern struct iwl_cfg iwl2000_2bg_cfg;
+extern struct iwl_cfg iwl2030_2bgn_cfg;
+extern struct iwl_cfg iwl2030_2bg_cfg;
+extern struct iwl_cfg iwl6035_2agn_cfg;
+extern struct iwl_cfg iwl6035_2abg_cfg;
+extern struct iwl_cfg iwl6035_2bg_cfg;
+extern struct iwl_cfg iwl105_bg_cfg;
+extern struct iwl_cfg iwl105_bgn_cfg;
+extern struct iwl_cfg iwl135_bg_cfg;
+extern struct iwl_cfg iwl135_bgn_cfg;
+
+#endif /* __iwl_pci_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 45f8a33..27aee52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -77,6 +77,11 @@ struct iwl_priv;
 struct iwl_sensitivity_ranges;
 struct iwl_trans_ops;
 
+#define DRV_NAME        "iwlagn"
+#define IWLWIFI_VERSION "in-tree:"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
+#define DRV_AUTHOR     "<ilw@linux.intel.com>"
+
 extern struct iwl_mod_params iwlagn_mod_params;
 
 /**
-- 
1.7.0.4

