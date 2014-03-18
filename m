Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37157 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaCROqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:10 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so5536759eei.28
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:08 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/35] iwlwifi: mvm: make bt-coex.c generic
Date: Tue, 18 Mar 2014 16:45:18 +0200
Message-Id: <1395153939-23897-14-git-send-email-egrumbach@gmail.com> (sfid-20140318_154634_953928_23934CA6)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Make bt-coex generic to allow other coex mechanisms.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/Makefile         |    2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        | 1280 ---------------------
 drivers/net/wireless/iwlwifi/mvm/coex.c           | 1280 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |  350 ------
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h    |  350 ++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |    4 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c             |    2 +-
 8 files changed, 1635 insertions(+), 1635 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/mvm/bt-coex.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/coex.c
 delete mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h

diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index 41d390f..9798aa5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_IWLMVM)   += iwlmvm.o
 iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
-iwlmvm-y += power.o bt-coex.o
+iwlmvm-y += power.o coex.o
 iwlmvm-y += led.o tt.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
deleted file mode 100644
index 4ae3c85..0000000
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ /dev/null
@@ -1,1280 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
- * in the file called COPYING.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
-
-#include <net/mac80211.h>
-
-#include "fw-api-bt-coex.h"
-#include "iwl-modparams.h"
-#include "mvm.h"
-#include "iwl-debug.h"
-
-#define EVENT_PRIO_ANT(_evt, _prio, _shrd_ant)			\
-	[(_evt)] = (((_prio) << BT_COEX_PRIO_TBL_PRIO_POS) |	\
-		   ((_shrd_ant) << BT_COEX_PRIO_TBL_SHRD_ANT_POS))
-
-static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_INIT_CALIB1,
-		       BT_COEX_PRIO_TBL_PRIO_BYPASS, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_INIT_CALIB2,
-		       BT_COEX_PRIO_TBL_PRIO_BYPASS, 1),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1,
-		       BT_COEX_PRIO_TBL_PRIO_LOW, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2,
-		       BT_COEX_PRIO_TBL_PRIO_LOW, 1),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1,
-		       BT_COEX_PRIO_TBL_PRIO_HIGH, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2,
-		       BT_COEX_PRIO_TBL_PRIO_HIGH, 1),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_DTIM,
-		       BT_COEX_PRIO_TBL_DISABLED, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_SCAN52,
-		       BT_COEX_PRIO_TBL_PRIO_COEX_OFF, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_SCAN24,
-		       BT_COEX_PRIO_TBL_PRIO_COEX_ON, 0),
-	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_IDLE,
-		       BT_COEX_PRIO_TBL_PRIO_COEX_IDLE, 0),
-	0, 0, 0, 0, 0, 0,
-};
-
-#undef EVENT_PRIO_ANT
-
-#define BT_ENABLE_REDUCED_TXPOWER_THRESHOLD	(-62)
-#define BT_DISABLE_REDUCED_TXPOWER_THRESHOLD	(-65)
-#define BT_ANTENNA_COUPLING_THRESHOLD		(30)
-
-int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
-{
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
-		return 0;
-
-	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, CMD_SYNC,
-				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
-				    &iwl_bt_prio_tbl);
-}
-
-const u32 iwl_bt_ack_kill_msk[BT_KILL_MSK_MAX] = {
-	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
-	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
-	[BT_KILL_MSK_REDUCED_TXPOW] = 0,
-};
-
-const u32 iwl_bt_cts_kill_msk[BT_KILL_MSK_MAX] = {
-	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
-	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
-	[BT_KILL_MSK_REDUCED_TXPOW] = 0,
-};
-
-static const __le32 iwl_bt_prio_boost[BT_COEX_BOOST_SIZE] = {
-	cpu_to_le32(0xf0f0f0f0),
-	cpu_to_le32(0xc0c0c0c0),
-	cpu_to_le32(0xfcfcfcfc),
-	cpu_to_le32(0xff00ff00),
-};
-
-static const __le32 iwl_single_shared_ant[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
-	{
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-	},
-};
-
-static const __le32 iwl_combined_lookup[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
-	{
-		/* Tight */
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaeaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xcc00ff28),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xcc00aaaa),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		/* Loose */
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xcc00ff28),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xcc00aaaa),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		/* Tx Tx disabled */
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xcc00ff28),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xcc00aaaa),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xC0004000),
-		cpu_to_le32(0xC0004000),
-		cpu_to_le32(0xF0005000),
-		cpu_to_le32(0xF0005000),
-	},
-};
-
-/* 20MHz / 40MHz below / 40Mhz above*/
-static const __le64 iwl_ci_mask[][3] = {
-	/* dummy entry for channel 0 */
-	{cpu_to_le64(0), cpu_to_le64(0), cpu_to_le64(0)},
-	{
-		cpu_to_le64(0x0000001FFFULL),
-		cpu_to_le64(0x0ULL),
-		cpu_to_le64(0x00007FFFFFULL),
-	},
-	{
-		cpu_to_le64(0x000000FFFFULL),
-		cpu_to_le64(0x0ULL),
-		cpu_to_le64(0x0003FFFFFFULL),
-	},
-	{
-		cpu_to_le64(0x000003FFFCULL),
-		cpu_to_le64(0x0ULL),
-		cpu_to_le64(0x000FFFFFFCULL),
-	},
-	{
-		cpu_to_le64(0x00001FFFE0ULL),
-		cpu_to_le64(0x0ULL),
-		cpu_to_le64(0x007FFFFFE0ULL),
-	},
-	{
-		cpu_to_le64(0x00007FFF80ULL),
-		cpu_to_le64(0x00007FFFFFULL),
-		cpu_to_le64(0x01FFFFFF80ULL),
-	},
-	{
-		cpu_to_le64(0x0003FFFC00ULL),
-		cpu_to_le64(0x0003FFFFFFULL),
-		cpu_to_le64(0x0FFFFFFC00ULL),
-	},
-	{
-		cpu_to_le64(0x000FFFF000ULL),
-		cpu_to_le64(0x000FFFFFFCULL),
-		cpu_to_le64(0x3FFFFFF000ULL),
-	},
-	{
-		cpu_to_le64(0x007FFF8000ULL),
-		cpu_to_le64(0x007FFFFFE0ULL),
-		cpu_to_le64(0xFFFFFF8000ULL),
-	},
-	{
-		cpu_to_le64(0x01FFFE0000ULL),
-		cpu_to_le64(0x01FFFFFF80ULL),
-		cpu_to_le64(0xFFFFFE0000ULL),
-	},
-	{
-		cpu_to_le64(0x0FFFF00000ULL),
-		cpu_to_le64(0x0FFFFFFC00ULL),
-		cpu_to_le64(0x0ULL),
-	},
-	{
-		cpu_to_le64(0x3FFFC00000ULL),
-		cpu_to_le64(0x3FFFFFF000ULL),
-		cpu_to_le64(0x0)
-	},
-	{
-		cpu_to_le64(0xFFFE000000ULL),
-		cpu_to_le64(0xFFFFFF8000ULL),
-		cpu_to_le64(0x0)
-	},
-	{
-		cpu_to_le64(0xFFF8000000ULL),
-		cpu_to_le64(0xFFFFFE0000ULL),
-		cpu_to_le64(0x0)
-	},
-	{
-		cpu_to_le64(0xFFC0000000ULL),
-		cpu_to_le64(0x0ULL),
-		cpu_to_le64(0x0ULL)
-	},
-};
-
-static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x22002200),
-	cpu_to_le32(0x33113311),
-};
-
-struct corunning_block_luts {
-	u8 range;
-	__le32 lut20[BT_COEX_CORUN_LUT_SIZE];
-};
-
-/*
- * Ranges for the antenna coupling calibration / co-running block LUT:
- *		LUT0: [ 0, 12[
- *		LUT1: [12, 20[
- *		LUT2: [20, 21[
- *		LUT3: [21, 23[
- *		LUT4: [23, 27[
- *		LUT5: [27, 30[
- *		LUT6: [30, 32[
- *		LUT7: [32, 33[
- *		LUT8: [33, - [
- */
-static const struct corunning_block_luts antenna_coupling_ranges[] = {
-	{
-		.range = 0,
-		.lut20 = {
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 12,
-		.lut20 = {
-			cpu_to_le32(0x00000001),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 20,
-		.lut20 = {
-			cpu_to_le32(0x00000002),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 21,
-		.lut20 = {
-			cpu_to_le32(0x00000003),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 23,
-		.lut20 = {
-			cpu_to_le32(0x00000004),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 27,
-		.lut20 = {
-			cpu_to_le32(0x00000005),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 30,
-		.lut20 = {
-			cpu_to_le32(0x00000006),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 32,
-		.lut20 = {
-			cpu_to_le32(0x00000007),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-	{
-		.range = 33,
-		.lut20 = {
-			cpu_to_le32(0x00000008),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
-		},
-	},
-};
-
-static enum iwl_bt_coex_lut_type
-iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
-{
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum iwl_bt_coex_lut_type ret;
-	u16 phy_ctx_id;
-
-	/*
-	 * Checking that we hold mvm->mutex is a good idea, but the rate
-	 * control can't acquire the mutex since it runs in Tx path.
-	 * So this is racy in that case, but in the worst case, the AMPDU
-	 * size limit will be wrong for a short time which is not a big
-	 * issue.
-	 */
-
-	rcu_read_lock();
-
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-
-	if (!chanctx_conf ||
-	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
-		rcu_read_unlock();
-		return BT_COEX_LOOSE_LUT;
-	}
-
-	ret = BT_COEX_TX_DIS_LUT;
-
-	if (mvm->cfg->bt_shared_single_ant) {
-		rcu_read_unlock();
-		return ret;
-	}
-
-	phy_ctx_id = *((u16 *)chanctx_conf->drv_priv);
-
-	if (mvm->last_bt_ci_cmd.primary_ch_phy_id == phy_ctx_id)
-		ret = le32_to_cpu(mvm->last_bt_notif.primary_ch_lut);
-	else if (mvm->last_bt_ci_cmd.secondary_ch_phy_id == phy_ctx_id)
-		ret = le32_to_cpu(mvm->last_bt_notif.secondary_ch_lut);
-	/* else - default = TX TX disallowed */
-
-	rcu_read_unlock();
-
-	return ret;
-}
-
-int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
-{
-	struct iwl_bt_coex_cmd *bt_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
-	};
-	int ret;
-	u32 flags;
-
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
-		return 0;
-
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
-	if (!bt_cmd)
-		return -ENOMEM;
-	cmd.data[0] = bt_cmd;
-
-	bt_cmd->max_kill = 5;
-	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD,
-	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling,
-	bt_cmd->bt4_tx_tx_delta_freq_thr = 15,
-	bt_cmd->bt4_tx_rx_max_freq0 = 15,
-
-	flags = iwlwifi_mod_params.bt_coex_active ?
-			BT_COEX_NW : BT_COEX_DISABLE;
-	bt_cmd->flags = cpu_to_le32(flags);
-
-	bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_ENABLE |
-					    BT_VALID_BT_PRIO_BOOST |
-					    BT_VALID_MAX_KILL |
-					    BT_VALID_3W_TMRS |
-					    BT_VALID_KILL_ACK |
-					    BT_VALID_KILL_CTS |
-					    BT_VALID_REDUCED_TX_POWER |
-					    BT_VALID_LUT |
-					    BT_VALID_WIFI_RX_SW_PRIO_BOOST |
-					    BT_VALID_WIFI_TX_SW_PRIO_BOOST |
-					    BT_VALID_ANT_ISOLATION |
-					    BT_VALID_ANT_ISOLATION_THRS |
-					    BT_VALID_TXTX_DELTA_FREQ_THRS |
-					    BT_VALID_TXRX_MAX_FREQ_0 |
-					    BT_VALID_SYNC_TO_SCO);
-
-	if (IWL_MVM_BT_COEX_SYNC2SCO)
-		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
-
-	if (IWL_MVM_BT_COEX_CORUNNING) {
-		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_CORUN_LUT_20 |
-						    BT_VALID_CORUN_LUT_40);
-		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
-	}
-
-	if (mvm->cfg->bt_shared_single_ant)
-		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
-		       sizeof(iwl_single_shared_ant));
-	else
-		memcpy(&bt_cmd->decision_lut, iwl_combined_lookup,
-		       sizeof(iwl_combined_lookup));
-
-	/* Take first Co-running block LUT to get started */
-	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[0].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut20));
-	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[0].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut40));
-
-	memcpy(&bt_cmd->bt_prio_boost, iwl_bt_prio_boost,
-	       sizeof(iwl_bt_prio_boost));
-	memcpy(&bt_cmd->bt4_multiprio_lut, iwl_bt_mprio_lut,
-	       sizeof(iwl_bt_mprio_lut));
-	bt_cmd->kill_ack_msk =
-		cpu_to_le32(iwl_bt_ack_kill_msk[BT_KILL_MSK_DEFAULT]);
-	bt_cmd->kill_cts_msk =
-		cpu_to_le32(iwl_bt_cts_kill_msk[BT_KILL_MSK_DEFAULT]);
-
-	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
-	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
-
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-
-	kfree(bt_cmd);
-	return ret;
-}
-
-static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
-					   bool reduced_tx_power)
-{
-	enum iwl_bt_kill_msk bt_kill_msk;
-	struct iwl_bt_coex_cmd *bt_cmd;
-	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.data[0] = &bt_cmd,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
-	};
-	int ret = 0;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (reduced_tx_power) {
-		/* Reduced Tx power has precedence on the type of the profile */
-		bt_kill_msk = BT_KILL_MSK_REDUCED_TXPOW;
-	} else {
-		/* Low latency BT profile is active: give higher prio to BT */
-		if (BT_MBOX_MSG(notif, 3, SCO_STATE)  ||
-		    BT_MBOX_MSG(notif, 3, A2DP_STATE) ||
-		    BT_MBOX_MSG(notif, 3, SNIFF_STATE))
-			bt_kill_msk = BT_KILL_MSK_SCO_HID_A2DP;
-		else
-			bt_kill_msk = BT_KILL_MSK_DEFAULT;
-	}
-
-	IWL_DEBUG_COEX(mvm,
-		       "Update kill_msk: %d - SCO %sactive A2DP %sactive SNIFF %sactive\n",
-		       bt_kill_msk,
-		       BT_MBOX_MSG(notif, 3, SCO_STATE) ? "" : "in",
-		       BT_MBOX_MSG(notif, 3, A2DP_STATE) ? "" : "in",
-		       BT_MBOX_MSG(notif, 3, SNIFF_STATE) ? "" : "in");
-
-	/* Don't send HCMD if there is no update */
-	if (bt_kill_msk == mvm->bt_kill_msk)
-		return 0;
-
-	mvm->bt_kill_msk = bt_kill_msk;
-
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
-	if (!bt_cmd)
-		return -ENOMEM;
-	cmd.data[0] = bt_cmd;
-	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
-
-	bt_cmd->kill_ack_msk = cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
-	bt_cmd->kill_cts_msk = cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
-	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
-					     BT_VALID_KILL_ACK |
-					     BT_VALID_KILL_CTS);
-
-	IWL_DEBUG_COEX(mvm, "ACK Kill msk = 0x%08x, CTS Kill msk = 0x%08x\n",
-		       iwl_bt_ack_kill_msk[bt_kill_msk],
-		       iwl_bt_cts_kill_msk[bt_kill_msk]);
-
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-
-	kfree(bt_cmd);
-	return ret;
-}
-
-int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable)
-{
-	struct iwl_bt_coex_cmd *bt_cmd;
-	/* Send ASYNC since this can be sent from an atomic context */
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_ASYNC,
-	};
-	struct iwl_mvm_sta *mvmsta;
-	int ret;
-
-	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
-	if (!mvmsta)
-		return 0;
-
-	/* nothing to do */
-	if (mvmsta->bt_reduced_txpower_dbg ||
-	    mvmsta->bt_reduced_txpower == enable)
-		return 0;
-
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_ATOMIC);
-	if (!bt_cmd)
-		return -ENOMEM;
-	cmd.data[0] = bt_cmd;
-	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
-
-	bt_cmd->valid_bit_msk =
-		cpu_to_le32(BT_VALID_ENABLE | BT_VALID_REDUCED_TX_POWER);
-	bt_cmd->bt_reduced_tx_power = sta_id;
-
-	if (enable)
-		bt_cmd->bt_reduced_tx_power |= BT_REDUCED_TX_POWER_BIT;
-
-	IWL_DEBUG_COEX(mvm, "%sable reduced Tx Power for sta %d\n",
-		       enable ? "en" : "dis", sta_id);
-
-	mvmsta->bt_reduced_txpower = enable;
-
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-
-	kfree(bt_cmd);
-	return ret;
-}
-
-struct iwl_bt_iterator_data {
-	struct iwl_bt_coex_profile_notif *notif;
-	struct iwl_mvm *mvm;
-	u32 num_bss_ifaces;
-	bool reduced_tx_power;
-	struct ieee80211_chanctx_conf *primary;
-	struct ieee80211_chanctx_conf *secondary;
-	bool primary_ll;
-};
-
-static inline
-void iwl_mvm_bt_coex_enable_rssi_event(struct iwl_mvm *mvm,
-				       struct ieee80211_vif *vif,
-				       bool enable, int rssi)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	mvmvif->bf_data.last_bt_coex_event = rssi;
-	mvmvif->bf_data.bt_coex_max_thold =
-		enable ? BT_ENABLE_REDUCED_TXPOWER_THRESHOLD : 0;
-	mvmvif->bf_data.bt_coex_min_thold =
-		enable ? BT_DISABLE_REDUCED_TXPOWER_THRESHOLD : 0;
-}
-
-/* must be called under rcu_read_lock */
-static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
-				      struct ieee80211_vif *vif)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_bt_iterator_data *data = _data;
-	struct iwl_mvm *mvm = data->mvm;
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum ieee80211_smps_mode smps_mode;
-	u32 bt_activity_grading;
-	int ave_rssi;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		/* default smps_mode for BSS / P2P client is AUTOMATIC */
-		smps_mode = IEEE80211_SMPS_AUTOMATIC;
-		data->num_bss_ifaces++;
-
-		/*
-		 * Count unassoc BSSes, relax SMSP constraints
-		 * and disable reduced Tx Power
-		 */
-		if (!vif->bss_conf.assoc) {
-			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-					    smps_mode);
-			if (iwl_mvm_bt_coex_reduced_txp(mvm,
-							mvmvif->ap_sta_id,
-							false))
-				IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-			return;
-		}
-		break;
-	case NL80211_IFTYPE_AP:
-		/* default smps_mode for AP / GO is OFF */
-		smps_mode = IEEE80211_SMPS_OFF;
-		if (!mvmvif->ap_ibss_active) {
-			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-					    smps_mode);
-			return;
-		}
-
-		/* the Ack / Cts kill mask must be default if AP / GO */
-		data->reduced_tx_power = false;
-		break;
-	default:
-		return;
-	}
-
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-
-	/* If channel context is invalid or not on 2.4GHz .. */
-	if ((!chanctx_conf ||
-	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ)) {
-		/* ... relax constraints and disable rssi events */
-		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-				    smps_mode);
-		if (vif->type == NL80211_IFTYPE_STATION)
-			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
-		return;
-	}
-
-	bt_activity_grading = le32_to_cpu(data->notif->bt_activity_grading);
-	if (bt_activity_grading >= BT_HIGH_TRAFFIC)
-		smps_mode = IEEE80211_SMPS_STATIC;
-	else if (bt_activity_grading >= BT_LOW_TRAFFIC)
-		smps_mode = vif->type == NL80211_IFTYPE_AP ?
-				IEEE80211_SMPS_OFF :
-				IEEE80211_SMPS_DYNAMIC;
-	IWL_DEBUG_COEX(data->mvm,
-		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
-		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
-		       smps_mode);
-
-	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
-
-	/* low latency is always primary */
-	if (iwl_mvm_vif_low_latency(mvmvif)) {
-		data->primary_ll = true;
-
-		data->secondary = data->primary;
-		data->primary = chanctx_conf;
-	}
-
-	if (vif->type == NL80211_IFTYPE_AP) {
-		if (!mvmvif->ap_ibss_active)
-			return;
-
-		if (chanctx_conf == data->primary)
-			return;
-
-		if (!data->primary_ll) {
-			/*
-			 * downgrade the current primary no matter what its
-			 * type is.
-			 */
-			data->secondary = data->primary;
-			data->primary = chanctx_conf;
-		} else {
-			/* there is low latency vif - we will be secondary */
-			data->secondary = chanctx_conf;
-		}
-		return;
-	}
-
-	/*
-	 * STA / P2P Client, try to be primary if first vif. If we are in low
-	 * latency mode, we are already in primary and just don't do much
-	 */
-	if (!data->primary || data->primary == chanctx_conf)
-		data->primary = chanctx_conf;
-	else if (!data->secondary)
-		/* if secondary is not NULL, it might be a GO */
-		data->secondary = chanctx_conf;
-
-	/* don't reduce the Tx power if in loose scheme */
-	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
-	    mvm->cfg->bt_shared_single_ant) {
-		data->reduced_tx_power = false;
-		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
-		return;
-	}
-
-	/* reduced Txpower only if BT is on, so ...*/
-	if (!data->notif->bt_status) {
-		/* ... cancel reduced Tx power ... */
-		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
-			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-		data->reduced_tx_power = false;
-
-		/* ... and there is no need to get reports on RSSI any more. */
-		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
-		return;
-	}
-
-	/* try to get the avg rssi from fw */
-	ave_rssi = mvmvif->bf_data.ave_beacon_signal;
-
-	/* if the RSSI isn't valid, fake it is very low */
-	if (!ave_rssi)
-		ave_rssi = -100;
-	if (ave_rssi > BT_ENABLE_REDUCED_TXPOWER_THRESHOLD) {
-		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true))
-			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-
-		/*
-		 * bt_kill_msk can be BT_KILL_MSK_REDUCED_TXPOW only if all the
-		 * BSS / P2P clients have rssi above threshold.
-		 * We set the bt_kill_msk to BT_KILL_MSK_REDUCED_TXPOW before
-		 * the iteration, if one interface's rssi isn't good enough,
-		 * bt_kill_msk will be set to default values.
-		 */
-	} else if (ave_rssi < BT_DISABLE_REDUCED_TXPOWER_THRESHOLD) {
-		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
-			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-
-		/*
-		 * One interface hasn't rssi above threshold, bt_kill_msk must
-		 * be set to default values.
-		 */
-		data->reduced_tx_power = false;
-	}
-
-	/* Begin to monitor the RSSI: it may influence the reduced Tx power */
-	iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, true, ave_rssi);
-}
-
-static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
-{
-	struct iwl_bt_iterator_data data = {
-		.mvm = mvm,
-		.notif = &mvm->last_bt_notif,
-		.reduced_tx_power = true,
-	};
-	struct iwl_bt_coex_ci_cmd cmd = {};
-	u8 ci_bw_idx;
-
-	rcu_read_lock();
-	ieee80211_iterate_active_interfaces_atomic(
-					mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-					iwl_mvm_bt_notif_iterator, &data);
-
-	if (data.primary) {
-		struct ieee80211_chanctx_conf *chan = data.primary;
-		if (WARN_ON(!chan->def.chan)) {
-			rcu_read_unlock();
-			return;
-		}
-
-		if (chan->def.width < NL80211_CHAN_WIDTH_40) {
-			ci_bw_idx = 0;
-			cmd.co_run_bw_primary = 0;
-		} else {
-			cmd.co_run_bw_primary = 1;
-			if (chan->def.center_freq1 >
-			    chan->def.chan->center_freq)
-				ci_bw_idx = 2;
-			else
-				ci_bw_idx = 1;
-		}
-
-		cmd.bt_primary_ci =
-			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
-		cmd.primary_ch_phy_id = *((u16 *)data.primary->drv_priv);
-	}
-
-	if (data.secondary) {
-		struct ieee80211_chanctx_conf *chan = data.secondary;
-		if (WARN_ON(!data.secondary->def.chan)) {
-			rcu_read_unlock();
-			return;
-		}
-
-		if (chan->def.width < NL80211_CHAN_WIDTH_40) {
-			ci_bw_idx = 0;
-			cmd.co_run_bw_secondary = 0;
-		} else {
-			cmd.co_run_bw_secondary = 1;
-			if (chan->def.center_freq1 >
-			    chan->def.chan->center_freq)
-				ci_bw_idx = 2;
-			else
-				ci_bw_idx = 1;
-		}
-
-		cmd.bt_secondary_ci =
-			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
-		cmd.secondary_ch_phy_id = *((u16 *)data.secondary->drv_priv);
-	}
-
-	rcu_read_unlock();
-
-	/* Don't spam the fw with the same command over and over */
-	if (memcmp(&cmd, &mvm->last_bt_ci_cmd, sizeof(cmd))) {
-		if (iwl_mvm_send_cmd_pdu(mvm, BT_COEX_CI, CMD_SYNC,
-					 sizeof(cmd), &cmd))
-			IWL_ERR(mvm, "Failed to send BT_CI cmd");
-		memcpy(&mvm->last_bt_ci_cmd, &cmd, sizeof(cmd));
-	}
-
-	/*
-	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
-	 * irrelevant since it is based on the RSSI coming from the beacon.
-	 * Use BT_KILL_MSK_DEFAULT in that case.
-	 */
-	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
-
-	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
-		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
-}
-
-/* upon association, the fw will send in BT Coex notification */
-int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
-			     struct iwl_rx_cmd_buffer *rxb,
-			     struct iwl_device_cmd *dev_cmd)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_bt_coex_profile_notif *notif = (void *)pkt->data;
-
-
-	IWL_DEBUG_COEX(mvm, "BT Coex Notification received\n");
-	IWL_DEBUG_COEX(mvm, "\tBT status: %s\n",
-		       notif->bt_status ? "ON" : "OFF");
-	IWL_DEBUG_COEX(mvm, "\tBT open conn %d\n", notif->bt_open_conn);
-	IWL_DEBUG_COEX(mvm, "\tBT ci compliance %d\n", notif->bt_ci_compliance);
-	IWL_DEBUG_COEX(mvm, "\tBT primary_ch_lut %d\n",
-		       le32_to_cpu(notif->primary_ch_lut));
-	IWL_DEBUG_COEX(mvm, "\tBT secondary_ch_lut %d\n",
-		       le32_to_cpu(notif->secondary_ch_lut));
-	IWL_DEBUG_COEX(mvm, "\tBT activity grading %d\n",
-		       le32_to_cpu(notif->bt_activity_grading));
-	IWL_DEBUG_COEX(mvm, "\tBT agg traffic load %d\n",
-		       notif->bt_agg_traffic_load);
-
-	/* remember this notification for future use: rssi fluctuations */
-	memcpy(&mvm->last_bt_notif, notif, sizeof(mvm->last_bt_notif));
-
-	iwl_mvm_bt_coex_notif_handle(mvm);
-
-	/*
-	 * This is an async handler for a notification, returning anything other
-	 * than 0 doesn't make sense even if HCMD failed.
-	 */
-	return 0;
-}
-
-static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
-				   struct ieee80211_vif *vif)
-{
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
-	struct iwl_bt_iterator_data *data = _data;
-	struct iwl_mvm *mvm = data->mvm;
-
-	struct ieee80211_sta *sta;
-	struct iwl_mvm_sta *mvmsta;
-
-	struct ieee80211_chanctx_conf *chanctx_conf;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-	/* If channel context is invalid or not on 2.4GHz - don't count it */
-	if (!chanctx_conf ||
-	    chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
-		rcu_read_unlock();
-		return;
-	}
-	rcu_read_unlock();
-
-	if (vif->type != NL80211_IFTYPE_STATION ||
-	    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
-		return;
-
-	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
-					lockdep_is_held(&mvm->mutex));
-
-	/* This can happen if the station has been removed right now */
-	if (IS_ERR_OR_NULL(sta))
-		return;
-
-	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-	data->num_bss_ifaces++;
-
-	/*
-	 * This interface doesn't support reduced Tx power (because of low
-	 * RSSI probably), then set bt_kill_msk to default values.
-	 */
-	if (!mvmsta->bt_reduced_txpower)
-		data->reduced_tx_power = false;
-	/* else - possibly leave it to BT_KILL_MSK_REDUCED_TXPOW */
-}
-
-void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			   enum ieee80211_rssi_event rssi_event)
-{
-	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
-	struct iwl_bt_iterator_data data = {
-		.mvm = mvm,
-		.reduced_tx_power = true,
-	};
-	int ret;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	/* Rssi update while not associated ?! */
-	if (WARN_ON_ONCE(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
-		return;
-
-	/* No BT - reports should be disabled */
-	if (!mvm->last_bt_notif.bt_status)
-		return;
-
-	IWL_DEBUG_COEX(mvm, "RSSI for %pM is now %s\n", vif->bss_conf.bssid,
-		       rssi_event == RSSI_EVENT_HIGH ? "HIGH" : "LOW");
-
-	/*
-	 * Check if rssi is good enough for reduced Tx power, but not in loose
-	 * scheme.
-	 */
-	if (rssi_event == RSSI_EVENT_LOW || mvm->cfg->bt_shared_single_ant ||
-	    iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT)
-		ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
-						  false);
-	else
-		ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true);
-
-	if (ret)
-		IWL_ERR(mvm, "couldn't send BT_CONFIG HCMD upon RSSI event\n");
-
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_bt_rssi_iterator, &data);
-
-	/*
-	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
-	 * irrelevant since it is based on the RSSI coming from the beacon.
-	 * Use BT_KILL_MSK_DEFAULT in that case.
-	 */
-	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
-
-	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
-		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
-}
-
-#define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000)
-#define LINK_QUAL_AGG_TIME_LIMIT_BT_ACT	(1200)
-
-u16 iwl_mvm_bt_coex_agg_time_limit(struct iwl_mvm *mvm,
-				   struct ieee80211_sta *sta)
-{
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	enum iwl_bt_coex_lut_type lut_type;
-
-	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
-	    BT_HIGH_TRAFFIC)
-		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
-
-	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
-
-	if (lut_type == BT_COEX_LOOSE_LUT)
-		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
-
-	/* tight coex, high bt traffic, reduce AGG time limit */
-	return LINK_QUAL_AGG_TIME_LIMIT_BT_ACT;
-}
-
-bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
-				     struct ieee80211_sta *sta)
-{
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
-	    BT_HIGH_TRAFFIC)
-		return true;
-
-	/*
-	 * In Tight, BT can't Rx while we Tx, so use both antennas since BT is
-	 * already killed.
-	 * In Loose, BT can Rx while we Tx, so forbid MIMO to let BT Rx while we
-	 * Tx.
-	 */
-	return iwl_get_coex_type(mvm, mvmsta->vif) == BT_COEX_TIGHT_LUT;
-}
-
-void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
-{
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
-		return;
-
-	iwl_mvm_bt_coex_notif_handle(mvm);
-}
-
-int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *dev_cmd)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
-	u8 __maybe_unused lower_bound, upper_bound;
-	u8 lut;
-
-	struct iwl_bt_coex_cmd *bt_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
-	};
-
-	if (!IWL_MVM_BT_COEX_CORUNNING)
-		return 0;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (ant_isolation ==  mvm->last_ant_isol)
-		return 0;
-
-	for (lut = 0; lut < ARRAY_SIZE(antenna_coupling_ranges) - 1; lut++)
-		if (ant_isolation < antenna_coupling_ranges[lut + 1].range)
-			break;
-
-	lower_bound = antenna_coupling_ranges[lut].range;
-
-	if (lut < ARRAY_SIZE(antenna_coupling_ranges) - 1)
-		upper_bound = antenna_coupling_ranges[lut + 1].range;
-	else
-		upper_bound = antenna_coupling_ranges[lut].range;
-
-	IWL_DEBUG_COEX(mvm, "Antenna isolation=%d in range [%d,%d[, lut=%d\n",
-		       ant_isolation, lower_bound, upper_bound, lut);
-
-	mvm->last_ant_isol = ant_isolation;
-
-	if (mvm->last_corun_lut == lut)
-		return 0;
-
-	mvm->last_corun_lut = lut;
-
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
-	if (!bt_cmd)
-		return 0;
-	cmd.data[0] = bt_cmd;
-
-	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
-	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
-					     BT_VALID_CORUN_LUT_20 |
-					     BT_VALID_CORUN_LUT_40);
-
-	/* For the moment, use the same LUT for 20GHz and 40GHz */
-	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[lut].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut20));
-
-	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[lut].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut40));
-
-	return 0;
-}
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
new file mode 100644
index 0000000..0b2e351
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -0,0 +1,1280 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
+
+#include <net/mac80211.h>
+
+#include "fw-api-coex.h"
+#include "iwl-modparams.h"
+#include "mvm.h"
+#include "iwl-debug.h"
+
+#define EVENT_PRIO_ANT(_evt, _prio, _shrd_ant)			\
+	[(_evt)] = (((_prio) << BT_COEX_PRIO_TBL_PRIO_POS) |	\
+		   ((_shrd_ant) << BT_COEX_PRIO_TBL_SHRD_ANT_POS))
+
+static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_INIT_CALIB1,
+		       BT_COEX_PRIO_TBL_PRIO_BYPASS, 0),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_INIT_CALIB2,
+		       BT_COEX_PRIO_TBL_PRIO_BYPASS, 1),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1,
+		       BT_COEX_PRIO_TBL_PRIO_LOW, 0),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2,
+		       BT_COEX_PRIO_TBL_PRIO_LOW, 1),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1,
+		       BT_COEX_PRIO_TBL_PRIO_HIGH, 0),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2,
+		       BT_COEX_PRIO_TBL_PRIO_HIGH, 1),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_DTIM,
+		       BT_COEX_PRIO_TBL_DISABLED, 0),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_SCAN52,
+		       BT_COEX_PRIO_TBL_PRIO_COEX_OFF, 0),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_SCAN24,
+		       BT_COEX_PRIO_TBL_PRIO_COEX_ON, 0),
+	EVENT_PRIO_ANT(BT_COEX_PRIO_TBL_EVT_IDLE,
+		       BT_COEX_PRIO_TBL_PRIO_COEX_IDLE, 0),
+	0, 0, 0, 0, 0, 0,
+};
+
+#undef EVENT_PRIO_ANT
+
+#define BT_ENABLE_REDUCED_TXPOWER_THRESHOLD	(-62)
+#define BT_DISABLE_REDUCED_TXPOWER_THRESHOLD	(-65)
+#define BT_ANTENNA_COUPLING_THRESHOLD		(30)
+
+int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
+{
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
+		return 0;
+
+	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, CMD_SYNC,
+				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
+				    &iwl_bt_prio_tbl);
+}
+
+const u32 iwl_bt_ack_kill_msk[BT_KILL_MSK_MAX] = {
+	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
+	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
+	[BT_KILL_MSK_REDUCED_TXPOW] = 0,
+};
+
+const u32 iwl_bt_cts_kill_msk[BT_KILL_MSK_MAX] = {
+	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
+	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
+	[BT_KILL_MSK_REDUCED_TXPOW] = 0,
+};
+
+static const __le32 iwl_bt_prio_boost[BT_COEX_BOOST_SIZE] = {
+	cpu_to_le32(0xf0f0f0f0),
+	cpu_to_le32(0xc0c0c0c0),
+	cpu_to_le32(0xfcfcfcfc),
+	cpu_to_le32(0xff00ff00),
+};
+
+static const __le32 iwl_single_shared_ant[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
+	{
+		cpu_to_le32(0x40000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x44000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x40000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x44000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+	},
+	{
+		cpu_to_le32(0x40000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x44000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x40000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x44000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+	},
+	{
+		cpu_to_le32(0x40000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x44000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x40000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x44000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+	},
+};
+
+static const __le32 iwl_combined_lookup[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
+	{
+		/* Tight */
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaeaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xcc00ff28),
+		cpu_to_le32(0x0000aaaa),
+		cpu_to_le32(0xcc00aaaa),
+		cpu_to_le32(0x0000aaaa),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xf0005000),
+	},
+	{
+		/* Loose */
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xcc00ff28),
+		cpu_to_le32(0x0000aaaa),
+		cpu_to_le32(0xcc00aaaa),
+		cpu_to_le32(0x0000aaaa),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x00000000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xf0005000),
+	},
+	{
+		/* Tx Tx disabled */
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xcc00ff28),
+		cpu_to_le32(0x0000aaaa),
+		cpu_to_le32(0xcc00aaaa),
+		cpu_to_le32(0x0000aaaa),
+		cpu_to_le32(0xC0004000),
+		cpu_to_le32(0xC0004000),
+		cpu_to_le32(0xF0005000),
+		cpu_to_le32(0xF0005000),
+	},
+};
+
+/* 20MHz / 40MHz below / 40Mhz above*/
+static const __le64 iwl_ci_mask[][3] = {
+	/* dummy entry for channel 0 */
+	{cpu_to_le64(0), cpu_to_le64(0), cpu_to_le64(0)},
+	{
+		cpu_to_le64(0x0000001FFFULL),
+		cpu_to_le64(0x0ULL),
+		cpu_to_le64(0x00007FFFFFULL),
+	},
+	{
+		cpu_to_le64(0x000000FFFFULL),
+		cpu_to_le64(0x0ULL),
+		cpu_to_le64(0x0003FFFFFFULL),
+	},
+	{
+		cpu_to_le64(0x000003FFFCULL),
+		cpu_to_le64(0x0ULL),
+		cpu_to_le64(0x000FFFFFFCULL),
+	},
+	{
+		cpu_to_le64(0x00001FFFE0ULL),
+		cpu_to_le64(0x0ULL),
+		cpu_to_le64(0x007FFFFFE0ULL),
+	},
+	{
+		cpu_to_le64(0x00007FFF80ULL),
+		cpu_to_le64(0x00007FFFFFULL),
+		cpu_to_le64(0x01FFFFFF80ULL),
+	},
+	{
+		cpu_to_le64(0x0003FFFC00ULL),
+		cpu_to_le64(0x0003FFFFFFULL),
+		cpu_to_le64(0x0FFFFFFC00ULL),
+	},
+	{
+		cpu_to_le64(0x000FFFF000ULL),
+		cpu_to_le64(0x000FFFFFFCULL),
+		cpu_to_le64(0x3FFFFFF000ULL),
+	},
+	{
+		cpu_to_le64(0x007FFF8000ULL),
+		cpu_to_le64(0x007FFFFFE0ULL),
+		cpu_to_le64(0xFFFFFF8000ULL),
+	},
+	{
+		cpu_to_le64(0x01FFFE0000ULL),
+		cpu_to_le64(0x01FFFFFF80ULL),
+		cpu_to_le64(0xFFFFFE0000ULL),
+	},
+	{
+		cpu_to_le64(0x0FFFF00000ULL),
+		cpu_to_le64(0x0FFFFFFC00ULL),
+		cpu_to_le64(0x0ULL),
+	},
+	{
+		cpu_to_le64(0x3FFFC00000ULL),
+		cpu_to_le64(0x3FFFFFF000ULL),
+		cpu_to_le64(0x0)
+	},
+	{
+		cpu_to_le64(0xFFFE000000ULL),
+		cpu_to_le64(0xFFFFFF8000ULL),
+		cpu_to_le64(0x0)
+	},
+	{
+		cpu_to_le64(0xFFF8000000ULL),
+		cpu_to_le64(0xFFFFFE0000ULL),
+		cpu_to_le64(0x0)
+	},
+	{
+		cpu_to_le64(0xFFC0000000ULL),
+		cpu_to_le64(0x0ULL),
+		cpu_to_le64(0x0ULL)
+	},
+};
+
+static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
+	cpu_to_le32(0x22002200),
+	cpu_to_le32(0x33113311),
+};
+
+struct corunning_block_luts {
+	u8 range;
+	__le32 lut20[BT_COEX_CORUN_LUT_SIZE];
+};
+
+/*
+ * Ranges for the antenna coupling calibration / co-running block LUT:
+ *		LUT0: [ 0, 12[
+ *		LUT1: [12, 20[
+ *		LUT2: [20, 21[
+ *		LUT3: [21, 23[
+ *		LUT4: [23, 27[
+ *		LUT5: [27, 30[
+ *		LUT6: [30, 32[
+ *		LUT7: [32, 33[
+ *		LUT8: [33, - [
+ */
+static const struct corunning_block_luts antenna_coupling_ranges[] = {
+	{
+		.range = 0,
+		.lut20 = {
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 12,
+		.lut20 = {
+			cpu_to_le32(0x00000001),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 20,
+		.lut20 = {
+			cpu_to_le32(0x00000002),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 21,
+		.lut20 = {
+			cpu_to_le32(0x00000003),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 23,
+		.lut20 = {
+			cpu_to_le32(0x00000004),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 27,
+		.lut20 = {
+			cpu_to_le32(0x00000005),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 30,
+		.lut20 = {
+			cpu_to_le32(0x00000006),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 32,
+		.lut20 = {
+			cpu_to_le32(0x00000007),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 33,
+		.lut20 = {
+			cpu_to_le32(0x00000008),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+};
+
+static enum iwl_bt_coex_lut_type
+iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum iwl_bt_coex_lut_type ret;
+	u16 phy_ctx_id;
+
+	/*
+	 * Checking that we hold mvm->mutex is a good idea, but the rate
+	 * control can't acquire the mutex since it runs in Tx path.
+	 * So this is racy in that case, but in the worst case, the AMPDU
+	 * size limit will be wrong for a short time which is not a big
+	 * issue.
+	 */
+
+	rcu_read_lock();
+
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+
+	if (!chanctx_conf ||
+	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
+		rcu_read_unlock();
+		return BT_COEX_LOOSE_LUT;
+	}
+
+	ret = BT_COEX_TX_DIS_LUT;
+
+	if (mvm->cfg->bt_shared_single_ant) {
+		rcu_read_unlock();
+		return ret;
+	}
+
+	phy_ctx_id = *((u16 *)chanctx_conf->drv_priv);
+
+	if (mvm->last_bt_ci_cmd.primary_ch_phy_id == phy_ctx_id)
+		ret = le32_to_cpu(mvm->last_bt_notif.primary_ch_lut);
+	else if (mvm->last_bt_ci_cmd.secondary_ch_phy_id == phy_ctx_id)
+		ret = le32_to_cpu(mvm->last_bt_notif.secondary_ch_lut);
+	/* else - default = TX TX disallowed */
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
+int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
+{
+	struct iwl_bt_coex_cmd *bt_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_SYNC,
+	};
+	int ret;
+	u32 flags;
+
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
+		return 0;
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
+	if (!bt_cmd)
+		return -ENOMEM;
+	cmd.data[0] = bt_cmd;
+
+	bt_cmd->max_kill = 5;
+	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD,
+	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling,
+	bt_cmd->bt4_tx_tx_delta_freq_thr = 15,
+	bt_cmd->bt4_tx_rx_max_freq0 = 15,
+
+	flags = iwlwifi_mod_params.bt_coex_active ?
+			BT_COEX_NW : BT_COEX_DISABLE;
+	bt_cmd->flags = cpu_to_le32(flags);
+
+	bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_ENABLE |
+					    BT_VALID_BT_PRIO_BOOST |
+					    BT_VALID_MAX_KILL |
+					    BT_VALID_3W_TMRS |
+					    BT_VALID_KILL_ACK |
+					    BT_VALID_KILL_CTS |
+					    BT_VALID_REDUCED_TX_POWER |
+					    BT_VALID_LUT |
+					    BT_VALID_WIFI_RX_SW_PRIO_BOOST |
+					    BT_VALID_WIFI_TX_SW_PRIO_BOOST |
+					    BT_VALID_ANT_ISOLATION |
+					    BT_VALID_ANT_ISOLATION_THRS |
+					    BT_VALID_TXTX_DELTA_FREQ_THRS |
+					    BT_VALID_TXRX_MAX_FREQ_0 |
+					    BT_VALID_SYNC_TO_SCO);
+
+	if (IWL_MVM_BT_COEX_SYNC2SCO)
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
+
+	if (IWL_MVM_BT_COEX_CORUNNING) {
+		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_CORUN_LUT_20 |
+						    BT_VALID_CORUN_LUT_40);
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
+	}
+
+	if (mvm->cfg->bt_shared_single_ant)
+		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
+		       sizeof(iwl_single_shared_ant));
+	else
+		memcpy(&bt_cmd->decision_lut, iwl_combined_lookup,
+		       sizeof(iwl_combined_lookup));
+
+	/* Take first Co-running block LUT to get started */
+	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[0].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut20));
+	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[0].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut40));
+
+	memcpy(&bt_cmd->bt_prio_boost, iwl_bt_prio_boost,
+	       sizeof(iwl_bt_prio_boost));
+	memcpy(&bt_cmd->bt4_multiprio_lut, iwl_bt_mprio_lut,
+	       sizeof(iwl_bt_mprio_lut));
+	bt_cmd->kill_ack_msk =
+		cpu_to_le32(iwl_bt_ack_kill_msk[BT_KILL_MSK_DEFAULT]);
+	bt_cmd->kill_cts_msk =
+		cpu_to_le32(iwl_bt_cts_kill_msk[BT_KILL_MSK_DEFAULT]);
+
+	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
+	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(bt_cmd);
+	return ret;
+}
+
+static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
+					   bool reduced_tx_power)
+{
+	enum iwl_bt_kill_msk bt_kill_msk;
+	struct iwl_bt_coex_cmd *bt_cmd;
+	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.data[0] = &bt_cmd,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_SYNC,
+	};
+	int ret = 0;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (reduced_tx_power) {
+		/* Reduced Tx power has precedence on the type of the profile */
+		bt_kill_msk = BT_KILL_MSK_REDUCED_TXPOW;
+	} else {
+		/* Low latency BT profile is active: give higher prio to BT */
+		if (BT_MBOX_MSG(notif, 3, SCO_STATE)  ||
+		    BT_MBOX_MSG(notif, 3, A2DP_STATE) ||
+		    BT_MBOX_MSG(notif, 3, SNIFF_STATE))
+			bt_kill_msk = BT_KILL_MSK_SCO_HID_A2DP;
+		else
+			bt_kill_msk = BT_KILL_MSK_DEFAULT;
+	}
+
+	IWL_DEBUG_COEX(mvm,
+		       "Update kill_msk: %d - SCO %sactive A2DP %sactive SNIFF %sactive\n",
+		       bt_kill_msk,
+		       BT_MBOX_MSG(notif, 3, SCO_STATE) ? "" : "in",
+		       BT_MBOX_MSG(notif, 3, A2DP_STATE) ? "" : "in",
+		       BT_MBOX_MSG(notif, 3, SNIFF_STATE) ? "" : "in");
+
+	/* Don't send HCMD if there is no update */
+	if (bt_kill_msk == mvm->bt_kill_msk)
+		return 0;
+
+	mvm->bt_kill_msk = bt_kill_msk;
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
+	if (!bt_cmd)
+		return -ENOMEM;
+	cmd.data[0] = bt_cmd;
+	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
+
+	bt_cmd->kill_ack_msk = cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
+	bt_cmd->kill_cts_msk = cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
+	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
+					     BT_VALID_KILL_ACK |
+					     BT_VALID_KILL_CTS);
+
+	IWL_DEBUG_COEX(mvm, "ACK Kill msk = 0x%08x, CTS Kill msk = 0x%08x\n",
+		       iwl_bt_ack_kill_msk[bt_kill_msk],
+		       iwl_bt_cts_kill_msk[bt_kill_msk]);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(bt_cmd);
+	return ret;
+}
+
+int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable)
+{
+	struct iwl_bt_coex_cmd *bt_cmd;
+	/* Send ASYNC since this can be sent from an atomic context */
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_ASYNC,
+	};
+	struct iwl_mvm_sta *mvmsta;
+	int ret;
+
+	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
+	if (!mvmsta)
+		return 0;
+
+	/* nothing to do */
+	if (mvmsta->bt_reduced_txpower_dbg ||
+	    mvmsta->bt_reduced_txpower == enable)
+		return 0;
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_ATOMIC);
+	if (!bt_cmd)
+		return -ENOMEM;
+	cmd.data[0] = bt_cmd;
+	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
+
+	bt_cmd->valid_bit_msk =
+		cpu_to_le32(BT_VALID_ENABLE | BT_VALID_REDUCED_TX_POWER);
+	bt_cmd->bt_reduced_tx_power = sta_id;
+
+	if (enable)
+		bt_cmd->bt_reduced_tx_power |= BT_REDUCED_TX_POWER_BIT;
+
+	IWL_DEBUG_COEX(mvm, "%sable reduced Tx Power for sta %d\n",
+		       enable ? "en" : "dis", sta_id);
+
+	mvmsta->bt_reduced_txpower = enable;
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(bt_cmd);
+	return ret;
+}
+
+struct iwl_bt_iterator_data {
+	struct iwl_bt_coex_profile_notif *notif;
+	struct iwl_mvm *mvm;
+	u32 num_bss_ifaces;
+	bool reduced_tx_power;
+	struct ieee80211_chanctx_conf *primary;
+	struct ieee80211_chanctx_conf *secondary;
+	bool primary_ll;
+};
+
+static inline
+void iwl_mvm_bt_coex_enable_rssi_event(struct iwl_mvm *mvm,
+				       struct ieee80211_vif *vif,
+				       bool enable, int rssi)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	mvmvif->bf_data.last_bt_coex_event = rssi;
+	mvmvif->bf_data.bt_coex_max_thold =
+		enable ? BT_ENABLE_REDUCED_TXPOWER_THRESHOLD : 0;
+	mvmvif->bf_data.bt_coex_min_thold =
+		enable ? BT_DISABLE_REDUCED_TXPOWER_THRESHOLD : 0;
+}
+
+/* must be called under rcu_read_lock */
+static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_bt_iterator_data *data = _data;
+	struct iwl_mvm *mvm = data->mvm;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_smps_mode smps_mode;
+	u32 bt_activity_grading;
+	int ave_rssi;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		/* default smps_mode for BSS / P2P client is AUTOMATIC */
+		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+		data->num_bss_ifaces++;
+
+		/*
+		 * Count unassoc BSSes, relax SMSP constraints
+		 * and disable reduced Tx Power
+		 */
+		if (!vif->bss_conf.assoc) {
+			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+					    smps_mode);
+			if (iwl_mvm_bt_coex_reduced_txp(mvm,
+							mvmvif->ap_sta_id,
+							false))
+				IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
+			return;
+		}
+		break;
+	case NL80211_IFTYPE_AP:
+		/* default smps_mode for AP / GO is OFF */
+		smps_mode = IEEE80211_SMPS_OFF;
+		if (!mvmvif->ap_ibss_active) {
+			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+					    smps_mode);
+			return;
+		}
+
+		/* the Ack / Cts kill mask must be default if AP / GO */
+		data->reduced_tx_power = false;
+		break;
+	default:
+		return;
+	}
+
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+
+	/* If channel context is invalid or not on 2.4GHz .. */
+	if ((!chanctx_conf ||
+	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ)) {
+		/* ... relax constraints and disable rssi events */
+		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+				    smps_mode);
+		if (vif->type == NL80211_IFTYPE_STATION)
+			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
+		return;
+	}
+
+	bt_activity_grading = le32_to_cpu(data->notif->bt_activity_grading);
+	if (bt_activity_grading >= BT_HIGH_TRAFFIC)
+		smps_mode = IEEE80211_SMPS_STATIC;
+	else if (bt_activity_grading >= BT_LOW_TRAFFIC)
+		smps_mode = vif->type == NL80211_IFTYPE_AP ?
+				IEEE80211_SMPS_OFF :
+				IEEE80211_SMPS_DYNAMIC;
+	IWL_DEBUG_COEX(data->mvm,
+		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
+		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
+		       smps_mode);
+
+	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
+
+	/* low latency is always primary */
+	if (iwl_mvm_vif_low_latency(mvmvif)) {
+		data->primary_ll = true;
+
+		data->secondary = data->primary;
+		data->primary = chanctx_conf;
+	}
+
+	if (vif->type == NL80211_IFTYPE_AP) {
+		if (!mvmvif->ap_ibss_active)
+			return;
+
+		if (chanctx_conf == data->primary)
+			return;
+
+		if (!data->primary_ll) {
+			/*
+			 * downgrade the current primary no matter what its
+			 * type is.
+			 */
+			data->secondary = data->primary;
+			data->primary = chanctx_conf;
+		} else {
+			/* there is low latency vif - we will be secondary */
+			data->secondary = chanctx_conf;
+		}
+		return;
+	}
+
+	/*
+	 * STA / P2P Client, try to be primary if first vif. If we are in low
+	 * latency mode, we are already in primary and just don't do much
+	 */
+	if (!data->primary || data->primary == chanctx_conf)
+		data->primary = chanctx_conf;
+	else if (!data->secondary)
+		/* if secondary is not NULL, it might be a GO */
+		data->secondary = chanctx_conf;
+
+	/* don't reduce the Tx power if in loose scheme */
+	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
+	    mvm->cfg->bt_shared_single_ant) {
+		data->reduced_tx_power = false;
+		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
+		return;
+	}
+
+	/* reduced Txpower only if BT is on, so ...*/
+	if (!data->notif->bt_status) {
+		/* ... cancel reduced Tx power ... */
+		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
+			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
+		data->reduced_tx_power = false;
+
+		/* ... and there is no need to get reports on RSSI any more. */
+		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
+		return;
+	}
+
+	/* try to get the avg rssi from fw */
+	ave_rssi = mvmvif->bf_data.ave_beacon_signal;
+
+	/* if the RSSI isn't valid, fake it is very low */
+	if (!ave_rssi)
+		ave_rssi = -100;
+	if (ave_rssi > BT_ENABLE_REDUCED_TXPOWER_THRESHOLD) {
+		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true))
+			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
+
+		/*
+		 * bt_kill_msk can be BT_KILL_MSK_REDUCED_TXPOW only if all the
+		 * BSS / P2P clients have rssi above threshold.
+		 * We set the bt_kill_msk to BT_KILL_MSK_REDUCED_TXPOW before
+		 * the iteration, if one interface's rssi isn't good enough,
+		 * bt_kill_msk will be set to default values.
+		 */
+	} else if (ave_rssi < BT_DISABLE_REDUCED_TXPOWER_THRESHOLD) {
+		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
+			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
+
+		/*
+		 * One interface hasn't rssi above threshold, bt_kill_msk must
+		 * be set to default values.
+		 */
+		data->reduced_tx_power = false;
+	}
+
+	/* Begin to monitor the RSSI: it may influence the reduced Tx power */
+	iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, true, ave_rssi);
+}
+
+static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
+{
+	struct iwl_bt_iterator_data data = {
+		.mvm = mvm,
+		.notif = &mvm->last_bt_notif,
+		.reduced_tx_power = true,
+	};
+	struct iwl_bt_coex_ci_cmd cmd = {};
+	u8 ci_bw_idx;
+
+	rcu_read_lock();
+	ieee80211_iterate_active_interfaces_atomic(
+					mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_bt_notif_iterator, &data);
+
+	if (data.primary) {
+		struct ieee80211_chanctx_conf *chan = data.primary;
+		if (WARN_ON(!chan->def.chan)) {
+			rcu_read_unlock();
+			return;
+		}
+
+		if (chan->def.width < NL80211_CHAN_WIDTH_40) {
+			ci_bw_idx = 0;
+			cmd.co_run_bw_primary = 0;
+		} else {
+			cmd.co_run_bw_primary = 1;
+			if (chan->def.center_freq1 >
+			    chan->def.chan->center_freq)
+				ci_bw_idx = 2;
+			else
+				ci_bw_idx = 1;
+		}
+
+		cmd.bt_primary_ci =
+			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
+		cmd.primary_ch_phy_id = *((u16 *)data.primary->drv_priv);
+	}
+
+	if (data.secondary) {
+		struct ieee80211_chanctx_conf *chan = data.secondary;
+		if (WARN_ON(!data.secondary->def.chan)) {
+			rcu_read_unlock();
+			return;
+		}
+
+		if (chan->def.width < NL80211_CHAN_WIDTH_40) {
+			ci_bw_idx = 0;
+			cmd.co_run_bw_secondary = 0;
+		} else {
+			cmd.co_run_bw_secondary = 1;
+			if (chan->def.center_freq1 >
+			    chan->def.chan->center_freq)
+				ci_bw_idx = 2;
+			else
+				ci_bw_idx = 1;
+		}
+
+		cmd.bt_secondary_ci =
+			iwl_ci_mask[chan->def.chan->hw_value][ci_bw_idx];
+		cmd.secondary_ch_phy_id = *((u16 *)data.secondary->drv_priv);
+	}
+
+	rcu_read_unlock();
+
+	/* Don't spam the fw with the same command over and over */
+	if (memcmp(&cmd, &mvm->last_bt_ci_cmd, sizeof(cmd))) {
+		if (iwl_mvm_send_cmd_pdu(mvm, BT_COEX_CI, CMD_SYNC,
+					 sizeof(cmd), &cmd))
+			IWL_ERR(mvm, "Failed to send BT_CI cmd");
+		memcpy(&mvm->last_bt_ci_cmd, &cmd, sizeof(cmd));
+	}
+
+	/*
+	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
+	 * irrelevant since it is based on the RSSI coming from the beacon.
+	 * Use BT_KILL_MSK_DEFAULT in that case.
+	 */
+	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
+
+	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
+		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
+}
+
+/* upon association, the fw will send in BT Coex notification */
+int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
+			     struct iwl_rx_cmd_buffer *rxb,
+			     struct iwl_device_cmd *dev_cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_bt_coex_profile_notif *notif = (void *)pkt->data;
+
+
+	IWL_DEBUG_COEX(mvm, "BT Coex Notification received\n");
+	IWL_DEBUG_COEX(mvm, "\tBT status: %s\n",
+		       notif->bt_status ? "ON" : "OFF");
+	IWL_DEBUG_COEX(mvm, "\tBT open conn %d\n", notif->bt_open_conn);
+	IWL_DEBUG_COEX(mvm, "\tBT ci compliance %d\n", notif->bt_ci_compliance);
+	IWL_DEBUG_COEX(mvm, "\tBT primary_ch_lut %d\n",
+		       le32_to_cpu(notif->primary_ch_lut));
+	IWL_DEBUG_COEX(mvm, "\tBT secondary_ch_lut %d\n",
+		       le32_to_cpu(notif->secondary_ch_lut));
+	IWL_DEBUG_COEX(mvm, "\tBT activity grading %d\n",
+		       le32_to_cpu(notif->bt_activity_grading));
+	IWL_DEBUG_COEX(mvm, "\tBT agg traffic load %d\n",
+		       notif->bt_agg_traffic_load);
+
+	/* remember this notification for future use: rssi fluctuations */
+	memcpy(&mvm->last_bt_notif, notif, sizeof(mvm->last_bt_notif));
+
+	iwl_mvm_bt_coex_notif_handle(mvm);
+
+	/*
+	 * This is an async handler for a notification, returning anything other
+	 * than 0 doesn't make sense even if HCMD failed.
+	 */
+	return 0;
+}
+
+static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_bt_iterator_data *data = _data;
+	struct iwl_mvm *mvm = data->mvm;
+
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+
+	struct ieee80211_chanctx_conf *chanctx_conf;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	/* If channel context is invalid or not on 2.4GHz - don't count it */
+	if (!chanctx_conf ||
+	    chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	if (vif->type != NL80211_IFTYPE_STATION ||
+	    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
+		return;
+
+	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
+					lockdep_is_held(&mvm->mutex));
+
+	/* This can happen if the station has been removed right now */
+	if (IS_ERR_OR_NULL(sta))
+		return;
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	data->num_bss_ifaces++;
+
+	/*
+	 * This interface doesn't support reduced Tx power (because of low
+	 * RSSI probably), then set bt_kill_msk to default values.
+	 */
+	if (!mvmsta->bt_reduced_txpower)
+		data->reduced_tx_power = false;
+	/* else - possibly leave it to BT_KILL_MSK_REDUCED_TXPOW */
+}
+
+void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			   enum ieee80211_rssi_event rssi_event)
+{
+	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
+	struct iwl_bt_iterator_data data = {
+		.mvm = mvm,
+		.reduced_tx_power = true,
+	};
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* Rssi update while not associated ?! */
+	if (WARN_ON_ONCE(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
+		return;
+
+	/* No BT - reports should be disabled */
+	if (!mvm->last_bt_notif.bt_status)
+		return;
+
+	IWL_DEBUG_COEX(mvm, "RSSI for %pM is now %s\n", vif->bss_conf.bssid,
+		       rssi_event == RSSI_EVENT_HIGH ? "HIGH" : "LOW");
+
+	/*
+	 * Check if rssi is good enough for reduced Tx power, but not in loose
+	 * scheme.
+	 */
+	if (rssi_event == RSSI_EVENT_LOW || mvm->cfg->bt_shared_single_ant ||
+	    iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT)
+		ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
+						  false);
+	else
+		ret = iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true);
+
+	if (ret)
+		IWL_ERR(mvm, "couldn't send BT_CONFIG HCMD upon RSSI event\n");
+
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_bt_rssi_iterator, &data);
+
+	/*
+	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
+	 * irrelevant since it is based on the RSSI coming from the beacon.
+	 * Use BT_KILL_MSK_DEFAULT in that case.
+	 */
+	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
+
+	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
+		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
+}
+
+#define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000)
+#define LINK_QUAL_AGG_TIME_LIMIT_BT_ACT	(1200)
+
+u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
+				struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	enum iwl_bt_coex_lut_type lut_type;
+
+	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
+	    BT_HIGH_TRAFFIC)
+		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
+
+	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
+
+	if (lut_type == BT_COEX_LOOSE_LUT)
+		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
+
+	/* tight coex, high bt traffic, reduce AGG time limit */
+	return LINK_QUAL_AGG_TIME_LIMIT_BT_ACT;
+}
+
+bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
+				     struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
+	    BT_HIGH_TRAFFIC)
+		return true;
+
+	/*
+	 * In Tight, BT can't Rx while we Tx, so use both antennas since BT is
+	 * already killed.
+	 * In Loose, BT can Rx while we Tx, so forbid MIMO to let BT Rx while we
+	 * Tx.
+	 */
+	return iwl_get_coex_type(mvm, mvmsta->vif) == BT_COEX_TIGHT_LUT;
+}
+
+void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
+{
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWBT_COEX))
+		return;
+
+	iwl_mvm_bt_coex_notif_handle(mvm);
+}
+
+int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
+				  struct iwl_rx_cmd_buffer *rxb,
+				  struct iwl_device_cmd *dev_cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
+	u8 __maybe_unused lower_bound, upper_bound;
+	u8 lut;
+
+	struct iwl_bt_coex_cmd *bt_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_SYNC,
+	};
+
+	if (!IWL_MVM_BT_COEX_CORUNNING)
+		return 0;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (ant_isolation ==  mvm->last_ant_isol)
+		return 0;
+
+	for (lut = 0; lut < ARRAY_SIZE(antenna_coupling_ranges) - 1; lut++)
+		if (ant_isolation < antenna_coupling_ranges[lut + 1].range)
+			break;
+
+	lower_bound = antenna_coupling_ranges[lut].range;
+
+	if (lut < ARRAY_SIZE(antenna_coupling_ranges) - 1)
+		upper_bound = antenna_coupling_ranges[lut + 1].range;
+	else
+		upper_bound = antenna_coupling_ranges[lut].range;
+
+	IWL_DEBUG_COEX(mvm, "Antenna isolation=%d in range [%d,%d[, lut=%d\n",
+		       ant_isolation, lower_bound, upper_bound, lut);
+
+	mvm->last_ant_isol = ant_isolation;
+
+	if (mvm->last_corun_lut == lut)
+		return 0;
+
+	mvm->last_corun_lut = lut;
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
+	if (!bt_cmd)
+		return 0;
+	cmd.data[0] = bt_cmd;
+
+	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
+	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
+					     BT_VALID_CORUN_LUT_20 |
+					     BT_VALID_CORUN_LUT_40);
+
+	/* For the moment, use the same LUT for 20GHz and 40GHz */
+	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[lut].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut20));
+
+	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[lut].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut40));
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
deleted file mode 100644
index 32156d7..0000000
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
+++ /dev/null
@@ -1,350 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
- * in the file called COPYING.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
-#ifndef __fw_api_bt_coex_h__
-#define __fw_api_bt_coex_h__
-
-#include <linux/types.h>
-#include <linux/bitops.h>
-
-#define BITS(nb) (BIT(nb) - 1)
-
-/**
- * enum iwl_bt_coex_flags - flags for BT_COEX command
- * @BT_COEX_MODE_POS:
- * @BT_COEX_MODE_MSK:
- * @BT_COEX_DISABLE:
- * @BT_COEX_2W:
- * @BT_COEX_3W:
- * @BT_COEX_NW:
- * @BT_COEX_SYNC2SCO:
- * @BT_COEX_CORUNNING:
- *
- * The COEX_MODE must be set for each command. Even if it is not changed.
- */
-enum iwl_bt_coex_flags {
-	BT_COEX_MODE_POS		= 3,
-	BT_COEX_MODE_MSK		= BITS(3) << BT_COEX_MODE_POS,
-	BT_COEX_DISABLE			= 0x0 << BT_COEX_MODE_POS,
-	BT_COEX_2W			= 0x1 << BT_COEX_MODE_POS,
-	BT_COEX_3W			= 0x2 << BT_COEX_MODE_POS,
-	BT_COEX_NW			= 0x3 << BT_COEX_MODE_POS,
-	BT_COEX_SYNC2SCO		= BIT(7),
-	BT_COEX_CORUNNING		= BIT(8),
-};
-
-/*
- * indicates what has changed in the BT_COEX command.
- * BT_VALID_ENABLE must be set for each command. Commands without this bit will
- * discarded by the firmware
- */
-enum iwl_bt_coex_valid_bit_msk {
-	BT_VALID_ENABLE			= BIT(0),
-	BT_VALID_BT_PRIO_BOOST		= BIT(1),
-	BT_VALID_MAX_KILL		= BIT(2),
-	BT_VALID_3W_TMRS		= BIT(3),
-	BT_VALID_KILL_ACK		= BIT(4),
-	BT_VALID_KILL_CTS		= BIT(5),
-	BT_VALID_REDUCED_TX_POWER	= BIT(6),
-	BT_VALID_LUT			= BIT(7),
-	BT_VALID_WIFI_RX_SW_PRIO_BOOST	= BIT(8),
-	BT_VALID_WIFI_TX_SW_PRIO_BOOST	= BIT(9),
-	BT_VALID_MULTI_PRIO_LUT		= BIT(10),
-	BT_VALID_TRM_KICK_FILTER	= BIT(11),
-	BT_VALID_CORUN_LUT_20		= BIT(12),
-	BT_VALID_CORUN_LUT_40		= BIT(13),
-	BT_VALID_ANT_ISOLATION		= BIT(14),
-	BT_VALID_ANT_ISOLATION_THRS	= BIT(15),
-	BT_VALID_TXTX_DELTA_FREQ_THRS	= BIT(16),
-	BT_VALID_TXRX_MAX_FREQ_0	= BIT(17),
-	BT_VALID_SYNC_TO_SCO		= BIT(18),
-};
-
-/**
- * enum iwl_bt_reduced_tx_power - allows to reduce txpower for WiFi frames.
- * @BT_REDUCED_TX_POWER_CTL: reduce Tx power for control frames
- * @BT_REDUCED_TX_POWER_DATA: reduce Tx power for data frames
- *
- * This mechanism allows to have BT and WiFi run concurrently. Since WiFi
- * reduces its Tx power, it can work along with BT, hence reducing the amount
- * of WiFi frames being killed by BT.
- */
-enum iwl_bt_reduced_tx_power {
-	BT_REDUCED_TX_POWER_CTL		= BIT(0),
-	BT_REDUCED_TX_POWER_DATA	= BIT(1),
-};
-
-enum iwl_bt_coex_lut_type {
-	BT_COEX_TIGHT_LUT = 0,
-	BT_COEX_LOOSE_LUT,
-	BT_COEX_TX_DIS_LUT,
-
-	BT_COEX_MAX_LUT,
-};
-
-#define BT_COEX_LUT_SIZE (12)
-#define BT_COEX_CORUN_LUT_SIZE (32)
-#define BT_COEX_MULTI_PRIO_LUT_SIZE (2)
-#define BT_COEX_BOOST_SIZE (4)
-#define BT_REDUCED_TX_POWER_BIT BIT(7)
-
-/**
- * struct iwl_bt_coex_cmd - bt coex configuration command
- * @flags:&enum iwl_bt_coex_flags
- * @max_kill:
- * @bt_reduced_tx_power: enum %iwl_bt_reduced_tx_power
- * @bt4_antenna_isolation:
- * @bt4_antenna_isolation_thr:
- * @bt4_tx_tx_delta_freq_thr:
- * @bt4_tx_rx_max_freq0:
- * @bt_prio_boost:
- * @wifi_tx_prio_boost: SW boost of wifi tx priority
- * @wifi_rx_prio_boost: SW boost of wifi rx priority
- * @kill_ack_msk:
- * @kill_cts_msk:
- * @decision_lut:
- * @bt4_multiprio_lut:
- * @bt4_corun_lut20:
- * @bt4_corun_lut40:
- * @valid_bit_msk: enum %iwl_bt_coex_valid_bit_msk
- *
- * The structure is used for the BT_COEX command.
- */
-struct iwl_bt_coex_cmd {
-	__le32 flags;
-	u8 max_kill;
-	u8 bt_reduced_tx_power;
-	u8 reserved[2];
-
-	u8 bt4_antenna_isolation;
-	u8 bt4_antenna_isolation_thr;
-	u8 bt4_tx_tx_delta_freq_thr;
-	u8 bt4_tx_rx_max_freq0;
-
-	__le32 bt_prio_boost[BT_COEX_BOOST_SIZE];
-	__le32 wifi_tx_prio_boost;
-	__le32 wifi_rx_prio_boost;
-	__le32 kill_ack_msk;
-	__le32 kill_cts_msk;
-
-	__le32 decision_lut[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE];
-	__le32 bt4_multiprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE];
-	__le32 bt4_corun_lut20[BT_COEX_CORUN_LUT_SIZE];
-	__le32 bt4_corun_lut40[BT_COEX_CORUN_LUT_SIZE];
-
-	__le32 valid_bit_msk;
-} __packed; /* BT_COEX_CMD_API_S_VER_3 */
-
-/**
- * struct iwl_bt_coex_ci_cmd - bt coex channel inhibition command
- * @bt_primary_ci:
- * @bt_secondary_ci:
- * @co_run_bw_primary:
- * @co_run_bw_secondary:
- * @primary_ch_phy_id:
- * @secondary_ch_phy_id:
- *
- * Used for BT_COEX_CI command
- */
-struct iwl_bt_coex_ci_cmd {
-	__le64 bt_primary_ci;
-	__le64 bt_secondary_ci;
-
-	u8 co_run_bw_primary;
-	u8 co_run_bw_secondary;
-	u8 primary_ch_phy_id;
-	u8 secondary_ch_phy_id;
-} __packed; /* BT_CI_MSG_API_S_VER_1 */
-
-#define BT_MBOX(n_dw, _msg, _pos, _nbits)	\
-	BT_MBOX##n_dw##_##_msg##_POS = (_pos),	\
-	BT_MBOX##n_dw##_##_msg = BITS(_nbits) << BT_MBOX##n_dw##_##_msg##_POS
-
-enum iwl_bt_mxbox_dw0 {
-	BT_MBOX(0, LE_SLAVE_LAT, 0, 3),
-	BT_MBOX(0, LE_PROF1, 3, 1),
-	BT_MBOX(0, LE_PROF2, 4, 1),
-	BT_MBOX(0, LE_PROF_OTHER, 5, 1),
-	BT_MBOX(0, CHL_SEQ_N, 8, 4),
-	BT_MBOX(0, INBAND_S, 13, 1),
-	BT_MBOX(0, LE_MIN_RSSI, 16, 4),
-	BT_MBOX(0, LE_SCAN, 20, 1),
-	BT_MBOX(0, LE_ADV, 21, 1),
-	BT_MBOX(0, LE_MAX_TX_POWER, 24, 4),
-	BT_MBOX(0, OPEN_CON_1, 28, 2),
-};
-
-enum iwl_bt_mxbox_dw1 {
-	BT_MBOX(1, BR_MAX_TX_POWER, 0, 4),
-	BT_MBOX(1, IP_SR, 4, 1),
-	BT_MBOX(1, LE_MSTR, 5, 1),
-	BT_MBOX(1, AGGR_TRFC_LD, 8, 6),
-	BT_MBOX(1, MSG_TYPE, 16, 3),
-	BT_MBOX(1, SSN, 19, 2),
-};
-
-enum iwl_bt_mxbox_dw2 {
-	BT_MBOX(2, SNIFF_ACT, 0, 3),
-	BT_MBOX(2, PAG, 3, 1),
-	BT_MBOX(2, INQUIRY, 4, 1),
-	BT_MBOX(2, CONN, 5, 1),
-	BT_MBOX(2, SNIFF_INTERVAL, 8, 5),
-	BT_MBOX(2, DISC, 13, 1),
-	BT_MBOX(2, SCO_TX_ACT, 16, 2),
-	BT_MBOX(2, SCO_RX_ACT, 18, 2),
-	BT_MBOX(2, ESCO_RE_TX, 20, 2),
-	BT_MBOX(2, SCO_DURATION, 24, 6),
-};
-
-enum iwl_bt_mxbox_dw3 {
-	BT_MBOX(3, SCO_STATE, 0, 1),
-	BT_MBOX(3, SNIFF_STATE, 1, 1),
-	BT_MBOX(3, A2DP_STATE, 2, 1),
-	BT_MBOX(3, ACL_STATE, 3, 1),
-	BT_MBOX(3, MSTR_STATE, 4, 1),
-	BT_MBOX(3, OBX_STATE, 5, 1),
-	BT_MBOX(3, OPEN_CON_2, 8, 2),
-	BT_MBOX(3, TRAFFIC_LOAD, 10, 2),
-	BT_MBOX(3, CHL_SEQN_LSB, 12, 1),
-	BT_MBOX(3, INBAND_P, 13, 1),
-	BT_MBOX(3, MSG_TYPE_2, 16, 3),
-	BT_MBOX(3, SSN_2, 19, 2),
-	BT_MBOX(3, UPDATE_REQUEST, 21, 1),
-};
-
-#define BT_MBOX_MSG(_notif, _num, _field)				     \
-	((le32_to_cpu((_notif)->mbox_msg[(_num)]) & BT_MBOX##_num##_##_field)\
-	>> BT_MBOX##_num##_##_field##_POS)
-
-enum iwl_bt_activity_grading {
-	BT_OFF			= 0,
-	BT_ON_NO_CONNECTION	= 1,
-	BT_LOW_TRAFFIC		= 2,
-	BT_HIGH_TRAFFIC		= 3,
-};
-
-/**
- * struct iwl_bt_coex_profile_notif - notification about BT coex
- * @mbox_msg: message from BT to WiFi
- * @msg_idx: the index of the message
- * @bt_status: 0 - off, 1 - on
- * @bt_open_conn: number of BT connections open
- * @bt_traffic_load: load of BT traffic
- * @bt_agg_traffic_load: aggregated load of BT traffic
- * @bt_ci_compliance: 0 - no CI compliance, 1 - CI compliant
- * @primary_ch_lut: LUT used for primary channel
- * @secondary_ch_lut: LUT used for secondary channel
- * @bt_activity_grading: the activity of BT enum %iwl_bt_activity_grading
- */
-struct iwl_bt_coex_profile_notif {
-	__le32 mbox_msg[4];
-	__le32 msg_idx;
-	u8 bt_status;
-	u8 bt_open_conn;
-	u8 bt_traffic_load;
-	u8 bt_agg_traffic_load;
-	u8 bt_ci_compliance;
-	u8 reserved[3];
-
-	__le32 primary_ch_lut;
-	__le32 secondary_ch_lut;
-	__le32 bt_activity_grading;
-} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_2 */
-
-enum iwl_bt_coex_prio_table_event {
-	BT_COEX_PRIO_TBL_EVT_INIT_CALIB1		= 0,
-	BT_COEX_PRIO_TBL_EVT_INIT_CALIB2		= 1,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1	= 2,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2	= 3,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1	= 4,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2	= 5,
-	BT_COEX_PRIO_TBL_EVT_DTIM			= 6,
-	BT_COEX_PRIO_TBL_EVT_SCAN52			= 7,
-	BT_COEX_PRIO_TBL_EVT_SCAN24			= 8,
-	BT_COEX_PRIO_TBL_EVT_IDLE			= 9,
-	BT_COEX_PRIO_TBL_EVT_MAX			= 16,
-}; /* BT_COEX_PRIO_TABLE_EVENTS_API_E_VER_1 */
-
-enum iwl_bt_coex_prio_table_prio {
-	BT_COEX_PRIO_TBL_DISABLED	= 0,
-	BT_COEX_PRIO_TBL_PRIO_LOW	= 1,
-	BT_COEX_PRIO_TBL_PRIO_HIGH	= 2,
-	BT_COEX_PRIO_TBL_PRIO_BYPASS	= 3,
-	BT_COEX_PRIO_TBL_PRIO_COEX_OFF	= 4,
-	BT_COEX_PRIO_TBL_PRIO_COEX_ON	= 5,
-	BT_COEX_PRIO_TBL_PRIO_COEX_IDLE = 6,
-	BT_COEX_PRIO_TBL_MAX		= 8,
-}; /* BT_COEX_PRIO_TABLE_PRIORITIES_API_E_VER_1 */
-
-#define BT_COEX_PRIO_TBL_SHRD_ANT_POS     (0)
-#define BT_COEX_PRIO_TBL_PRIO_POS         (1)
-#define BT_COEX_PRIO_TBL_RESERVED_POS     (4)
-
-/**
- * struct iwl_bt_coex_prio_tbl_cmd - priority table for BT coex
- * @prio_tbl:
- */
-struct iwl_bt_coex_prio_tbl_cmd {
-	u8 prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX];
-} __packed;
-
-#endif /* __fw_api_bt_coex_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
new file mode 100644
index 0000000..32156d7
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -0,0 +1,350 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
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
+#ifndef __fw_api_bt_coex_h__
+#define __fw_api_bt_coex_h__
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+#define BITS(nb) (BIT(nb) - 1)
+
+/**
+ * enum iwl_bt_coex_flags - flags for BT_COEX command
+ * @BT_COEX_MODE_POS:
+ * @BT_COEX_MODE_MSK:
+ * @BT_COEX_DISABLE:
+ * @BT_COEX_2W:
+ * @BT_COEX_3W:
+ * @BT_COEX_NW:
+ * @BT_COEX_SYNC2SCO:
+ * @BT_COEX_CORUNNING:
+ *
+ * The COEX_MODE must be set for each command. Even if it is not changed.
+ */
+enum iwl_bt_coex_flags {
+	BT_COEX_MODE_POS		= 3,
+	BT_COEX_MODE_MSK		= BITS(3) << BT_COEX_MODE_POS,
+	BT_COEX_DISABLE			= 0x0 << BT_COEX_MODE_POS,
+	BT_COEX_2W			= 0x1 << BT_COEX_MODE_POS,
+	BT_COEX_3W			= 0x2 << BT_COEX_MODE_POS,
+	BT_COEX_NW			= 0x3 << BT_COEX_MODE_POS,
+	BT_COEX_SYNC2SCO		= BIT(7),
+	BT_COEX_CORUNNING		= BIT(8),
+};
+
+/*
+ * indicates what has changed in the BT_COEX command.
+ * BT_VALID_ENABLE must be set for each command. Commands without this bit will
+ * discarded by the firmware
+ */
+enum iwl_bt_coex_valid_bit_msk {
+	BT_VALID_ENABLE			= BIT(0),
+	BT_VALID_BT_PRIO_BOOST		= BIT(1),
+	BT_VALID_MAX_KILL		= BIT(2),
+	BT_VALID_3W_TMRS		= BIT(3),
+	BT_VALID_KILL_ACK		= BIT(4),
+	BT_VALID_KILL_CTS		= BIT(5),
+	BT_VALID_REDUCED_TX_POWER	= BIT(6),
+	BT_VALID_LUT			= BIT(7),
+	BT_VALID_WIFI_RX_SW_PRIO_BOOST	= BIT(8),
+	BT_VALID_WIFI_TX_SW_PRIO_BOOST	= BIT(9),
+	BT_VALID_MULTI_PRIO_LUT		= BIT(10),
+	BT_VALID_TRM_KICK_FILTER	= BIT(11),
+	BT_VALID_CORUN_LUT_20		= BIT(12),
+	BT_VALID_CORUN_LUT_40		= BIT(13),
+	BT_VALID_ANT_ISOLATION		= BIT(14),
+	BT_VALID_ANT_ISOLATION_THRS	= BIT(15),
+	BT_VALID_TXTX_DELTA_FREQ_THRS	= BIT(16),
+	BT_VALID_TXRX_MAX_FREQ_0	= BIT(17),
+	BT_VALID_SYNC_TO_SCO		= BIT(18),
+};
+
+/**
+ * enum iwl_bt_reduced_tx_power - allows to reduce txpower for WiFi frames.
+ * @BT_REDUCED_TX_POWER_CTL: reduce Tx power for control frames
+ * @BT_REDUCED_TX_POWER_DATA: reduce Tx power for data frames
+ *
+ * This mechanism allows to have BT and WiFi run concurrently. Since WiFi
+ * reduces its Tx power, it can work along with BT, hence reducing the amount
+ * of WiFi frames being killed by BT.
+ */
+enum iwl_bt_reduced_tx_power {
+	BT_REDUCED_TX_POWER_CTL		= BIT(0),
+	BT_REDUCED_TX_POWER_DATA	= BIT(1),
+};
+
+enum iwl_bt_coex_lut_type {
+	BT_COEX_TIGHT_LUT = 0,
+	BT_COEX_LOOSE_LUT,
+	BT_COEX_TX_DIS_LUT,
+
+	BT_COEX_MAX_LUT,
+};
+
+#define BT_COEX_LUT_SIZE (12)
+#define BT_COEX_CORUN_LUT_SIZE (32)
+#define BT_COEX_MULTI_PRIO_LUT_SIZE (2)
+#define BT_COEX_BOOST_SIZE (4)
+#define BT_REDUCED_TX_POWER_BIT BIT(7)
+
+/**
+ * struct iwl_bt_coex_cmd - bt coex configuration command
+ * @flags:&enum iwl_bt_coex_flags
+ * @max_kill:
+ * @bt_reduced_tx_power: enum %iwl_bt_reduced_tx_power
+ * @bt4_antenna_isolation:
+ * @bt4_antenna_isolation_thr:
+ * @bt4_tx_tx_delta_freq_thr:
+ * @bt4_tx_rx_max_freq0:
+ * @bt_prio_boost:
+ * @wifi_tx_prio_boost: SW boost of wifi tx priority
+ * @wifi_rx_prio_boost: SW boost of wifi rx priority
+ * @kill_ack_msk:
+ * @kill_cts_msk:
+ * @decision_lut:
+ * @bt4_multiprio_lut:
+ * @bt4_corun_lut20:
+ * @bt4_corun_lut40:
+ * @valid_bit_msk: enum %iwl_bt_coex_valid_bit_msk
+ *
+ * The structure is used for the BT_COEX command.
+ */
+struct iwl_bt_coex_cmd {
+	__le32 flags;
+	u8 max_kill;
+	u8 bt_reduced_tx_power;
+	u8 reserved[2];
+
+	u8 bt4_antenna_isolation;
+	u8 bt4_antenna_isolation_thr;
+	u8 bt4_tx_tx_delta_freq_thr;
+	u8 bt4_tx_rx_max_freq0;
+
+	__le32 bt_prio_boost[BT_COEX_BOOST_SIZE];
+	__le32 wifi_tx_prio_boost;
+	__le32 wifi_rx_prio_boost;
+	__le32 kill_ack_msk;
+	__le32 kill_cts_msk;
+
+	__le32 decision_lut[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE];
+	__le32 bt4_multiprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE];
+	__le32 bt4_corun_lut20[BT_COEX_CORUN_LUT_SIZE];
+	__le32 bt4_corun_lut40[BT_COEX_CORUN_LUT_SIZE];
+
+	__le32 valid_bit_msk;
+} __packed; /* BT_COEX_CMD_API_S_VER_3 */
+
+/**
+ * struct iwl_bt_coex_ci_cmd - bt coex channel inhibition command
+ * @bt_primary_ci:
+ * @bt_secondary_ci:
+ * @co_run_bw_primary:
+ * @co_run_bw_secondary:
+ * @primary_ch_phy_id:
+ * @secondary_ch_phy_id:
+ *
+ * Used for BT_COEX_CI command
+ */
+struct iwl_bt_coex_ci_cmd {
+	__le64 bt_primary_ci;
+	__le64 bt_secondary_ci;
+
+	u8 co_run_bw_primary;
+	u8 co_run_bw_secondary;
+	u8 primary_ch_phy_id;
+	u8 secondary_ch_phy_id;
+} __packed; /* BT_CI_MSG_API_S_VER_1 */
+
+#define BT_MBOX(n_dw, _msg, _pos, _nbits)	\
+	BT_MBOX##n_dw##_##_msg##_POS = (_pos),	\
+	BT_MBOX##n_dw##_##_msg = BITS(_nbits) << BT_MBOX##n_dw##_##_msg##_POS
+
+enum iwl_bt_mxbox_dw0 {
+	BT_MBOX(0, LE_SLAVE_LAT, 0, 3),
+	BT_MBOX(0, LE_PROF1, 3, 1),
+	BT_MBOX(0, LE_PROF2, 4, 1),
+	BT_MBOX(0, LE_PROF_OTHER, 5, 1),
+	BT_MBOX(0, CHL_SEQ_N, 8, 4),
+	BT_MBOX(0, INBAND_S, 13, 1),
+	BT_MBOX(0, LE_MIN_RSSI, 16, 4),
+	BT_MBOX(0, LE_SCAN, 20, 1),
+	BT_MBOX(0, LE_ADV, 21, 1),
+	BT_MBOX(0, LE_MAX_TX_POWER, 24, 4),
+	BT_MBOX(0, OPEN_CON_1, 28, 2),
+};
+
+enum iwl_bt_mxbox_dw1 {
+	BT_MBOX(1, BR_MAX_TX_POWER, 0, 4),
+	BT_MBOX(1, IP_SR, 4, 1),
+	BT_MBOX(1, LE_MSTR, 5, 1),
+	BT_MBOX(1, AGGR_TRFC_LD, 8, 6),
+	BT_MBOX(1, MSG_TYPE, 16, 3),
+	BT_MBOX(1, SSN, 19, 2),
+};
+
+enum iwl_bt_mxbox_dw2 {
+	BT_MBOX(2, SNIFF_ACT, 0, 3),
+	BT_MBOX(2, PAG, 3, 1),
+	BT_MBOX(2, INQUIRY, 4, 1),
+	BT_MBOX(2, CONN, 5, 1),
+	BT_MBOX(2, SNIFF_INTERVAL, 8, 5),
+	BT_MBOX(2, DISC, 13, 1),
+	BT_MBOX(2, SCO_TX_ACT, 16, 2),
+	BT_MBOX(2, SCO_RX_ACT, 18, 2),
+	BT_MBOX(2, ESCO_RE_TX, 20, 2),
+	BT_MBOX(2, SCO_DURATION, 24, 6),
+};
+
+enum iwl_bt_mxbox_dw3 {
+	BT_MBOX(3, SCO_STATE, 0, 1),
+	BT_MBOX(3, SNIFF_STATE, 1, 1),
+	BT_MBOX(3, A2DP_STATE, 2, 1),
+	BT_MBOX(3, ACL_STATE, 3, 1),
+	BT_MBOX(3, MSTR_STATE, 4, 1),
+	BT_MBOX(3, OBX_STATE, 5, 1),
+	BT_MBOX(3, OPEN_CON_2, 8, 2),
+	BT_MBOX(3, TRAFFIC_LOAD, 10, 2),
+	BT_MBOX(3, CHL_SEQN_LSB, 12, 1),
+	BT_MBOX(3, INBAND_P, 13, 1),
+	BT_MBOX(3, MSG_TYPE_2, 16, 3),
+	BT_MBOX(3, SSN_2, 19, 2),
+	BT_MBOX(3, UPDATE_REQUEST, 21, 1),
+};
+
+#define BT_MBOX_MSG(_notif, _num, _field)				     \
+	((le32_to_cpu((_notif)->mbox_msg[(_num)]) & BT_MBOX##_num##_##_field)\
+	>> BT_MBOX##_num##_##_field##_POS)
+
+enum iwl_bt_activity_grading {
+	BT_OFF			= 0,
+	BT_ON_NO_CONNECTION	= 1,
+	BT_LOW_TRAFFIC		= 2,
+	BT_HIGH_TRAFFIC		= 3,
+};
+
+/**
+ * struct iwl_bt_coex_profile_notif - notification about BT coex
+ * @mbox_msg: message from BT to WiFi
+ * @msg_idx: the index of the message
+ * @bt_status: 0 - off, 1 - on
+ * @bt_open_conn: number of BT connections open
+ * @bt_traffic_load: load of BT traffic
+ * @bt_agg_traffic_load: aggregated load of BT traffic
+ * @bt_ci_compliance: 0 - no CI compliance, 1 - CI compliant
+ * @primary_ch_lut: LUT used for primary channel
+ * @secondary_ch_lut: LUT used for secondary channel
+ * @bt_activity_grading: the activity of BT enum %iwl_bt_activity_grading
+ */
+struct iwl_bt_coex_profile_notif {
+	__le32 mbox_msg[4];
+	__le32 msg_idx;
+	u8 bt_status;
+	u8 bt_open_conn;
+	u8 bt_traffic_load;
+	u8 bt_agg_traffic_load;
+	u8 bt_ci_compliance;
+	u8 reserved[3];
+
+	__le32 primary_ch_lut;
+	__le32 secondary_ch_lut;
+	__le32 bt_activity_grading;
+} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_2 */
+
+enum iwl_bt_coex_prio_table_event {
+	BT_COEX_PRIO_TBL_EVT_INIT_CALIB1		= 0,
+	BT_COEX_PRIO_TBL_EVT_INIT_CALIB2		= 1,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1	= 2,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2	= 3,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1	= 4,
+	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2	= 5,
+	BT_COEX_PRIO_TBL_EVT_DTIM			= 6,
+	BT_COEX_PRIO_TBL_EVT_SCAN52			= 7,
+	BT_COEX_PRIO_TBL_EVT_SCAN24			= 8,
+	BT_COEX_PRIO_TBL_EVT_IDLE			= 9,
+	BT_COEX_PRIO_TBL_EVT_MAX			= 16,
+}; /* BT_COEX_PRIO_TABLE_EVENTS_API_E_VER_1 */
+
+enum iwl_bt_coex_prio_table_prio {
+	BT_COEX_PRIO_TBL_DISABLED	= 0,
+	BT_COEX_PRIO_TBL_PRIO_LOW	= 1,
+	BT_COEX_PRIO_TBL_PRIO_HIGH	= 2,
+	BT_COEX_PRIO_TBL_PRIO_BYPASS	= 3,
+	BT_COEX_PRIO_TBL_PRIO_COEX_OFF	= 4,
+	BT_COEX_PRIO_TBL_PRIO_COEX_ON	= 5,
+	BT_COEX_PRIO_TBL_PRIO_COEX_IDLE = 6,
+	BT_COEX_PRIO_TBL_MAX		= 8,
+}; /* BT_COEX_PRIO_TABLE_PRIORITIES_API_E_VER_1 */
+
+#define BT_COEX_PRIO_TBL_SHRD_ANT_POS     (0)
+#define BT_COEX_PRIO_TBL_PRIO_POS         (1)
+#define BT_COEX_PRIO_TBL_RESERVED_POS     (4)
+
+/**
+ * struct iwl_bt_coex_prio_tbl_cmd - priority table for BT coex
+ * @prio_tbl:
+ */
+struct iwl_bt_coex_prio_tbl_cmd {
+	u8 prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX];
+} __packed;
+
+#endif /* __fw_api_bt_coex_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 703168b..6e75b52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -70,7 +70,7 @@
 #include "fw-api-mac.h"
 #include "fw-api-power.h"
 #include "fw-api-d3.h"
-#include "fw-api-bt-coex.h"
+#include "fw-api-coex.h"
 
 /* maximal number of Tx queues in any platform */
 #define IWL_MVM_MAX_QUEUES	20
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 18939dc..4c38654 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -908,8 +908,8 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   enum ieee80211_rssi_event rssi_event);
 void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm);
-u16 iwl_mvm_bt_coex_agg_time_limit(struct iwl_mvm *mvm,
-				   struct ieee80211_sta *sta);
+u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
+				struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
 int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 399709f..ad83342 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2591,7 +2591,7 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 
 	if (sta)
 		lq_cmd->agg_time_limit =
-			cpu_to_le16(iwl_mvm_bt_coex_agg_time_limit(mvm, sta));
+			cpu_to_le16(iwl_mvm_coex_agg_time_limit(mvm, sta));
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
-- 
1.8.3.2

