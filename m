Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5-g19.free.fr ([212.27.42.35]:33964 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbYGZQcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 12:32:39 -0400
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 3D4793F6236
	for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 18:32:38 +0200 (CEST)
Received: from localhost (ble59-5-82-233-204-229.fbx.proxad.net [82.233.204.229])
	by smtp5-g19.free.fr (Postfix) with ESMTP id EE0903F6226
	for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 18:32:37 +0200 (CEST)
Date: Sat, 26 Jul 2008 18:32:37 +0200
From: =?UTF-8?B?Q8OpZHJpYw==?= Auger <cedric@grisbi.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
Message-ID: <20080726183237.02a1e28e@grisbi.org> (sfid-20080726_183258_392670_CB4D6FB4)
In-Reply-To: <488B48C1.6090506@lwfinger.net>
References: <20080726161140.59041730@grisbi.org>
	<488B3969.4050405@openwrt.org>
	<488B48C1.6090506@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Sat, 26 Jul 2008 10:54:41 -0500,
Larry Finger <Larry.Finger@lwfinger.net> a =C3=A9crit :

> Felix Fietkau wrote:
> > I don't know if it helps with debugging this issue, but I've seen
> > the same on a laptop from a friend of mine (same card).
> >=20
> > After some searching I found that setting the AP to g-only mode
> > instead of b+g mixed made it work at decent speeds. Another symptom
> > of this slowdown is that there is typically an unnaturally high
> > number of retransmissions on the air, which eats up a lot of
> > airtime.
> >=20
> > I've spent some time looking through the code to find the reason
> > for this but couldn't find anything yet (maybe somebody from Intel
> > could help).
>=20
> Just for comparison, my BCM4312 running b43 from the latest
> wireless-testing gets the following tcpperf throughput:
>=20
> AP Mode          TX          RX
>=20
> Mixed b/g    19.8 MB/s   23.0 MB/s
> g-only       20.5 MB/s   23.1 MB/s
>=20
> For these tests, the connecting end was wired to the router. The
> difference in TX speeds was about what I expected - the small
> difference in RX speeds was not. In any case, if you see a large
> difference with iwl3945, that would be useful information.
>=20
> You can obtain tcpperf from
> http://wand.cs.waikato.ac.nz/~stj2/nsc/software.html

hello
thanks for your answers.
i tried to set my ap to g-only, but i cannot :-( the wifi box is given
by my provider and it seems cannot be changed...
so i tried tcpperf, this is the result :

cedric:/home/grisbi/tcpperf-1.754# ./tcpperf -c 192.168.0.4 -t 30
Duration: 30 9482usec
Bytes sent: 5481472 (5353 kB 5 MB 0 GB)
Bandwidth: 1461264 b/s (1461.26 kb/s 1.46 Mb/s)
Close duration: 0s 22usec

then i tried to download an image of ubuntu and i had about 900kb/s,
so very good and i don't understand...  then i tried to send a big file
with scp to the other computer, as user and as root, it begins at
2,2MB/s and decrease untill 150kb/s and stays between 130-200kb/s
i did again a tcpperf with -t 300 to check if it's not with the time,
but i have 1,30MB/s, seems correct.

second test :
i stop the wifi and plug a cable. the second computer is still in wifi.
tcpperf gives me 17Mb/s and the same file with scp is sent with about
2,2MB/s...
so now i really don't understand, from internet, loading work untill
900kb/s (ok for me), but beween 2 computers on my network i have max
200kb/s...
hopes this can be usefull
thanks
cedric



--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
