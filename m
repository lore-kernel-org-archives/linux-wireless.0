Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chiark.greenend.org.uk ([212.13.197.229]:53997 "EHLO
	chiark.greenend.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1CTJMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 05:12:41 -0400
Message-ID: <4D85C506.1060003@greenend.org.uk>
Date: Sun, 20 Mar 2011 09:12:38 +0000
From: Richard Kettlewell <rjk@greenend.org.uk>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: linux-wireless@vger.kernel.org, 618930@bugs.debian.org,
	Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: Bug#618930: High network latency with ralink usb wireless device
References: <4D84E433.70001@greenend.org.uk> <1300555815.26693.83.camel@localhost> <4D84EC90.4090803@greenend.org.uk> <20110319223159.GA19576@sig21.net>
In-Reply-To: <20110319223159.GA19576@sig21.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/03/2011 22:31, Johannes Stezenbach wrote:

> I sent a patch to disable power save by default, but then work started
> to fix it instead, but then stalled.  Seems like 2.6.38 shipped with
> broken power save enabled by default.  Plese read the discussion
> following my RFC patch:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/thread.html#3017
>
> You can test if power saving causes your issue by disabling
> it with "iwconfig wlan0 power off".

That does the trick - thanks!

richard@sfere:~$ ssh violeer uname -a
Linux violeer 2.6.38-1-686 #1 SMP Wed Mar 16 17:37:47 UTC 2011 i686 
GNU/Linux
richard@sfere:~$ ping -qc10 violeer
PING violeer.wlan.anjou.terraraq.org.uk (172.31.59.138) 56(84) bytes of 
data.

--- violeer.wlan.anjou.terraraq.org.uk ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9016ms
rtt min/avg/max/mdev = 0.919/0.981/1.089/0.057 ms
richard@sfere:~$

ttfn/rjk
