Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032Ab1LPQh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/24] iwlwifi: add IO function for continuous write of target memory
Date: Fri, 16 Dec 2011 07:37:28 -0800
Message-Id: <1324049849-831-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173822_578915_C8E0810D)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Add new IO function _iwl_write_targ_mem_words() to support
target memory write for a continuous area. It will return
error code -EBUSY if iwl_grab_nic_access() fails to indicate
the memory write does not be performed. Meanwhile the existing
function iwl_write_targ_mem() also been updated by using
_iwl_write_targ_mem_words() in a single word case.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c |   19 ++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-io.h |    5 ++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 3464cad..d57ea64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -283,16 +283,29 @@ u32 iwl_read_targ_mem(struct iwl_bus *bus, u32 addr)
 	return value;
 }
 
-void iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val)
+int _iwl_write_targ_mem_words(struct iwl_bus *bus, u32 addr,
+				void *buf, int words)
 {
 	unsigned long flags;
+	int offs, result = 0;
+	u32 *vals = buf;
 
 	spin_lock_irqsave(&bus->reg_lock, flags);
 	if (!iwl_grab_nic_access(bus)) {
 		iwl_write32(bus, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
-		iwl_write32(bus, HBUS_TARG_MEM_WDAT, val);
+
+		for (offs = 0; offs < words; offs++)
+			iwl_write32(bus, HBUS_TARG_MEM_WDAT, vals[offs]);
 		iwl_release_nic_access(bus);
-	}
+	} else
+		result = -EBUSY;
 	spin_unlock_irqrestore(&bus->reg_lock, flags);
+
+	return result;
+}
+
+int iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val)
+{
+	return _iwl_write_targ_mem_words(bus, addr, &val, 1);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index ced2cbe..aae2eeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -85,6 +85,9 @@ void _iwl_read_targ_mem_words(struct iwl_bus *bus, u32 addr,
 					 (bufsize) / sizeof(u32));\
 	} while (0)
 
+int _iwl_write_targ_mem_words(struct iwl_bus *bus, u32 addr,
+			      void *buf, int words);
+
 u32 iwl_read_targ_mem(struct iwl_bus *bus, u32 addr);
-void iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val);
+int iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val);
 #endif
-- 
1.7.0.4

