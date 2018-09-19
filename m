Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2328 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730911AbeISLmQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:16 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/29] staging: wilc1000: change return type to 'void' tcp ack filter functions
Date: Wed, 19 Sep 2018 11:34:58 +0530
Message-ID: <1537337119-14952-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080559_229981_ABF0DEB6)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'void' return type for below functions as they always return '0' and
their return value is not used by caller.
add_tcp_pending_ack()
update_tcp_session()
add_tcp_pending_ack()

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8057db9..66ce29d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -91,8 +91,8 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 
 #define NOT_TCP_ACK			(-1)
 
-static inline int add_tcp_session(struct wilc_vif *vif, u32 src_prt,
-				  u32 dst_prt, u32 seq)
+static inline void add_tcp_session(struct wilc_vif *vif, u32 src_prt,
+				   u32 dst_prt, u32 seq)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
 
@@ -103,22 +103,20 @@ static inline int add_tcp_session(struct wilc_vif *vif, u32 src_prt,
 		f->ack_session_info[f->tcp_session].dst_port = dst_prt;
 		f->tcp_session++;
 	}
-	return 0;
 }
 
-static inline int update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
+static inline void update_tcp_session(struct wilc_vif *vif, u32 index, u32 ack)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
 
 	if (index < 2 * MAX_TCP_SESSION &&
 	    ack > f->ack_session_info[index].bigger_ack_num)
 		f->ack_session_info[index].bigger_ack_num = ack;
-	return 0;
 }
 
-static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
-				      u32 session_index,
-				      struct txq_entry_t *txqe)
+static inline void add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
+				       u32 session_index,
+				       struct txq_entry_t *txqe)
 {
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = f->pending_base + f->pending_acks_idx;
@@ -130,7 +128,6 @@ static inline int add_tcp_pending_ack(struct wilc_vif *vif, u32 ack,
 		txqe->ack_idx = i;
 		f->pending_acks_idx++;
 	}
-	return 0;
 }
 
 static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
-- 
2.7.4
