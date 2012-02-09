Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56538 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2BIWyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 17:54:14 -0500
Received: by iacb35 with SMTP id b35so3149222iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:54:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327581484-22047-6-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-6-git-send-email-victorg@ti.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 9 Feb 2012 14:53:54 -0800
Message-ID: <CAB=NE6XL4=RJZtbf_qnyDpShk5qFrLFFxSrnaoow1F5ayhdE6A@mail.gmail.com> (sfid-20120209_235418_411892_D65ADF61)
Subject: Re: [RFC 5/9] nl80211/cfg80211: add ap channel switch command/event
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 4:38 AM, Victor Goldenshtein <victorg@ti.com> wrote:
> Add new NL80211_CMD_AP_CHANNEL_SWITCH command which
> triggers a channel switch process, this command also
> notifies usermode about channel switch complete event.
>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  include/linux/nl80211.h |   23 +++++++++++++
>  include/net/cfg80211.h  |   16 +++++++++
>  net/wireless/mlme.c     |   11 ++++++
>  net/wireless/nl80211.c  |   80 +++++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/nl80211.h  |    4 ++
>  5 files changed, 134 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index b45ceb1..8a004fc 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -551,6 +551,15 @@
>  *     radar interference is detected during this period the dfs master may
>  *     initiate the tx.
>  *
> + * @NL80211_CMD_AP_CHANNEL_SWITCH: Perform a channel switch in the driver (for
> + *     AP/GO).
> + *     %NL80211_ATTR_WIPHY_FREQ: new channel frequency.
> + *     %NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel.
> + *     %NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel.

This is left as optional. It would be good to explain why this is
option and/or why userspace would set this
NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX flag or not.

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -4072,6 +4075,39 @@ static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
>        return rdev->ops->dfs_en_tx(&rdev->wiphy, dev);
>  }
>
> +static int nl80211_ap_channel_switch(struct sk_buff *skb,
> +                                    struct genl_info *info)
> +{
> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +       struct net_device *dev = info->user_ptr[1];
> +       u32 freq = 0, count = 0, post_switch_block_tx = 0, block_tx = 0;

Please use bool for flags.

> +
> +       ASSERT_RDEV_LOCK(rdev);
> +
> +       if (!rdev->ops->ap_channel_switch)
> +               return -EOPNOTSUPP;
> +
> +       if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
> +           dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
> +               return -EOPNOTSUPP;

If we want to restrict this command from userspace to only be able to
issue a channel switch for DFS we need to consider some additional
sanity checks here. It may be worth adding a small state machine to
cfg80211 for the device and only allow certain of these commands for
specific DFS states, if these commands are to be used only on DFS
states. This would limit the stupidities that userspace can put
cfg80211 into.

  Luis
