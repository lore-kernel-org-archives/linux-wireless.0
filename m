Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYLEP5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlwifi: fix time interval misuse in iwl_poll_{direct_}bit
Date: Fri,  5 Dec 2008 07:58:38 -0800
Message-Id: <1228492721-27381-4-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165753_313310_4377AD8D)
In-Reply-To: <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

The patch fixes the misuse of microsecond with millisecond in the
polling mechanism of the iwlwifi driver. The impact of this problem
is the unacceptable latency for the whole system (especially during
bringing down the wlan interface).

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 7dea155..2f74943 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -93,7 +93,7 @@ static inline int _iwl3945_poll_bit(struct iwl3945_priv *priv, u32 addr,
 	do {
 		if ((_iwl3945_read32(priv, addr) & mask) == (bits & mask))
 			return i;
-		mdelay(10);
+		udelay(10);
 		i += 10;
 	} while (i < timeout);
 
@@ -276,7 +276,7 @@ static inline int _iwl3945_poll_direct_bit(struct iwl3945_priv *priv,
 	do {
 		if ((_iwl3945_read_direct32(priv, addr) & mask) == mask)
 			return i;
-		mdelay(10);
+		udelay(10);
 		i += 10;
 	} while (i < timeout);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index bc10435..a5c489a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -95,7 +95,7 @@ static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 	do {
 		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
 			return i;
-		mdelay(10);
+		udelay(10);
 		i += 10;
 	} while (i < timeout);
 
@@ -277,7 +277,7 @@ static inline int _iwl_poll_direct_bit(struct iwl_priv *priv,
 	do {
 		if ((_iwl_read_direct32(priv, addr) & mask) == mask)
 			return i;
-		mdelay(10);
+		udelay(10);
 		i += 10;
 	} while (i < timeout);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 6614e67..661a4e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -628,7 +628,7 @@ void iwl_txq_ctx_stop(struct iwl_priv *priv)
 		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
 		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    200);
+				    1000);
 	}
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.5.4.3

