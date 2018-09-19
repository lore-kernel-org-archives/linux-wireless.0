Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33675 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730956AbeISLmM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/29] staging: wilc1000: use 'void' return for wilc_wlan_txq_add_to_head()
Date: Wed, 19 Sep 2018 11:34:57 +0530
Message-ID: <1537337119-14952-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080555_656993_AC2A743F)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'void' return for wilc_wlan_txq_add_to_head() as its always
return '0' value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 590a51c..8057db9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -71,8 +71,8 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 	complete(&wilc->txq_event);
 }
 
-static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
-				     struct txq_entry_t *tqe)
+static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
+				      struct txq_entry_t *tqe)
 {
 	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
@@ -87,8 +87,6 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 	complete(&wilc->txq_event);
-
-	return 0;
 }
 
 #define NOT_TCP_ACK			(-1)
@@ -275,10 +273,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	tqe->priv = NULL;
 	tqe->ack_idx = NOT_TCP_ACK;
 
-	if (wilc_wlan_txq_add_to_head(vif, tqe)) {
-		kfree(tqe);
-		return 0;
-	}
+	wilc_wlan_txq_add_to_head(vif, tqe);
 
 	return 1;
 }
-- 
2.7.4
