Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41364 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJhQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:16 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 20/24] staging: wilc1000: avoid line over 80 chars in tcp_process()
Date: Tue, 14 Aug 2018 12:20:12 +0530
Message-ID: <1534229416-13254-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085130_515185_8677A22C)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid line over 80 chars issue reported by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 041c9dd..f0743d9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -137,6 +137,11 @@ static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 	return 0;
 }
 
+static inline void clear_tcp_session_txq(struct wilc_vif *vif, int index)
+{
+	vif->ack_filter.pending_acks_info[index].txqe = NULL;
+}
+
 static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 {
 	void *buffer = tqe->buffer;
@@ -670,7 +675,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			tqe->tx_complete_func(tqe->priv, tqe->status);
 		if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
 		    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
-			vif->ack_filter.pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
+			clear_tcp_session_txq(vif, tqe->tcp_pending_ack_idx);
 		kfree(tqe);
 	} while (--entries);
 
-- 
2.7.4
