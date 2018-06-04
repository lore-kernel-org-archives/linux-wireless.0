Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:8556 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbeFDF32 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 01:29:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/4] staging: wilc1000: move 'txq_spinlock_flags' from 'wilc' structure to local variable
Date: Mon, 4 Jun 2018 10:59:10 +0530
Message-ID: <1528090150-5397-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180604_073035_081990_D804DD0F)
In-Reply-To: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
References: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove 'txq_spinlock_flags' element in 'wilc' and used
local variable 'flag' in wilc_wlan_txq_filter_dup_tcp_ack().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 --
 drivers/staging/wilc1000/wilc_wlan.c          | 5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index afba372..fe18ae9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -155,8 +155,6 @@ struct wilc {
 	u32 rx_buffer_offset;
 	u8 *tx_buffer;
 
-	unsigned long txq_spinlock_flags;
-
 	struct txq_entry_t txq_head;
 	int txq_entries;
 	int txq_exit;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 26252d1..55755d7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -219,11 +219,12 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	struct wilc *wilc;
 	u32 i = 0;
 	u32 dropped = 0;
+	unsigned long flags;
 
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
 
-	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 	for (i = pending_base; i < (pending_base + pending_acks); i++) {
 		u32 session_index;
 		u32 bigger_ack_num;
@@ -261,7 +262,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	else
 		pending_base = 0;
 
-	spin_unlock_irqrestore(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
 	while (dropped > 0) {
 		wait_for_completion_timeout(&wilc->txq_event,
-- 
2.7.4
