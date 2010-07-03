Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44361 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0GCR5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jul 2010 13:57:20 -0400
Message-ID: <4C2F79FF.4080604@candelatech.com>
Date: Sat, 03 Jul 2010 10:57:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k doesn't clean up virtual wifis on rmmod, and crashes.
References: <4C2ED806.9000105@candelatech.com> <20100703070259.GA15479@vasanth-laptop> <4C2F6681.7070202@candelatech.com>
In-Reply-To: <4C2F6681.7070202@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just for reference, same problem on un-modified 2.6.35-rc3+ (pulled last night)

The crash below is from reproducing it with your patch included.

[root@atom ~]# ls
anaconda-ks.cfg  Documents  Music     Public     Videos
Desktop          Downloads  Pictures  Templates
[root@atom ~]# echo add > /debug/ath9k/phy0/wiphy
Jul  3 10:55:24 atom kernel: phy1: Selected rate control algorithm 'ath9k_rate_control'
[root@atom ~]# Jul  3 10:55:25 atom kernel: ADDRCONF(NETDEV_UP): wlan1: link is not ready

[root@atom ~]# rmmod ath9k
BUG: unable to handle kernel NULL pointer dereference at 000000a4
IP: [<f8d65fd1>] ath9k_hw_intrpend+0x6/0x49 [ath9k_hw]
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:03.0/class
Modules linked in:

(It reboots before printing anything else to console).


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
