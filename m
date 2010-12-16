Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0LPG7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 01:59:38 -0500
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
In-Reply-To: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 07:59:35 +0100
Message-ID: <1292482775.3542.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 10:54 -0800, Paul Stewart wrote:
> Sometimes mac80211 doesn't push idle state downwards to the
> driver.  Specifically, there are times in some functions where
> the "local->hw.conf.flags & IEEE80211_CONF_IDLE" may change but
> the equivalent of "drv_config(local, IEEE80211_CONF_CHANGE_IDLE)"
> does not end up being called.  This is usually not all that
> problematic except, for example, suspending and resuming an idle
> ath9k device.  If the device isn't marked idle when
> ieee80211_stop_device() is called, the device never gets put to
> sleep, and will end up in an unresponsive state on resume.

I thought this was solved in ath9k differently? Was that somehow
inadequate?

> As a precaution, explicitly call drv_config() before
> ieee80211_stop_device(), which should be a no-op under normal
> circumstances, but where this problem arises, it will shut down
> the ath9k where necessary.

I'm not convinced that this makes a lot of sense. I'm sure you can come
up with other scenarios in which we stop a device and expect it to come
back. I'm not sure why mac80211 should be responsible for all this?

> One example where this problem occurs is when I down an interface
> while a scan is in progress on ath9k.  If the device was not shut
> down correctly and the system suspends and resumes repeatedly with
> ath9k, I end up with a fatal register read error (0x7000/deadbeef)
> when trying to bring the interface back up.
> 
> Signed-off-by: Paul Stewart <pstew@google.com>
> ---
>  net/mac80211/iface.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index b6db237..5af5a89 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -536,6 +536,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		if (local->ops->napi_poll)
>  			napi_disable(&local->napi);
>  		ieee80211_clear_tx_pending(local);
> +		drv_config(local, IEEE80211_CONF_CHANGE_IDLE);
>  		ieee80211_stop_device(local);
>  
>  		/* no reconfiguring after stop! */

I don't like this anyway -- you're calling a driver callback directly,
and there's no guarantee that just that particular change will be used
by the driver -- it's free to look at other state given to it in each
callback as well. That seems problematic because of all the other logic
that we have in ieee80211_hw_config().

At the very least I think you need to provide a better rationale for
this patch and explain why the ath9k change isn't sufficient?

johannes

