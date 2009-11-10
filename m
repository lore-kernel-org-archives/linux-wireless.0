Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60375 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbZKJQAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 11:00:13 -0500
Date: Tue, 10 Nov 2009 10:55:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luca Niccoli <lultimouomo@gmail.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: Please backport [PATCH] rtl8187: Fix kernel oops when device
	is removed when LEDS enabled (Bugzilla #14539)
Message-ID: <20091110155511.GE12682@tuxdriver.com>
References: <4e9568870911100747o6088ca86lf168849e6a42b91d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4e9568870911100747o6088ca86lf168849e6a42b91d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 04:47:50PM +0100, Luca Niccoli wrote:
> I'm running 2.6.31 (from debian source) and I experienced hard freezes
> on removing the module or disconnecting the USB card.
> The patch at [1] seems to have fixed the problem, so it would be nice
> if it could be included in the 2.6.31 branch.
> Note that I was not experiencing the freezes with the distribution
> kernel, just with a self compiled one (without source modifications
> though, only config).
> Cheers,
> 
> Luca
> 
> (For further info please Cc: me)
> 
> [1]
> http://marc.info/?l=linux-wireless&m=125731443329754&w=2

This has already been sent with the proper tagging to make the stable
crew aware of it...

Thanks,

John

commit 37b12dd2b07b4d7dc222a5f7f88b25cec532b2aa
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Wed Nov 4 00:00:25 2009 -0600

    rtl8187: Fix kernel oops when device is removed when LEDS enabled
    
    As reported by Rick Farina (sidhayn@gmail.com), removing the RTL8187
    USB stick, or unloading the driver rtl8187 using rmmod will cause a
    kernel oops.  There are at least two forms of the failure, (1) BUG:
    Scheduling while atomic, and (2) a fatal kernel page fault. This
    problem is reported in Bugzilla #14539.
    
    This problem does not occur for kernel 2.6.31, but does for 2.6.32-rc2,
    thus it is technically a regression; however, bisection did not locate
    any faulty patch. The fix was found by comparing the faulty code in
    rtl8187 with p54usb.  My interpretation is that the handling of work
    queues in mac80211 changed enough to the LEDs to be unregistered
    before tasks on the work queues are cancelled. Previously, these
    actions could be done in either order.
    
    (Herton Ronaldo Krzesinski <herton@mandriva.com.br> reports that the
    code is the same in 2.6.31, so this may be a candidate for 2.6.31.x.
    -- JWL)
    
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Reported-by: Rick Farina <sidhayn@gmail.com>
    Tested-by: Rick Farina <sidhayn@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
