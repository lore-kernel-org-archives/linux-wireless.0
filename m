Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51672 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2DVWDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/7] compat-wireless: build alx for kernel > 2.6.27
Date: Mon, 23 Apr 2012 00:03:18 +0200
Message-Id: <1335132199-21320-6-git-send-email-hauke@hauke-m.de> (sfid-20120423_000345_257284_84A8045B)
In-Reply-To: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
References: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling against kernel <= 2.6.27 alx has build errors so use
atl1c there instead. The logic was wrong before.
---
 config.mk |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 584189b..e8ee333 100644
--- a/config.mk
+++ b/config.mk
@@ -400,13 +400,13 @@ export CONFIG_MWL8K=m
 export CONFIG_ATL1=m
 export CONFIG_ATL2=m
 export CONFIG_ATL1E=m
-ifdef CONFIG_COMPAT_KERNEL_2_6_27
-export CONFIG_ATL1C=n
-export CONFIG_ALX=m
-else #CONFIG_COMPAT_KERNEL_2_6_27
+ifdef CONFIG_COMPAT_KERNEL_2_6_28
+export CONFIG_ATL1C=m
+export CONFIG_ALX=n
+else #CONFIG_COMPAT_KERNEL_2_6_28
 export CONFIG_ATL1C=n
 export CONFIG_ALX=m
-endif #CONFIG_COMPAT_KERNEL_2_6_27
+endif #CONFIG_COMPAT_KERNEL_2_6_28
 
 ifdef CONFIG_WIRELESS_EXT
 export CONFIG_HERMES=m
-- 
1.7.9.5

