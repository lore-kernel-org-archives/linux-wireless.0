Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab0EMVuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/17] iwlwifi: don't crash on firmware file missing info
Date: Thu, 13 May 2010 14:49:46 -0700
Message-Id: <1273787399-9280-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a firmware file misses one of the required
instruction or data pieces, the driver currently
crashes. Let it gracefully refuse that firmware
file instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 3ff6b9d..6984639 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -92,6 +92,11 @@ static inline void iwl_free_fw_desc(struct pci_dev *pci_dev,
 static inline int iwl_alloc_fw_desc(struct pci_dev *pci_dev,
 				    struct fw_desc *desc)
 {
+	if (!desc->len) {
+		desc->v_addr = NULL;
+		return -EINVAL;
+	}
+
 	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, desc->len,
 					  &desc->p_addr, GFP_KERNEL);
 	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
-- 
1.6.3.3

