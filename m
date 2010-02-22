Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BVKox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 05:44:53 -0500
Subject: Re: [PATCH 15/22] wl1271: Aggregate RX acknowledgements to FW
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1266834820.10120.163.camel@wimaxnb.nmp.nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1266820722-20202-16-git-send-email-juuso.oikarinen@nokia.com>
	 <1266827747.5154.1.camel@jlt3.sipsolutions.net>
	 <1266834820.10120.163.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 11:44:47 +0100
Message-ID: <1266835487.5609.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-22 at 12:33 +0200, Juuso Oikarinen wrote:

> > > 		wl->rx_counter++;
> > >  		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
> > > -		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
> > >  	}
> > > +
> > > +	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
> > >  }
> > 
> > What if the counter overflows and you got the & to change it?
> > 
> > johannes
> > 
> 
> The rx_counter itself is never changed with & - it's just incremented
> for each frame. It's supposed to overflow when the u32 is full - it
> will
> then still behave sane when a delta is calculated inside the firmware
> against its corresponding counter. That's a very common way to handle
> counters for this particular chipset.

Ok.

> Did I miss the point?

No ... I did. I thought the second quoted line was the same counter,
didn't see it was a different variable because it looked so similar.
That and I wasn't sure the firmware would really do the right thing when
an overflow happened since it looked like before it wouldn't have to :)

johannes

