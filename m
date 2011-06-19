Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1FSIMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 04:12:06 -0400
Subject: Re: [PATCH/Resend] mac80211: Start monitor work on restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name
In-Reply-To: <20110610150249.1483C204D2@glenhelen.mtv.corp.google.com> (sfid-20110610_170256_292222_A328F720)
References: <20110610150249.1483C204D2@glenhelen.mtv.corp.google.com>
	 (sfid-20110610_170256_292222_A328F720)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:12:04 +0200
Message-ID: <1308471124.4145.8.camel@jlt3.sipsolutions.net> (sfid-20110619_101209_580537_A51BA10D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-10 at 07:00 -0800, Paul Stewart wrote:
> Trigger connection monitor on resume from suspend.  Since we
> have been sleeping, there is reason to suspect that we might
> not still be associated.  The speed of detecting loss of
> {connection,authentication} is worth the cost of the small
> additional traffic at resume.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Paul Stewart <pstew@chromium.org>
> ---
>  net/mac80211/mlme.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d595265..c188238 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2206,6 +2206,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
>  		add_timer(&ifmgd->chswitch_timer);
>  	ieee80211_sta_reset_beacon_monitor(sdata);
>  	ieee80211_restart_sta_timer(sdata);
> +	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.monitor_work);
>  }
>  #endif
>  


