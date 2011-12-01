Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60550 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082Ab1LALNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 06:13:50 -0500
Received: by lagw12 with SMTP id w12so532378lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 03:13:49 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Restore testmode ABI
Date: Thu,  1 Dec 2011 12:13:44 +0100
Message-Id: <1322738024-16626-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20111201_121354_219530_27D8E3B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 80900d0140a7648587982c8f299830e900e49165 accidently broke
the ABI for testmode commands. Restore the ABI again.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/wl12xx/testmode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 61fff45..5b3f781 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -37,6 +37,7 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_TEST,
 	WL1271_TM_CMD_INTERROGATE,
 	WL1271_TM_CMD_CONFIGURE,
+	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */
 	WL1271_TM_CMD_SET_PLT_MODE,
 	WL1271_TM_CMD_RECOVER,
 
-- 
1.7.5.4

