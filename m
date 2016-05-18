Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33839 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbcERBPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 21:15:24 -0400
Received: by mail-pf0-f195.google.com with SMTP id 145so3413380pfz.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 18:15:23 -0700 (PDT)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, jes.sorensen@redhat.com
Subject: [PATCH 1/2] rtl8xxxu: Increase default polling timeout for firmware startup
Date: Tue, 17 May 2016 18:14:45 -0700
Message-Id: <1463534086-22353-2-git-send-email-dlenski@gmail.com> (sfid-20160518_031527_381577_A0845E3C)
In-Reply-To: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
References: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch increases the default value for the maximum number of polling
loops to wait for the rtl8xxxu MCU to start after the firmware is loaded
(from 1000 to 5000).

With RTL8723AU chipset, I frequently encounter "Firmware failed to start"
errors from rtl8xxxu after a cold boot.

It appears that other chipsets supported by the driver have the same
problem. Here are a couple of relevant bug reports:
- http://ubuntuforums.org/showthread.php?t=2321756
- https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg4942468.html

This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
too short, and the MCU fails to start up as quickly as expected.

With a longer value (5000), the driver starts up consistently and
successfully after cold-boot.

Signed-off-by: Dan Lenski <dlenski@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f2a1bac..39c6ce7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -49,7 +49,7 @@
 #define TX_PAGE_NUM_NORM_PQ		0x02
 
 #define RTL_FW_PAGE_SIZE		4096
-#define RTL8XXXU_FIRMWARE_POLL_MAX	1000
+#define RTL8XXXU_FIRMWARE_POLL_MAX	5000
 
 #define RTL8723A_CHANNEL_GROUPS		3
 #define RTL8723A_MAX_RF_PATHS		2
-- 
2.8.2

