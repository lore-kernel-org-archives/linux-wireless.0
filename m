Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12390 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMGJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:06:09 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 09/29] staging: wilc1000: use 'void' return for wilc_wlan_txq_filter_dup_tcp_ack()
Date: Thu, 20 Sep 2018 11:53:20 +0530
Message-ID: <1537424620-6982-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082458_351381_3E79381A)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'void' return for wilc_wlan_txq_filter_dup_tcp_ack() as it always
return value '1' and its not used by the caller.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 66ce29d..88808d9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -182,7 +182,7 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 }
 
-static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
+static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
@@ -237,8 +237,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 					    msecs_to_jiffies(1));
 		dropped--;
 	}
-
-	return 1;
 }
 
 void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value)
-- 
2.7.4
