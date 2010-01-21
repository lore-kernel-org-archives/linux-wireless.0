Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:12637 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0AUUQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 15:16:46 -0500
Message-ID: <4B58B62B.4060905@irobot.com>
Date: Thu, 21 Jan 2010 12:16:43 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, mcgrof@infradead.org
Subject: Re: [PATCH] compat: fix build on arm
References: <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com> <1264102368-8918-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1264102368-8918-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Confirm; this fixes the compile issue for ARM

Hauke Mehrtens wrote:
> ARM does not provided the include file asm/compat.h. Use linux/compat.h
> instead, it includes asm/compat.h if needed.
> This patch is from OpenWRT:
> https://dev.openwrt.org/browser/trunk/package/mac80211/patches/020-fix_compat_h.patch?rev=19063
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.32.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
> index c3e4dbe..11060d8 100644
> --- a/include/linux/compat-2.6.32.h
> +++ b/include/linux/compat-2.6.32.h
> @@ -6,7 +6,7 @@
>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
>  
>  #include <linux/netdevice.h>
> -#include <asm/compat.h>
> +#include <linux/compat.h>
>  #include <net/iw_handler.h>
>  #include <linux/workqueue.h>
>  
>   

