Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35953 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3IISpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:12 -0400
Date: Mon, 9 Sep 2013 14:33:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cw1200:  Don't perform SPI transfers in interrupt
 context
Message-ID: <20130909183350.GB1955@tuxdriver.com> (sfid-20130909_204518_495298_046A6B7D)
References: <1377649787-2817-1-git-send-email-pizza@shaftnet.org>
 <20130903115856.GA16844@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130903115856.GA16844@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 03, 2013 at 07:58:57AM -0400, Solomon Peachy wrote:
> On Tue, Aug 27, 2013 at 08:29:46PM -0400, Solomon Peachy wrote:
> > When we get an interrupt from the hardware, the first thing the driver does
> > is tell the device to mask off the interrupt line.  Unfortunately this
> > involves a SPI transaction in interrupt context.  Some (most?) SPI
> > controllers perform the transfer asynchronously and try to sleep.
> > This is bad, and triggers a BUG().
> 
> Did this patch series get dropped?  I saw that the followup series 
> of minor cleanups were merged into wireless-next, but not these.
> 
> Since they didn't make it into 3.11, I intend to submit them to -stable, 
> but I need to make sure they at least make it into -next.

I'll be sending them for 3.12 soon...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
