Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2DWVw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/29] iwlwifi: remove TX/RX frame statistics
Date: Mon, 23 Apr 2012 14:47:28 -0700
Message-Id: <1335217660-21950-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235338_726815_7B77A374)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Keeping statistics per frame type really isn't
very useful, and needs a huge amount of code
so remove it. Since that is the only thing in
iwl-core.{c,h} now, those files can be killed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h   |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn.c         |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c        |  178 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h        |   90 ------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   84 -----------
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   42 ------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c         |    1 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-testmode.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c       |    1 -
 23 files changed, 1 insertions(+), 417 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-core.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-core.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index f2cd678..406f297 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -5,7 +5,7 @@ iwlwifi-objs		+= iwl-ucode.o iwl-agn-tx.o iwl-debug.o
 iwlwifi-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
 iwlwifi-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
 
-iwlwifi-objs		+= iwl-core.o iwl-eeprom.o iwl-power.o
+iwlwifi-objs		+= iwl-eeprom.o iwl-power.o
 iwlwifi-objs		+= iwl-scan.o iwl-led.o
 iwlwifi-objs		+= iwl-agn-rxon.o iwl-agn-devices.o
 iwlwifi-objs		+= iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index b088f9b..95f27f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -64,7 +64,6 @@
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 #include "iwl-agn.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index 9ed6683..dbe1378 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -63,7 +63,6 @@
 #define __iwl_calib_h__
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-commands.h"
 
 void iwl_chain_noise_calibration(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
index d0700e0..48533b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
@@ -27,7 +27,6 @@
 /*
  * DVM device-specific data & functions
  */
-#include "iwl-core.h"
 #include "iwl-agn.h"
 #include "iwl-dev.h"
 #include "iwl-commands.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 90b6ee8..ed37174 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -33,7 +33,6 @@
 #include <linux/sched.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 024a0dd..14afd01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -36,7 +36,6 @@
 #include <linux/workqueue.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-agn.h"
 #include "iwl-op-mode.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 45a153f..6b2007a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -34,7 +34,6 @@
 #include <asm/unaligned.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
@@ -762,8 +761,6 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 	p = rxb_steal_page(rxb);
 	skb_add_rx_frag(skb, 0, p, offset, len, len);
 
-	iwl_update_stats(priv, false, fc, len);
-
 	/*
 	* Wake any queues that were stopped due to a passive channel tx
 	* failure. This can happen because the regulatory enforcement in
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 8f41543..6e9dce7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -27,7 +27,6 @@
 #include <linux/etherdevice.h>
 #include "iwl-dev.h"
 #include "iwl-agn.h"
-#include "iwl-core.h"
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 0119e7a..67e6f1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -30,7 +30,6 @@
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index f6bf874..cd331da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -37,7 +37,6 @@
 #include "iwl-agn.h"
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-commands.h"
 #include "iwl-debug.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2a2ac15..587cfe6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -34,7 +34,6 @@
 #include <linux/ieee80211.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
@@ -399,8 +398,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
 
-	iwl_update_stats(priv, true, fc, len);
-
 	memset(&info->status, 0, sizeof(info->status));
 
 	info->driver_data[0] = ctx;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 39187ea..d479dac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -46,7 +46,6 @@
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
deleted file mode 100644
index 52805a1..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/******************************************************************************
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
- *****************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <net/mac80211.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-debug.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-power.h"
-#include "iwl-agn.h"
-#include "iwl-trans.h"
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-
-const char *get_mgmt_string(int cmd)
-{
-#define IWL_CMD(x) case x: return #x
-	switch (cmd) {
-		IWL_CMD(MANAGEMENT_ASSOC_REQ);
-		IWL_CMD(MANAGEMENT_ASSOC_RESP);
-		IWL_CMD(MANAGEMENT_REASSOC_REQ);
-		IWL_CMD(MANAGEMENT_REASSOC_RESP);
-		IWL_CMD(MANAGEMENT_PROBE_REQ);
-		IWL_CMD(MANAGEMENT_PROBE_RESP);
-		IWL_CMD(MANAGEMENT_BEACON);
-		IWL_CMD(MANAGEMENT_ATIM);
-		IWL_CMD(MANAGEMENT_DISASSOC);
-		IWL_CMD(MANAGEMENT_AUTH);
-		IWL_CMD(MANAGEMENT_DEAUTH);
-		IWL_CMD(MANAGEMENT_ACTION);
-	default:
-		return "UNKNOWN";
-
-	}
-#undef IWL_CMD
-}
-
-const char *get_ctrl_string(int cmd)
-{
-#define IWL_CMD(x) case x: return #x
-	switch (cmd) {
-		IWL_CMD(CONTROL_BACK_REQ);
-		IWL_CMD(CONTROL_BACK);
-		IWL_CMD(CONTROL_PSPOLL);
-		IWL_CMD(CONTROL_RTS);
-		IWL_CMD(CONTROL_CTS);
-		IWL_CMD(CONTROL_ACK);
-		IWL_CMD(CONTROL_CFEND);
-		IWL_CMD(CONTROL_CFENDACK);
-	default:
-		return "UNKNOWN";
-
-	}
-#undef IWL_CMD
-}
-
-/*
- * if CONFIG_IWLWIFI_DEBUGFS defined, iwl_update_stats function will
- * record all the MGMT, CTRL and DATA pkt for both TX and Rx pass.
- * Use debugFs to display the rx/rx_statistics
- * if CONFIG_IWLWIFI_DEBUGFS not being defined, then no MGMT and CTRL
- * information will be recorded, but DATA pkt still will be recorded
- * for the reason of iwl_led.c need to control the led blinking based on
- * number of tx and rx data.
- *
- */
-void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
-{
-	struct traffic_stats	*stats;
-
-	if (is_tx)
-		stats = &priv->tx_stats;
-	else
-		stats = &priv->rx_stats;
-
-	if (ieee80211_is_mgmt(fc)) {
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-			stats->mgmt[MANAGEMENT_ASSOC_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
-			stats->mgmt[MANAGEMENT_ASSOC_RESP]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-			stats->mgmt[MANAGEMENT_REASSOC_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
-			stats->mgmt[MANAGEMENT_REASSOC_RESP]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
-			stats->mgmt[MANAGEMENT_PROBE_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
-			stats->mgmt[MANAGEMENT_PROBE_RESP]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_BEACON):
-			stats->mgmt[MANAGEMENT_BEACON]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ATIM):
-			stats->mgmt[MANAGEMENT_ATIM]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
-			stats->mgmt[MANAGEMENT_DISASSOC]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_AUTH):
-			stats->mgmt[MANAGEMENT_AUTH]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-			stats->mgmt[MANAGEMENT_DEAUTH]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ACTION):
-			stats->mgmt[MANAGEMENT_ACTION]++;
-			break;
-		}
-	} else if (ieee80211_is_ctl(fc)) {
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_BACK_REQ):
-			stats->ctrl[CONTROL_BACK_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_BACK):
-			stats->ctrl[CONTROL_BACK]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_PSPOLL):
-			stats->ctrl[CONTROL_PSPOLL]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_RTS):
-			stats->ctrl[CONTROL_RTS]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_CTS):
-			stats->ctrl[CONTROL_CTS]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ACK):
-			stats->ctrl[CONTROL_ACK]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_CFEND):
-			stats->ctrl[CONTROL_CFEND]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_CFENDACK):
-			stats->ctrl[CONTROL_CFENDACK]++;
-			break;
-		}
-	} else {
-		/* data */
-		stats->data_cnt++;
-		stats->data_bytes += len;
-	}
-}
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
deleted file mode 100644
index cfa539b..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
- *****************************************************************************/
-
-#ifndef __iwl_core_h__
-#define __iwl_core_h__
-
-#include "iwl-dev.h"
-#include "iwl-io.h"
-
-/************************
- * forward declarations *
- ************************/
-struct iwl_host_cmd;
-struct iwl_cmd;
-
-/***************************
- *   L i b                 *
- ***************************/
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-const char *get_mgmt_string(int cmd);
-const char *get_ctrl_string(int cmd);
-void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len);
-#else
-static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
-				    __le16 fc, u16 len)
-{
-}
-#endif
-
-#endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index eb93fdd..f612ce8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -37,7 +37,6 @@
 
 #include "iwl-dev.h"
 #include "iwl-debug.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
 
