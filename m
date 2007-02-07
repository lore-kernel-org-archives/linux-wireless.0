Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38045 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965669AbXBGHgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 02:36:01 -0500
Date: Wed, 7 Feb 2007 07:35:57 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [RFC PATCH 1/3] wireless: add cfg80211
Message-ID: <20070207073557.GA14703@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com> <20070207004626.GA23096@tuxdriver.com> <20070207004747.GB23096@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070207004747.GB23096@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 06, 2007 at 07:47:47PM -0500, John W. Linville wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This patch adds cfg80211, a new configuration system for wireless
> hardware.
> 
> It currently features a bunch of configuration requests, support for
> adding and removing virtual interfaces, the ability to inject packets and
> more.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  include/linux/netdevice.h  |    1 +
>  include/net/cfg80211.h     |  186 ++++++++++++++++++++++++++++++++++++++++++++
>  net/Kconfig                |    3 +
>  net/Makefile               |    1 +
>  net/wireless/Makefile      |    4 +
>  net/wireless/core.c        |  158 +++++++++++++++++++++++++++++++++++++
>  net/wireless/core.h        |   57 ++++++++++++++
>  net/wireless/wext-compat.c |   25 ++++++
>  8 files changed, 435 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index fea0d9d..c1e9962 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -398,6 +398,7 @@ struct net_device
>  	void                    *ip6_ptr;       /* IPv6 specific data */
>  	void			*ec_ptr;	/* Econet specific data	*/
>  	void			*ax25_ptr;	/* AX.25 specific data */
> +	void			*ieee80211_ptr;	/* IEEE 802.11 specific data */
>  
>  /*
>   * Cache line mostly used on receive path (including eth_type_trans())

> --- /dev/null
> +++ b/net/wireless/Makefile
> @@ -0,0 +1,4 @@
> +obj-$(CONFIG_CFG80211) += cfg80211.o
> +
> +cfg80211-objs := \
> +	core.o

the contents of this file should be:

obj-$(CONFIG_CFG80211)	+= cfg80211.o
cfg80211-y		+= core.o


> @@ -0,0 +1,158 @@
> +/*
> + * This is the new wireless configuration interface.

I don't think new makes a lot of sense here, it's hopefully the
standad one soon.

> + *
> + * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
> + */
> +
> +#include "core.h"
> +#include <linux/if.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <net/genetlink.h>
> +#include <net/cfg80211.h>
> +#include <linux/mutex.h>
> +#include <linux/list.h>

This include order seems odd.  We normally include local headers
last and net/ after linux/

> +MODULE_AUTHOR("Johannes Berg");
> +MODULE_LICENSE("GPL");

Can you please add a MODULE_DESCRIPTION aswell?

> +
> +/* RCU might be appropriate here since we usually
> + * only read the list, and that can happen quite
> + * often because we need to do it for each command */
> +LIST_HEAD(cfg80211_drv_list);
> +DEFINE_MUTEX(cfg80211_drv_mutex);

Any reason these are non-static?  They aren't actually used outside
of this file, and in general having non-static lists isn't very nice,
we prefer having proper accessor functions.

> +static int cfg80211_init(void)
> +{
> +	/* possibly need to do more later */
> +	return 0;
> +}
> +
> +static void cfg80211_exit(void)
> +{
> +}
> +
> +module_init(cfg80211_init);
> +module_exit(cfg80211_exit);

Just drop these two, there's not point in adding dead code.

> --- /dev/null
> +++ b/net/wireless/wext-compat.c
> @@ -0,0 +1,25 @@
> +/* NOT YET */
> +

huh?  this file isn't added to the build process and only contains
a (non-standard formatted) comment.  No point in adding it in this
patch.

