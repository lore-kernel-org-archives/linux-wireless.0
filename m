Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36106.mail.mud.yahoo.com ([66.163.179.220]:23434 "HELO
	web36106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753883Ab1BKAFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 19:05:33 -0500
Message-ID: <971463.73333.qm@web36106.mail.mud.yahoo.com>
References: <875258.44241.qm@web36104.mail.mud.yahoo.com>
Date: Thu, 10 Feb 2011 16:05:31 -0800 (PST)
From: Noel Milton Vega <nmvega@nyceyes.com>
Reply-To: Noel Milton Vega <nmvega@nyceyes.com>
Subject: Re: compat-wireless trial :: Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: Noel Milton Vega <nmvega@nyceyes.com>,
	Julian Calaby <julian.calaby@gmail.com>, ozan@pardus.org.tr
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <875258.44241.qm@web36104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello:

As someone suggested, I tried the stable version of the compat-wireless solution
(http://wireless.kernel.org/en/users/Download/stable). Because I'm
running FC14 kernel version "2.6.35.10-74.fc14.x86_64", I
selected "compat-wireless-2.6.35-1.tar.bz2" (if that logic is
flawed for selecting a compat version, please let me know. Thanks. Note
that I acknowledge seeing the "Bug" citation near the end of the URL above).

####################################################################
Here's what I did in a nutshell:
####################################################################
   root# bzip2 -dc compat-wireless-2.6.35-1.tar.bz2 | tar -xf -
   root# cd compat-wireless-2.6.35-1
   root# ./scripts/driver-select iwlwifi
   root# make             (The compile succeeded and generally went w/o 
warnings)
   root# make install
   root# make modunload (Same as "modprobe -r iwlagn", although one was not 
previously loaded)

   root# modprobe -l | grep iwl
     updates/drivers/net/wireless/iwlwifi/iwlagn.ko
     updates/drivers/net/wireless/iwlwifi/iwlcore.ko
     updates/drivers/net/wireless/iwlwifi/iwl3945.ko

   root# modprobe iwlagn (Also tried a reboot here).
   root# lsmod | grep iwl
     iwlagn                209705  0 
     iwlcore               196953  1 iwlagn
     mac80211              235755  2 iwlagn,iwlcore
     cfg80211              137516  3 iwlagn,iwlcore,mac80211

   root# dmesg | tail -10
     [ 5047.010147] cfg80211: Calling CRDA to update world regulatory domain
     [ 5047.013692] cfg80211: World regulatory domain updated:
     [ 5047.013695]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
     [ 5047.013697]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 
mBm)
     [ 5047.013699]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 
mBm)
     [ 5047.013701]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 
mBm)
     [ 5047.013704]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 
mBm)
     [ 5047.013705]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 
mBm)
     [ 5047.064643] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
in-tree:d
     [ 5047.064645] iwlagn: Copyright(c) 2003-2010 Intel Corporation
     < End of dmesg output >

   root# ifconfig -a
   eth0   Link encap:Ethernet  HWaddr 00:90:F5:B4:5F:2E  
          inet addr:192.168.0.20  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::290:f5ff:feb4:5f2e/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1268 errors:0 dropped:0 overruns:0 frame:0
          TX packets:58 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:86446 (84.4 KiB)  TX bytes:6898 (6.7 KiB)
          Interrupt:48 

   lo     Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:4 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:240 (240.0 b)  TX bytes:240 (240.0 b)

   <End of ifconfig output>
#############################################################################

Seems no luck with this version either (from the stable section).

One continuing oddity is that the WiFi light has never come on when I boot
to Linux (although the Bluetooth one does). Bluetooth/WiFi both toggle
on/off in Windows, so it's not a bad light issue.

Thanks in advance for help and suggestions,
Noel




