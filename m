Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57853 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754644AbeBPPMe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:34 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/12] staging: wilc1000: fix line over 80 chars in wilc_wlan_txq_filter_dup_tcp_ack()
Date: Fri, 16 Feb 2018 20:41:48 +0530
Message-ID: <1518793909-15573-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161239_337212_B98991C3)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue reported by checkpatch.pl.
Use temporary variable to avoid checkpatch.pl issue.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 391ecd5..98cd949 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -262,10 +262,20 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
 	for (i = pending_base; i < (pending_base + pending_acks); i++) {
-		if (i >= MAX_PENDING_ACKS ||
-		    pending_acks_info[i].session_index >= 2 * MAX_TCP_SESSION)
+		u32 session_index;
+		u32 bigger_ack_num;
+
+		if (i >= MAX_PENDING_ACKS)
+			break;
+
+		session_index = pending_acks_info[i].session_index;
+
+		if (session_index >= 2 * MAX_TCP_SESSION)
 			break;
-		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
+
+		bigger_ack_num = ack_session_info[session_index].bigger_ack_num;
+
+		if (pending_acks_info[i].ack_num < bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
 			tqe = pending_acks_info[i].txqe;
-- 
2.7.4
