Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:20708 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbdFZLo5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:44:57 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2 7/8] staging: wilc1000: Change ac based on acm status
Date: Mon, 26 Jun 2017 17:13:29 +0530
Message-ID: <1498477410-19518-8-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_134506_927736_79CC1DD4)
In-Reply-To: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
References: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new function to check and alter the ac if needed
based on the acm status for a particular queue.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b3e1136..e323fd4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -451,6 +451,16 @@ static inline void ac_pkt_count(u32 reg, u8 *pkt_count)
 	pkt_count[AC_VO_Q] = (reg & 0xfe000000) >> VO_AC_COUNT_POS;
 }
 
+static inline u8 ac_change(struct wilc *wilc, u8 *ac)
+{
+	do {
+		if (wilc->txq[*ac].acm == 0)
+			return 0;
+		(*ac)++;
+	} while (*ac < NQUEUES);
+	return 1;
+}
+
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-- 
2.7.4
