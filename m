Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:35994 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933AbYG0Gav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 02:30:51 -0400
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 8BD1832A7F4
	for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 08:30:49 +0200 (CEST)
Received: from localhost (ble59-5-82-233-204-229.fbx.proxad.net [82.233.204.229])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 435F432A7C6
	for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 08:30:49 +0200 (CEST)
Date: Sun, 27 Jul 2008 08:30:48 +0200
From: =?UTF-8?B?Q8OpZHJpYw==?= Auger <cedric@grisbi.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
Message-ID: <20080727083048.4279c9b9@grisbi.org> (sfid-20080727_083118_289920_78EB8A35)
In-Reply-To: <488B92E3.6050200@lwfinger.net>
References: <20080726161140.59041730@grisbi.org>
	<488B3969.4050405@openwrt.org>
	<488B48C1.6090506@lwfinger.net>
	<20080726183237.02a1e28e@grisbi.org>
	<488B92E3.6050200@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Sat, 26 Jul 2008 16:10:59 -0500,
Larry Finger <Larry.Finger@lwfinger.net> a =C3=A9crit :

> C=C3=A9dric Auger wrote:
> > Le Sat, 26 Jul 2008 10:54:41 -0500,
> > Larry Finger <Larry.Finger@lwfinger.net> a =C3=A9crit :
> >=20
> >> Felix Fietkau wrote:
> >>> I don't know if it helps with debugging this issue, but I've seen
> >>> the same on a laptop from a friend of mine (same card).
> >>>
> >>> After some searching I found that setting the AP to g-only mode
> >>> instead of b+g mixed made it work at decent speeds. Another
> >>> symptom of this slowdown is that there is typically an
> >>> unnaturally high number of retransmissions on the air, which eats
> >>> up a lot of airtime.
> >>>
> >>> I've spent some time looking through the code to find the reason
> >>> for this but couldn't find anything yet (maybe somebody from Inte=
l
> >>> could help).
> >> Just for comparison, my BCM4312 running b43 from the latest
> >> wireless-testing gets the following tcpperf throughput:
> >>
> >> AP Mode          TX          RX
> >>
> >> Mixed b/g    19.8 MB/s   23.0 MB/s
> >> g-only       20.5 MB/s   23.1 MB/s
> >>
> >> For these tests, the connecting end was wired to the router. The
> >> difference in TX speeds was about what I expected - the small
> >> difference in RX speeds was not. In any case, if you see a large
> >> difference with iwl3945, that would be useful information.
> >>
> >> You can obtain tcpperf from
> >> http://wand.cs.waikato.ac.nz/~stj2/nsc/software.html
> >=20
> > hello
> > thanks for your answers.
> > i tried to set my ap to g-only, but i cannot :-( the wifi box is
> > given by my provider and it seems cannot be changed...
> > so i tried tcpperf, this is the result :
> >=20
> > cedric:/home/grisbi/tcpperf-1.754# ./tcpperf -c 192.168.0.4 -t 30
> > Duration: 30 9482usec
> > Bytes sent: 5481472 (5353 kB 5 MB 0 GB)
> > Bandwidth: 1461264 b/s (1461.26 kb/s 1.46 Mb/s)
> > Close duration: 0s 22usec
> >=20
> > then i tried to download an image of ubuntu and i had about 900kb/s=
,
> > so very good and i don't understand...  then i tried to send a big
> > file with scp to the other computer, as user and as root, it begins
> > at 2,2MB/s and decrease untill 150kb/s and stays between 130-200kb/=
s
> > i did again a tcpperf with -t 300 to check if it's not with the
> > time, but i have 1,30MB/s, seems correct.
> >=20
> > second test :
> > i stop the wifi and plug a cable. the second computer is still in
> > wifi. tcpperf gives me 17Mb/s and the same file with scp is sent
> > with about 2,2MB/s...
> > so now i really don't understand, from internet, loading work until=
l
> > 900kb/s (ok for me), but beween 2 computers on my network i have ma=
x
> > 200kb/s...
> > hopes this can be usefull
>=20
> It looks as if your receive rate is a lot higher than the transmit
> rate. You can check that by using the computer with the iwl3945 as
> the server and initiate tcpperf from the other end.

hi
i didn't think about that...=20
i did the test and i have a bandwidth of 7,55Mb/s... more than for the
other test...
so i did a transfer by scp from the other computer to my computer,
begin to 2,2Mb/s and decrease to 930kb/s, which is good for me.
so if i resume :

my computer 1 to computer 2 : 100-200kb/s
computer 2 to computer 1 : 950kb/s
internet to computer 1 : 950kb/s

then download seems correct, but upload seems bad. but if we look the
results of tcpperf :
computer 1 to computer 2 : 1,5Mb/s
computer 2 to computer 1 : 7,5Mb/s

perhaps 1,5Mb/s for upload is not good as i thought ?
thanks
cedric
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
