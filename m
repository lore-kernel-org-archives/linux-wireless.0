Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44733 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZAIBsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 20:48:03 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LL6Th-00018M-60
	for linux-wireless@vger.kernel.org; Fri, 09 Jan 2009 01:48:01 +0000
Received: from 69-196-155-127.dsl.teksavvy.com ([69.196.155.127])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 01:48:01 +0000
Received: from monnier by 69-196-155-127.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 01:48:01 +0000
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: b43 terribly slow
Date: Thu, 08 Jan 2009 20:47:51 -0500
Message-ID: <jwvvdspbjv6.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org> (sfid-20090109_024808_753131_BAC0B0D1)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the b43 driver with a OpenWRT's 2.6.25 kernel (which includes
changes from compat-wireless).  I'm happy to say that it works on my WPA
network, but the bandwidth it offers is cometimes terrible.
(like less than 50kB/s over NFS).

The affected machine (an asus WL-700gE) is not overloaded at all, and
while it serves those files over NFS, `top' says it's 94% idle.

Has anybody seen this or have some idea what might be the trouble?

It's not always like that, so it might be due to interference, but 
I have an old WL-500g right next to this box (i.e. similar b43
hardware, but running a 2.4 kernel with broadcom's proprietary driver),
and I always get around 700kB/s bandwidth, so the problem is likely to
be on the driver side.

This afternoon, the problem lasted for a while, so I experimented a bit.
While investigating, I noticed that a likely culprit is that `iwconfig'
says it's rate is set to 1M.  So I tried to change the rate.

Typical link quality during this test:
Link Quality=70/100  Signal level:-40 dBm  Noise level=-63 dBm
tho I've seen link quality reported as high as 105/100
(and as low as 60/100).

- with a 1M transfer speed, I see a bandwidth around 80kB/s
- setting the rate manually to 2M improved the transfer speed to
  around 140kB/s.
- setting the rate to 5.5M improved the speed to around 280kB/s,
  but with periods where nothing gets through.
- with 11M, the periods where nothing get through are much more
  significant, so connections are becoming very difficult.
- with 54M, same thing.
- if I "iwconfig wlan0 rate auto" it goes back down to 1M fairly quickly.

Any idea what might be going on?  Or what I could do to try and figure
it out?  It seems that the rate choice is a bit conservative (2M works
as well as 1M, just faster), but it's probably not the culprit.
So could someone explain to me why I see these drops in connectivity
even though the WL-500g that sits right next stays connected "full
blast" (at least 500kB/s, so at least 11M I guess)?


        Stefan

