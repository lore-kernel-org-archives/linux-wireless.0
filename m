Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53857 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757945AbeDXNTD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 09:19:03 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ath6kl: fix ath6kl_data_tx()'s return type
Date: Tue, 24 Apr 2018 15:18:59 +0200
Message-Id: <20180424131900.5718-1-luc.vanoostenryck@gmail.com> (sfid-20180424_152411_906545_3831E3E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/core.h | 2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index e23d450ba..0d30e762c 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -914,7 +914,7 @@ void ath6kl_tx_data_cleanup(struct ath6kl *ar);
 
 struct ath6kl_cookie *ath6kl_alloc_cookie(struct ath6kl *ar);
 void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie);
-int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev);
 
 struct aggr_info *aggr_init(struct ath6kl_vif *vif);
 void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info *aggr_info,
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 8da9506f8..618d12ed4 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -353,7 +353,7 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	return status;
 }
 
-int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_cookie *cookie = NULL;
-- 
2.17.0
