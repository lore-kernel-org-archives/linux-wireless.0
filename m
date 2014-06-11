Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:53028 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaFKO5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:57:50 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so2412834wes.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:57:49 -0700 (PDT)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: rtl8723au: Add compiler check for -Wtype-limits
Date: Wed, 11 Jun 2014 16:57:46 +0200
Message-Id: <1402498666-5018-1-git-send-email-geert@linux-m68k.org> (sfid-20140611_165753_393553_D8978A50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gcc versions before 4.3 do not support -Wtype-limits:

cc1: error: unrecognized command line option "-Wtype-limits"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/rtl8723au/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/Makefile b/drivers/staging/rtl8723au/Makefile
index a6316af94b79..6b3f25555c74 100644
--- a/drivers/staging/rtl8723au/Makefile
+++ b/drivers/staging/rtl8723au/Makefile
@@ -53,4 +53,5 @@ r8723au-$(CONFIG_8723AU_AP_MODE) += core/rtw_ap.o
 
 obj-$(CONFIG_R8723AU)	:= r8723au.o
 
-ccflags-y += -Wtype-limits -D__CHECK_ENDIAN__ -I$(src)/include
+ccflags-y += $(call cc-option,-Wtype-limits,)
+ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/include
-- 
1.9.1

