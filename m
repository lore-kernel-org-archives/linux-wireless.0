Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab3GZI3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 21/30] iwlwifi: mvm: split constants into separate file
Date: Fri, 26 Jul 2013 10:28:38 +0200
Message-Id: <1374827327-3464-22-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103019_382272_01FCE463)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To make maintaining some constant default values in the
driver easier, declare them in a separate file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 71 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/iwlwifi/mvm/power.c     | 12 +++--
 3 files changed, 80 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/constants.h

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
new file mode 100644
index 0000000..64656e0c
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -0,0 +1,71 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 Intel Corporation. All rights reserved.
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
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2013 Intel Corporation. All rights reserved.
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
+#ifndef __MVM_CONSTANTS_H
+#define __MVM_CONSTANTS_H
+
+#define IWL_MVM_DEFAULT_PS_TX_DATA_TIMEOUT	(100 * USEC_PER_MSEC)
+#define IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT	(100 * USEC_PER_MSEC)
+#define IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
+#define IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
+
+#endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 879fb01..8891c81 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -76,6 +76,7 @@
 #include "iwl-trans.h"
 #include "sta.h"
 #include "fw-api.h"
+#include "constants.h"
 
 #define IWL_INVALID_MAC80211_QUEUE	0xff
 #define IWL_MVM_MAX_ADDRESSES		5
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 644bf47..8ed0403 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -217,11 +217,15 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	}
 
 	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
-		cmd->rx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
-		cmd->tx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
+		cmd->rx_data_timeout =
+			cpu_to_le32(IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout =
+			cpu_to_le32(IWL_MVM_DEFAULT_PS_TX_DATA_TIMEOUT);
 	} else {
-		cmd->rx_data_timeout = cpu_to_le32(10 * USEC_PER_MSEC);
-		cmd->tx_data_timeout = cpu_to_le32(10 * USEC_PER_MSEC);
+		cmd->rx_data_timeout =
+			cpu_to_le32(IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout =
+			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.8.0

