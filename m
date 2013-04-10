Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:55447 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313Ab3DJOV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 10:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <8701347.YaW7b4Fxgt@uw000953>
References: <CAFSJ42ZZH7Y+MPUURG_hQRuwhv8UKkF5sQQebsTjhH0uT07rjA@mail.gmail.com>
	<8701347.YaW7b4Fxgt@uw000953>
Date: Wed, 10 Apr 2013 16:21:57 +0200
Message-ID: <CAFSJ42a5PsnbhgEaWWWZTBDVKhKUGR4xWY1pEXPc-UaQcC9AFA@mail.gmail.com> (sfid-20130410_162201_754829_785BF335)
Subject: Re: include/linux/device.h:715:38: error: 'THIS_MODULE' undeclared
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Szymon Janc <szymon.janc@tieto.com>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanx for reply. That also works.
But is it a solution or workaround? May be there should be smarter
check than just a kernel version?

2013/4/10 Szymon Janc <szymon.janc@tieto.com>:
> On Wednesday 10 of April 2013 12:20:37 Eugene Krasnikov wrote:
> Hi Eugene,
>
>> I have tried to build latest compat-drivers for android/cyanogenmod
>> kernel version 3.0.60 but it fails with the following error:
>>
>> /cyanogenmod/kernel/sony/msm8x60/include/linux/device.h: In function
>> 'root_device_register':
>> /cyanogenmod/kernel/sony/msm8x60/include/linux/device.h:715:38: error:
>> 'THIS_MODULE' undeclared (first use in this function)
>>
>> Command line that is used to build compat-drivers is:
>>
>> make KLIB=/cyanogenmod/out/target/product/mint/obj/KERNEL_OBJ
>> KLIB_BUILD=/cyanogenmod/out/target/product/mint/obj/KERNEL_OBJ
>> ARCH=arm CROSS_COMPILE=/cyanogenmod/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
>>
>> Did anybody meet such an error?
>> Patch bellow was used as a workaround to this error, but i would like
>> to find a proper solution.
>
> I had similar issue with grouper (nexus7) 3.1 kernel. This was due to DMA_BUF
> stuff being backported to that kernel (and that pulled also export.h change).
> Maybe it is same with CM kernel?
>
> This fixed build for me:
> ---
>  include/linux/export.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/export.h b/include/linux/export.h
> index f7842b7..5ef58c5 100644
> --- a/include/linux/export.h
> +++ b/include/linux/export.h
> @@ -3,10 +3,10 @@
>
>  #include <linux/version.h>
>
> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0))
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
>  #include_next <linux/export.h>
>  #else
>  #include <linux/module.h>
> -#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)) */
> +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0)) */
>
>  #endif /* _COMPAT_LINUX_EXPORT_H */
>
>
> You can check if enabling this for kernel >=3.0.0 works for you:)
>
> --
> BR
> Szymon Janc



-- 
Best regards,
Eugene
