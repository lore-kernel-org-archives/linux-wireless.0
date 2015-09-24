Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbbIXO7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:59:03 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Deinline iwl_write8/write32/read32()
Date: Thu, 24 Sep 2015 16:58:55 +0200
Message-Id: <1443106735-9661-1-git-send-email-dvlasenk@redhat.com> (sfid-20150924_165926_056144_9DFC3994)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
after deinlining these functions have sizes and callsite counts
as follows:

iwl_write8: 315 bytes, 3 calls
iwl_write32: 296 bytes, 90 calls
iwl_read32: 278 bytes, 51 calls

Total size reduction is about 40 kbytes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Johannes Berg <johannes.berg@intel.com>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>
CC: Gregory Greenman <gregory.greenman@intel.com>
CC: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-io.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h | 21 +++------------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 27c66e4..782e7e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -38,6 +38,28 @@
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
+void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
+{
+	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val);
+	iwl_trans_write8(trans, ofs, val);
+}
+IWL_EXPORT_SYMBOL(iwl_write8);
+
+void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
+{
+	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val);
+	iwl_trans_write32(trans, ofs, val);
+}
+IWL_EXPORT_SYMBOL(iwl_write32);
+
+u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
+{
+	u32 val = iwl_trans_read32(trans, ofs);
+	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val);
+	return val;
+}
+IWL_EXPORT_SYMBOL(iwl_read32);
+
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 705d12c..501d056 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -32,24 +32,9 @@
 #include "iwl-devtrace.h"
 #include "iwl-trans.h"
 
-static inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
-{
-	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val);
-	iwl_trans_write8(trans, ofs, val);
-}
-
-static inline void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
-{
-	trace_iwlwifi_dev_iowrite32(trans->dev, ofs, val);
-	iwl_trans_write32(trans, ofs, val);
-}
-
-static inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
-{
-	u32 val = iwl_trans_read32(trans, ofs);
-	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val);
-	return val;
-}
+void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val);
+void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val);
+u32 iwl_read32(struct iwl_trans *trans, u32 ofs);
 
 static inline void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
-- 
1.8.1.4

