Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3CDPKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:10:52 -0500
Message-ID: <1362409848.21028.16.camel@jlt4.sipsolutions.net> (sfid-20130304_161055_042293_6464CF82)
Subject: Re: [PATCH 4/6] nl80211: user_mpm overrides auto_open_plinks
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Mar 2013 16:10:48 +0100
In-Reply-To: <1362204172-28307-4-git-send-email-thomas@cozybit.com> (sfid-20130302_070418_378350_47836780)
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
	 <1362204172-28307-4-git-send-email-thomas@cozybit.com>
	 (sfid-20130302_070418_378350_47836780)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 22:02 -0800, Thomas Pedersen wrote:
> If the user requested a userspace MPM, automatically
> disable auto_open_plinks to fully disable the kernel MPM.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  include/uapi/linux/nl80211.h |    6 ++++--
>  net/wireless/nl80211.c       |    3 +++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 8134c6a..79da871 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2467,8 +2467,10 @@ enum nl80211_mesh_power_mode {
>   * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
>   *	point.
>   *
> - * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
> - *	open peer links when we detect compatible mesh peers.
> + * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically open
> + *	peer links when we detect compatible mesh peers. Disabled if
> + *	@NL80211_MESH_SETUP_USERSPACE_MPM or @NL80211_MESH_SETUP_USERSPACE_AMPE are
> + *	set.
>   *
>   * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
>   *	containing a PREQ that an MP can send to a particular destination (path
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index e3f2489..bd73231 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -7422,6 +7422,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
>  			return err;
>  	}
>  
> +	if (setup.user_mpm)
> +		cfg.auto_open_plinks = false;

Maybe you should reject the invalid configuration instead?

johannes

