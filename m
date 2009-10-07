Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZJGTQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 15:16:45 -0400
Date: Wed, 7 Oct 2009 15:01:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
Message-ID: <20091007190106.GB22394@tuxdriver.com>
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 07, 2009 at 10:06:05AM -0500, Larry Finger wrote:
> In commit 26e5ab35b4c7b1d4cb487a11084520aed9a8d05e entitled "b43: Fix PPC
> crash in rfkill polling on unload", the call to stop polling should not have
> been placed inside the wl->mutex. The result was incorrect locking messages.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> I had not intended for the previous patch to be applied as I was waiting for
> the Bugzilla OP to test. He promised to do that today. In any case, that patch
> introduced a locking problem that needs to be fixed.
> 
> Why do the one-liners cause so many problems?
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -4501,8 +4501,8 @@ static void b43_op_stop(struct ieee80211
>  
>  	cancel_work_sync(&(wl->beacon_update_trigger));
>  
> -	mutex_lock(&wl->mutex);
>  	wiphy_rfkill_stop_polling(hw->wiphy);
> +	mutex_lock(&wl->mutex);
>  	if (b43_status(dev) >= B43_STAT_STARTED) {
>  		dev = b43_wireless_core_stop(dev);
>  		if (!dev)

OK, but why do we start polling under the lock but stop polling without
the lock?  Should we start polling without holding the lock too?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
