Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59231 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2LEU0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:26:40 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so2225726wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 12:26:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354680761-32703-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1354680761-32703-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 5 Dec 2012 12:26:18 -0800
Message-ID: <CAG6hwVN3F+KY=LkrG0j8WfFczBJawTD5J4kbbsnPfSAGrX5dXA@mail.gmail.com> (sfid-20121205_212644_164725_62C52373)
Subject: Re: [RFC] mac80211_hwsim: dont modify TBTT if beacon is already enabled
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 4, 2012 at 8:12 PM, Marco Porsch
<marco.porsch@etit.tu-chemnitz.de> wrote:
> If the beacon is already enabled, do not modify the beacon timer. This causes
> a hard TBTT adjustment and may cause mischief for powersave or synchronization.j

It might be clearer if you explain this patch actually defers "TBTT"
adjustment until the next beacon.

> Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index bc763d2..abfa7e6 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -1174,7 +1174,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
>         data->power_level = conf->power_level;
>         if (!data->started || !data->beacon_int)
>                 del_timer(&data->beacon_timer);
> -       else
> +       else if (!timer_pending(&data->beacon_timer))
>                 mod_timer(&data->beacon_timer, jiffies + data->beacon_int);

There is an immediate beacon timer adjustment in
mac80211_hwsim_bss_info_changed() as well.

Thomas
