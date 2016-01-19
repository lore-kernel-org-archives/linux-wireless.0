Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33013 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbcASK01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 05:26:27 -0500
Received: by mail-pa0-f65.google.com with SMTP id pv5so34794945pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 02:26:27 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/3] staging: wilc1000: fix return type of wilc_send_config_pkt
Date: Tue, 19 Jan 2016 19:26:15 +0900
Message-Id: <1453199177-21085-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160119_112631_009788_D8944C4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_send_config_pkt is returned to 0 or -ETIMEDOUT according to return
value of wilc_wlan_cfg_get and wilc_wlan_cfg_set functions.
It is better to use int type in order to represent linux standard error
code.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 2d4d3f1..ee9f91f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -588,10 +588,11 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
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
2.6.4

