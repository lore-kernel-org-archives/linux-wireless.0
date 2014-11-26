Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaKZVfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 16:35:34 -0500
Date: Wed, 26 Nov 2014 22:35:31 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 3/4] cfg80211: allow usermode to query wiphy
	specific regdom
Message-ID: <20141126213531.GT25677@wotan.suse.de> (sfid-20141126_223537_338459_9493B85F)
References: <1417035388-2511-1-git-send-email-arik@wizery.com> <1417035388-2511-3-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417035388-2511-3-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:56:27PM +0200, Arik Nemtsov wrote:
> If a wiphy-idx is specified, the kernel will return the wiphy specific
> regdomain, if such exists. Otherwise return the global regdom.
> 
> When no wiphy-idx is specified, return the global regdomain as well as
> all wiphy-specific regulatory domains in the system, via a new nested
> list of attributes.

Very sexy.

> Add a new attribute for each wiphy-specific regdomain, for usermode to
> identify it as such.

I think I found a couple of minor issues.

> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> ---
> Rest assured, I have an iw version that prints all the regdomains. I just
> need a bit of time to clean it up.
> 
>  include/uapi/linux/nl80211.h |  16 +++++-
>  net/wireless/nl80211.c       | 123 +++++++++++++++++++++++++++++++++----------
>  net/wireless/reg.c           |   2 +-
>  net/wireless/reg.h           |   1 +
>  4 files changed, 111 insertions(+), 31 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 3771e7d..6517210 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -252,7 +252,9 @@
>   *	%NL80211_ATTR_IFINDEX.
>   *
>   * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
> - * 	regulatory domain.
> + *	regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
> + *	its private regulatory domain will be returned.
> + *	returned, even if it's regulatory is not self-managed.

This is all jumbled up.

> +static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	const struct ieee80211_regdomain *regdom = NULL;
> +	struct cfg80211_registered_device *rdev;
> +	struct wiphy *wiphy;
> +	struct sk_buff *msg;
> +	struct nlattr *nl_priv_regdoms, *nl_priv_regdom;
> +	void *hdr = NULL;
> +	int i;
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOBUFS;
> +
> +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> +			     NL80211_CMD_GET_REG);
> +	if (!hdr)
> +		goto put_failure;
> +
> +	if (info->attrs[NL80211_ATTR_WIPHY]) {
> +		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
> +		if (IS_ERR(rdev)) {
> +			nlmsg_free(msg);
> +			return PTR_ERR(rdev);
> +		}
> +
> +		wiphy = &rdev->wiphy;
> +		regdom = get_wiphy_regdom(wiphy);
> +		if (regdom &&
> +		    nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
> +			goto nla_put_failure;
> +	}

If the wiphy was used as part of the query aren't we still sending
all the data?

> +
> +	if (!regdom) {
> +		if (!cfg80211_regdomain) {
> +			nlmsg_free(msg);
> +			return -EINVAL;
> +		}
> +
> +		if (reg_last_request_cell_base() &&
> +		    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
> +				NL80211_USER_REG_HINT_CELL_BASE))
> +			goto nla_put_failure;
> +	}
> +
> +	rcu_read_lock();
> +
> +	if (!regdom)
> +		regdom = rcu_dereference(cfg80211_regdomain);
> +
> +	if (nl80211_put_regdom(regdom, msg))
> +		goto nla_put_failure_rcu;
> +
> +	nl_priv_regdoms = nla_nest_start(msg, NL80211_ATTR_WIPHY_REGDOM_LIST);
> +	if (!nl_priv_regdoms)
> +		goto nla_put_failure_rcu;
> +

As I read this even if the query had a wiphy specified we'd go
on providing all the wiphys with their regd.

> +	i = 0;
> +	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +		wiphy = &rdev->wiphy;
> +		regdom = get_wiphy_regdom(wiphy);
> +		if (!regdom)
> +			continue;
> +
> +		nl_priv_regdom = nla_nest_start(msg, i);
> +		if (!nl_priv_regdom)
> +			goto nla_put_failure_rcu;
> +
> +		if (nl80211_put_regdom(regdom, msg))
> +			goto nla_put_failure_rcu;
> +
> +		if (nla_put_flag(msg, NL80211_ATTR_WIPHY_PRIV_REG))
> +			goto nla_put_failure_rcu;

We're not checking here if this was a managed wiphy or not, we
want userspace to be able to tell if a wiphy was managed or not.

  Luis
