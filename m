Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbeCTKht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 06:37:49 -0400
Date: Tue, 20 Mar 2018 11:37:47 +0100
From: Michal Kubecek <mkubecek@suse.cz>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [RFC] ethtool:  Support ETHTOOL_GSTATS2 command.
Message-ID: <20180320103747.7kcfdu4yzof6bwxw@unicorn.suse.cz> (sfid-20180320_113759_019814_DC42A255)
References: <1520452289-14172-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520452289-14172-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 07, 2018 at 11:51:29AM -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This is similar to ETHTOOL_GSTATS, but it allows you to specify
> a 'level'.  This level can be used by the driver to decrease the
> amount of stats refreshed.  In particular, this helps with ath10k
> since getting the firmware stats can be slow.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> NOTE:  I know to make it upstream I would need to split the patch and
> remove the #define for 'backporting' that I added.  But, is the
> feature in general wanted?  If so, I'll do the patch split and
> other tweaks that might be suggested.

I'm not familiar enough with the technical background of stats
collecting to comment on usefulness and desirability of this feature.
Adding a new command just to add a numeric parameter certainly doesn't
feel right but it's how the ioctl interface works. I take it as
a reminder to find some time to get back to the netlink interface.

> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 674b6c9..d3b709f 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -1947,6 +1947,54 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
>  	return ret;
>  }
>  
> +static int ethtool_get_stats2(struct net_device *dev, void __user *useraddr)
> +{
> +	struct ethtool_stats stats;
> +	const struct ethtool_ops *ops = dev->ethtool_ops;
> +	u64 *data;
> +	int ret, n_stats;
> +	u32 stats_level = 0;
> +
> +	if (!ops->get_ethtool_stats2 || !ops->get_sset_count)
> +		return -EOPNOTSUPP;
> +
> +	n_stats = ops->get_sset_count(dev, ETH_SS_STATS);
> +	if (n_stats < 0)
> +		return n_stats;
> +	if (n_stats > S32_MAX / sizeof(u64))
> +		return -ENOMEM;
> +	WARN_ON_ONCE(!n_stats);
> +	if (copy_from_user(&stats, useraddr, sizeof(stats)))
> +		return -EFAULT;
> +
> +	/* User can specify the level of stats to query.  How the
> +	 * level value is used is up to the driver, but in general,
> +	 * 0 means 'all', 1 means least, and higher means more.
> +	 * The idea is that some stats may be expensive to query, so user
> +	 * space could just ask for the cheap ones...
> +	 */
> +	stats_level = stats.n_stats;
> +
> +	stats.n_stats = n_stats;
> +	data = vzalloc(n_stats * sizeof(u64));
> +	if (n_stats && !data)
> +		return -ENOMEM;
> +
> +	ops->get_ethtool_stats2(dev, &stats, data, stats_level);
> +
> +	ret = -EFAULT;
> +	if (copy_to_user(useraddr, &stats, sizeof(stats)))
> +		goto out;
> +	useraddr += sizeof(stats);
> +	if (n_stats && copy_to_user(useraddr, data, n_stats * sizeof(u64)))
> +		goto out;
> +	ret = 0;
> +
> + out:
> +	vfree(data);
> +	return ret;
> +}
> +
>  static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
>  {
>  	struct ethtool_stats stats;

IMHO it would be more practical to set "0 means same as GSTATS" as a
rule and make ethtool_get_stats() a wrapper for ethtool_get_stats2() to
avoid code duplication (or perhaps a use fall-through in the switch). It
would also allow drivers to provide only one of the callbacks.

Michal Kubecek
