Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZGPJdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/10] iwmc3200wifi: hardware does not support IP checksum
Date: Thu, 16 Jul 2009 17:34:07 +0800
Message-Id: <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwmc3200wifi hardware doesn't support IP checksum. So mark the
skb->ip_summed to CHECKSUM_NONE instead of CHECKSUM_UNNECESSARY.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 59ef69c..9fb498b 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1359,7 +1359,7 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 
 		skb->dev = iwm_to_ndev(iwm);
 		skb->protocol = eth_type_trans(skb, ndev);
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->ip_summed = CHECKSUM_NONE;
 		memset(skb->cb, 0, sizeof(skb->cb));
 
 		ndev->stats.rx_packets++;
-- 
1.6.0.4

