Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33120 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbHVK6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 06:58:41 -0400
Received: by pdrh1 with SMTP id h1so36038740pdr.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2015 03:58:40 -0700 (PDT)
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Donald <gdonald@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 2/4] Staging: rtl8192e: r8192E_dev.c: Remove unused variable
Date: Sat, 22 Aug 2015 16:28:12 +0530
Message-Id: <1440241094-5927-2-git-send-email-shraddha.6596@gmail.com> (sfid-20150822_125856_676821_B573EE36)
In-Reply-To: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
References: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch discards the variable as it is not used anywhere throughout
the kernel.

Build tested it.

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index c28cabc..353e3fe 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -108,7 +108,6 @@ void rtl92e_set_reg(struct net_device *dev, u8 variable, u8 *val)
 	case HW_VAR_MEDIA_STATUS:
 	{
 		enum rt_op_mode OpMode = *((enum rt_op_mode *)(val));
-		enum led_ctl_mode LedAction = LED_CTL_NO_LINK;
 		u8 btMsr = rtl92e_readb(dev, MSR);
 
 		btMsr &= 0xfc;
@@ -116,7 +115,6 @@ void rtl92e_set_reg(struct net_device *dev, u8 variable, u8 *val)
 		switch (OpMode) {
 		case RT_OP_MODE_INFRASTRUCTURE:
 			btMsr |= MSR_INFRA;
-			LedAction = LED_CTL_LINK;
 			break;
 
 		case RT_OP_MODE_IBSS:
@@ -125,7 +123,6 @@ void rtl92e_set_reg(struct net_device *dev, u8 variable, u8 *val)
 
 		case RT_OP_MODE_AP:
 			btMsr |= MSR_AP;
-			LedAction = LED_CTL_LINK;
 			break;
 
 		default:
-- 
2.1.4

