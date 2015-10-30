Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56585 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030341AbbJ3Jo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:44:58 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 06/17] staging: wilc1000: wilc_wlan_txq_add_cfg_pkt: add argument net_device
Date: Fri, 30 Oct 2015 18:47:12 +0900
Message-ID: <1446198443-6623-6-git-send-email-glen.lee@atmel.com> (sfid-20151030_104500_599642_E501A80A)
In-Reply-To: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device and use netdev private data
member wilc instead of g_linux_wlan, pass dev to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 75b0616..ec4bff4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -484,15 +484,20 @@ bool is_TCP_ACK_Filter_Enabled(void)
 	return EnableTCPAckFilter;
 }
 
-static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
+static int wilc_wlan_txq_add_cfg_pkt(struct net_device *dev,
+				     u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
 	if (p->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
-		up(&g_linux_wlan->cfg_event);
+		up(&wilc->cfg_event);
 		return 0;
 	}
 
@@ -1763,7 +1768,7 @@ static int wilc_wlan_cfg_commit(struct net_device *dev,
 	 *      Add to TX queue
 	 **/
 
-	if (!wilc_wlan_txq_add_cfg_pkt(&cfg->wid_header[0], total_len))
+	if (!wilc_wlan_txq_add_cfg_pkt(dev, &cfg->wid_header[0], total_len))
 		return -1;
 
 	return 0;
-- 
1.9.1

