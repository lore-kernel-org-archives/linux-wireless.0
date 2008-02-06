Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38763 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbYBFXkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 18:40:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH stable 1/3] b43: Fix suspend/resume
Date: Thu, 7 Feb 2008 00:39:19 +0100
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
References: <200801251211.45980.mb@bu3sch.de> <20080206231431.GC12395@kroah.com>
In-Reply-To: <20080206231431.GC12395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802070039.19914.mb@bu3sch.de> (sfid-20080206_234009_915272_0F8A695E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 February 2008 00:14:31 Greg KH wrote:
> On Fri, Jan 25, 2008 at 12:11:45PM +0100, Michael Buesch wrote:
> > This patch makes suspend/resume work with the b43 driver.
> > We must not overwrite the MAC addresses in the init function, as this
> > would also overwrite the MAC on resume. With an all-zero MAC the device
> > firmware is not able to ACK any received packets anymore.
> > Fix this by moving the initializion stuff that must be done on init but
> > not on resume to the start function.
> > Also zero out filter_flags to make sure we don't have some flags
> > from a previous instance for a tiny timeframe until mac80211 reconfigures
> > them.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > This patch is upstream inside of the netdev tree.
> 
> Was this series, and the other one, for .24-stable, or .23-stable?

This was for .24 stable.
.23 stable didn't have the driver, yet.

-- 
Greetings Michael.
