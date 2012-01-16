Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2APQvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 11:51:35 -0500
Subject: Re: [RFC] mac80211: Fix possible race between sta_unblock and
 network softirq
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1326728542-31697-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120116_164310_103029_9A53761B)
References: <1326728542-31697-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20120116_164310_103029_9A53761B)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 17:51:33 +0100
Message-ID: <1326732693.3510.21.camel@jlt3.sipsolutions.net> (sfid-20120116_175138_802879_09C3B180)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-16 at 16:42 +0100, Helmut Schaa wrote:
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> I'm currently writing some code for rt2800 that requires the driver
> to stop sending to a specific station for a short period of time
> (until all AMPDUs are finished to work around a hw issue that affects
> rate sampling with minstrel_ht). I decided to give
> ieee80211_sta_block_awake a try, however, the machine sometimes locked
> up while running some performance tests but due to a hw watchdog I
> wasn't able to get any sort of backtrace :(
> 
> So, while doing some review of the ieee80211_sta_block_awake I came
> across this and wondered if softirqs should be disabled when delivering
> the buffered frames in sta_unblock.
> 
> Using this patch I cannot reproduce the lockup anymore.
> 
> So, is there any special reason this single code path in sta_unblock
> doesn't disable softirqs?

This seems right -- not sure where the lockup would be though.

johannes

> Thanks,
> Helmut
> 
>  net/mac80211/sta_info.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 24d321f..5b4ab21 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -238,9 +238,11 @@ static void sta_unblock(struct work_struct *wk)
>  	if (sta->dead)
>  		return;
>  
> -	if (!test_sta_flag(sta, WLAN_STA_PS_STA))
> +	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
> +		local_bh_disable();
>  		ieee80211_sta_ps_deliver_wakeup(sta);
> -	else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL)) {
> +		local_bh_enable();
> +	} else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL)) {
>  		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
>  
>  		local_bh_disable();


