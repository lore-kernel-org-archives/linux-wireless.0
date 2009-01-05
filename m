Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:39606 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbZAEDzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 22:55:10 -0500
Message-ID: <49618497.50809@lwfinger.net> (sfid-20090105_045514_519814_E202517F)
Date: Sun, 04 Jan 2009 21:55:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org>
In-Reply-To: <20090105025302.GF496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> 
> Same issue with this patch. It fluctuates some time between 11Mbit/s
> and 48Mbit/s, but then eventually settles on 1Mbit/s again. That's with PID
> now, not Mistrel. I think it takes longer with this patch than
> before, but not much.
> 
> BTW I see the problem with RT2561 too.

Can you retry with mistrel? In my experience, it converges to a lower rate than
does pid, but it doesn't fluctuate as much.

I'll look into RT2561.

What I generally do is start a ping in one window and enter the following line
in another:

while [ 1 ] ; do iwconfig wlan0 | grep Mb ; sleep 1 ; done

and watch the rate.

Larry

