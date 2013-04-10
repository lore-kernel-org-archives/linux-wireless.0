Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:57416 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934753Ab3DJL47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 07:56:59 -0400
From: Szymon Janc <szymon.janc@tieto.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: include/linux/device.h:715:38: error: 'THIS_MODULE' undeclared
Date: Wed, 10 Apr 2013 13:56:56 +0200
Message-ID: <8701347.YaW7b4Fxgt@uw000953> (sfid-20130410_135708_517545_38522230)
In-Reply-To: <CAFSJ42ZZH7Y+MPUURG_hQRuwhv8UKkF5sQQebsTjhH0uT07rjA@mail.gmail.com>
References: <CAFSJ42ZZH7Y+MPUURG_hQRuwhv8UKkF5sQQebsTjhH0uT07rjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 of April 2013 12:20:37 Eugene Krasnikov wrote:
Hi Eugene,
 
> I have tried to build latest compat-drivers for android/cyanogenmod
> kernel version 3.0.60 but it fails with the following error:
> 
> /cyanogenmod/kernel/sony/msm8x60/include/linux/device.h: In function
> 'root_device_register':
> /cyanogenmod/kernel/sony/msm8x60/include/linux/device.h:715:38: error:
> 'THIS_MODULE' undeclared (first use in this function)
> 
> Command line that is used to build compat-drivers is:
> 
> make KLIB=/cyanogenmod/out/target/product/mint/obj/KERNEL_OBJ
> KLIB_BUILD=/cyanogenmod/out/target/product/mint/obj/KERNEL_OBJ
> ARCH=arm CROSS_COMPILE=/cyanogenmod/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
> 
> Did anybody meet such an error?
> Patch bellow was used as a workaround to this error, but i would like
> to find a proper solution.

I had similar issue with grouper (nexus7) 3.1 kernel. This was due to DMA_BUF
stuff being backported to that kernel (and that pulled also export.h change).
Maybe it is same with CM kernel?

This fixed build for me:
---
 include/linux/export.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/export.h b/include/linux/export.h
index f7842b7..5ef58c5 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -3,10 +3,10 @@
 
 #include <linux/version.h>
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0))
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
 #include_next <linux/export.h>
 #else
 #include <linux/module.h>
-#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)) */
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0)) */
 
 #endif	/* _COMPAT_LINUX_EXPORT_H */


You can check if enabling this for kernel >=3.0.0 works for you:)

-- 
BR
Szymon Janc
