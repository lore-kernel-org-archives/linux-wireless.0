Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760046AbZKFWxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/20] iwlwifi: add FIFO usage for 5000
Date: Fri,  6 Nov 2009 14:52:53 -0800
Message-Id: <1257547983-12590-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This is part of the code, but the comment doesn't have it,
add pointers to the code and the FIFO usage for 5000 and
up.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index d393e8f..6d95832 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -254,7 +254,8 @@
  * device.  A queue maps to only one (selectable by driver) Tx DMA channel,
  * but one DMA channel may take input from several queues.
  *
- * Tx DMA channels have dedicated purposes.  For 4965, they are used as follows:
+ * Tx DMA channels have dedicated purposes.  For 4965, they are used as follows
+ * (cf. default_queue_to_tx_fifo in iwl-4965.c):
  *
  * 0 -- EDCA BK (background) frames, lowest priority
  * 1 -- EDCA BE (best effort) frames, normal priority
@@ -265,9 +266,21 @@
  * 6 -- HCCA long frames
  * 7 -- not used by driver (device-internal only)
  *
+ * For 5000 series and up, they are used slightly differently
+ * (cf. iwl5000_default_queue_to_tx_fifo in iwl-5000.c):
+ *
+ * 0 -- EDCA BK (background) frames, lowest priority
+ * 1 -- EDCA BE (best effort) frames, normal priority
+ * 2 -- EDCA VI (video) frames, higher priority
+ * 3 -- EDCA VO (voice) and management frames, highest priority
+ * 4 -- (TBD)
+ * 5 -- HCCA short frames
+ * 6 -- HCCA long frames
+ * 7 -- Commands
+ *
  * Driver should normally map queues 0-6 to Tx DMA/FIFO channels 0-6.
- * In addition, driver can map queues 7-15 to Tx DMA/FIFO channels 0-3 to
- * support 11n aggregation via EDCA DMA channels.
+ * In addition, driver can map the remaining queues to Tx DMA/FIFO
+ * channels 0-3 to support 11n aggregation via EDCA DMA channels.
  *
  * The driver sets up each queue to work in one of two modes:
  *
-- 
1.5.6.3

