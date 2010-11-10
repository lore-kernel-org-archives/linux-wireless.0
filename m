Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27272 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab0KJWYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:24:50 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 14:24:37 -0800
Date: Wed, 10 Nov 2010 14:24:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 28/44] compat: avoid using `#include_next' directive in
 compat headers
Message-ID: <20101110222448.GG4667@tux>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
 <1289355626-25373-29-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289355626-25373-29-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 06:20:10PM -0800, Arnaud Lacombe wrote:
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

But will the kernels' own pm_qos_params.h be included for kernels >= 2.6.25?

  Luis
