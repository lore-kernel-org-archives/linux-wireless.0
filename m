Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZJWUme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/18] iwlwifi: separate led function from statistic notification
Date: Fri, 23 Oct 2009 13:42:22 -0700
Message-Id: <1256330556-20997-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Detach led background task from statistic notification routine. if led
blinking is required; the blink rate is based on the traffic condition.
It do not relate to statistics notification. In addition to that, there is
not a requirement for statistics notification has to occur all the time.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7142aa5..269b988 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -359,8 +359,6 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 
 	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
-
-	iwl_leds_background(priv);
 }
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 64d9187..a34acb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1019,6 +1019,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 		iwl_rx_handle(priv);
 		priv->isr_stats.rx++;
+		iwl_leds_background(priv);
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
@@ -1220,6 +1221,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 				    CSR_INT_PERIODIC_ENA);
 
 		priv->isr_stats.rx++;
+		iwl_leds_background(priv);
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0a407f7..cfc31ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -627,9 +627,6 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 		iwl_rx_calc_noise(priv);
 		queue_work(priv->workqueue, &priv->run_time_calib_work);
 	}
-
-	iwl_leds_background(priv);
-
 	if (priv->cfg->ops->lib->temp_ops.temperature && change)
 		priv->cfg->ops->lib->temp_ops.temperature(priv);
 }
-- 
1.5.6.3

