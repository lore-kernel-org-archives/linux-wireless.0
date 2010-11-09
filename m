Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51813 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0KIVaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:30:00 -0500
Date: Tue, 9 Nov 2010 16:24:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Blaise Gassend <blaise@willowgarage.com>
Cc: linville@redhat.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211_hwsim: Incorporate txpower into rssi
Message-ID: <20101109212422.GE2374@tuxdriver.com>
References: <AANLkTi=t-rEsFKMv-V7Q3cyY6A_+LiBBYW2WbwXzg50b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=t-rEsFKMv-V7Q3cyY6A_+LiBBYW2WbwXzg50b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 28, 2010 at 02:01:24AM -0700, Blaise Gassend wrote:
> Up to now mac80211_hwsim has been reporting an rssi of -50. This patch
> improves the model slightly by returning txpower-50. This makes it
> easy to stimulate tests that need to see a varying rssi.
> 
> Signed-off-by: Blaise Gassend <blaise@willowgarage.com>

This patch seems to be whitespace-damaged.  Also, you should have a
space around the "-" operator.

Any comments on this patch from the mac80211_hwsim users?

> ---
> diff --git a/drivers/net/wireless/mac80211_hwsim.c
> b/drivers/net/wireless/mac80211
> index 7eaaa3b..3c44246 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -309,6 +309,8 @@ struct mac80211_hwsim_data {
>          */
>         u64 group;
>         struct dentry *debugfs_group;
> +
> +       int power_level;
>  };
> 
> 
> @@ -497,7 +499,7 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
>         rx_status.band = data->channel->band;
>         rx_status.rate_idx = info->control.rates[0].idx;
>         /* TODO: simulate real signal strength (and optional packet loss) */
> -       rx_status.signal = -50;
> +       rx_status.signal = data->power_level-50;
> 
>         if (data->ps != PS_DISABLED)
>                 hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> @@ -698,6 +700,7 @@ static int mac80211_hwsim_config(struct
> ieee80211_hw *hw, u32
>         data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
> 
>         data->channel = conf->channel;
> +       data->power_level = conf->power_level;
>         if (!data->started || !data->beacon_int)
>                 del_timer(&data->beacon_timer);
>         else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
