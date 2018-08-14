Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57930 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:13 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 19/24] staging: wilc1000: avoid line over 80 chars in wilc_wlan_txq_filter_dup_tcp_ack()
Date: Tue, 14 Aug 2018 12:20:11 +0530
Message-ID: <1534229416-13254-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085127_030874_9825F3FA)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid line over 80 chars checkpatch issue introduced in
previous code refactor commit.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 52402c3..041c9dd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -199,19 +199,20 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-	for (i = f->pending_base; i < (f->pending_base + f->pending_acks); i++) {
-		u32 session_index;
+	i = f->pending_base;
+	for (; i < (f->pending_base + f->pending_acks); i++) {
+		u32 index;
 		u32 bigger_ack_num;
 
 		if (i >= MAX_PENDING_ACKS)
 			break;
 
-		session_index = f->pending_acks_info[i].session_index;
+		index = f->pending_acks_info[i].session_index;
 
-		if (session_index >= 2 * MAX_TCP_SESSION)
+		if (index >= 2 * MAX_TCP_SESSION)
 			break;
 
-		bigger_ack_num = f->ack_session_info[session_index].bigger_ack_num;
+		bigger_ack_num = f->ack_session_info[index].bigger_ack_num;
 
 		if (f->pending_acks_info[i].ack_num < bigger_ack_num) {
 			struct txq_entry_t *tqe;
-- 
2.7.4
