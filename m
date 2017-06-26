Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:63467 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdFZLol (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:44:41 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2 1/8] staging: wilc1000: Add support for AC classification.
Date: Mon, 26 Jun 2017 17:13:23 +0530
Message-ID: <1498477410-19518-2-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_134449_849387_A9001DC9)
In-Reply-To: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
References: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new variables and defines for adding access
category classification

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 7a5eba9..c97f94a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -133,6 +133,17 @@
 
 #define MODALIAS		"WILC_SPI"
 #define GPIO_NUM		0x44
+
+#define NQUEUES			4
+#define VO_AC_COUNT_POS		25
+#define VO_AC_ACM_STAT_POS	24
+#define VI_AC_COUNT_POS		17
+#define VI_AC_ACM_STAT_POS	16
+#define BE_AC_COUNT_POS		9
+#define BE_AC_ACM_STAT_POS	8
+#define BK_AC_COUNT_POS		2
+#define BK_AC_ACM_STAT_POS	1
+#define AC_BUFFER_SIZE		1000
 /*******************************************/
 /*        E0 and later Interrupt flags.    */
 /*******************************************/
@@ -206,11 +217,25 @@ typedef void (*wilc_debug_func)(u32, char *, ...);
  *      Tx/Rx Queue Structure
  *
  ********************************************/
+struct txq_handle {
+	struct txq_entry_t *txq_head;
+	struct txq_entry_t *txq_tail;
+	u16 count;
+	u8 acm;
+};
+
+enum ip_pkt_priority {
+	AC_VO_Q = 0,
+	AC_VI_Q = 1,
+	AC_BE_Q = 2,
+	AC_BK_Q = 3
+};
 
 struct txq_entry_t {
 	struct txq_entry_t *next;
 	struct txq_entry_t *prev;
 	int type;
+	u8 q_num;
 	int tcp_pending_ack_idx;
 	u8 *buffer;
 	int buffer_size;
-- 
2.7.4
