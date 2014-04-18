Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58143 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaDRCjP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 22:39:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Thu, 17 Apr 2014 19:39:00 -0700
Subject: RE: [PATCH] mwifiex: use generic header for if_arp.h
Message-ID: <477F20668A386D41ADCC57781B1F70430F706866FA@SC-VEXCH1.marvell.com> (sfid-20140418_043919_639395_9778BDCB)
References: <1397784348-16059-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1397784348-16059-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Older kernels require both, but if we instead include the general header we
> get both in-kernel and UAPI stuff. This simplifies the backport.
> 
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/decl.h   | 2 +-
>  drivers/net/wireless/mwifiex/sta_rx.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/decl.h
> b/drivers/net/wireless/mwifiex/decl.h
> index e7b3e16..51e0f6d 100644
> --- a/drivers/net/wireless/mwifiex/decl.h
> +++ b/drivers/net/wireless/mwifiex/decl.h
> @@ -26,7 +26,7 @@
>  #include <linux/wait.h>
>  #include <linux/timer.h>
>  #include <linux/ieee80211.h>
> -#include <uapi/linux/if_arp.h>
> +#include <linux/if_arp.h>
>  #include <net/mac80211.h>
> 
> 
> diff --git a/drivers/net/wireless/mwifiex/sta_rx.c
> b/drivers/net/wireless/mwifiex/sta_rx.c
> index ed26387..ea20fef 100644
> --- a/drivers/net/wireless/mwifiex/sta_rx.c
> +++ b/drivers/net/wireless/mwifiex/sta_rx.c
> @@ -17,7 +17,7 @@
>   * this warranty disclaimer.
>   */
> 
> -#include <uapi/linux/ipv6.h>
> +#include <linux/ipv6.h>
>  #include <net/ndisc.h>
>  #include "decl.h"
>  #include "ioctl.h"
> --
> 1.9.1

