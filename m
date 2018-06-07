Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:43352 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932790AbeFGNho (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Jun 2018 09:37:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eyal Ilsar <eilsar@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] wcn36xx: Remove Unicode Byte Order Mark from testcode
Date: Thu,  7 Jun 2018 14:45:27 +0200
Message-Id: <1528375527-22761-1-git-send-email-geert@linux-m68k.org> (sfid-20180607_153806_721591_572D8BBD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Older gcc (< 4.4) doesn't like files starting with a Unicode BOM:

    drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray ‘\357’ in program
    drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray ‘\273’ in program
    drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray ‘\277’ in program

Remove the BOM, the rest of the file is plain ASCII anyway.

Output of "file drivers/net/wireless/ath/wcn36xx/testmode.c" before:

    drivers/net/wireless/ath/wcn36xx/testmode.c: C source, UTF-8 Unicode (with BOM) text

and after:

    drivers/net/wireless/ath/wcn36xx/testmode.c: C source, ASCII text

Fixes: 87f825e6e246cee0 ("wcn36xx: Add support for Factory Test Mode (FTM)")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/ath/wcn36xx/testmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.c b/drivers/net/wireless/ath/wcn36xx/testmode.c
index 1279064a3b716c2e..51a038022c8b8040 100644
--- a/drivers/net/wireless/ath/wcn36xx/testmode.c
+++ b/drivers/net/wireless/ath/wcn36xx/testmode.c
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.7.4
