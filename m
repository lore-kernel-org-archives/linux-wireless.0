Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:57566 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0GHVcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 17:32:51 -0400
Received: by pxi14 with SMTP id 14so485588pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jul 2010 14:32:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278623628-25477-2-git-send-email-hauke@hauke-m.de>
References: <1278623628-25477-1-git-send-email-hauke@hauke-m.de>
	<1278623628-25477-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Jul 2010 14:32:26 -0700
Message-ID: <AANLkTim2NY3vJEJVQh3ubiPidGEZi3ZRMKUK39j3HSb_@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: fix build problems
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 8, 2010 at 2:13 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Fix some minor build problems in patch.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  patches/28-pm-qos-params.patch |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
> index c5f8fd2..438bdd8 100644
> --- a/patches/28-pm-qos-params.patch
> +++ b/patches/28-pm-qos-params.patch
> @@ -47,9 +47,9 @@ little wierd.
>        spin_unlock_irqrestore(&priv->low_lock, flags);
>
>  +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
> -+      pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
> -+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
>        pm_qos_update_request(&ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
> ++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
> ++      pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
>  +#else
>  +      pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
>  +                                PM_QOS_DEFAULT_VALUE);
> @@ -83,7 +83,7 @@ little wierd.
>  +#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
>  +      pm_qos_remove_request(ipw2100_pm_qos_req);
>  +#else
> -+      pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100")
> ++      pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
>  +#endif
>  }

Oops thanks, applied, and forced out a new tarball.

  Luis
