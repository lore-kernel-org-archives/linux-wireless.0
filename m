Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48200 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0AJNfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 08:35:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mac80211: flush workqueue before calling driver ->stop() method
Date: Sun, 10 Jan 2010 14:35:24 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <20100110130752.GG1735@mail.wantstofly.org>
In-Reply-To: <20100110130752.GG1735@mail.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201001101435.26235.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 January 2010 14:07:53 Lennert Buytenhek wrote:
> Since commit "mwl8k: handle station database update for AP's sta entry
> via ->sta_notify()", mwl8k every now and then gets a command timeout
> when ifconfig'ing a STA interface down.  This turns out to be due to
> mwl8k_stop() being called while the work queue item that was scheduled
> by mwl8k_sta_notify() to remove the STA entry for the associated AP is
> still queued, and the former disables interrupts so that when the
> latter eventually runs, a command completion interrupt is never seen.
> 
> Fix this by changing ieee80211_stop_device() so that the workqueue is
> flushed before drv_stop() is called, instead of doing it the other way
> around as is done now.  (As ->stop() is allowed to sleep, there isn't
> any reason for drivers to queue work from within it.)

This smells like we should either:
o Add an assertion that checks whether the driver queued work although it was forbidden.
or
o Call flush_workqueue twice. Once before and once after drv_stop.

> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index bc73904..04680ca 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1077,9 +1077,9 @@ void ieee80211_stop_device(struct ieee80211_local *local)
>  	ieee80211_led_radio(local, false);
>  
>  	cancel_work_sync(&local->reconfig_filter);
> -	drv_stop(local);
>  
>  	flush_workqueue(local->workqueue);
> +	drv_stop(local);
>  }
>  
>  int ieee80211_reconfig(struct ieee80211_local *local)

-- 
Greetings, Michael.
