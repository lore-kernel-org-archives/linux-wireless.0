Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34105 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1JJPQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 30/34] iwlagn: remove 6000 hw header
Date: Mon, 10 Oct 2011 07:27:15 -0700
Message-Id: <1318256839-31837-31-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171649_104824_05F280B5)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The constants can be moved together with
the similar ones for other devices and we
can then remove the file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h |   81 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h  |    9 +++
 4 files changed, 9 insertions(+), 83 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-6000-hw.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index e969c5f..f14eb0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -42,7 +42,6 @@
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
-#include "iwl-6000-hw.h"
 #include "iwl-shared.h"
 #include "iwl-cfg.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
deleted file mode 100644
index b27986e..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
+++ /dev/null
@@ -1,81 +0,0 @@
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
-/*
- * Please use this file (iwl-6000-hw.h) only for hardware-related definitions.
- * Use iwl-commands.h for uCode API definitions.
- */
-
-#ifndef __iwl_6000_hw_h__
-#define __iwl_6000_hw_h__
-
-#define IWL60_RTC_INST_LOWER_BOUND		(0x000000)
-#define IWL60_RTC_INST_UPPER_BOUND		(0x040000)
-#define IWL60_RTC_DATA_LOWER_BOUND		(0x800000)
-#define IWL60_RTC_DATA_UPPER_BOUND		(0x814000)
-#define IWL60_RTC_INST_SIZE \
-	(IWL60_RTC_INST_UPPER_BOUND - IWL60_RTC_INST_LOWER_BOUND)
-#define IWL60_RTC_DATA_SIZE \
-	(IWL60_RTC_DATA_UPPER_BOUND - IWL60_RTC_DATA_LOWER_BOUND)
-
-#endif /* __iwl_6000_hw_h__ */
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index aece578..f05f2b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -42,7 +42,6 @@
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
-#include "iwl-6000-hw.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 #include "iwl-cfg.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index ac039d4..123ef5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -78,6 +78,15 @@
 #define IWLAGN_RTC_DATA_SIZE (IWLAGN_RTC_DATA_UPPER_BOUND - \
 				IWLAGN_RTC_DATA_LOWER_BOUND)
 
+#define IWL60_RTC_INST_LOWER_BOUND		(0x000000)
+#define IWL60_RTC_INST_UPPER_BOUND		(0x040000)
+#define IWL60_RTC_DATA_LOWER_BOUND		(0x800000)
+#define IWL60_RTC_DATA_UPPER_BOUND		(0x814000)
+#define IWL60_RTC_INST_SIZE \
+	(IWL60_RTC_INST_UPPER_BOUND - IWL60_RTC_INST_LOWER_BOUND)
+#define IWL60_RTC_DATA_SIZE \
+	(IWL60_RTC_DATA_UPPER_BOUND - IWL60_RTC_DATA_LOWER_BOUND)
+
 /* RSSI to dBm */
 #define IWLAGN_RSSI_OFFSET	44
 
-- 
1.7.0.4

