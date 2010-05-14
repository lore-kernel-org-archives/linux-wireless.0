Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39941 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0ENUNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 16:13:00 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OD1Ff-0004dl-VG
	for linux-wireless@vger.kernel.org; Fri, 14 May 2010 22:12:56 +0200
Received: from CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com ([99.234.24.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 22:12:55 +0200
Received: from senada by CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 22:12:55 +0200
To: linux-wireless@vger.kernel.org
From: seno <senada@t-online.de>
Subject: Re: RTL 8187b - naughty behaviour
Date: Fri, 14 May 2010 20:12:44 +0000 (UTC)
Message-ID: <loom.20100514T211527-88@post.gmane.org>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com> <4BB7660A.3030900@lwfinger.net> <loom.20100506T185847-345@post.gmane.org> <4BE30879.4020008@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> I do not understand the poor performance. I have a device with the
> rtl8187b chip - USB IDs 0bda:8187. That is an ID for an rtl8187, but it
> does have the B chip. I use tcpperf to measure the transmit speed. At 2
> m from the AP with an indicated signal of -17 dBm, my throughput is 13
> Mb/s. At 10 m with a signal of -49 dBm, the transmit speed is 3.5 Mb/s.
> On the download using speedtest.net, I got 11.3 Mb/s at 2 m, and 2.64 at
> 10 m. I got 0.49 Mb/s upload at both distances as that is the speed of
> my line.
> 
> What happens if you use iwconfig to force a particular rate? At what
> setting is your throughput maximized. I don't think there is a problem
> with the rate setting mechanism, but that would test it.
> 
> Larry


Hello,
it turns out that terms 'poor' or 'slow' performance on 8187b chipsets need to 
be discussed more in detail.
If I would have never had a faster network, I would possibly not notice those 
performance downturns.
I did some test on my notebook, once with mandriva 2010.0 and once with win 7.

The results:

windows:
 @ 2  meters distance
  rate : 54M
  dBm  : -46
  speedtest: 9.9/0.98 Mbit/s (down/up)
  DL file*: ~2.5 MByte/s

 @ 10  meters distance
  rate : 54M
  dBm  : -64
  speedtest: 9.9/0.97 Mbit/s (down/up)
  DL file*: ~1.25 MByte/s


linux:
 @ 2  meters distance
  rate : 36M
  dBm  : -30
  speedtest: 9.9/1.00 Mbit/s (down/up)
  DL file*: ~1.5 MByte/s
  tcpperf output: 11769623 b/s (11769.62 kb/s 11.77 Mbit/s)

 @ 10  meters distance
  rate : 18M
  dBm  : -45
  speedtest: 1.2/0.85 Mbit/s (down/up)
  Dl file*: ~130 KByte/s (<---!!)
  tcpperf output: 3663403 b/s (3663.40 kb/s 3.66 Mbit/s)

Dl file* = copy large file from a machine which is connected via 100mbit 
ethernet to the router.

I did all tests several times to make sure to not report some random results.

Before I used pid algorithm as someone described above, but could not notice 
any difference in network behavior.

If rate is set to auto, it _sometimes_ (~ twice a day) happens that connection 
is up and iwconfig shows a rate of 24M, but I can not even ping the router.
Same happens if I set a fixed rate of 36 or 18, but it happens more often 
(every 15 min) that the connection is up but no traffic is possible at all.
A fixed rate of 5.5M gives the most stable connection although the wireless 
speed is as slow @ 10 meters with auto rate (130 KByte/s is FAR from 5.5M)
The rate settings apply to 10 meters distance, which is my typical situation 
here at home.

On another PC with zw1211 wireless I set rate to 54M some time ago and there 
the trick did it, connection is perfect and very fast.

