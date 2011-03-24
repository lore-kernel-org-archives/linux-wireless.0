Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1CXNhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 09:37:32 -0400
Subject: Re: [PATCH] mac80211: rename RX_FLAG_TSFT
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <greg@kroah.com>
In-Reply-To: <op.vsunv6ae3ri7v4@arend-laptop>
References: <1298469968.4122.8.camel@jlt3.sipsolutions.net>
	 <op.vsunv6ae3ri7v4@arend-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 14:37:25 +0100
Message-ID: <1300973845.26265.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> > +#if 0
> > +	/* Clearly, this is bogus -- reading the TSF now is wrong */
> >  	wlc_read_tsf(wlc, &tsf_l, &tsf_h);	/* mactime */
> >  	rx_status->mactime = tsf_h;
> >  	rx_status->mactime <<= 32;
> >  	rx_status->mactime |= tsf_l;
> > -	rx_status->flag |= RX_FLAG_TSFT;
> > +	rx_status->flag |= RX_FLAG_MACTIME_MPDU; /* clearly wrong */
> > +#endif
> 
> This piece of code has been '#if 0'-ed by you. Could you elaborate why  
> this is clearly wrong? Because of this the variables tsf_l and tsf_h are  
> not being used hence the warning.

include/net/mac80211.h:

 * @mactime: value in microseconds of the 64-bit Time Synchronization Function
 *      (TSF) timer when the first data symbol (MPDU) arrived at the hardware.


Not sure what else to say ... reading the TSF when processing the frame
in software is clearly bogus.

johannes


