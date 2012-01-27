Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51974 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab2A0Nt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 08:49:27 -0500
Received: by lagu2 with SMTP id u2so962189lag.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2012 05:49:25 -0800 (PST)
Message-ID: <4F22AB63.2090008@gmail.com> (sfid-20120127_144937_257502_6D99265A)
Date: Fri, 27 Jan 2012 14:49:23 +0100
From: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: wl1271: ERROR watchdog interrupt received! starting recovery.
References: <4F19397A.8080408@gmail.com>
In-Reply-To: <4F19397A.8080408@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-20 10:52, Martin Hundebøll wrote:
> I'm running an ad-hoc network with two pandaboards using the following commands to setup the network:
>
> root@panda0 # ip link set dev wlan0 address 7e:78:47:8c:26:52
> root@panda0 # iw dev wlan0 set type ibss
> root@panda0 # ip link set dev wlan0 up
> root@panda0 # iw dev wlan0 ibss join panda-mesh 2412 02:72:CF:28:19:1A
> root@panda0 # iw phy phy0 set rts 100
> root@panda0 # ip addr add 10.10.10.52/24 dev wlan0
>
> and
>
> root@panda1 # ip link set dev wlan0 address 7e:78:47:8c:26:53
> root@panda1 # iw dev wlan0 set type ibss
> root@panda1 # ip link set dev wlan0 up
> root@panda1 # iw dev wlan0 ibss join panda-mesh 2412 02:72:CF:28:19:1A
> root@panda1 # iw phy phy0 set rts 100
> root@panda1 # ip addr add 10.10.10.53/24 dev wlan0
>
> After this, the nodes list each other in a station dump. I then run ping:
>
> root@panda0 # ping 10.10.10.53
>
> but only two requests are transmitted before the devices restart as seen in the attached dmesg logs. The tcpdump from panda1 is attached in tcpdump.txt. I have attached the kernel config and here is some additional info:
>
I have investigated the issue further and it seems to be related to the rts-setting in the commands listed above. Since my last mail I have update to kernel v3.2.1 and now the watchdog interrupts continuously if I configure the RTS threshold to 62 bytes or less. Changing the threshold to 63 bytes or more stops the watchdog interrupt from occuring.

Kind regards,
Martin Hundebøll
