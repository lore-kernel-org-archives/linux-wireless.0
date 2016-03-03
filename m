Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34922 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbcCCMGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 07:06:16 -0500
Received: by mail-pa0-f68.google.com with SMTP id fl4so1151431pad.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 04:06:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/6] staging: wilc1000: use TAG_PARAM_OFFSET define
Date: Thu,  3 Mar 2016 21:05:17 +0900
Message-Id: <1457006722-14400-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_130619_715483_BD5F3B0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TAG_PARAM_OFFSET is defined at top of this file so that it is used
to simplify codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 25dc108..2c4ae1f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -178,10 +178,8 @@ static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 	u8 i   = 0;
 	u8 j   = 0;
 
-	len = data[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN +
-		   CAP_INFO_LEN + 1];
-	j   = MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN +
-		CAP_INFO_LEN + 2;
+	len = data[TAG_PARAM_OFFSET + 1];
+	j   = TAG_PARAM_OFFSET + 2;
 
 	if (len >= MAX_SSID_LEN)
 		len = 0;
@@ -335,10 +333,8 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		tim_elm = get_tim_elm(msa, rx_len + FCS_LEN, index);
 		if (tim_elm)
 			network_info->dtim_period = tim_elm[3];
-		ies = &msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN +
-			   CAP_INFO_LEN];
-		ies_len = rx_len - (MAC_HDR_LEN + TIME_STAMP_LEN +
-				    BEACON_INTERVAL_LEN + CAP_INFO_LEN);
+		ies = &msa[TAG_PARAM_OFFSET];
+		ies_len = rx_len - TAG_PARAM_OFFSET;
 
 		if (ies_len > 0) {
 			network_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
-- 
2.7.1

