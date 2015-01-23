Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:37975 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbAWRla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:41:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: b43: stop leds during suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421678072-28997-1-git-send-email-sd@queasysnail.net>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Sabrina Dubroca <sd@queasysnail.net>
Message-Id: <20150123174129.CB09914180B@smtp.codeaurora.org> (sfid-20150123_184134_948299_C404A514)
Date: Fri, 23 Jan 2015 17:41:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Call b43_leds_stop during suspend to avoid this WARN:
> 
> WARNING: CPU: 1 PID: 0 at net/mac80211/util.c:755 ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]()
> queueing ieee80211 work while going to suspend
> 
>  [...]
> 
> Call Trace:
>  [<c165fb2a>] dump_stack+0x48/0x69
>  [<c1052f7b>] warn_slowpath_common+0x8b/0xc0
>  [<f9c30225>] ? ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]
>  [<f9c30225>] ? ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]
>  [<c1052fe3>] warn_slowpath_fmt+0x33/0x40
>  [<f9c30225>] ieee80211_can_queue_work.isra.11+0x35/0x50 [mac80211]
>  [<f9c30260>] ieee80211_queue_work+0x20/0x40 [mac80211]
>  [<f9f25d78>] b43_led_brightness_set+0x28/0x30 [b43]
>  [<c14f3835>] led_timer_function+0xd5/0xe0
>  [<c10cb534>] call_timer_fn+0xa4/0x4a0
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
