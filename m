Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:41209 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0BVKgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 05:36:42 -0500
Subject: Re: [PATCH 15/22] wl1271: Aggregate RX acknowledgements to FW
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1266827747.5154.1.camel@jlt3.sipsolutions.net>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1266820722-20202-16-git-send-email-juuso.oikarinen@nokia.com>
	 <1266827747.5154.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 12:33:40 +0200
Message-ID: <1266834820.10120.163.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-22 at 09:35 +0100, ext Johannes Berg wrote:
> On Mon, 2010-02-22 at 08:38 +0200, Juuso Oikarinen wrote:
> 
> > 		wl->rx_counter++;
> >  		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
> > -		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
> >  	}
> > +
> > +	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
> >  }
> 
> What if the counter overflows and you got the & to change it?
> 
> johannes
> 

The rx_counter itself is never changed with & - it's just incremented
for each frame. It's supposed to overflow when the u32 is full - it will
then still behave sane when a delta is calculated inside the firmware
against its corresponding counter. That's a very common way to handle
counters for this particular chipset.

Did I miss the point?

-Juuso


