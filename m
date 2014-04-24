Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbaDXQaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 12:30:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WdMXD-0001LC-MN
	for linux-wireless@vger.kernel.org; Thu, 24 Apr 2014 18:30:03 +0200
Received: from 46-126-92-137.dynamic.hispeed.ch ([46.126.92.137])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 18:30:03 +0200
Received: from belegdol by 46-126-92-137.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 18:30:03 +0200
To: linux-wireless@vger.kernel.org
From: Julian Sikorski <belegdol@gmail.com>
Subject: Re: Low 5 GHz performance of Intel Advanced-N 6230
Date: Thu, 24 Apr 2014 18:24:00 +0200
Message-ID: <ljbdr0$c27$1@ger.gmane.org> (sfid-20140424_183018_299864_F03B960E)
References: <5358AADD.3010702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <5358AADD.3010702@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 24.04.2014 08:10, Julian Sikorski pisze:
> Dear all,
> 
> I have been moderately recently hit by a performance drop of Intel
> Advanced-N 6230 card. I unfortunately do not have the "before" numbers,
> but I have noticed this since I was able to stream bluray rips over nfs
> to a wired Raspberry Pi a while ago and now I cannot. This has lead me
> to begin investigating the issue.
> In the end I have used iperf3, testing speeds between RPi and laptop,
> with laptop running both Windows and Linux. iperf3 on RPi was always the
> same, on the laptop it was self-compiled iperf3 git master (on Windows I
> used Cygwin). Please see the observed speeds below:
> - Windows: upload to RPi 93 Mbit/s, download from RPi 54 Mbit/s
> - Fedora: upload to RPi 26 Mbit/s, download from RPi 48 Mbit/s
> 
> This is all on Fedora 20 x86_64. Please find attached the journalctl log
> for the last boot. Please let me know if more information is needed - I
> would love to get my network speeds back up to the level where I can
> watch bluray rips again. Thank you for your support in advance.
> 
> Best regards,
> Julian
> 
Hello again,

I have narrowed this down to have regressed between 3.13.6-200.fc20 and
3.13.7-200. Using pointers from Josh Boyer of #fedora-devel, I have
managed to restore the previous performance by loading iwlwifi with
11n_disable=8. I am now at 3.14.1-200 with that option enabled and the
network is fast as it used to be.
Is such a major performance hit expected from this change? Here is the
commit in question:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.13.y&id=45e5cb4f43d33e72ff5f98c80b081eb42e4e4182

Best regards,
Julian