----- Original Message ----
> From: Noel Milton Vega <nmvega@nyceyes.com>
> To: Julian Calaby <julian.calaby@gmail.com>; ozan@pardus.org.tr
> Cc: linux-wireless@vger.kernel.org; Noel Milton Vega 
><nmvega@ComputingArchitects.Com>
> Sent: Thu, February 10, 2011 3:31:02 PM
> Subject: Re: UPDATE -- Need Linux driver (preferably 64 bit) for "Intel 
>Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
> 
> Hello again all:
> 
> It seems that the bluetooth capability of this card now  works.
> I don't know whether this had to do with my installing a  missing
> firmware package that Julian pointed out
> (i.e.  iwl6000g2b-firmware-17.168.5.1-1.fc14.noarch), or maybe
> that the bluetooth  radio was off when I was attempting to pair
> (I do remember turning it on  though). In any case, I inserted an
> "rfkill unblock all" statement in  /etc/rc.local to automate
> that - at least at a O/S level (thank you Ozan for  alerting
> me to that command). 
> 
> Anyway, I'd like to post an accurate  update to the question I posed on
> the forums (FedoraForum & Linuxforums)  for this issue (I will
> not divulge email addresses btw).
> 
> Given the  dialogue we had last night, would you guys/gals
> characterize the update shown  next as  accurate:
> 
> ###################################################################
> Hi  Friends....
> 
> UPDATE:
> 
> In working with the kernel.org linux-wireless developers, the  conclusion
> from one developer was that, though generally speaking  the
> "Centrino Advanced-N 6230 AGN" card is supported by the "iwlagn"  kernel
> module, it seems that the stock kernel module provided in  the
> Fedora 14 kernel package (circa 2.6.35.10-74.fc14.x86_64), does  not
> support the this card.
> 
> In other words, though code in the main  kernel.org git repository does
> show support for the card (via iwlagn kernel  module), Fedora 14's
> rendition/distribution of that does  not.
> 
> "lspci(8) -v" did show the hardware (Intel Corporation Centrino  Advanced-N 
>6230
> (rev 34)), the necessary driver and firmware packages were  installed, and the
> laptop RF toggle switches are set to enable wireless  communications.
> Yet manually performing "modprobe(8) iwlagn" does not produce  a wlan0
> interface in "ifconfig(8) -a" output; and although "dmesg(8)" shows  the
> module being loaded, it does not show it detecting the card.
> 
> The  two work arounds were suggested (I haven't tried either):
> 
>   (1)  Update the kernel. Since I have the latest one provided
>        by Fedora for Fedora 14, this implies a manual compile
>        of a kernel.org kernel. Note that if Fedora is not aware of
>        this issue, it's not likely that the next kernel update
>        will remedy this.
> 
>   (2) Using a compat-wireless technique  described here,
>        http://wireless.kernel.org/en/users/Download
> 
> 
> Command output during my  debugging session with the developers is
> shown below for completeness, and in  case the Fedora folks  are
> monitoring.
> 
> Regards,
> Noel
> 
> ###################################################################
> 
> Thanks  again to all participants on this email  list.
> Noel
> 
> 
> 
> 
> 
> 
> 
> 
> 
> ________________________________
> From:  Julian Calaby <julian.calaby@gmail.com>
> To:  Noel Milton Vega <nmvega@computingarchitects.com>
> Cc: linux-wireless@vger.kernel.org
> Sent:  Thu, February 10, 2011 1:11:36 AM
> Subject: Re: Need Linux driver (preferably  64 bit)  for "Intel Corporation 
> Centrino Advanced-N 6230 (rev 34)" WiFI  & Bluetooth card ...
> 
> On Thu, Feb 10, 2011 at 16:25, Noel Milton  Vega
> <nmvega@computingarchitects.com>  wrote:
> > Hi Julian,
> >
> > Thank you for the extended reply.  It's appreciated. Your output wish is
> > my command. Here they are (and  then some):
> >
> >  #####################################################
> > nmvega@p170hm$  sudo rpm -qa | grep iwl
> >  #####################################################
> >  iwl1000-firmware-128.50.3.1-2.fc13.noarch
> >  iwl6050-firmware-41.28.5.1-2.fc14.noarch
> >  iwl5150-firmware-8.24.2.2-1.fc13.noarch
> >  python-iwlib-0.1-3.fc14.x86_64
> >  iwl4965-firmware-228.61.2.24-2.fc12.noarch
> >  iwl6000-firmware-9.221.4.1-1.fc14.noarch
> >  iwl3945-firmware-15.32.2.9-4.fc13.noarch
> >  iwl5000-firmware-8.24.2.12-3.fc13.noarch
> >   iwl6000g2b-firmware-17.168.5.1-1.fc14.noarch  <--- Indeed that was  
>missing, 
>
> >and
> > I just installed it (then rebooted).
> >  #####################################################
> 
> Ok, if the driver  supports your card then it should now work.
> 
> >  #####################################################
> > nmvega@p170hm$  sudo modprobe -r iwlagn
> > nmvega@p170hm$ lsmod | grep iwl  (the Unix  NULL output was provided here)
> > nmvega@-170hm$ sudo modeprobe  iwlagn
> > nmvega@p170hm$ sudo dmesg | tail -8
> >  #####################################################
> > [   576.353525]     (start_freq - end_freq @ bandwidth),  (max_antenna_gain,
> > max_eirp)
> > [  576.353528]      (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 
> mBm)
> > [   576.353530]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,  2000 

> mBm)
> > [  576.353532]      (2474000 KHz -  2494000 KHz @ 20000 KHz), (300 mBi, 2000 

> >mBm)
> > [   576.353534]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,  2000 

