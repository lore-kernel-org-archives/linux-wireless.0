Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760129AbZKFWxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/20] iwlwifi: Add comments about MAC_ACCESS_REQ
Date: Fri,  6 Nov 2009 14:53:00 -0800
Message-Id: <1257547983-12590-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 0a078b0..d0a358c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -200,6 +200,26 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 
 	/* this bit wakes up the NIC */
 	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/*
+	 * These bits say the device is running, and should keep running for
+	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
+	 * but they do not indicate that embedded SRAM is restored yet;
+	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
+	 * to/from host DRAM when sleeping/waking for power-saving.
+	 * Each direction takes approximately 1/4 millisecond; with this
+	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
+	 * series of register accesses are expected (e.g. reading Event Log),
+	 * to keep device from sleeping.
+	 *
+	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
+	 * SRAM is okay/restored.  We don't check that here because this call
+	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
+	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
+	 *
+	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
+	 * and do not save/restore SRAM when power cycling.
+	 */
 	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-- 
1.5.6.3

