Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61442 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0FCWtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 18:49:14 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 03 Jun 2010 15:49:14 -0700
Date: Thu, 3 Jun 2010 15:49:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [PATCH] ath5k: drop warning on jumbo frames
Message-ID: <20100603224912.GK2318@tux>
References: <1273519587-25740-1-git-send-email-lrodriguez@atheros.com>
 <20100603220947.GA22595@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100603220947.GA22595@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 03, 2010 at 03:09:47PM -0700, Greg KH wrote:
> On Mon, May 10, 2010 at 03:26:27PM -0400, Luis R. Rodriguez wrote:
> > Jumbo frames are not supported, and if they are seen it is likely
> > a bogus frame so just silently discard them instead of warning on
> > them all time. Also, instead of dropping them immediately though
> > move the check *after* we check for all sort of frame errors. This
> > should enable us to discard these frames if the hardware picks
> > other bogus items first. Lets see if we still get those jumbo
> > counters increasing still with this.
> > 
> > Jumbo frames would happen if we tell hardware we can support
> > a small 802.11 chunks of DMA'd frame, hardware would split RX'd
> > frames into parts and we'd have to reconstruct them in software.
> > This is done with USB due to the bulk size but with ath5k we
> > already provide a good limit to hardware and this should not be
> > happening.
> > 
> > This is reported quite often and if it fills the logs then this
> > needs to be addressed and to avoid spurious reports.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath5k/base.c |   12 ++++++------
> 
> This is now upstream, but doesn't seem to apply to any of the .32, .33,
> or .34 trees.  If you want it there, please send me a backported version
> of it.

Thanks Greg. I cannot address this right now so I've stashed it here:

http://wireless.kernel.org/en/developers/stable-pending

If anyone has free time please feel free to address the backport and
any other listed above (just one more).

  Luis
