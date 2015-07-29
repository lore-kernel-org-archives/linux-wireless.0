Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43490 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbG2VPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 17:15:05 -0400
Date: Thu, 30 Jul 2015 00:14:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 09/21] staging: wilc1000: #ifdef conditionals cover
 entire functions
Message-ID: <20150729211408.GL5180@mwanda> (sfid-20150729_231510_893469_B4302A28)
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
 <1438073261-28315-10-git-send-email-tony.cho@atmel.com>
 <20150729205454.GA7965@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150729205454.GA7965@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 01:54:54PM -0700, Greg KH wrote:
> On Tue, Jul 28, 2015 at 05:47:28PM +0900, Tony Cho wrote:
> >  	/**
> >  	 *      Disable power sequencer
> >  	 **/
> > -	if (!sdio_read_reg(WILC_MISC, &reg)) {
> > +	if(!sdio_read_reg(WILC_MISC, &reg)) {
> 

I noticed this style change during my review, but I didn't comment
because I was feeling in a happy mood and because it got fixed again in
patch 13.  Normally, of course we don't allow people to break and then
fix things in later patches but this was a white space issue.

It's sometimes hard to know how strict to be.  I knowingly allowed far
worse things in that series of 150 unisys patches which was probably
a mistake in retrospect.

regards,
dan carpenter

