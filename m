Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:45442 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbZCARst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 12:48:49 -0500
Received: from localhost ([127.0.0.1] helo=www.phantomjinx.co.uk)
	by vilya.visn.co.uk with esmtpa (Exim 4.69)
	(envelope-from <p.g.richardson@phantomjinx.co.uk>)
	id 1LdpmR-00058y-9S
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2009 17:48:47 +0000
Message-ID: <60836.82.152.175.172.1235929727.squirrel@www.phantomjinx.co.uk> (sfid-20090301_184853_854118_7AE391DC)
In-Reply-To: <499F4763.70106@lwfinger.net>
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
    <499B27A4.30708@lwfinger.net>
    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>
    <499B4526.1030705@lwfinger.net>
    <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>
    <499E1826.8040903@lwfinger.net>
    <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk>
    <499F4763.70106@lwfinger.net>
Date: Sun, 1 Mar 2009 17:48:47 -0000 (UTC)
Subject: rtl8187 performance diagnostics (was: rtl8187 cannot fix rate)
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm not an expert in reading these tables, but the success rates abov=
e 11
> Mb/s
> are very low, which seems to indicate that 11 Mb/s is a reasonable ra=
te
> for your
> device. There is, however, a possibility that the code is not reporti=
ng
> the
> retry count correctly. I know from your initial post that 54M doesn't
> work, but
> can you get any throughput at 24, 36, or 48M? There is also the
> possibility that
> your hardware is broken for OFDM encoding. That scheme is used for 6,=
 9,
> and all
> rates 18M and above.
>
> Larry

=46urther playing around with my rtl8187b card. I have installed window=
s
onto my laptop too for performance comparisons. Just how crude or accur=
ate
such comparisons are I dont know so if anyone has any experience then d=
o
shout.

After installing windows, I did the following:

1) ping -n 10000 [server]
Result: Ping replies were good from throughout the house. Only 1 packet
lost out of about 600.

2) Observation of wireless connection
Result: From the little diagnostics there are on windows, it reckons it
connected at 54g (completely false as windows might just say that anywa=
y).
Walking around the house, the signal bars only ever went down to 3 out =
of
5.

3) iperf -c [server]
Result: From 3 different locations in the house, the performance is
reported at 5.5 - 6Mbits/sec.


Rebooted back into Mandriva 2009 using the compat-wireless snapshot fro=
m
the 24/2/2009.

1) ping [server]
Result: Ping is brittle. Movements around the house can ensure a packet=
 is
lost with minimal effort. Locations away from the router but within ran=
ge,
that could be pinged from under Windows, resulted in lost packets and e=
ven
"Destination unreachables". Slight turnings of the laptop either left o=
r
right when placed on a table impact ping connectivity.

2) Observation of wireless connection
Result: running iwconfig and looking at the signal strength indicates a
range of 28-100. The locations where 28 occurs rarely get a decent ping
test.

3) iperf -c [server]
Result: From 3 different locations in the house, the performance is
reported at 3 - 4Mbits/sec.

So my rather crude conclusions at the moment is the rtl8187 under mandr=
iva
performs at a slower rate than under windows. More interestingly, it se=
ems
that its receiver is not performing as well either, meaning the signal
coverage area for my laptop is much smaller.

Is there anything I can do to help improve this situation? These result=
s
seems to rule out hardware in favour of being driver related. Are there
other tests I could perform to determine where the fragility lies?

Any thoughts, let me know.

Regards

PGR

--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
