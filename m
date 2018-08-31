Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45674 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728088AbeHaODO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:06 +0300
Message-Id: <20180831095614.14099-9-luca@coelho.fi> (sfid-20180831_115639_139752_5F820E7B)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: remove ucode error tracepoint
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Alexei's patch, assumed that all versions of "struct iwl_error_event_table"
are the same, but there are really different versions in different files.

Rather than trying to fix this, or splitting the tracepoint, or anything of
the sort, just remove it entirely - turns out that nobody really uses it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  2 +-
 .../intel/iwlwifi/iwl-devtrace-iwlwifi.h      | 55 -------------------
 .../net/wireless/intel/iwlwifi/iwl-devtrace.c |  3 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  1 -
 4 files changed, 2 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 1ef072071b0b..1088ff036e13 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -1647,7 +1648,6 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 			priv->status, table.valid);
 	}
 
-	trace_iwlwifi_dev_ucode_error(trans->dev, &table, 0, table.brd_ver);
 	IWL_ERR(priv, "0x%08X | %-28s\n", table.error_id,
 		desc_lookup(table.error_id));
 	IWL_ERR(priv, "0x%08X | uPc\n", table.pc);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
index 82cfbfa0795d..8e87186682e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h
@@ -128,61 +128,6 @@ TRACE_EVENT(iwlwifi_dev_tx,
 		  __entry->framelen, __entry->skbaddr)
 );
 
-struct iwl_error_event_table;
-TRACE_EVENT(iwlwifi_dev_ucode_error,
-	TP_PROTO(const struct device *dev, const struct iwl_error_event_table *table,
-		 u32 hw_ver, u32 brd_ver),
-	TP_ARGS(dev, table, hw_ver, brd_ver),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u32, desc)
-		__field(u32, tsf_low)
-		__field(u32, data1)
-		__field(u32, data2)
-		__field(u32, line)
-		__field(u32, blink2)
-		__field(u32, ilink1)
-		__field(u32, ilink2)
-		__field(u32, bcon_time)
-		__field(u32, gp1)
-		__field(u32, gp2)
-		__field(u32, rev_type)
-		__field(u32, major)
-		__field(u32, minor)
-		__field(u32, hw_ver)
-		__field(u32, brd_ver)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->desc = table->error_id;
-		__entry->tsf_low = table->tsf_low;
-		__entry->data1 = table->data1;
-		__entry->data2 = table->data2;
-		__entry->line = table->line;
-		__entry->blink2 = table->blink2;
-		__entry->ilink1 = table->ilink1;
-		__entry->ilink2 = table->ilink2;
-		__entry->bcon_time = table->bcon_time;
-		__entry->gp1 = table->gp1;
-		__entry->gp2 = table->gp2;
-		__entry->rev_type = table->gp3;
-		__entry->major = table->ucode_ver;
-		__entry->minor = table->hw_ver;
-		__entry->hw_ver = hw_ver;
-		__entry->brd_ver = brd_ver;
-	),
-	TP_printk("[%s] #%02d %010u data 0x%08X 0x%08X line %u, "
-		  "blink2 0x%05X ilink 0x%05X 0x%05X "
-		  "bcon_tm %010u gp 0x%08X 0x%08X rev_type 0x%08X major 0x%08X "
-		  "minor 0x%08X hw 0x%08X brd 0x%08X",
-		  __get_str(dev), __entry->desc, __entry->tsf_low,
-		  __entry->data1, __entry->data2, __entry->line,
-		  __entry->blink2, __entry->ilink1, __entry->ilink2,
-		  __entry->bcon_time, __entry->gp1, __entry->gp2,
-		  __entry->rev_type, __entry->major, __entry->minor,
-		  __entry->hw_ver, __entry->brd_ver)
-);
-
 TRACE_EVENT(iwlwifi_dev_ucode_event,
 	TP_PROTO(const struct device *dev, u32 time, u32 data, u32 ev),
 	TP_ARGS(dev, time, data, ev),
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
index 27b4dd409a0e..9805432f124f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -26,12 +27,10 @@
 #ifndef __CHECKER__
 #include "iwl-trans.h"
 
-#include "dvm/commands.h"
 #define CREATE_TRACE_POINTS
 #include "iwl-devtrace.h"
 
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_cont_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_wrap_event);
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 99a872769e90..dcacc4d11abc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -546,7 +546,6 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 
 	IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
 
-	trace_iwlwifi_dev_ucode_error(trans->dev, &table, table.hw_ver, table.brd_ver);
 	IWL_ERR(mvm, "0x%08X | %-28s\n", table.error_id,
 		desc_lookup(table.error_id));
 	IWL_ERR(mvm, "0x%08X | trm_hw_status0\n", table.trm_hw_status0);
-- 
2.18.0
