Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54803 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BJGL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 01:11:57 -0500
Received: by iyj8 with SMTP id 8so964497iyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 22:11:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <681857.63296.qm@web36106.mail.mud.yahoo.com>
References: <426364.35269.qm@web36108.mail.mud.yahoo.com> <AANLkTinoaTFbb3yaEmD5B4q+6U+VVtSVxrqnkryVrxeT@mail.gmail.com>
 <681857.63296.qm@web36106.mail.mud.yahoo.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 10 Feb 2011 17:11:36 +1100
Message-ID: <AANLkTin-U6mWDWLVq57QOjZp=N+kZCmJsO2GeXcbTEdB@mail.gmail.com>
Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation
 Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: Noel Milton Vega <nmvega@computingarchitects.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 16:25, Noel Milton Vega
<nmvega@computingarchitects.com> wrote:
> Hi Julian,
>
> Thank you for the extended reply. It's appreciated. Your output wish is
> my command. Here they are (and then some):
>
> #####################################################
> nmvega@p170hm$ sudo rpm -qa | grep iwl
> #####################################################
> iwl1000-firmware-128.50.3.1-2.fc13.noarch
> iwl6050-firmware-41.28.5.1-2.fc14.noarch
> iwl5150-firmware-8.24.2.2-1.fc13.noarch
> python-iwlib-0.1-3.fc14.x86_64
> iwl4965-firmware-228.61.2.24-2.fc12.noarch
> iwl6000-firmware-9.221.4.1-1.fc14.noarch
> iwl3945-firmware-15.32.2.9-4.fc13.noarch
> iwl5000-firmware-8.24.2.12-3.fc13.noarch
> iwl6000g2b-firmware-17.168.5.1-1.fc14.noarch  <--- Indeed that was missing, and
> I just installed it (then rebooted).
> #####################################################

Ok, if the driver supports your card then it should now work.

> #####################################################
> nmvega@p170hm$ sudo modprobe -r iwlagn
> nmvega@p170hm$ lsmod | grep iwl  (the Unix NULL output was provided here)
> nmvega@-170hm$ sudo modeprobe iwlagn
> nmvega@p170hm$ sudo dmesg | tail -8
> #####################################################
> [  576.353525]     (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> max_eirp)
> [  576.353528]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  576.353530]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  576.353532]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  576.353534]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  576.353536]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  576.384224] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
> in-tree:d
> [  576.384227] iwlagn: Copyright(c) 2003-2010 Intel Corporation
> #####################################################

Not really enough information, but yeah, the first 6 lines are the
tail end of initialising the wireless subsystem, and the last two are
printed when the driver loads. Given that nothing mentions the driver
actually detecting the card, then I'm guessing it isn't supported by
this version of the driver.

> #####################################################
> nmvega@p170hm$ ifconfig -a
> #####################################################
> eth0      Link encap:Ethernet  HWaddr 00:90:F5:B4:5F:2E
>          inet addr:192.168.0.20  Bcast:192.168.0.255  Mask:255.255.255.0
>          inet6 addr: fe80::290:f5ff:feb4:5f2e/64 Scope:Link
>          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>          RX packets:440 errors:0 dropped:0 overruns:0 frame:0
>          TX packets:49 errors:0 dropped:0 overruns:0 carrier:0
>          collisions:0 txqueuelen:1000
>          RX bytes:33496 (32.7 KiB)  TX bytes:6320 (6.1 KiB)
>          Interrupt:48
>
> lo        Link encap:Local Loopback
>          inet addr:127.0.0.1  Mask:255.0.0.0
>          inet6 addr: ::1/128 Scope:Host
>          UP LOOPBACK RUNNING  MTU:16436  Metric:1
>          RX packets:4 errors:0 dropped:0 overruns:0 frame:0
>          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
>          collisions:0 txqueuelen:0
>          RX bytes:240 (240.0 b)  TX bytes:240 (240.0 b)
> #####################################################

And as it hasn't appeared here, that's definitely the case.

> #####################################################
> nmvega@p170hm$ sudo lspci -n
> #####################################################
> 00:00.0 0600: 8086:0104 (rev 09)
> 00:01.0 0604: 8086:0101 (rev 09)
> 00:16.0 0780: 8086:1c3a (rev 04)
> 00:1a.0 0c03: 8086:1c2d (rev 04)
> 00:1b.0 0403: 8086:1c20 (rev 04)
> 00:1c.0 0604: 8086:1c10 (rev b4)
> 00:1c.1 0604: 8086:1c12 (rev b4)
> 00:1c.2 0604: 8086:1c14 (rev b4)
> 00:1c.3 0604: 8086:1c16 (rev b4)
> 00:1d.0 0c03: 8086:1c26 (rev 04)
> 00:1f.0 0601: 8086:1c4b (rev 04)
> 00:1f.2 0106: 8086:1c03 (rev 04)
> 00:1f.3 0c05: 8086:1c22 (rev 04)
> 01:00.0 0300: 10de:0e31 (rev a1)
> 01:00.1 0403: 10de:0beb (rev a1)
> 02:00.0 0c03: 1033:0194 (rev 03)
> 03:00.0 0200: 197b:0250 (rev 05)
> 03:00.1 0880: 197b:2392 (rev 90)
> 03:00.2 0805: 197b:2391 (rev 90)
> 03:00.3 0880: 197b:2393 (rev 90)
> 04:00.0 0280: 8086:0091 (rev 34)  <--- this one.
> 05:00.0 0c00: 197b:2380 (rev 30)
> ####################################################

Ok, with this I can determine that the card wasn't added with the
initial batch of cards I linked you to, but it appears to be fully
supported as it was added later.

> With all that provided, the only thing I didn't investigate pursuant to your
> below
> email was the "compat-wireless". I will do so via the URL:
> http://wireless.kernel.org/en/users/Download

This is probably your best option as it appears that the stock driver
in the F14 2.6.35 kernel doesn't support your card.

> PS: My only side comment is that suggestion (3) was not applicable. My email
> question was peppered with "hello friends", "correct me if I'm wrongs", "and
> please and thank yous". Fair enough that some key output I didn't realize would
> be
> necessary was omitted (my bad, as I'm a compute infrastructure architect not a
> kernel module author), but I did my best to get this dialog started well. =:)

My issue with your email wasn't the text or the content, it was with
the tone of it. Your email implied that your issue was something that
we needed to be stepped through and that it was our fault. I
understand that having hardware on your brand new laptop not work is
an annoyance, especially when it's the built-in wireless - I have
bought several different pieces of hardware only to discover that
support under Linux simply doesn't exist, or requires a lot of work -
but your problem could have been stated in less words with a calmer
tone of voice.

As for the details you provided, they were more than sufficient for
the first stage of a request for help.

I hope that installing compat-wireless goes as smoothly for you as it
does for me, and that after installing it your card works properly.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
