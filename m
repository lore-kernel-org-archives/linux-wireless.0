Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:33694 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbdFZHEz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 03:04:55 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH 7/7] staging: wilc1000: Update ACM bit status
Date: Mon, 26 Jun 2017 12:33:38 +0530
Message-ID: <1498460618-22187-8-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_090458_188726_934D7602)
In-Reply-To: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com>
References: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new function to update ACM bit status for a queue
for all access categories.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e323fd4..929166a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -461,6 +461,14 @@ static inline u8 ac_change(struct wilc *wilc, u8 *ac)
 	return 1;
 }
 
+static inline void ac_acm_bit(struct wilc *wilc, u32 reg)
+{
+	wilc->txq[AC_BK_Q].acm = (reg & 0x00000002) >> BK_AC_ACM_STAT_POS;
+	wilc->txq[AC_BE_Q].acm = (reg & 0x00000100) >> BE_AC_ACM_STAT_POS;
+	wilc->txq[AC_VI_Q].acm = (reg & 0x00010000) >> VI_AC_ACM_STAT_POS;
+	wilc->txq[AC_VO_Q].acm = (reg & 0x01000000) >> VO_AC_ACM_STAT_POS;
+}
+
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-- 
2.7.4
