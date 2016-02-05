Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33528 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:49 -0500
Received: by mail-pa0-f54.google.com with SMTP id cy9so25035684pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:49 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/8] staging: wilc1000: fix return type of wilc_send_config_pkt
Date: Fri,  5 Feb 2016 10:35:15 +0900
Message-Id: <1454636118-9943-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023552_909362_673DA224)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_send_config_pkt is returned 0 or -ETIMEDOUT according to return
value of wilc_wlan_cfg_get or wilc_wlan_cfg_set.
It is better to use int type to represent linux standard error code.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 49ae9b1..323a0cd 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -449,10 +449,11 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	s32 counter = 0, ret = 0;
+	s32 counter = 0;
+	int ret = 0;
 
 	if (mode == GET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-- 
2.7.0

