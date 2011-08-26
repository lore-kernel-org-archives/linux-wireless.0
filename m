Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab1HZGxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/60] iwlagn: add comments to iwl_bus / iwl_trans
Date: Thu, 25 Aug 2011 23:10:49 -0700
Message-Id: <1314339092-20797-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085523_954782_D510056D)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Rename the recursive inclusion protection in iwl-bus.h while we are at it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h   |   15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    5 +++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 5d0e155..edec2f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -60,8 +60,10 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
-#ifndef __iwl_pci_h__
-#define __iwl_pci_h__
+#ifndef __iwl_bus_h__
+#define __iwl_bus_h__
+
+/*This file includes the declaration that are exported from the bus layer */
 
 struct iwl_shared;
 struct iwl_bus;
@@ -86,6 +88,13 @@ struct iwl_bus_ops {
 	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
 };
 
+/**
+ * struct iwl_bus - bus common data
+ * @dev - pointer to struct device * that represent the device
+ * @ops - pointer to iwl_bus_ops
+ * @shrd - pointer to iwl_shared which holds shared data from the upper layer
+ * @irq - the irq number for the device
+ */
 struct iwl_bus {
 	/* Common data to all buses */
 	struct device *dev;
@@ -138,4 +147,4 @@ static inline u32 bus_read32(struct iwl_bus *bus, u32 ofs)
 int __must_check iwl_pci_register_driver(void);
 void iwl_pci_unregister_driver(void);
 
-#endif
+#endif /* __iwl_bus_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index eec25b4..4a0c786 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -130,6 +130,11 @@ struct iwl_trans_ops {
 	void (*free)(struct iwl_priv *priv);
 };
 
+/**
+ * struct iwl_trans - transport common data
+ * @ops - pointer to iwl_trans_ops
+ * @shrd - pointer to iwl_shared which holds shared data from the upper layer
+ */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_shared *shrd;
-- 
1.7.0.4

