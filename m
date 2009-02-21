Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34822 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbZBUAO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 19:14:29 -0500
Message-ID: <499F4763.70106@lwfinger.net> (sfid-20090221_011435_100621_EF1DCBD0)
Date: Fri, 20 Feb 2009 18:14:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 cannot fix rate
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>    <499B27A4.30708@lwfinger.net>    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>    <499B4526.1030705@lwfinger.net>    <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>    <499E1826.8040903@lwfinger.net> <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> Right, in business ... took an effort but there we are.
> 
> Still couldnt get any info from "find /sys -name rc_stats". However, I
> found an old thread from last year which interestingly seems exactly the
> problem.
> 
> http://www.gossamer-threads.com/lists/linux/kernel/860544
> 
> So have done similar and mounted debugfs at /debug. This is the results of
> cat /debug/ieee80211/phy0/stations/f6cefa14/rc_stats:

My /etc/fsconfig has these two lines:

sysfs   /sys    sysfs   noauto 0 0
debugfs /sys/kernel/debug       debugfs noauto 0 0

For getting help with issues like this, you should probably mount debugfs this
way as well. AFAIK, these were set up by openSUSE.

> rate     throughput  ewma prob   this prob  this succ/attempt   success   
> attempts
>  tP  1         0.8       89.5      100.0          1(  1)        102       
>  176
>      2         0.7       39.3       50.0          0(  0)         11       
>   56
> T    5.5       3.4       68.7       50.0          1(  2)       1065       
> 3462
>     11         0.2        2.4        0.0          0(  0)       1158       
> 1463
>      6         0.1        2.6        0.0          0(  0)        232       
>  935
>      9         0.0        0.7        0.0          0(  0)         17       
>  159
>     12         0.0        0.7        0.0          0(  0)        106       
>  338
>     18         0.0        0.4        0.0          0(  0)         52       
>  246
>     24         0.0        0.1        0.0          0(  0)         17       
>  207
>     36         0.0        0.1        0.0          0(  0)         10       
>  143
>     48         0.0        0.0        0.0          0(  0)          0       
>   28
>     54         0.0        0.0        0.0          0(  0)          0       
>   28
> 
> Total packet count::    ideal 2863      lookaround 150
> 
> Let me know if this means anything or you need further info. Certainly,
> seems to confirm that connection never seems to go above 11Mb/s.

I'm not an expert in reading these tables, but the success rates above 11 Mb/s
are very low, which seems to indicate that 11 Mb/s is a reasonable rate for your
device. There is, however, a possibility that the code is not reporting the
retry count correctly. I know from your initial post that 54M doesn't work, but
can you get any throughput at 24, 36, or 48M? There is also the possibility that
your hardware is broken for OFDM encoding. That scheme is used for 6, 9, and all
rates 18M and above.

Larry


