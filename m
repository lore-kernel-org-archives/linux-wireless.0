Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbG2V3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 17:29:10 -0400
Date: Wed, 29 Jul 2015 14:29:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 09/21] staging: wilc1000: #ifdef conditionals cover
 entire functions
Message-ID: <20150729212907.GA16614@kroah.com> (sfid-20150729_232914_930750_0B391831)
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
 <1438073261-28315-10-git-send-email-tony.cho@atmel.com>
 <20150729205454.GA7965@kroah.com>
 <20150729211408.GL5180@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150729211408.GL5180@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 12:14:08AM +0300, Dan Carpenter wrote:
> On Wed, Jul 29, 2015 at 01:54:54PM -0700, Greg KH wrote:
> > On Tue, Jul 28, 2015 at 05:47:28PM +0900, Tony Cho wrote:
> > >  	/**
> > >  	 *      Disable power sequencer
> > >  	 **/
> > > -	if (!sdio_read_reg(WILC_MISC, &reg)) {
> > > +	if(!sdio_read_reg(WILC_MISC, &reg)) {
> > 
> 
> I noticed this style change during my review, but I didn't comment
> because I was feeling in a happy mood and because it got fixed again in
> patch 13.  Normally, of course we don't allow people to break and then
> fix things in later patches but this was a white space issue.

What this shows is that Tony isn't syncing up properly with other
changes that have happened in the upstream tree from his tree, which is
indicitive of not doing development properly, which is why I rejected
this.  And it shouldn't be done anyway, but that's a minor issue
overall.

thanks,

greg k-h
