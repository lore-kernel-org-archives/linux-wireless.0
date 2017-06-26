Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59483 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdFZHEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 03:04:46 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH 5/7] staging: wilc1000: Get packet count from firmware
Date: Mon, 26 Jun 2017 12:33:36 +0530
Message-ID: <1498460618-22187-6-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_090448_886215_38CF2ADE)
In-Reply-To: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com>
References: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new function to get packet count from the firmware.

31:25       24      23:17   16      15:9    8       7:2     1       0
VO CNT      VO ACM  VI CNT  VI ACM  BE CNT  BE ACM  BK CNT  BK ACM  VMM ready

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 655f229..b3e1136 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -443,6 +443,14 @@ static inline int ac_balance(u8 *count, u8 *ratio)
 	return 0;
 }
 
+static inline void ac_pkt_count(u32 reg, u8 *pkt_count)
+{
+	pkt_count[AC_BK_Q] = (reg & 0x000000fa) >> BK_AC_COUNT_POS;
+	pkt_count[AC_BE_Q] = (reg & 0x0000fe00) >> BE_AC_COUNT_POS;
+	pkt_count[AC_VI_Q] = (reg & 0x00fe0000) >> VI_AC_COUNT_POS;
+	pkt_count[AC_VO_Q] = (reg & 0xfe000000) >> VO_AC_COUNT_POS;
+}
+
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-- 
2.7.4
