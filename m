Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35679 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbcCCF2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 00:28:44 -0500
Received: by mail-pa0-f68.google.com with SMTP id fl4so686936pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 21:28:44 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: remove typedef from enum tenuConnectSts
Date: Thu,  3 Mar 2016 14:28:24 +0900
Message-Id: <1456982904-8063-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160303_062859_636329_76AE4D9B)
In-Reply-To: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456982904-8063-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from enum tenuConnectSts and renames it to
connect_status to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 63eca24..076e06a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -50,7 +50,7 @@
 #define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
 #define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
 
-typedef enum {
+enum connect_status {
 	SUCCESSFUL_STATUSCODE    = 0,
 	UNSPEC_FAIL              = 1,
 	UNSUP_CAP                = 10,
@@ -68,7 +68,7 @@ typedef enum {
 	SHORT_SLOT_UNSUP         = 25,
 	OFDM_DSSS_UNSUP          = 26,
 	CONNECT_STS_FORCE_16_BIT = 0xFFFF
-} tenuConnectSts;
+};
 
 typedef struct {
 	u8 u8Full;
-- 
2.7.1

