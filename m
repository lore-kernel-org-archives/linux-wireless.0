Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab2COIDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 04:03:38 -0400
Subject: Re: [PATCH 1/2] cfg80211: Fix a compilation warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1331797479-2838-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120315_084450_920775_6E2CFD1C)
References: <1331797479-2838-1-git-send-email-nataraja@qca.qualcomm.com>
	 (sfid-20120315_084450_920775_6E2CFD1C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 09:03:30 +0100
Message-ID: <1331798610.3432.0.camel@jlt3.sipsolutions.net> (sfid-20120315_090344_047879_BCF6E21A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 13:14 +0530, Vivek Natarajan wrote:
> Fix a macro redefined warning:
> 
> net/wireless/reg.c:45:1 warning: "pr_fmt" redefined
> 
> Also remove an unused instance in core.c
> 
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
> ---
>  net/wireless/core.c |    2 --
>  net/wireless/reg.c  |    2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index ccdfed8..067c008 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -4,8 +4,6 @@
>   * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
>   */
>  
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
>  #include <linux/if.h>
>  #include <linux/module.h>
>  #include <linux/err.h>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index e9a0ac8..1797fcc 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -42,7 +42,9 @@
>   *
>   */
>  
> +#ifndef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#endif

Umm, no? This isn't right -- are you getting this warning while building
a compat tree?

johannes

