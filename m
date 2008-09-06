Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44379 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbYIFWlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:41:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Date: Sun, 7 Sep 2008 00:40:04 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net>
In-Reply-To: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200809070040.04300.mb@bu3sch.de> (sfid-20080907_004111_331335_39750A74)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008 23:51:22 Larry Finger wrote:
> A coding error present since b43legacy was incorporated into the
> kernel has prevented the driver from using the rate-setting mechanism
> of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>		[2.6.26], [2.6.25]

Reviewed-by: Michael Buesch <mb@bu3sch.de>

> ---
> 
> John,
> 
> This is a bug, not a regression. I guess under the new rules that it
> is 2.6.28 material.

I wonder what the -stable rules are.
It seems really screwed to me to avoid applying the fix to 2.6.27,
but still apply it to 2.6.25/26-stable.

I'd like to see this patch in .25, .26 and .27, however I'm not sure
what the rules are.

For reference:
Three people agree on the correctness of the patch, it's a oneliner
and it's tested to fix the bug. However it is not a regression. The
bug is in there since day-0 of b43legacy. But this fix improves
TX rates a lot.

> Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c
> +++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c
> @@ -624,7 +624,7 @@ void b43legacy_handle_hwtxstatus(struct
>  	tmp = hw->count;
>  	status.frame_count = (tmp >> 4);
>  	status.rts_count = (tmp & 0x0F);
> -	tmp = hw->flags;
> +	tmp = hw->flags << 1;
>  	status.supp_reason = ((tmp & 0x1C) >> 2);
>  	status.pm_indicated = !!(tmp & 0x80);
>  	status.intermediate = !!(tmp & 0x40);

-- 
Greetings Michael.