@@ -111,85 +110,6 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.llseek = generic_file_llseek,					\
 };
 
-static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-
-	int cnt;
-	ssize_t ret;
-	const size_t bufsz = 100 +
-		sizeof(char) * 50 * (MANAGEMENT_MAX + CONTROL_MAX);
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-	pos += scnprintf(buf + pos, bufsz - pos, "Management:\n");
-	for (cnt = 0; cnt < MANAGEMENT_MAX; cnt++) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%25s\t\t: %u\n",
-				 get_mgmt_string(cnt),
-				 priv->tx_stats.mgmt[cnt]);
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Control\n");
-	for (cnt = 0; cnt < CONTROL_MAX; cnt++) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%25s\t\t: %u\n",
-				 get_ctrl_string(cnt),
-				 priv->tx_stats.ctrl[cnt]);
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Data:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "\tcnt: %u\n",
-			 priv->tx_stats.data_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "\tbytes: %llu\n",
-			 priv->tx_stats.data_bytes);
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	int cnt;
-	ssize_t ret;
-	const size_t bufsz = 100 +
-		sizeof(char) * 50 * (MANAGEMENT_MAX + CONTROL_MAX);
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Management:\n");
-	for (cnt = 0; cnt < MANAGEMENT_MAX; cnt++) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%25s\t\t: %u\n",
-				 get_mgmt_string(cnt),
-				 priv->rx_stats.mgmt[cnt]);
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Control:\n");
-	for (cnt = 0; cnt < CONTROL_MAX; cnt++) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%25s\t\t: %u\n",
-				 get_ctrl_string(cnt),
-				 priv->rx_stats.ctrl[cnt]);
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Data:\n");
-	pos += scnprintf(buf + pos, bufsz - pos, "\tcnt: %u\n",
-			 priv->rx_stats.data_cnt);
-	pos += scnprintf(buf + pos, bufsz - pos, "\tbytes: %llu\n",
-			 priv->rx_stats.data_bytes);
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
 static ssize_t iwl_dbgfs_sram_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos)
