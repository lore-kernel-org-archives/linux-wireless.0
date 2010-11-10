Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35558 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757208Ab0KJWXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:23:36 -0500
Message-ID: <4CDB1B64.6010002@openwrt.org>
Date: Wed, 10 Nov 2010 23:23:32 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 28/44] compat: avoid using `#include_next' directive in
 compat headers
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com> <1289355626-25373-29-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-29-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 3:20 AM, Arnaud Lacombe wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/linux/pm_qos_params.h |    7 +++----
>  include/linux/tracepoint.h    |   14 +++++++-------
>  include/net/net_namespace.h   |   14 +++++++-------
>  include/trace/define_trace.h  |    5 -----
>  4 files changed, 17 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
> index e1f083c..8c69ab2 100644
> --- a/include/linux/pm_qos_params.h
> +++ b/include/linux/pm_qos_params.h
> @@ -1,8 +1,7 @@
>  #include <linux/version.h>
>  
> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
> -#include_next <linux/pm_qos_params.h>
> -#else
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
> +
>  /* interface for the pm_qos_power infrastructure of the linux kernel.
>   *
>   * Mark Gross <mgross@linux.intel.com>
> @@ -28,5 +27,5 @@ int pm_qos_requirement(int qos);
>  
>  int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
>  int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
> -#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)) */
>  
> +#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
With #include_next gone, how would the compiler find the other header
file for version >= 2.6.25?

- Felix
