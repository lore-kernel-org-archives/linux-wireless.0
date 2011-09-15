Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500Ab1IOTcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/27] iwlagn: rename iwl-pci.h to iwl-cfg.h
Date: Thu, 15 Sep 2011 11:46:46 -0700
Message-Id: <1316112414-6341-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213302_993939_1FD05C60)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's nothing PCI(E) specific in this file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |  115 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.h  |  116 -------------------------------
 7 files changed, 120 insertions(+), 121 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-cfg.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index dacbe3a..887f9ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -44,7 +44,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-shared.h"
-#include "iwl-pci.h"
+#include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 82719b7..5a87010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -45,7 +45,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
 #include "iwl-shared.h"
-#include "iwl-pci.h"
+#include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index de7f7f2..2907016 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -47,7 +47,7 @@
 #include "iwl-5000-hw.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
-#include "iwl-pci.h"
+#include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5c1a8b8..37837f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,7 +46,7 @@
 #include "iwl-6000-hw.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
-#include "iwl-pci.h"
+#include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
new file mode 100644
index 0000000..d4f317c
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
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
+/*
+ * This file declares the config structures for all devices.
+ */
+
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
+extern struct iwl_cfg iwl2000_2bgn_d_cfg;
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 1be0bc4..849b5ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -68,7 +68,7 @@
 #include "iwl-shared.h"
 #include "iwl-trans.h"
 #include "iwl-csr.h"
-#include "iwl-pci.h"
+#include "iwl-cfg.h"
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.h b/drivers/net/wireless/iwlwifi/iwl-pci.h
deleted file mode 100644
index c0aea9e..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-pci.h
+++ /dev/null
@@ -1,116 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#ifndef __iwl_pci_h__
-#define __iwl_pci_h__
-
-
-/* This file includes the declaration that are internal to the PCI
- * implementation of the bus layer
- */
-
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
-extern struct iwl_cfg iwl2000_2bgn_d_cfg;
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
-#endif /* __iwl_pci_h__ */
-- 
1.7.0.4

