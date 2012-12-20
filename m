Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33119 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2LTJDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 04:03:25 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so1790789wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 01:03:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355881021-7071-1-git-send-email-thomas@cozybit.com>
References: <1355881021-7071-1-git-send-email-thomas@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 20 Dec 2012 01:03:03 -0800
Message-ID: <CAG6hwVPQdBg4aLdJf6eD4kS40s3WcMcux8639sfYjSuJ85y9nw@mail.gmail.com> (sfid-20121220_100328_264614_DE911700)
Subject: Re: [PATCH 1/3] mac80211_hwsim: use hrtimer for beacon timers
To: linville@tuxdriver.com
Cc: j@wl.fi, jlopex@cozybit.com, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 18, 2012 at 5:36 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> For testing various timing-sensitive protocols (power
> save, etc.), a beacon accuracy of jiffies is not
> sufficient.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |   63 ++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index ff90855..0a8f37e 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -333,11 +333,11 @@ struct mac80211_hwsim_data {
>         int scan_chan_idx;
>
>         struct ieee80211_channel *channel;
> -       unsigned long beacon_int; /* in jiffies unit */
> +       ktime_t beacon_int;
>         unsigned int rx_filter;
>         bool started, idle, scanning;
>         struct mutex mutex;
> -       struct timer_list beacon_timer;
> +       struct hrtimer beacon_timer;
>         enum ps_mode {
>                 PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
>         } ps;
> @@ -358,6 +358,7 @@ struct mac80211_hwsim_data {
>
>         /* difference between this hw's clock and the real clock, in usecs */
>         u64 tsf_offset;
> +       struct tasklet_struct bcn_tasklet;
>  };
>
>
> @@ -896,7 +897,8 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
>  {
>         struct mac80211_hwsim_data *data = hw->priv;
>         data->started = false;
> -       del_timer(&data->beacon_timer);
> +       hrtimer_cancel(&data->beacon_timer);
> +       tasklet_disable(&data->bcn_tasklet);

*sigh*, we should use tasklet_kill() here though. Will send a v2 to fix this.

Thomas
