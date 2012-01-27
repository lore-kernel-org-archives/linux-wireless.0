Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60496 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab2A0OXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 09:23:45 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id l5so1609098lah.17
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2012 06:23:44 -0800 (PST)
Subject: Re: wl1271: ERROR watchdog interrupt received! starting recovery.
From: Luciano Coelho <coelho@ti.com>
To: Martin =?ISO-8859-1?Q?Hundeb=F8ll?= <m.hundeboll@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F22AB63.2090008@gmail.com>
References: <4F19397A.8080408@gmail.com>  <4F22AB63.2090008@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Jan 2012 16:23:41 +0200
Message-ID: <1327674221.4329.54.camel@cumari> (sfid-20120127_152348_825313_ABAED9EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

On Fri, 2012-01-27 at 14:49 +0100, Martin Hundebøll wrote: 
> On 2012-01-20 10:52, Martin Hundebøll wrote:
> > I'm running an ad-hoc network with two pandaboards using the following commands to setup the network:
> >
> > root@panda0 # ip link set dev wlan0 address 7e:78:47:8c:26:52
> > root@panda0 # iw dev wlan0 set type ibss
> > root@panda0 # ip link set dev wlan0 up
> > root@panda0 # iw dev wlan0 ibss join panda-mesh 2412 02:72:CF:28:19:1A
> > root@panda0 # iw phy phy0 set rts 100
> > root@panda0 # ip addr add 10.10.10.52/24 dev wlan0
> >
> > and
> >
> > root@panda1 # ip link set dev wlan0 address 7e:78:47:8c:26:53
> > root@panda1 # iw dev wlan0 set type ibss
> > root@panda1 # ip link set dev wlan0 up
> > root@panda1 # iw dev wlan0 ibss join panda-mesh 2412 02:72:CF:28:19:1A
> > root@panda1 # iw phy phy0 set rts 100
> > root@panda1 # ip addr add 10.10.10.53/24 dev wlan0
> >
> > After this, the nodes list each other in a station dump. I then run ping:
> >
> > root@panda0 # ping 10.10.10.53
> >
> > but only two requests are transmitted before the devices restart as seen in the attached dmesg logs. The tcpdump from panda1 is attached in tcpdump.txt. I have attached the kernel config and here is some additional info:
> >
> I have investigated the issue further and it seems to be related to the rts-setting in the commands listed above. Since my last mail I have update to kernel v3.2.1 and now the watchdog interrupts continuously if I configure the RTS threshold to 62 bytes or less. Changing the threshold to 63 bytes or more stops the watchdog interrupt from occuring.

I'm sorry I didn't have the time to look into this earlier.  This seems
to be a bug in the firmware (at least the watchdog is triggered when the
FW stops responding).

I'll take this up with our firmware team and see what we can do.

Thanks for reporting!

-- 
Cheers,
Luca.

