Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38050 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYI2SjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 14:39:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
Date: Mon, 29 Sep 2008 20:38:37 +0200
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>, fback+bcm@fback.net
References: <48E11F1E.50705@lwfinger.net>
In-Reply-To: <48E11F1E.50705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809292038.37939.mb@bu3sch.de> (sfid-20080929_203910_586513_D685A99D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 September 2008 20:31:58 Larry Finger wrote:
> Michael,
> 
> I have started modifying my copy of b43 to see if I can locate any
> coding problems that might be causing the PHY transmission errors. To
> start with, I am checking all the sections that use udelay. The main
> reason is that when a bug in the CPU timer cut all delays in half, I
> got these errors in b43legacy. I also noted the report this morning
> that compiler and toolchain versions seem to be important.
> 
> One of the first places I looked was in do_dummy_tx. When I checked
> the spin-on-condition loops in this routine, I found that the 3rd
> always used the maximum number of loops and exited before the
> condition was met. I increased the number of possible loops from 10 to
> 20 and found that it always takes 17 or 18 passes for the condition to
> be met on my machine.
> 
> The existing code matches specs - I even checked the code in
> 4.150.10.5. It is too early to tell if this has anything to do with
> the errors, but I suggest the following change:
> 
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index 7205a93..af60122 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -814,7 +814,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
>  			break;
>  		udelay(10);
>  	}
> -	for (i = 0x00; i < 0x0A; i++) {
> +	for (i = 0x00; i < 0x19; i++) {
>  		value = b43_read16(dev, 0x0690);
>  		if (!(value & 0x0100))
>  			break;
> 
> Using 25 passes gives a little margin for CPUs that are much faster
> than mine. Perhaps the margin should even be bigger.


Yeah, feel free to submit this to John.
Dummy-tx _can_ for sure trigger PHY TX errors. I already saw that
in my experiments, too. It also makes sense, as dummy-tx is poking
with the lowlevel TX hardware.
So if a loop exists early it may leave TX hardware in an inconsistent state.

Actually, I do know since the very first days of bcm43xx that the
loop counts are not big enough in some of these loops. But I didn't
change it, as it was said the current counts match the specs.
However, I think it's perfectly valid to raise the values.
Please do so, thanks a lot.

-- 
Greetings Michael.
