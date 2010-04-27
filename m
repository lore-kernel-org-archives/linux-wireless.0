Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab0D0URA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 16:17:00 -0400
Date: Tue, 27 Apr 2010 13:16:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com, joe@perches.com
Subject: Re: [PATCH] Added configurable debug messages to libertastf
Message-Id: <20100427131654.4ee04752.akpm@linux-foundation.org>
In-Reply-To: <1272231646-67723-1-git-send-email-steve@cozybit.com>
References: <g2t446ae9281004251430t89236181p8f3d056181fb8b49@mail.gmail.com>
	<1272231646-67723-1-git-send-email-steve@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 25 Apr 2010 14:40:46 -0700
Steve deRosier <steve@cozybit.com> wrote:

> Add the same type of configurable debug messages to libertas_tf as
> already exist in the libertas driver.  This has facilitated creation of a interface
> specification and will facilitate future development of this driver.
> 
> ...
>
> --- /dev/null
> +++ b/drivers/net/wireless/libertas_tf/deb_defs.h
> @@ -0,0 +1,106 @@
> +/**
> +  * This header file contains global constant/enum definitions,
> +  * global variable declaration.
> +  */
> +#ifndef _LBS_DEB_DEFS_H_
> +#define _LBS_DEB_EFS_H_
> +
> +#ifndef DRV_NAME
> +#define DRV_NAME "libertas_tf"
> +#endif
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +

I dunno what this pr_fmt() definition is doing here, but it has
unpleasant effects with a x86_64 allmodconfig build:

In file included from drivers/net/wireless/libertas_tf/main.c:12:
drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
In file included from /usr/src/devel/arch/x86/include/asm/percpu.h:44,
	from /usr/src/devel/arch/x86/include/asm/current.h:5,
	from /usr/src/devel/arch/x86/include/asm/processor.h:15,
	from /usr/src/devel/arch/x86/include/asm/thread_info.h:22,
	from include/linux/thread_info.h:56,
	from include/linux/preempt.h:9,
	from include/linux/spinlock.h:50,
	from include/linux/mmzone.h:7,
	from include/linux/gfp.h:4,
	from include/linux/slab.h:12,
	from drivers/net/wireless/libertas_tf/main.c:10:
include/linux/kernel.h:376:1: warning: this is the location of the previous definition

so I cheerily deleted it.
