Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYIHHwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 03:52:53 -0400
Date: Sun, 7 Sep 2008 22:31:55 -0700
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <20080908053155.GI4099@kroah.com> (sfid-20080908_095307_802271_57036949)
References: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net> <200809070040.04300.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809070040.04300.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 07, 2008 at 12:40:04AM +0200, Michael Buesch wrote:
> On Saturday 06 September 2008 23:51:22 Larry Finger wrote:
> > A coding error present since b43legacy was incorporated into the
> > kernel has prevented the driver from using the rate-setting mechanism
> > of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Stable <stable@kernel.org>		[2.6.26], [2.6.25]
> 
> Reviewed-by: Michael Buesch <mb@bu3sch.de>
> 
> > ---
> > 
> > John,
> > 
> > This is a bug, not a regression. I guess under the new rules that it
> > is 2.6.28 material.
> 
> I wonder what the -stable rules are.

Bug fixes, not new features, it's pretty simple :)

> It seems really screwed to me to avoid applying the fix to 2.6.27,
> but still apply it to 2.6.25/26-stable.

I have to wait until it is in upstream before adding it to the -stable
tree, so this will not happen.

> I'd like to see this patch in .25, .26 and .27, however I'm not sure
> what the rules are.
> 
> For reference:
> Three people agree on the correctness of the patch, it's a oneliner
> and it's tested to fix the bug. However it is not a regression. The
> bug is in there since day-0 of b43legacy. But this fix improves
> TX rates a lot.

If it goes into .27, please forward it on to stable@kernel.org so we can
include it in older releases.

thanks,

greg k-h
