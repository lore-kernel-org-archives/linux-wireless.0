Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760125AbZKFWxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/20] iwlwifi: speed up event log dumps
Date: Fri,  6 Nov 2009 14:52:58 -0800
Message-Id: <1257547983-12590-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Take advantage of device's auto-increment for SRAM reads to eliminate extra
write address accesses.

Grab/release NIC access before/after entire read sequence, rather than for
each read individually.

After a quick check of dmesg logs, this seems to double Event Log dump speed,
reducing from about 20 milliseconds to about 10 milliseconds for 512 entries
using 3945.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   22 ++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   22 ++++++++++++++++------
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index be99d19..a1d2cda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1667,6 +1667,7 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	u32 event_size; /* 2 u32s, or 3 u32s if timestamp recorded */
 	u32 ptr;        /* SRAM byte address of log data */
 	u32 ev, time, data; /* event log data */
+	unsigned long reg_flags;
 
 	if (num_events == 0)
 		return;
@@ -1682,25 +1683,34 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
+	/* Make sure device is powered up for SRAM reads */
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+
+	/* Set starting address; reads will auto-increment */
+	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	rmb();
+
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
-		time = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
+		ev = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			trace_iwlwifi_dev_ucode_event(priv, 0, time, ev);
 			IWL_ERR(priv, "EVT_LOG:0x%08x:%04u\n", time, ev);
 		} else {
-			data = iwl_read_targ_mem(priv, ptr);
-			ptr += sizeof(u32);
+			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 			IWL_ERR(priv, "EVT_LOGT:%010u:0x%08x:%04u\n",
 					time, data, ev);
 			trace_iwlwifi_dev_ucode_event(priv, time, data, ev);
 		}
 	}
+
+	/* Allow device to power down */
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 
 /* For sanity check only.  Actual size is determined by uCode, typ. 512 */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 75caa5f..6285e51 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1571,6 +1571,7 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	u32 event_size;	/* 2 u32s, or 3 u32s if timestamp recorded */
 	u32 ptr;        /* SRAM byte address of log data */
 	u32 ev, time, data; /* event log data */
+	unsigned long reg_flags;
 
 	if (num_events == 0)
 		return;
@@ -1584,24 +1585,33 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
+	/* Make sure device is powered up for SRAM reads */
+	spin_lock_irqsave(&priv->reg_lock, reg_flags);
+	iwl_grab_nic_access(priv);
+
+	/* Set starting address; reads will auto-increment */
+	_iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	rmb();
+
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
-		time = iwl_read_targ_mem(priv, ptr);
-		ptr += sizeof(u32);
+		ev = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
+		time = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			IWL_ERR(priv, "0x%08x\t%04u\n", time, ev);
 			trace_iwlwifi_dev_ucode_event(priv, 0, time, ev);
 		} else {
-			data = iwl_read_targ_mem(priv, ptr);
-			ptr += sizeof(u32);
+			data = _iwl_read_direct32(priv, HBUS_TARG_MEM_RDAT);
 			IWL_ERR(priv, "%010u\t0x%08x\t%04u\n", time, data, ev);
 			trace_iwlwifi_dev_ucode_event(priv, time, data, ev);
 		}
 	}
+
+	/* Allow device to power down */
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 }
 
 /* For sanity check only.  Actual size is determined by uCode, typ. 512 */
-- 
1.5.6.3

