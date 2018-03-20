Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59372 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeCTPjf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 11:39:35 -0400
Subject: Re: [RFC] ethtool: Support ETHTOOL_GSTATS2 command.
To: Michal Kubecek <mkubecek@suse.cz>
References: <1520452289-14172-1-git-send-email-greearb@candelatech.com>
 <20180320103747.7kcfdu4yzof6bwxw@unicorn.suse.cz>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <37830d46-762b-2a92-4506-5792a65d2ebd@candelatech.com> (sfid-20180320_163946_668037_E0BA11C9)
Date: Tue, 20 Mar 2018 08:39:33 -0700
MIME-Version: 1.0
In-Reply-To: <20180320103747.7kcfdu4yzof6bwxw@unicorn.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2018 03:37 AM, Michal Kubecek wrote:
> On Wed, Mar 07, 2018 at 11:51:29AM -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This is similar to ETHTOOL_GSTATS, but it allows you to specify
>> a 'level'.  This level can be used by the driver to decrease the
>> amount of stats refreshed.  In particular, this helps with ath10k
>> since getting the firmware stats can be slow.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>
>> NOTE:  I know to make it upstream I would need to split the patch and
>> remove the #define for 'backporting' that I added.  But, is the
>> feature in general wanted?  If so, I'll do the patch split and
>> other tweaks that might be suggested.
>
> I'm not familiar enough with the technical background of stats
> collecting to comment on usefulness and desirability of this feature.
> Adding a new command just to add a numeric parameter certainly doesn't
> feel right but it's how the ioctl interface works. I take it as
> a reminder to find some time to get back to the netlink interface.
>
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>> index 674b6c9..d3b709f 100644
>> --- a/net/core/ethtool.c
>> +++ b/net/core/ethtool.c
>> @@ -1947,6 +1947,54 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
>>  	return ret;
>>  }
>>
>> +static int ethtool_get_stats2(struct net_device *dev, void __user *useraddr)
>> +{
>> +	struct ethtool_stats stats;
>> +	const struct ethtool_ops *ops = dev->ethtool_ops;
>> +	u64 *data;
>> +	int ret, n_stats;
>> +	u32 stats_level = 0;
>> +
>> +	if (!ops->get_ethtool_stats2 || !ops->get_sset_count)
>> +		return -EOPNOTSUPP;
>> +
>> +	n_stats = ops->get_sset_count(dev, ETH_SS_STATS);
>> +	if (n_stats < 0)
>> +		return n_stats;
>> +	if (n_stats > S32_MAX / sizeof(u64))
>> +		return -ENOMEM;
>> +	WARN_ON_ONCE(!n_stats);
>> +	if (copy_from_user(&stats, useraddr, sizeof(stats)))
>> +		return -EFAULT;
>> +
>> +	/* User can specify the level of stats to query.  How the
>> +	 * level value is used is up to the driver, but in general,
>> +	 * 0 means 'all', 1 means least, and higher means more.
>> +	 * The idea is that some stats may be expensive to query, so user
>> +	 * space could just ask for the cheap ones...
>> +	 */
>> +	stats_level = stats.n_stats;
>> +
>> +	stats.n_stats = n_stats;
>> +	data = vzalloc(n_stats * sizeof(u64));
>> +	if (n_stats && !data)
>> +		return -ENOMEM;
>> +
>> +	ops->get_ethtool_stats2(dev, &stats, data, stats_level);
>> +
>> +	ret = -EFAULT;
>> +	if (copy_to_user(useraddr, &stats, sizeof(stats)))
>> +		goto out;
>> +	useraddr += sizeof(stats);
>> +	if (n_stats && copy_to_user(useraddr, data, n_stats * sizeof(u64)))
>> +		goto out;
>> +	ret = 0;
>> +
>> + out:
>> +	vfree(data);
>> +	return ret;
>> +}
>> +
>>  static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
>>  {
>>  	struct ethtool_stats stats;
>
> IMHO it would be more practical to set "0 means same as GSTATS" as a
> rule and make ethtool_get_stats() a wrapper for ethtool_get_stats2() to
> avoid code duplication (or perhaps a use fall-through in the switch). It
> would also allow drivers to provide only one of the callbacks.

Yes, but that would require changing all drivers at once, and would make backporting
and out-of-tree drivers harder to manage.  I had low hopes that this feature would
make it upstream, so I didn't want to propose any large changes up front.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
