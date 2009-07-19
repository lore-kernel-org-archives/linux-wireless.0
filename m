Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:45500 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbZGSOgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 10:36:49 -0400
Message-ID: <4A632F9C.8080207@lwfinger.net>
Date: Sun, 19 Jul 2009 09:37:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111) with
 p54usb
References: <4A611FC0.9040507@lwfinger.net> <4A61E436.9060808@lwfinger.net> <b6c5339f0907181419h28b84166s72ba9386f2833c61@mail.gmail.com> <200907190032.58156.chunkeey@web.de>
In-Reply-To: <200907190032.58156.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> well, ieee80211_sta_monitor_work - which probes the AP every now and then -
> didn't check if we're scanning.
> The attached diff survives a non-stop scanning without throwing the WARN in
> rate_lowest_index once.
> 
> However, I'm not so sure about the locking for hw_scanning and sw_scanning.
> It looks like only scan.c manipulates them under the scan mutex.
> But then, do we need locking for a single threaded workqueue? guess not.
> ---
> Larry,
> 
> here's another _fix_ which might even fix the problem after all ;-)
> 
> Regards,
> 	Chr
> ---
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 18dad22..4833e7c 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2210,6 +2210,9 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
>  		container_of(work, struct ieee80211_sub_if_data,
>  			     u.mgd.monitor_work);
>  
> +	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
> +		return;
> +
>  	ieee80211_mgd_probe_ap(sdata, false);
>  }

Yes - this patch gets rid of the warnings.

Thanks,

Larry

