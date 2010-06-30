Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:43881 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0F3HNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 03:13:22 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Date: Wed, 30 Jun 2010 09:15:49 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values - thanks for a fix
Message-ID: <4C2AEF25.1702.2DF7E2@jafojtik.seznam.cz>
In-reply-to: <201006281021.47132.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C26FD91.10140.F4D6B@jafojtik.seznam.cz>, <201006281021.47132.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno,

> > Anyway, when you look at the magenta line here:
> >   http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi
> > 
> > There are big drops in measured signal. Did you fix all places?
> > 
> > Before this patch there were short peeks from -78dB to -71dB.
> > After patch there are short measurement drops from -62dB to -70dB.
> > 
> > The week charting simply averages it:
> >   http://78.108.103.11:11080/cgi-bin/rodga_1week_big.cgi
> 
> i guess this must be the same situation as before, no?
Just repeat:
## Before this patch there were short peeks from -78dB to -71dB.

## After patch there are short measurement drops from -62dB to -70dB.

MadWiFi does not produce such drops.

 
> how many antennas do you have attached to your device? 
One miniPCI device has only one antenna attached. Second U.FL. connector 
is empty.


> it might be interesting to check if you get more consistent 
> signal measurements by disabling antenna 
> diversity, setting it to a fixed antenna. you can do this by using a debugfs 
> file "echo fixed-a > /sys/kernel/debug/ath5k/phy0/antenna" (or "fixed-b")...
I have found that "fixed-b" is a right connector. There is a stupid question why?
When I am using "out" and not "aux". I just guess that "out" should be 'a'
and 'aux' should be 'b'.

Please again have a look at:
  http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi
It looks like signal power jumped to -46dB.
It seems that ATH5k never switched to "fixed-b" and I has been receiving
garbage from empty U.FL. It is a miracle that it has been worked.


MadWiFi is much more intelligent. It tests both inputs and selects better one.

 
> btw: when the signal measurement was low, did you see any negative impact on 
> the thruput as well?
Nope.
 http://78.108.103.11:11080/cgi-bin/pktloss_1day_big.cgi
But the line is so overpowered that I would not notify 8dB drop.

regards
   Jara

 
> bruno


