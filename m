Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13405 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759815AbXG3C7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/8] iwlwifi: call QoS command on QoS data change
Date: Mon, 30 Jul 2007 10:57:00 +0800
Message-Id: <11857642362891-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642343783-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

The driver issues QoS command from post association, some time
post_assoc will be called before mac80211 sets QoS data. This
patch makes sure the QoS command will be called with new QoS data.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 57b8195..0648bec 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -7811,6 +7811,14 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	mutex_lock(&priv->mutex);
+
+	/* we wait for the last queue then call qos ucode command */
+	if (priv->assoc_id && iwl_is_associated(priv) && (i == (AC_NUM - 1)))
+		iwl_activate_qos(priv, 0);
+
+	mutex_unlock(&priv->mutex);
+
 #endif /*CONFIG_IWLWIFI_QOS */
 
 	IWL_DEBUG_MAC80211("leave\n");
-- 
1.5.2
