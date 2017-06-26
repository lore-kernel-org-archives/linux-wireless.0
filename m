Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50906 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdFZLoo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:44:44 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2 2/8] staging: wilc1000: Add function to calculate ac queue limit
Date: Mon, 26 Jun 2017 17:13:24 +0530
Message-ID: <1498477410-19518-3-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_134450_424665_028A5044)
In-Reply-To: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
References: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a function which calculates the queue limit
for a given access category queue.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9addef1..8c997ba 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -333,6 +333,48 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	return 1;
 }
 
+static inline void ac_q_limit(u8 ac, u16 *q_limit)
+{
+	static bool initialized;
+	static u8 buffer[AC_BUFFER_SIZE];
+	static u16 cnt[NQUEUES];
+	u8 factors[NQUEUES] = {1, 1, 1, 1};
+	static u16 sum;
+	u16 i;
+	static u16 end_index;
+
+	if (!initialized) {
+		for (i = 0; i < AC_BUFFER_SIZE; i++)
+			buffer[i] = i % NQUEUES;
+
+		for (i = 0; i < NQUEUES; i++) {
+			cnt[i] = AC_BUFFER_SIZE * factors[i] / NQUEUES;
+			sum += cnt[i];
+		}
+		end_index = AC_BUFFER_SIZE - 1;
+		initialized = 1;
+	}
+	if (end_index > AC_BUFFER_SIZE - 1)
+		end_index = AC_BUFFER_SIZE - 1;
+
+	cnt[buffer[end_index]] -= factors[buffer[end_index]];
+	cnt[ac] += factors[ac];
+	sum += (factors[ac] - factors[buffer[end_index]]);
+
+	buffer[end_index] = ac;
+	if (end_index > 0)
+		end_index--;
+	else
+		end_index = AC_BUFFER_SIZE - 1;
+
+	for (i = 0; i < NQUEUES; i++)
+		if (!sum)
+			q_limit[i] = 1;
+		else
+			q_limit[i] = (cnt[i] * FLOW_CONTROL_UPPER_THRESHOLD /
+				      sum) + 1;
+}
+
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-- 
2.7.4
