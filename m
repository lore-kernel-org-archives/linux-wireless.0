Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:57338 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbZBTXmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 18:42:47 -0500
Message-ID: <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk> (sfid-20090221_004250_332010_69F0B4EE)
In-Reply-To: <499E1826.8040903@lwfinger.net>
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
    <499B27A4.30708@lwfinger.net>
    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>
    <499B4526.1030705@lwfinger.net>
    <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>
    <499E1826.8040903@lwfinger.net>
Date: Fri, 20 Feb 2009 23:42:44 -0000 (UTC)
Subject: Re: rtl8187 cannot fix rate
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right, in business ... took an effort but there we are.

Still couldnt get any info from "find /sys -name rc_stats". However, I
found an old thread from last year which interestingly seems exactly th=
e
problem.

http://www.gossamer-threads.com/lists/linux/kernel/860544

So have done similar and mounted debugfs at /debug. This is the results=
 of
cat /debug/ieee80211/phy0/stations/f6cefa14/rc_stats:

rate     throughput  ewma prob   this prob  this succ/attempt   success=
  =20
attempts
 tP  1         0.8       89.5      100.0          1(  1)        102    =
  =20
 176
     2         0.7       39.3       50.0          0(  0)         11    =
  =20
  56
T    5.5       3.4       68.7       50.0          1(  2)       1065    =
  =20
3462
    11         0.2        2.4        0.0          0(  0)       1158    =
  =20
1463
     6         0.1        2.6        0.0          0(  0)        232    =
  =20
 935
     9         0.0        0.7        0.0          0(  0)         17    =
  =20
 159
    12         0.0        0.7        0.0          0(  0)        106    =
  =20
 338
    18         0.0        0.4        0.0          0(  0)         52    =
  =20
 246
    24         0.0        0.1        0.0          0(  0)         17    =
  =20
 207
    36         0.0        0.1        0.0          0(  0)         10    =
  =20
 143
    48         0.0        0.0        0.0          0(  0)          0    =
  =20
  28
    54         0.0        0.0        0.0          0(  0)          0    =
  =20
  28

Total packet count::    ideal 2863      lookaround 150

Let me know if this means anything or you need further info. Certainly,
seems to confirm that connection never seems to go above 11Mb/s.

Cheers

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
