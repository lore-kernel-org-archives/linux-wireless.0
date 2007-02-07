Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33371 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbXBGHy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 02:54:59 -0500
Date: Wed, 7 Feb 2007 07:54:20 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
Message-ID: <20070207075420.GB14703@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com> <20070207004626.GA23096@tuxdriver.com> <20070207004747.GB23096@tuxdriver.com> <20070207004832.GC23096@tuxdriver.com> <20070207004929.GD23096@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070207004929.GD23096@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c1e9962..6a9b4c8 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -348,12 +348,17 @@ struct net_device
>  
>  	struct net_device_stats* (*get_stats)(struct net_device *dev);
>  
> +#ifdef CONFIG_WIRELESS_EXT
>  	/* List of functions to handle Wireless Extensions (instead of ioctl).
>  	 * See <net/iw_handler.h> for details. Jean II */
>  	const struct iw_handler_def *	wireless_handlers;
>  	/* Instance data managed by the core of Wireless Extensions. */
>  	struct iw_public_data *	wireless_data;
> -
> +#endif
> +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> +	/* pending config used by cfg80211/wext compat code only */
> +	void *cfg80211_wext_pending_config;
> +#endif

Do we really have to add this directly to struct net_device and bloat it
for all users?  I'd put this behind  ieee80211_ptr instead unless there's
a good reason against that.

> +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> +extern int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
> +#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
> +int cfg80211_wext_nl_set(struct net_device *dev, char *data, int len);
> +int cfg80211_wext_nl_get(struct net_device *dev, char *data, int len,
> +			 char **p_buf, int *p_len);
> +#endif
> +#endif

Please chose either to use the extern prefix or not, but stick to one
choice for a single file :)  Also we don't need to ifdef out prototypes.

> +config CFG80211_WEXTNL_COMPAT
> +	bool "cfg80211 WE-netlink compatibility"
> +	depends CFG80211 && CFG80211_WEXT_COMPAT
> +	---help---
> +	This option allows using devices whose drivers have been
> +	converted to use the new cfg80211 with wireless extensions
> +	over rtnetlink, providing WE-20 compatibility. Note that
> +	cfg80211's "native" interface is nl80211 using generic netlink.
> +	The wireless extensions are being deprecated and the netlink
> +	based API for WE was never configured by default, nor do any
> +	userspace tools use this feature.
> +
> +	This option exists only to make Jean happy. Say N.

Should we really put this code in?  It seems like unessecary bloat to me.


> @@ -2798,6 +2799,39 @@ int dev_ioctl(unsigned int cmd, void __user *arg)
>  					ret = -EFAULT;
>  				return ret;
>  			}
> +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> +			/* Take care of cfg80211 WE compatibility */
> +			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
> +				/* If command is `set a parameter', or
> +				 * `get the encoding parameters', check if
> +				 * the user has the right to do it */
> +				if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE
> +				    || cmd == SIOCGIWENCODEEXT) {
> +					if (!capable(CAP_NET_ADMIN))
> +						return -EPERM;
> +				}
> +				dev_load(ifr.ifr_name);
> +				rtnl_lock();
> +				/* Follow me in net/wireless/wext-compat.c */
> +				ret = cfg80211_wext_ioctl(&ifr, cmd);
> +				rtnl_unlock();
> +				if (ret == 0 && IW_IS_GET(cmd) &&
> +				    copy_to_user(arg, &ifr,
> +						 sizeof(struct ifreq)))
> +					ret = -EFAULT;
> +				/* haha, I cheat here by allowing a driver or
> +				 * stack to have both WE or CFG80211-WE for
> +				 * a little while during conversion... hope that
> +				 * ENOSYS is only used to indicate not implemented
> +				 *
> +				 * if wireless extensions are not configured
> +				 * then this is the last thing here so that
> +				 * if we fall through we return -EINVAL
> +				 */
> +				if (ret != -ENOSYS)
> +					return ret;
> +			}

Can we split this into a nice little helper function in wext-compat.c
or a dummy macro if it's not configured?

> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -56,6 +56,9 @@
>  #include <linux/wireless.h>
>  #include <net/iw_handler.h>
>  #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
> +#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
> +#include <net/cfg80211.h>
> +#endif

There's not point in including headers conditionally.

> diff --git a/net/wireless/Makefile b/net/wireless/Makefile
> index 663a7d8..62e67b7 100644
> --- a/net/wireless/Makefile
> +++ b/net/wireless/Makefile
> @@ -4,3 +4,13 @@ cfg80211-objs := \
>  	core.o
>  
>  obj-$(CONFIG_WIRELESS_EXT) += wext-old.o
> +
> +obj-nn :=
> +obj-yy :=
> +obj-yn :=
> +obj-ny :=
> +
> +# this needs to be compiled in...
> +obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
> +obj-$(CONFIG_CFG80211_WEXT_COMPAT)$(CONFIG_NET_WIRELESS) += wext-common.o
> +obj-y += $(obj-yy) $(obj-yn) $(obj-ny)

This looks odd. Kbuild filters out duplicate objects, so something like
the snipplet below should work aswell:

obj-$(CONFIG_WIRELESS_EXT)		+= wext-common.o wext-old.o
obj-$(CONFIG_CFG80211_WEXT_COMPAT)	+= wext-common.o wext-compat.o	


> +#ifdef CONFIG_CFG80211_WEXT_COMPAT
> +/* wext compatibility must be compiled in...
> + * this extern is in wext-compat.c */

Is there really a point in making cfg80211 a loadable module?
This whle operation vector stuff looks like a lot of unnessecary
complexity to me.

> new file mode 100644
> index 0000000..c1de1d7
> --- /dev/null
> +++ b/net/wireless/wext-common.c
> @@ -0,0 +1,610 @@
> +/* common wext support routines, proc interface and events */

This is mostly Jean's old code, right?  Probably wants at least some
attribution.

> +static void cfg80211_ensure_netdev_pending_cfg(struct net_device *dev)
> +{
> +	struct cfg80211_config *cfg = dev->cfg80211_wext_pending_config;
> +	if (!cfg) {
> +		cfg = kmalloc(sizeof(*cfg)+32, GFP_KERNEL);

kmalloc return values need to be checked.

> +/* operations we implement. whew, I machine-generated these */

So should we put the shell-script to generate them intree instead? :)
Well, probably not, but then again we probably don't want this
comment either as it won't be true anymore as soon as someone touches
the code.


Btw, if we submit cfg80211 for inclusion there should be at least one patch
in the series actually converts a driver to use it.  Both to make this
code not dead and give people and example on how to use the cfg80211
infrastructure.
