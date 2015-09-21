Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45722 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbbIUU7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:44 +0300
Message-Id: <1442869141-31637-4-git-send-email-luca@coelho.fi> (sfid-20150921_225916_121407_DBF51765)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 04/21] iwlwifi: Deinline iwl_{read,write}(8,32}
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

With CONFIG_IWLWIFI_DEVICE_TRACING=y, these functions are rather large,
too big for inlining.

With this .config: http://busybox.net/~vda/kernel_config,
after uninlining these functions have sizes and callsite counts
as follows:

iwl_read32  475 bytes, 51 callsites
iwl_write32 477 bytes, 90 callsites
iwl_write8  493 bytes, 3 callsites

Reduction in size is about 74,000 bytes:

    text     data      bss       dec     hex filename
90758147 17226024 36659200 144643371 89f152b vmlinux0
90687995 17221928 36659200 144569123 89df323 vmlinux.after

Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h | 21 +++------------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 27c66e4..3c263a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -36,6 +36,28 @@
 #include "iwl-prph.h"
 #include "iwl-fh.h"
 
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
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
 int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
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
2.5.1

