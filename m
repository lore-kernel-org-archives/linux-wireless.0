Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:44896 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762488Ab2DLKNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 06:13:36 -0400
Received: by qafi31 with SMTP id i31so5483741qaf.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 03:13:35 -0700 (PDT)
Message-ID: <4F86AACD.5020607@gmail.com> (sfid-20120412_121349_464865_2935A1A6)
Date: Thu, 12 Apr 2012 06:13:33 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: fix undefined 'THIS_MODULE'
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cross compiling ath5k for a Mips machine with kernel 3.2.14
the compilation fails with "/ath5k/ahb.c:231:12: error: 'THIS_MODULE' undeclared here (not in a function)"
Fix the build by including <linux/export.h>

Signed-off-by: Jonathan Bither <jonbither@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 8faa129..47b6c35 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -19,6 +19,7 @@
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
 #include <linux/etherdevice.h>
+#include <linux/export.h>
 #include <ar231x_platform.h>
 #include "ath5k.h"
 #include "debug.h"
