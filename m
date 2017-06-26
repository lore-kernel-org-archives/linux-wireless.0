Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59483 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdFZHEk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 03:04:40 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH 3/7] staging: wilc1000: WMM classification of data
Date: Mon, 26 Jun 2017 12:33:34 +0530
Message-ID: <1498460618-22187-4-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_090443_415054_BC8482DA)
In-Reply-To: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com>
References: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a new function to classify data to available
WMM access categories based on the DSCP value in the header.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 51 ++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8c997ba..d1ed3ba8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -375,6 +375,57 @@ static inline void ac_q_limit(u8 ac, u16 *q_limit)
 				      sum) + 1;
 }
 
+static inline u8 ac_classify(struct wilc *wilc, struct txq_entry_t *tqe)
+{
+	u8 *eth_hdr_ptr;
+	u8 *buffer = tqe->buffer;
+	u8 ac;
+	u16 h_proto;
+
+	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
+
+	eth_hdr_ptr = &buffer[0];
+	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
+	if (h_proto == ETH_P_IP) {
+		u8 *ip_hdr_ptr;
+		u32 IHL, DSCP;
+
+		ip_hdr_ptr = &buffer[ETHERNET_HDR_LEN];
+		IHL = (ip_hdr_ptr[0] & 0xf) << 2;
+		DSCP = (ip_hdr_ptr[1] & 0xfc);
+
+		switch (DSCP) {
+		case 0x20:
+		case 0x40:
+		case 0x08:
+			ac = AC_BK_Q;
+			break;
+		case 0x80:
+		case 0xA0:
+		case 0x28:
+			ac = AC_VI_Q;
+			break;
+		case 0xC0:
+		case 0xd0:
+		case 0xE0:
+		case 0x88:
+		case 0xB8:
+			ac = AC_VO_Q;
+			break;
+		default:
+			ac = AC_BE_Q;
+			break;
+		}
+	} else {
+		ac  = AC_BE_Q;
+	}
+
+	tqe->q_num = ac;
+	spin_unlock_irqrestore(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
+
+	return ac;
+}
+
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-- 
2.7.4
