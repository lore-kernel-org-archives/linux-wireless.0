Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25662 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbIXJOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:14:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/15] staging: wilc1000: remove variable cif_func
Date: Thu, 24 Sep 2015 18:15:06 +0900
Message-ID: <1443086106-20482-15-git-send-email-glen.lee@atmel.com> (sfid-20150924_111426_995614_197CBD7D)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes variable cif_func and use mac_cfg directly. No need to have
another pointer variable.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 24a3aa1..1937d7d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -40,7 +40,6 @@ typedef struct {
 	/**
 	 *      configuration interface functions
 	 **/
-	wilc_cfg_func_t cif_func;
 	int cfg_frame_in_use;
 	wilc_cfg_frame_t cfg_frame;
 	u32 cfg_frame_offset;
@@ -1199,7 +1198,7 @@ static void wilc_wlan_handle_rxq(void)
 
 
 
-					p->cif_func.rx_indicate(&buffer[pkt_offset + offset], pkt_len, &rsp);
+					mac_cfg.rx_indicate(&buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
 						/**
 						 *      wake up the waiting task...
@@ -1764,7 +1763,8 @@ static int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size, in
 		p->cfg_frame_offset = 0;
 
 	offset = p->cfg_frame_offset;
-	ret_size = p->cif_func.cfg_wid_set(p->cfg_frame.frame, offset, (u16)wid, buffer, buffer_size);
+	ret_size = mac_cfg.cfg_wid_set(p->cfg_frame.frame, offset, (u16)wid,
+				       buffer, buffer_size);
 	offset += ret_size;
 	p->cfg_frame_offset = offset;
 
@@ -1803,7 +1803,7 @@ static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 		p->cfg_frame_offset = 0;
 
 	offset = p->cfg_frame_offset;
-	ret_size = p->cif_func.cfg_wid_get(p->cfg_frame.frame, offset, (u16)wid);
+	ret_size = mac_cfg.cfg_wid_get(p->cfg_frame.frame, offset, (u16)wid);
 	offset += ret_size;
 	p->cfg_frame_offset = offset;
 
@@ -1830,10 +1830,9 @@ static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 
 static int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 {
-	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int ret;
 
-	ret = p->cif_func.cfg_wid_get_val((u16)wid, buffer, buffer_size);
+	ret = mac_cfg.cfg_wid_get_val((u16)wid, buffer, buffer_size);
 
 	return ret;
 }
@@ -1999,8 +1998,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 		ret = -105;
 		goto _fail_;
 	}
-	memcpy((void *)&g_wlan.cif_func, &mac_cfg, sizeof(wilc_cfg_func_t));
-
 
 	/**
 	 *      alloc tx, rx buffer
-- 
1.9.1

