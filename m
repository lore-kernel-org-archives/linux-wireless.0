Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40285 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbbIPJyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:54:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 7/8] staging: wicl1000: remove function pointer wlan_handle_rx_que
Date: Wed, 16 Sep 2015 18:53:26 +0900
Message-ID: <1442397207-20491-7-git-send-email-tony.cho@atmel.com> (sfid-20150916_115417_123004_FC877142)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

The function pointer wlan_handle_rx_que is not called anywhere. Delete
wlan_handle_rx_que and it's assignment code.
But the function wilc_wlan_handle_rxq in assignment code is used. So leave it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c    | 1 -
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 22310cc..17f66e7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2126,7 +2126,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	oup->wlan_stop = wilc_wlan_stop;
 	oup->wlan_add_to_tx_que = wilc_wlan_txq_add_net_pkt;
 	oup->wlan_handle_tx_que = wilc_wlan_handle_txq;
-	oup->wlan_handle_rx_que = wilc_wlan_handle_rxq;
 	oup->wlan_handle_rx_isr = wilc_handle_isr;
 	oup->wlan_cleanup = wilc_wlan_cleanup;
 	oup->wlan_cfg_set = wilc_wlan_cfg_set;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index bccfcf9..cc92dc9 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -167,7 +167,6 @@ typedef struct {
 	int (*wlan_stop)(void);
 	int (*wlan_add_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 	int (*wlan_handle_tx_que)(u32 *);
-	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
 	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
-- 
1.9.1

