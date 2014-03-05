Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from connotech.com ([76.10.176.241]:47786 "EHLO mail.connotech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaCEGnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 01:43:50 -0500
Received: from [192.168.1.204] (DODECA1ER.CONNOTECH-INTERNAL.COM [192.168.1.204])
	by mail.connotech.com (Postfix) with ESMTPA id BF171319AB
	for <linux-wireless@vger.kernel.org>; Wed,  5 Mar 2014 01:34:00 -0500 (EST)
Message-ID: <5316C602.8020504@connotech.com> (sfid-20140305_074354_867766_28699694)
Date: Wed, 05 Mar 2014 06:36:50 +0000
From: Thierry Moreau <thierry.moreau@connotech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning
 works
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I am using a kind-of "linux from scratch" (i.e. Crux 3.0, 64 bits Intel, 
kernel 3.10.32) and I am stuck with a EBUSY error return from the 
wireless driver I suspect it comes from the driver behavior since it is 
consistent either from the command

iw dev wlan1 set channel 2

or the comand

iwconfig wlan1 set channel 2

(it occurred also with "iw" with a kernel where the iwconfig support 
emulation is off -- CONFIG_CFG82011_WEXT). The EBUSY error return occurs 
as early as immediately after the initial module install, and 
consistently thereafter. The wireless scanning works (reporting a nearby 
beacon on channel 1).

I understand this list is not for user/integrator support but since I 
control many variables in the troubleshooting exercise, some of you 
might be interested in finding more about a possible bug.

Here is a sequence of commands immediately after system boot:

+ uname -a
Linux a-host 3.10.32 #2 SMP Wed Mar 5 00:39:47 UTC 2014 x86_64 Intel(R) 
Atom(TM) CPU D2550 @ 1.86GHz GenuineIntel GNU/Linux

+ dmesg | grep -i wifi -C 4 -n
853-[    2.468354] gma500 0000:00:02.0: trying to get vblank count for 
disabled pipe 1
854-[    2.556398] usb 5-2: new low-speed USB device number 2 using uhci_hcd
855-[    2.685093] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip 
Version ID: B_CUT_88C
856-[    2.693197] fbcon: psbdrmfb (fb0) is primary device
857:[    2.697204] rtl8192ce: Using firmware rtlwifi/rtl8192cfwU_B.bin
858-[    2.700363] modprobe (109) used greatest stack depth: 3928 bytes left
859-[    2.700499] usb 5-2: skipped 1 descriptor after interface
860-[    2.700506] usb 5-2: skipped 1 descriptor after interface
861-[    2.705486] usb 5-2: default language 0x0409
--
889-[    3.149779] gma500 0000:00:02.0: fb0: psbdrmfb frame buffer device
890-[    3.149784] gma500 0000:00:02.0: registered panic notifier
891-[    3.149870] [drm] Initialized gma500 1.0.0 2011-06-06 for 
0000:00:02.0 on minor 0
892-[    3.403646] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
893:[    3.404050] rtlwifi: wireless switch is on
894-[    5.579389] Adding 16777212k swap on /dev/sda6.  Priority:42 
extents:1 across:16777212k
895-[    5.595963] Adding 16777212k swap on /dev/sda7.  Priority:52 
extents:1 across:16777212k
896-[    5.611337] Adding 16777212k swap on /dev/sda8.  Priority:62 
extents:1 across:16777212k
897-[    5.699807] rm (146) used greatest stack depth: 3032 bytes left

+ lsmod
Module                  Size  Used by
rtl8192ce              72128  0
gma500_gfx            147187  1
rtlwifi               106604  1 rtl8192ce
rtl8192c_common        54252  1 rtl8192ce
drm_kms_helper         27871  1 gma500_gfx

+ iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

sit0      no wireless extensions.

wlan1     IEEE 802.11bgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Encryption key:off
           Power Management:on


+ iw dev wlan1 info
Interface wlan1
	ifindex 4
	wdev 0x1
	addr 64:5a:04:aa:f8:16
	type managed
	wiphy 0

**** Here is the first occurrence of the blocking error condition:

+ iw dev wlan1 set channel 2
command failed: Device or resource busy (-16)

**** Next error is expected:

+ iw dev wlan1 scan
command failed: Network is down (-100)

+ ip link set up wlan1

+ iw dev wlan1 scan
BSS d8:6c:e9:29:e5:75(on wlan1)
	TSF: 1305304974530 usec (15d, 02:35:04)
	freq: 2412
... bla bla bla
		 * Device name: RalinkAPS
		 * Config methods: Label, PBC
		 * RF Bands: 0x1

+ iwlist wlan1 scanning
wlan1     Scan completed :
           Cell 01 - Address: D8:6C:E9:29:E5:75
                     Channel:1
                     Frequency:2.412 GHz (Channel 1)
                     Quality=70/70  Signal level=-4 dBm
... bla bla bla
                     IE: Unknown: 0706434120010B10


**** Here is another instance of the blocking error condition (occurs 
with iw as well):

+ iwconfig wlan1 channel 2
Error for wireless request "Set Frequency" (8B04) :
     SET failed on device wlan1 ; Device or resource busy.

**** Some user of a widespread distribution reported a similar problem 
and a work-around with the "iw ... interface add .." command, which I 
attempt here:

+ ip link set down wlan1

+ iw dev wlan1 interface add wlan2 type managed

**** note that I don't care that the name wlan2 turns into rename5 
because it did not occur without CONFIG_CFG82011_WEXT which is useless 
besides the present troubleshooting:

+ iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

sit0      no wireless extensions.

wlan1     IEEE 802.11bgn  ESSID:off/any
           Mode:Managed  Frequency:2.417 GHz  Access Point: 
Not-Associated
           Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Encryption key:off
           Power Management:off

rename5   IEEE 802.11bgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Encryption key:off
           Power Management:on

**** Too bad it occurs again:

+ iw dev rename5 set channel 2
command failed: Device or resource busy (-16)


==============

Final remarks:

I went through the firmware load learning curve for a Linux 
user/integrator and I am confident that the following sha1sum'ed file 
has been loaded:
c81ec289a236875ab7139c0e357fdcddcc21cc46 
/lib/firmware/rtlwifi/rtl8192cfwU_B.bin
(the fact that scanning works supports my confidence)

I investigated the iw source code (version 3.11, but the above is with 
version 3.14) and I gave up once I traced the reported error condition 
to the call to nl_recvmsgs in the iw.c source file.

I grep'ed EBUSY in the C source files in the drivers/net/rtlwifi 
sub-directories and find none. I suppose some other component in the 
driver detects the error condition.

If I recall correctly, the command "iw ... interface add ..." followed 
by "iw ... del" for the source interface allowed me to set the channel 
without the EBUSY outcome once (and the sticky EBUSY came again vey 
soon) with the kernel devoid of CONFIG_CFG82011_WEXT. It makes seldom 
sense to me to pursue this elusive workaround, but this could be a sign 
that a fresh kernel "interface" data structure turns EBUSY-sick after 
some action occurring in the driver initialization logic.

The system is a Shuttle XS36VL box 
(http://us.shuttle.com/barebone/Models/XS36VL.html). It does not have a 
physical wireless switch (a dmesg line above reports the switch position 
as "on").

Any suggestion about a next step in troubleshooting? Maybe trying the 
latest kernel release candidate?

Thanks for your attention.

-- Thierry Moreau
