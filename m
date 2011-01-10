Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm27-vm1.bullet.mail.ne1.yahoo.com ([98.138.90.59]:21260 "HELO
	nm27-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754554Ab1AJXgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 18:36:35 -0500
Message-ID: <20383.38500.qm@web120217.mail.ne1.yahoo.com>
References: <20101201211128.GC16125@vigoh> <907295.15255.qm@web120203.mail.ne1.yahoo.com> <201101102339.39965.chunkeey@googlemail.com>
Date: Mon, 10 Jan 2011 15:36:33 -0800 (PST)
From: Chris Pechard <chrispechard@yahoo.com>
Subject: Re: carl9170: RX and TX interrupt callback ?
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201101102339.39965.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the pointers, I will definitively contact the people you listed.

Chris.



----- Original Message ----
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris Pechard <chrispechard@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Sent: Mon, January 10, 2011 2:39:39 PM
Subject: Re: carl9170: RX and TX interrupt callback ?

On Monday 10 January 2011 22:24:18 Chris Pechard wrote:
> I am trying to do time measurement using carl9170 firmware side. There was some 
>
> interesting previous thread about clock to be used and location of the probe in 
>
> the code. My goal is to get a precise time from the moment a packet has been 
> transmitted (timestamp when the packet has been transmitted) and the arrival of 
>
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
[CP]: :-) I am measuring the delta between when a packet has left the wireless 
interface and the time the next packet is received on the interface. This timing 
is much less forgiving than measuring the time when a packet is sent to the TX 
queue and TXC or RXC has occurred ( the time difference could be more than 
double due to firmware latency, 802.11 medium access and packet transmit time). 
That's the reason I am interested in fast TXC notification which would 
eliminates some of the random delays.

> My current workaround is to add many check to AR9170_MAC_REG_INT_CTRL in the 
> main loop to reduce the detection latency which at least gave me better results 
>
> (TXC time < RXC time ) but somehow it does not seem AR9170_MAC_REG_INT_CTRL 
> register is refreshed right away when a packet is received or transmitted. I 
> would like to know if there is any way to attach a callback function  to the 
>RXC 
>
> or TXC interrupt so that we get immediate notification  instead of depending on 
>
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



      
