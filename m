Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab1FRQFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/25] iwlagn: waterfall the bus level if prepare card failed
Date: Sat, 18 Jun 2011 08:34:22 -0700
Message-Id: <1308411271-26093-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180600_420469_D3DB3F87)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 17228f7..bec98bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3540,6 +3540,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 		priv->cfg->name, hw_rev);
 
 	if (iwl_prepare_card_hw(priv)) {
+		err = -EIO;
 		IWL_WARN(priv, "Failed, HW not ready\n");
 		goto out_free_traffic_mem;
 	}
-- 
1.7.0.4

