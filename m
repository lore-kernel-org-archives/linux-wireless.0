Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50906 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbdFZLot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:44:49 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2 4/8] staging: wilc1000: Add function to balance packet count
Date: Mon, 26 Jun 2017 17:13:26 +0530
Message-ID: <1498477410-19518-5-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_134505_761711_58CB77B3)
In-Reply-To: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
References: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new function to track the cound of packets and
determine the ratio of current number of packets to
maximum count of packets.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d1ed3ba8..655f229 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -426,6 +426,23 @@ static inline u8 ac_classify(struct wilc *wilc, struct txq_entry_t *tqe)
 	return ac;
 }
 
+static inline int ac_balance(u8 *count, u8 *ratio)
+{
+	u8 i, max_count = 0;
+
+	if (!count || !ratio)
+		return -1;
+
+	for (i = 0; i < NQUEUES; i++)
+		if (count[i] > max_count)
+			max_count = count[i];
+
+	for (i = 0; i < NQUEUES; i++)
+		ratio[i] = max_count - count[i];
+
+	return 0;
+}
+
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-- 
2.7.4
