Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36106.mail.mud.yahoo.com ([66.163.179.220]:26739 "HELO
	web36106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750840Ab1BJFZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 00:25:14 -0500
Message-ID: <681857.63296.qm@web36106.mail.mud.yahoo.com>
References: <426364.35269.qm@web36108.mail.mud.yahoo.com> <AANLkTinoaTFbb3yaEmD5B4q+6U+VVtSVxrqnkryVrxeT@mail.gmail.com>
Date: Wed, 9 Feb 2011 21:25:12 -0800 (PST)
From: Noel Milton Vega <nmvega@computingarchitects.com>
Reply-To: Noel Milton Vega <nmvega@ComputingArchitects.Com>
Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: Noel Milton Vega <nmvega@ComputingArchitects.Com>
In-Reply-To: <AANLkTinoaTFbb3yaEmD5B4q+6U+VVtSVxrqnkryVrxeT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thank you for the extended reply. It's appreciated. Your output wish is
my command. Here they are (and then some):

#####################################################
nmvega@p170hm$ sudo rpm -qa | grep iwl
#####################################################
iwl1000-firmware-128.50.3.1-2.fc13.noarch
iwl6050-firmware-41.28.5.1-2.fc14.noarch
iwl5150-firmware-8.24.2.2-1.fc13.noarch
python-iwlib-0.1-3.fc14.x86_64
iwl4965-firmware-228.61.2.24-2.fc12.noarch
iwl6000-firmware-9.221.4.1-1.fc14.noarch
iwl3945-firmware-15.32.2.9-4.fc13.noarch
iwl5000-firmware-8.24.2.12-3.fc13.noarch
iwl6000g2b-firmware-17.168.5.1-1.fc14.noarch  <--- Indeed that was missing, and 
I just installed it (then rebooted).
#####################################################

#####################################################
nmvega@p170hm$ sudo modprobe -r iwlagn
nmvega@p170hm$ lsmod | grep iwl  (the Unix NULL output was provided here)
nmvega@-170hm$ sudo modeprobe iwlagn
nmvega@p170hm$ sudo dmesg | tail -8
#####################################################
[  576.353525]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[  576.353528]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  576.353530]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  576.353532]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  576.353534]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  576.353536]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  576.384224] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
in-tree:d
[  576.384227] iwlagn: Copyright(c) 2003-2010 Intel Corporation
#####################################################

#####################################################
nmvega@p170hm$ ifconfig -a
#####################################################
eth0      Link encap:Ethernet  HWaddr 00:90:F5:B4:5F:2E  
          inet addr:192.168.0.20  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::290:f5ff:feb4:5f2e/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:440 errors:0 dropped:0 overruns:0 frame:0
          TX packets:49 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:33496 (32.7 KiB)  TX bytes:6320 (6.1 KiB)
          Interrupt:48 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:4 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:240 (240.0 b)  TX bytes:240 (240.0 b)
#####################################################

#####################################################
nmvega@p170hm$ sudo lspci -n
#####################################################
00:00.0 0600: 8086:0104 (rev 09)
00:01.0 0604: 8086:0101 (rev 09)
00:16.0 0780: 8086:1c3a (rev 04)
00:1a.0 0c03: 8086:1c2d (rev 04)
00:1b.0 0403: 8086:1c20 (rev 04)
00:1c.0 0604: 8086:1c10 (rev b4)
00:1c.1 0604: 8086:1c12 (rev b4)
00:1c.2 0604: 8086:1c14 (rev b4)
00:1c.3 0604: 8086:1c16 (rev b4)
00:1d.0 0c03: 8086:1c26 (rev 04)
00:1f.0 0601: 8086:1c4b (rev 04)
00:1f.2 0106: 8086:1c03 (rev 04)
00:1f.3 0c05: 8086:1c22 (rev 04)
01:00.0 0300: 10de:0e31 (rev a1)
01:00.1 0403: 10de:0beb (rev a1)
02:00.0 0c03: 1033:0194 (rev 03)
03:00.0 0200: 197b:0250 (rev 05)
03:00.1 0880: 197b:2392 (rev 90)
03:00.2 0805: 197b:2391 (rev 90)
03:00.3 0880: 197b:2393 (rev 90)
04:00.0 0280: 8086:0091 (rev 34)  <--- this one.
05:00.0 0c00: 197b:2380 (rev 30)
####################################################

