Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZKTUFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/19] iwlwifi: separate IO tracing
Date: Fri, 20 Nov 2009 12:05:02 -0800
Message-Id: <1258747510-21233-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Since IO tracing is usually not needed and
generates a lot of data, separate it into
its own trace system so that we can always
enable iwlwifi:* and not have to worry about
getting too much data. If IO tracing is then
really needed we can enable iwlwifi_io:* in
addition and get that data.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index f2d4b01..2136196 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -14,7 +14,7 @@ static inline void trace_ ## name(proto) {}
 #define PRIV_ASSIGN	__entry->priv = priv
 
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM iwlwifi
+#define TRACE_SYSTEM iwlwifi_io
 
 TRACE_EVENT(iwlwifi_dev_ioread32,
 	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
@@ -64,6 +64,9 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
 );
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM iwlwifi
+
 TRACE_EVENT(iwlwifi_dev_hcmd,
 	TP_PROTO(struct iwl_priv *priv, void *hcmd, size_t len, u32 flags),
 	TP_ARGS(priv, hcmd, len, flags),
-- 
1.5.6.3

