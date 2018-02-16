Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:59573 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754607AbeBPPM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:27 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/12] staging: wilc1000: fix line over 80 chars in add_tcp_pending_ack()
Date: Fri, 16 Feb 2018 20:41:46 +0530
Message-ID: <1518793909-15573-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161232_725597_385F1644)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index acaeafc..aedf84d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -173,11 +173,13 @@ static inline int update_tcp_session(u32 index, u32 ack)
 static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 				      struct txq_entry_t *txqe)
 {
-	if (pending_base + pending_acks < MAX_PENDING_ACKS) {
-		pending_acks_info[pending_base + pending_acks].ack_num = ack;
-		pending_acks_info[pending_base + pending_acks].txqe = txqe;
-		pending_acks_info[pending_base + pending_acks].session_index = session_index;
-		txqe->tcp_pending_ack_idx = pending_base + pending_acks;
+	u32 i = pending_base + pending_acks;
+
+	if (i < MAX_PENDING_ACKS) {
+		pending_acks_info[i].ack_num = ack;
+		pending_acks_info[i].txqe = txqe;
+		pending_acks_info[i].session_index = session_index;
+		txqe->tcp_pending_ack_idx = i;
 		pending_acks++;
 	}
 	return 0;
-- 
2.7.4
