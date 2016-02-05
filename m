Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36682 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:52 -0500
Received: by mail-pf0-f175.google.com with SMTP id n128so59015248pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:52 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/8] staging: wilc1000: use int type for counter variable
Date: Fri,  5 Feb 2016 10:35:16 +0900
Message-Id: <1454636118-9943-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023556_027288_FC2BFD9E)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

counter is used as for-loop control variable and indicating index of
struct wid array so that it is better to use int type.
There is no need to set to 0 when it is declared at the top of this
function. It is initialized as 0 in for-loop statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 323a0cd..4008872 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -452,7 +452,7 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	s32 counter = 0;
+	int counter;
 	int ret = 0;
 
 	if (mode == GET_CFG) {
-- 
2.7.0

