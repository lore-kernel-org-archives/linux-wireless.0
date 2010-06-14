Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab0FNSYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: trace full RX
Date: Mon, 14 Jun 2010 11:24:47 -0700
Message-Id: <1276539892-12471-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
References: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The length contained in the status word doesn't
include the status word's length itself, so we
need to account for that for tracing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 +++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 69e17d7..ce88bc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -941,6 +941,8 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		fill_rx = 1;
 
 	while (i != r) {
+		int len;
+
 		rxb = rxq->queue[i];
 
 		/* If an RXB doesn't have a Rx queue slot associated with it,
@@ -955,8 +957,9 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			       PCI_DMA_FROMDEVICE);
 		pkt = rxb_addr(rxb);
 
-		trace_iwlwifi_dev_rx(priv, pkt,
-			le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len += sizeof(u32); /* account for status word */
+		trace_iwlwifi_dev_rx(priv, pkt, len);
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0f16c7d..fddae22 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1252,6 +1252,8 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
 
 	while (i != r) {
+		int len;
+
 		rxb = rxq->queue[i];
 
 		/* If an RXB doesn't have a Rx queue slot associated with it,
@@ -1266,8 +1268,9 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			       PCI_DMA_FROMDEVICE);
 		pkt = rxb_addr(rxb);
 
-		trace_iwlwifi_dev_rx(priv, pkt,
-			le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len += sizeof(u32); /* account for status word */
+		trace_iwlwifi_dev_rx(priv, pkt, len);
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
-- 
1.7.0.4