With all that provided, the only thing I didn't investigate pursuant to your 
below
email was the "compat-wireless". I will do so via the URL:
http://wireless.kernel.org/en/users/Download

Thank you, and do let me know your thoughts given the above additional 
information,
and if anything else would be helpful.

Best Regards,
Noel


PS: My only side comment is that suggestion (3) was not applicable. My email
question was peppered with "hello friends", "correct me if I'm wrongs", "and
please and thank yous". Fair enough that some key output I didn't realize would 
be
necessary was omitted (my bad, as I'm a compute infrastructure architect not a
kernel module author), but I did my best to get this dialog started well. =:) 
Thanks.




----- Original Message ----
> From: Julian Calaby <julian.calaby@gmail.com>
> To: Noel Milton Vega <nmvega@computingarchitects.com>
> Cc: linux-wireless@vger.kernel.org
> Sent: Wed, February 9, 2011 11:15:11 PM
> Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation 
>Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
> 
> On Thu, Feb 10, 2011 at 14:31, Noel Milton Vega
> <nmvega@computingarchitects.com>  wrote:
> > I'm writing because I'm having problems with the WiFi and  Bluetooth 
>interfaces
> > provided by the "Intel Centrino Advanced-N 6230AGN"  card in my laptop. I am
> > running Fedora 14 Linux / 64 Bit, with the  latest 2.6 kernel provided by 
>their
> > repositories  (2.6.35.10-74.fc14.x86_64).
> 
> [snip]
> 
> > So it looks like (1)  either these driver are not working for this device 
and
> > needs to be  fixed or *enhanced* to support this card; or (2) this is not 
the
> > driver  for this Intel Centrino Advanced-N 6230AGNdevice, and one needs to
> > be  written. So neither Wireless nor Bluetooth work because devices cannot  
>be
> > accessed.
> 
> Nothing needs to be done, these devices are already  supported.
> 
> See the linked line  in:
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-6000.c;h=af505bcd7ae0977f1095fc02ce8b9553f70dd86d;hb=HEAD#l601
>1
> 
> They  have been supported since the 6th of May last  year.
> 
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1808972f16adba592ceb10a47dee42ef8ee39cee
>e
> 
> This  support hit mainline in 2.6.36.
> 
> May I suggest that you upgrade your  kernel or, failing that, use
> compat-wireless. You should also make sure that  you have the firmware
> installed, it's in the iwl6000g2b-firmware package.  (See:
> https://admin.fedoraproject.org/pkgdb/acls/name/iwl6000g2b-firmware)
> 
> That  said, given that F14 ships the firmware for this device, I'm
> guessing it's  supported somehow. You *did* install the firmware,
> right?
> 
> Next time  you submit a bug report like this, make sure that you:
> 1. Include the dmesg  output for an attempt to load the driver. In your
> case the output of "dmesg |  grep iwl" would be a good start.
> Completely unloading the driver and then  re-loading it while recording
> the output would be better.
> 2. Include  lspci-n output as this means that we can match up your card
> with the list  supported in the driver - given the number of PCI ids
> out there, we cannot  match a text description like you provided to an
> actual card as there's  likely to be several different versions out
> there with the same name, but  differing IDs. If yours has a slightly
> different ID than the officially  supported ones, then it won't work.
> 3. Don't treat us like  idiots.
> 
> Hope that helps,
> 
> -- 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile:  http://www.google.com/profiles/julian.calaby/
> .Plan:  http://sites.google.com/site/juliancalaby/
> 
