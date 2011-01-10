Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:62918 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1AJWj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 17:39:58 -0500
Received: by fxm14 with SMTP id 14so5890960fxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 14:39:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris Pechard <chrispechard@yahoo.com>
Subject: Re: carl9170: RX and TX interrupt callback ?
Date: Mon, 10 Jan 2011 23:39:39 +0100
Cc: linux-wireless@vger.kernel.org
References: <20101201211128.GC16125@vigoh> <907295.15255.qm@web120203.mail.ne1.yahoo.com>
In-Reply-To: <907295.15255.qm@web120203.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101102339.39965.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 January 2011 22:24:18 Chris Pechard wrote:
> I am trying to do time measurement using carl9170 firmware side. There was some 
> interesting previous thread about clock to be used and location of the probe in 
> the code. My goal is to get a precise time from the moment a packet has been 
> transmitted (timestamp when the packet has been transmitted) and the arrival of 
> the next received packet (time when a packet has been fully received). Looking 
> though the code, there is a loop in src/main.c handling the TX/RX interrupt by 
> reading the AR9170_MAC_REG_INT_CTRL register and checking the 
> AR9170_MAC_INT_TXC/RXC bits. Pending on task to be performed in the loop, it 
> could take tens of microseconds to go through one iteration which affects the 
> measurement and resulting in having RXC timestamp smaller than TXC timestamp 
> which is clearly an issue!
are you sure, you put the right code in the right place :-D .
I've posted code for the same idea a while ago [on this mailing-list] and I
can't remember anything that weird.
 
> My current workaround is to add many check to AR9170_MAC_REG_INT_CTRL in the 
> main loop to reduce the detection latency which at least gave me better results 
> (TXC time < RXC time ) but somehow it does not seem AR9170_MAC_REG_INT_CTRL 
> register is refreshed right away when a packet is received or transmitted. I 
> would like to know if there is any way to attach a callback function  to the RXC 
> or TXC interrupt so that we get immediate notification  instead of depending on 
> a polling method.
Oh it is, or it should be easy to get an interrupt event from the MAC processor.
You just have to look through the SH2 platform docs [which are freely available
from Reneas] and setup the interrupt controller accordingly.

If you're stuck and need advice on the f/irq topic, you should definitely ask
Stephen Chen <Stephen.Chen@atheros.com> for assistance. As he's one of the
few persons who know how it works. I certainly can't...

Good Luck!
> If not, is there any way to minimize delays between the time 
> a packet is sent/received and the TXC/RXC bit flag raised in the register?
Don't forget the 802.11 is working against you.
CSMA/CA with R/S/D/P/E/IFS, [random] backoff, dynamic ACK delays and 
so much more can really spoil the day, if you are not aware that it's
there. 

Furthermore, have you tried to contact the people behind similar projects?
	Ignacy Gawedzki <i@lri.fr>
	David H. Lynch Jr. <dhlii@dlasys.net>

Especially David, since it seems that he's done with it.

Best Regards,
	Chr

PS.: you could also go a different route with OpenFWWF.
