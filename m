Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:37298 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0GMOF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 10:05:27 -0400
Message-ID: <4C3C7296.3070700@bu3sch.de>
Date: Tue, 13 Jul 2010 16:05:10 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Simon Richter <sjr@debian.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de> <1278887148.6139.91.camel@localhost> <4C3A4C6E.6060801@lwfinger.net> <20100713051430.GA2625@honey.hogyros.de> <4C3BFB87.5030907@lwfinger.net> <20100713073751.GB3089@richter> <4C3C6350.50304@bu3sch.de> <20100713130614.GB25565@richter> (sfid-20100713_150638_259090_128768E3)
In-Reply-To: <20100713130614.GB25565@richter> (sfid-20100713_150638_259090_128768E3)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2010 03:06 PM, Simon Richter wrote:
> Hi,
>
> On Tue, Jul 13, 2010 at 03:00:00PM +0200, Michael Büsch wrote:
>
>> But I wanna say again that this all is expected behavior. The PIO
>> fallback workaround randomly drops packets when switching modes.
>> So it is expected that certain handshaking packages may be lost.
>
> So if the handshake to join a MC group is lost for whatever reason, it
> is lost forever, or is that just in the "shit happened, reset
> everything" code path?

It's not entirely possible to answer that question from a b43 point of view.
What happens in b43 is:
It tries to transmit through DMA. If that fails, it drops all queued
packets (but does not tell any upper layer about that) and resets the
hardware to PIO mode and waits for further work.
So it is up to the upper layer to detect the failure. I don't think
it's possible to automatically detect such incidents for multicast
transmissions. So the mechanism fails here.

>>> I was also having some suspend related issues, I'm going to give it a
>>> few days now to see whether they also disappear now.
>
>> Please open a new bug for this. Thanks.
>
> If they keep appearing; this may also be related to lost packets.

I'm pretty sure that any suspend issue is not related to the PIO
fallback mechanism.

-- 
Greetings Michael.
