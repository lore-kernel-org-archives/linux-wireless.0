Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759947AbZKFWxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/20] iwlwifi: Limit size of Event Log dump
Date: Fri,  6 Nov 2009 14:52:57 -0800
Message-Id: <1257547983-12590-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

If device provides bad values for Event Log parameters (due to being asleep
or SRAM corruption, etc.), the size can be very, very large (e.g. 0xa5a5a5a5),
which can flood system log.

Sanity-check capacity and next_entry values and limit to reasonable size dump.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eff52b1..be99d19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1703,6 +1703,9 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	}
 }
 
+/* For sanity check only.  Actual size is determined by uCode, typ. 512 */
+#define MAX_EVENT_LOG_SIZE (512)
+
 void iwl_dump_nic_event_log(struct iwl_priv *priv)
 {
 	u32 base;       /* SRAM byte address of event log header */
@@ -1728,6 +1731,18 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
+	if (capacity > MAX_EVENT_LOG_SIZE) {
+		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
+			capacity, MAX_EVENT_LOG_SIZE);
+		capacity = MAX_EVENT_LOG_SIZE;
+	}
+
+	if (next_entry > MAX_EVENT_LOG_SIZE) {
+		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
+			next_entry, MAX_EVENT_LOG_SIZE);
+		next_entry = MAX_EVENT_LOG_SIZE;
+	}
+
 	size = num_wraps ? capacity : next_entry;
 
 	/* bail out if nothing in log */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 84dce68..75caa5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1604,6 +1604,9 @@ static void iwl3945_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	}
 }
 
+/* For sanity check only.  Actual size is determined by uCode, typ. 512 */
+#define IWL3945_MAX_EVENT_LOG_SIZE (512)
+
 void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 {
 	u32 base;       /* SRAM byte address of event log header */
@@ -1625,6 +1628,18 @@ void iwl3945_dump_nic_event_log(struct iwl_priv *priv)
 	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
+	if (capacity > IWL3945_MAX_EVENT_LOG_SIZE) {
+		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
+			capacity, IWL3945_MAX_EVENT_LOG_SIZE);
+		capacity = IWL3945_MAX_EVENT_LOG_SIZE;
+	}
+
+	if (next_entry > IWL3945_MAX_EVENT_LOG_SIZE) {
+		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
+			next_entry, IWL3945_MAX_EVENT_LOG_SIZE);
+		next_entry = IWL3945_MAX_EVENT_LOG_SIZE;
+	}
+
 	size = num_wraps ? capacity : next_entry;
 
 	/* bail out if nothing in log */
-- 
1.5.6.3