> mBm)
> > [  576.353536]     (5735000 KHz - 5835000  KHz @ 40000 KHz), (300 mBi, 2000 
> mBm)
> > [  576.384224] iwlagn:  Intel(R) Wireless WiFi Link AGN driver for Linux,
> > in-tree:d
> >  [  576.384227] iwlagn: Copyright(c) 2003-2010 Intel Corporation
> >  #####################################################
> 
> Not really enough  information, but yeah, the first 6 lines are the
> tail end of initialising the  wireless subsystem, and the last two are
> printed when the driver loads. Given  that nothing mentions the driver
> actually detecting the card, then I'm  guessing it isn't supported by
> this version of the driver.
> 
> >  #####################################################
> > nmvega@p170hm$  ifconfig -a
> >   #####################################################
> > eth0       Link encap:Ethernet  HWaddr 00:90:F5:B4:5F:2E
> >           inet addr:192.168.0.20  Bcast:192.168.0.255   Mask:255.255.255.0
> >          inet6 addr:  fe80::290:f5ff:feb4:5f2e/64 Scope:Link
> >           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
> >           RX packets:440 errors:0 dropped:0 overruns:0  frame:0
> >          TX packets:49 errors:0  dropped:0 overruns:0 carrier:0
> >           collisions:0 txqueuelen:1000
> >          RX  bytes:33496 (32.7 KiB)  TX bytes:6320 (6.1 KiB)
> >           Interrupt:48
> >
> > lo        Link  encap:Local Loopback
> >           inet  addr:127.0.0.1  Mask:255.0.0.0
> >           inet6 addr: ::1/128 Scope:Host
> >          UP  LOOPBACK RUNNING  MTU:16436  Metric:1
> >           RX packets:4 errors:0 dropped:0 overruns:0 frame:0
> >           TX packets:4 errors:0 dropped:0 overruns:0  carrier:0
> >          collisions:0  txqueuelen:0
> >          RX bytes:240 (240.0  b)  TX bytes:240 (240.0 b)
> >  #####################################################
> 
> And as it hasn't  appeared here, that's definitely the case.
> 
> >  #####################################################
> > nmvega@p170hm$  sudo lspci -n
> >  #####################################################
> > 00:00.0 0600:  8086:0104 (rev 09)
> > 00:01.0 0604: 8086:0101 (rev 09)
> > 00:16.0  0780:  8086:1c3a (rev 04)
> > 00:1a.0 0c03: 8086:1c2d (rev 04)
> >  00:1b.0 0403: 8086:1c20 (rev 04)
> > 00:1c.0 0604: 8086:1c10 (rev  b4)
> > 00:1c.1 0604: 8086:1c12 (rev b4)
> > 00:1c.2 0604: 8086:1c14  (rev b4)
> > 00:1c.3 0604: 8086:1c16 (rev b4)
> > 00:1d.0 0c03:  8086:1c26 (rev 04)
> > 00:1f.0 0601: 8086:1c4b (rev 04)
> > 00:1f.2  0106: 8086:1c03 (rev 04)
> > 00:1f.3 0c05: 8086:1c22 (rev 04)
> >  01:00.0 0300: 10de:0e31 (rev a1)
> > 01:00.1 0403: 10de:0beb (rev  a1)
> > 02:00.0 0c03: 1033:0194 (rev 03)
> > 03:00.0 0200: 197b:0250  (rev 05)
> > 03:00.1 0880: 197b:2392 (rev 90)
> > 03:00.2 0805:  197b:2391 (rev 90)
> > 03:00.3 0880: 197b:2393 (rev 90)
> > 04:00.0  0280: 8086:0091 (rev 34)  <--- this one.
> > 05:00.0 0c00: 197b:2380  (rev 30)
> > ####################################################
> 
> Ok,  with this I can determine that the card wasn't added with the
> initial   batch of cards I linked you to, but it appears to be fully
> supported as it  was added later.
> 
> > With all that provided, the only thing I didn't  investigate pursuant to 
your
> > below
> > email was the  "compat-wireless". I will do so via the URL:
> > http://wireless.kernel.org/en/users/Download
> 
> This is probably your  best option as it appears that the stock driver
> in the F14 2.6.35 kernel  doesn't support your card.
> 
> I hope that installing compat-wireless goes as  smoothly for you as it
> does for me, and that after installing it your card  works properly.
> 
> Thanks,
> 
> -- 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile:  http://www.google.com/profiles/julian.calaby/
> .Plan:  http://sites.google.com/site/juliancalaby/
> 
> 
