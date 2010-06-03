Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0FCWm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 18:42:28 -0400
Date: Thu, 3 Jun 2010 15:09:47 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Subject: Re: [stable] [PATCH] ath5k: drop warning on jumbo frames
Message-ID: <20100603220947.GA22595@kroah.com>
References: <1273519587-25740-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1273519587-25740-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 10, 2010 at 03:26:27PM -0400, Luis R. Rodriguez wrote:
> Jumbo frames are not supported, and if they are seen it is likely
> a bogus frame so just silently discard them instead of warning on
> them all time. Also, instead of dropping them immediately though
> move the check *after* we check for all sort of frame errors. This
> should enable us to discard these frames if the hardware picks
> other bogus items first. Lets see if we still get those jumbo
> counters increasing still with this.
> 
> Jumbo frames would happen if we tell hardware we can support
> a small 802.11 chunks of DMA'd frame, hardware would split RX'd
> frames into parts and we'd have to reconstruct them in software.
> This is done with USB due to the bulk size but with ath5k we
> already provide a good limit to hardware and this should not be
> happening.
> 
> This is reported quite often and if it fills the logs then this
> needs to be addressed and to avoid spurious reports.
> 
> Cc: stable@kernel.org
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   12 ++++++------

This is now upstream, but doesn't seem to apply to any of the .32, .33,
or .34 trees.  If you want it there, please send me a backported version
of it.

thanks,

greg k-h
