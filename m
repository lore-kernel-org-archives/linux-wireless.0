Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53957 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJJUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 05:20:37 -0400
MIME-Version: 1.0
Date: Wed, 10 Apr 2013 11:20:37 +0200
Message-ID: <CAFSJ42ZZH7Y+MPUURG_hQRuwhv8UKkF5sQQebsTjhH0uT07rjA@mail.gmail.com> (sfid-20130410_112044_498348_BE89F9F1)
Subject: include/linux/device.h:715:38: error: 'THIS_MODULE' undeclared
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: backports@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I have tried to build latest compat-drivers for android/cyanogenmod
kernel version 3.0.60 but it fails with the following error:

/cyanogenmod/kernel/sony/msm8x60/include/linux/device.h: In function
'root_device_register':
/cyanogenmod/kernel/sony/msm8x60/include/linux/device.h:715:38: error:
'THIS_MODULE' undeclared (first use in this function)

Command line that is used to build compat-drivers is:

make KLIB=/cyanogenmod/out/target/product/mint/obj/KERNEL_OBJ
KLIB_BUILD=/cyanogenmod/out/target/product/mint/obj/KERNEL_OBJ
ARCH=arm CROSS_COMPILE=/cyanogenmod/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-

Did anybody meet such an error?
Patch bellow was used as a workaround to this error, but i would like
to find a proper solution.

>From c059e8b803550c7b76cc102d6c1fb1d8a0fa6fa9 Mon Sep 17 00:00:00 2001
From: Eugene Krasnikov <k.eugene.e@gmail.com>
Date: Tue, 9 Apr 2013 18:28:38 +0200
Subject: [PATCH] Use export.h from CM location

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 include/linux/compat-2.6.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 1e9effb..47f7434 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -43,6 +43,7 @@ void backport_dependency_symbol(void);
  * Each compat file represents compatibility code for new kernel
  * code introduced for *that* kernel revision.
  */
+#include </cyanogenmod/kernel/sony/msm8x60/include/linux/export.h>

 #include <linux/compat-2.6.22.h>
 #include <linux/compat-2.6.23.h>
--
1.7.10


--
Best regards,
Eugene