@@ -2405,8 +2325,6 @@ static ssize_t iwl_dbgfs_calib_disabled_write(struct file *file,
 	return count;
 }
 
-DEBUGFS_READ_FILE_OPS(rx_statistics);
-DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
@@ -2468,8 +2386,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(temperature, dir_data, S_IRUSR);
 
-	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e89dc26..67e3b40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -507,44 +507,6 @@ struct reply_agg_tx_error_statistics {
 	u32 unknown;
 };
 
-/* management statistics */
-enum iwl_mgmt_stats {
-	MANAGEMENT_ASSOC_REQ = 0,
-	MANAGEMENT_ASSOC_RESP,
-	MANAGEMENT_REASSOC_REQ,
-	MANAGEMENT_REASSOC_RESP,
-	MANAGEMENT_PROBE_REQ,
-	MANAGEMENT_PROBE_RESP,
-	MANAGEMENT_BEACON,
-	MANAGEMENT_ATIM,
-	MANAGEMENT_DISASSOC,
-	MANAGEMENT_AUTH,
-	MANAGEMENT_DEAUTH,
-	MANAGEMENT_ACTION,
-	MANAGEMENT_MAX,
-};
-/* control statistics */
-enum iwl_ctrl_stats {
-	CONTROL_BACK_REQ =  0,
-	CONTROL_BACK,
-	CONTROL_PSPOLL,
-	CONTROL_RTS,
-	CONTROL_CTS,
-	CONTROL_ACK,
-	CONTROL_CFEND,
-	CONTROL_CFENDACK,
-	CONTROL_MAX,
-};
-
-struct traffic_stats {
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	u32 mgmt[MANAGEMENT_MAX];
-	u32 ctrl[CONTROL_MAX];
-	u32 data_cnt;
-	u64 data_bytes;
-#endif
-};
-
 /*
  * schedule the timer to wake up every UCODE_TRACE_PERIOD milliseconds
  * to perform continuous uCode event logging operation if enabled
@@ -894,10 +856,6 @@ struct iwl_priv {
 
 	int activity_timer_active;
 
-	/* counts mgmt, ctl, and data packets */
-	struct traffic_stats tx_stats;
-	struct traffic_stats rx_stats;
-
 	struct iwl_power_mgr power_data;
 	struct iwl_tt_mgmt thermal_throttle;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 098d565..50c5891 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -69,7 +69,6 @@
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-debug.h"
 #include "iwl-agn.h"
 #include "iwl-eeprom.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 7fbed47..1d62d06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -36,7 +36,6 @@
 #include <asm/unaligned.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-agn.h"
 #include "iwl-io.h"
 #include "iwl-trans.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 8adbbf2..4f45156 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -44,7 +44,6 @@
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index bc91cdd..5fba34b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -37,7 +37,6 @@
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-agn.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-commands.h"
 #include "iwl-debug.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 9b88b90..a8437a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -32,7 +32,6 @@
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index a6b16aa..bd92bd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -71,7 +71,6 @@
 #include <net/netlink.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-debug.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 1955803..bc40dc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -31,7 +31,6 @@
 #include <linux/init.h>
 
 #include "iwl-dev.h"
-#include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
-- 
1.7.0.4

