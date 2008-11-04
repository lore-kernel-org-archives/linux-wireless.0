Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59560 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYKDA2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 19:28:32 -0500
Subject: Re: Guidelines regarding separate directory
From: Pavel Roskin <proski@gnu.org>
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <490B5736.10508@gmail.com>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com>  <1225399481.7931.5.camel@dv>
	 <1225399682.3690.82.camel@johannes.berg>  <490B3AAC.1000803@gmail.com>
	 <1225474867.23627.4.camel@dv>  <490B5736.10508@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 19:28:29 -0500
Message-Id: <1225758509.13275.9.camel@dv> (sfid-20081104_012835_004627_349250CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-31 at 15:06 -0400, Richard Farina wrote:

> Last I checked, the orinoco_cs driver couldn't even put a prism2 card in 
> monitor mode.

It must have been some really obsolete driver.  I cannot reproduce this
problem with the current code.

>   I just tried it again and that is working, but the 
> channel hopping control doesn't seem to work properly at all. As an 
> example, airodump-ng cannot hop channels (which I'm reporting to the 
> aircrack-ng team next).

I'm not going to install that software, but I have no problem changing
channel in monitor mode with iwconfig.

>   I know that the idea of having one driver for 
> the two devices may seem like a good idea, but I've always been against 
> it because in fact the orinoco cards were a poor implementation of a 
> modified prism2 reference implementation.  I mean no disrespect to the 
> orinoco driver team (yes Pavel, I see your name on it) but the driver 
> simply is not nearly as mature as the hostap drivers.  The additional 
> functionality of the hostap drivers such as master mode, monitor mode 
> headers, and firmware loading (both flash and ram) make is an excellent 
> choice to be maintained at least in the foreseeable future.

I don't expect master mode to be implemented in orinoco, but the
radiotap headers should not be hard to add.  In fact, the hard part
would be not coding but negative feedback from users with various badly
written hacking tools that don't expect the radiotap header to be
present.

> That said, if there is anyone with some interest in fixing the monitor 
> mode inject which was broken in kernel 2.6.21 I would be happy to 
> provide you with everything I know if you can help (I have a lot of 
> documentation and the existing patch sets).  Sadly, my coding skills 
> only let me work on very minor things.

I'm not interested in coding it myself, but I'm would not object if
somebody provides a patch.

-- 
Regards,
Pavel Roskin
