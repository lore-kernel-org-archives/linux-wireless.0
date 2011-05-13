Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab1EMRj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 13:39:28 -0400
Subject: Re: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110513171849.GA2760@vmraj-lnx.users.atheros.com>
References: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
	 <1305221121.3461.32.camel@jlt3.sipsolutions.net>
	 <20110513053533.GA20459@vmraj-lnx.users.atheros.com>
	 <1305301416.3468.9.camel@jlt3.sipsolutions.net>
	 <20110513171849.GA2760@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 19:39:23 +0200
Message-ID: <1305308363.3468.18.camel@jlt3.sipsolutions.net> (sfid-20110513_193931_983318_B57469AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 22:48 +0530, Rajkumar Manoharan wrote:

> These unneccesary driver calls has to be avoided. How about the following
> change to abort scan during scan loop.
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 4054399..9d18c43 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -384,11 +384,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>         int i;
>         enum nl80211_channel_type orig_ct;
>  
> +       clear_bit(SDATA_STATE_RUNNING, &sdata->state);
> +
>         if (local->scan_sdata == sdata)
>                 ieee80211_scan_cancel(local);
>  
> -       clear_bit(SDATA_STATE_RUNNING, &sdata->state);
> -
>         /*
>          * Stop TX on this interface first.
>          */
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index ea44a8e..6353f93 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -719,6 +719,11 @@ void ieee80211_scan_work(struct work_struct *work)
>          * without scheduling a new work
>          */
>         do {
> +               if (!test_bit(SDATA_STATE_RUNNING, &sdata->state)) {
> +                       aborted = true;
> +                       goto out_complete;
> +               }
> +

Seems reasonable, but you should use ieee80211_sdata_running().

johannes

