Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36266 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762913AbYBFXQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 18:16:29 -0500
Date: Wed, 6 Feb 2008 15:14:31 -0800
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [stable] [PATCH stable 1/3] b43: Fix suspend/resume
Message-ID: <20080206231431.GC12395@kroah.com> (sfid-20080206_231634_160248_B1EF998F)
References: <200801251211.45980.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801251211.45980.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 12:11:45PM +0100, Michael Buesch wrote:
> This patch makes suspend/resume work with the b43 driver.
> We must not overwrite the MAC addresses in the init function, as this
> would also overwrite the MAC on resume. With an all-zero MAC the device
> firmware is not able to ACK any received packets anymore.
> Fix this by moving the initializion stuff that must be done on init but
> not on resume to the start function.
> Also zero out filter_flags to make sure we don't have some flags
> from a previous instance for a tiny timeframe until mac80211 reconfigures
> them.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This patch is upstream inside of the netdev tree.

Was this series, and the other one, for .24-stable, or .23-stable?

thanks,

greg k-h
