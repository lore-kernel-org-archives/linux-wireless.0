Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:57532 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbaCFOyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 09:54:44 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Thierry Moreau <thierry.moreau@connotech.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning works
Date: Thu, 06 Mar 2014 15:54:33 +0100
Message-ID: <2046728.MUZsZig9to@al> (sfid-20140306_155448_795244_EE1C31C8)
In-Reply-To: <531777F8.5060506@connotech.com>
References: <5316C602.8020504@connotech.com> <53175368.50009@lwfinger.net> <531777F8.5060506@connotech.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1978620.a9UpGo5cjN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1978620.a9UpGo5cjN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 05 March 2014 19:16:08 Thierry Moreau wrote:
> On 03/05/14 16:40, Larry Finger wrote:
> > Please give me the exact set of commands you use to get this problem. If
> > possible, capture the console output. As I am currently running
> > long-term tests of the latest version of rtl8192ce using an RTL8188CE
> > (10ec:8176), it will be a perfect time to test.
> 
> Here is the command script, and the console log
> (....sh 2>&1 | tee ....log)

Instead of cat, I used single-second sleeps as can be seen in the attached 
script. Our logs are roughly the same (I have replaced the last three bytes of 
the MAC address by XX for privacy). The rtlwifi module is patched[1], hence 
the out-of-tree marking.

What is the problem that you are experiencing? I am able to connect although 
it took half a minute for the first ICMP ping packets to pass (and then there 
is still a lot of packet loss). This pattern is observable on the past 2.5 
weeks that I have been running ping tests (ping every second to the gateway).

> Is it possible that the Shuttle system be arranged with a digital output
> enabling/inhibiting the Realtek wifi interface active participation in
> wifi protocol?

I didn't understand the first part, are you referring to a possible mistake in 
attaching the antennas? When I opened up the case, I saw two antennas that 
were properly secured to the card.

Regards,
Peter

 [1]: http://lkml.org/lkml/2014/2/14/430

--nextPart1978620.a9UpGo5cjN
Content-Disposition: attachment; filename="repro-shuttle.sh"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="repro-shuttle.sh"

#!/bin/bash
set -x
iface=wlan0
uname -a
dmesg | grep -i wifi -C 4 -n
lsmod
sleep 1
iwconfig
sleep 1
iw dev $iface info
sleep 1
iw dev $iface set channel 2
sleep 1
iw dev $iface scan
sleep 1
ip link set up $iface
sleep 1
iw dev $iface scan
sleep 1
iwlist $iface scanning
sleep 1
iwconfig $iface channel 2
sleep 1
ip link set down $iface
sleep 1
iw dev $iface interface add wlan2 type managed
sleep 1
iwconfig
sleep 1
iw dev wlan2 set channel 2
sleep 1

--nextPart1978620.a9UpGo5cjN
Content-Disposition: attachment; filename="repro.txt"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="repro.txt"

Script started on Thu 06 Mar 2014 02:43:56 PM CET
+ iface=3Dwlan0=0D
+ uname -a=0D
Linux work 3.14.0-rc2-custom-00267-g9398a10 #4 SMP PREEMPT Wed Feb 12 2=
0:41:43 CET 2014 x86_64 GNU/Linux=0D
+ dmesg=0D
+ grep -i wifi -C 4 -n=0D
1125-[   11.401304] [drm] No driver support for vblank timestamp query.=
=0D
1126-[   11.514185] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip V=
ersion ID: B_CUT_88C=0D
1127-[   11.526221] rtl8192ce: rtl8192ce: Power Save off (module option=
)=0D
1128-[   11.526222] rtl8192ce: rtl8192ce: FW Power Save off (module opt=
ion)=0D
1129:[   11.526242] rtl8192ce: Using firmware rtlwifi/rtl8192cfwU_B.bin=
=0D
1130-[   11.604096] systemd[1]: Received SIGCHLD from PID 137 (systemd-=
vconsol).=0D
1131-[   11.612617] systemd[1]: Got SIGCHLD for process 137 (systemd-vc=
onsol)=0D
1132-[   11.621165] systemd[1]: Child 137 died (code=3Dexited, status=3D=
0/SUCCESS)=0D
1133-[   11.629346] systemd[1]: Child 137 belongs to systemd-vconsole-s=
etup.service=0D
--=0D
1148-[   11.839624] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz)=
, (N/A, 2000 mBm)=0D
1149-[   11.855677] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz)=
, (N/A, 2000 mBm)=0D
1150-[   11.871911] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 =
KHz), (N/A, 0 mBm)=0D
1151-[   11.888513] ieee80211 phy0: Selected rate control algorithm 'rt=
l_rc'=0D
1152:[   11.897674] rtlwifi: wireless switch is on=0D
1153-[   11.908296] systemd[1]: sys-subsystem-net-devices-wlan0.device =
changed dead -> plugged=0D
1154-[   11.911950] input: HDA Intel HDMI/DP,pcm=3D3 as /devices/pci000=
0:00/0000:00:1b.0/sound/card0/input10=0D
1155-[   11.913175] input: HDA Intel Front Headphone as /devices/pci000=
0:00/0000:00:1b.0/sound/card0/input9=0D
1156-[   11.915407] input: HDA Intel Mic as /devices/pci0000:00/0000:00=
:1b.0/sound/card0/input8=0D
--=0D
1577-[   16.885077] systemd[1]: Got D-Bus request: org.freedesktop.DBus=
.Local.Disconnected() on /org/freedesktop/DBus/Local=0D
1578-[   16.890932] ------------[ cut here ]------------=0D
1579-[   16.890944] WARNING: CPU: 2 PID: 134 at /home/peter/linux/kerne=
l/locking/mutex.c:516 __mutex_lock_slowpath+0x357/0x370()=0D
1580-[   16.890947] DEBUG_LOCKS_WARN_ON(in_interrupt())=0D
1581:[   16.891013] Modules linked in: xt_tcpudp nf_conntrack_ipv6 nf_c=
onntrack_ipv4 nf_defrag_ipv4 nf_defrag_ipv6 xt_conntrack nf_conntrack i=
ptable_filter ip6table_filter ip_tables ip6_tables x_tables snd_hda_cod=
ec_hdmi arc4 snd_hda_codec_idt snd_hda_codec_generic rtl8192ce(O) rtl_p=
ci(O) gma500_gfx rtlwifi(O) mac80211 snd_hda_intel i2c_algo_bit drm_kms=
_helper snd_hda_codec snd_hwdep drm cfg80211 snd_pcm snd_timer snd evde=
v r8169 pcspkr iTCO_wdt i2c_i801 i2c_core iTCO_vendor_support video rfk=
ill rtl8192c_common(O) coretemp microcode lpc_ich rtsx_pci_ms mii memst=
ick soundcore fan processor thermal button ext4 crc16 mbcache jbd2 hid_=
logitech_dj usbhid hid sd_mod rtsx_pci_sdmmc mmc_core ahci libahci liba=
ta scsi_mod ehci_pci uhci_hcd ehci_hcd usbcore usb_common rtsx_pci mfd_=
core=0D
1582-[   16.891018] CPU: 2 PID: 134 Comm: systemd-journal Tainted: G   =
        O 3.14.0-rc2-custom-00267-g9398a10 #4=0D
1583-[   16.891019] Hardware name: Shuttle Inc. XS36V/XS36V, BIOS 1.11 =
12/18/2012=0D
1584-[   16.891026]  0000000000000009 ffff88012fd03bf0 ffffffff8146cca0=
 ffff88012fd03c38=0D
1585-[   16.891030]  ffff88012fd03c28 ffffffff8104c45d ffff880037945818=
 ffff880037945818=0D
+ lsmod=0D
Module                  Size  Used by=0D
xt_tcpudp               3111  1 =0D
nf_conntrack_ipv6       7995  1 =0D
nf_conntrack_ipv4       7754  1 =0D
nf_defrag_ipv4          1403  1 nf_conntrack_ipv4=0D
nf_defrag_ipv6         25934  1 nf_conntrack_ipv6=0D
xt_conntrack            3265  2 =0D
nf_conntrack           66712  3 xt_conntrack,nf_conntrack_ipv4,nf_connt=
rack_ipv6=0D
iptable_filter          1488  1 =0D
ip6table_filter         1428  1 =0D
ip_tables              16451  1 iptable_filter=0D
ip6_tables             16160  1 ip6table_filter=0D
x_tables               17522  6 ip6table_filter,ip_tables,xt_tcpudp,xt_=
conntrack,iptable_filter,ip6_tables=0D
snd_hda_codec_hdmi     36172  1 =0D
arc4                    2000  2 =0D
snd_hda_codec_idt      43450  1 =0D
snd_hda_codec_generic    52827  1 snd_hda_codec_idt=0D
rtl8192ce              73667  0 =0D
rtl_pci                24976  1 rtl8192ce=0D
gma500_gfx            174510  1 =0D
rtlwifi                71601  2 rtl_pci,rtl8192ce=0D
mac80211              490444  3 rtl_pci,rtlwifi,rtl8192ce=0D
snd_hda_intel          34841  0 =0D
i2c_algo_bit            5391  1 gma500_gfx=0D
drm_kms_helper         35572  1 gma500_gfx=0D
snd_hda_codec          98879  4 snd_hda_codec_hdmi,snd_hda_codec_idt,sn=
d_hda_codec_generic,snd_hda_intel=0D
snd_hwdep               5852  1 snd_hda_codec=0D
drm                   237941  2 drm_kms_helper,gma500_gfx=0D
cfg80211              430184  2 mac80211,rtlwifi=0D
snd_pcm                80379  3 snd_hda_codec_hdmi,snd_hda_codec,snd_hd=
a_intel=0D
snd_timer              18709  1 snd_pcm=0D
snd                    51167  8 snd_hwdep,snd_timer,snd_hda_codec_hdmi,=
snd_hda_codec_idt,snd_pcm,snd_hda_codec_generic,snd_hda_codec,snd_hda_i=
ntel=0D
evdev                  10981  4 =0D
r8169                  58223  0 =0D
pcspkr                  1995  0 =0D
iTCO_wdt                5407  0 =0D
i2c_i801               11109  0 =0D
i2c_core               23780  5 drm,i2c_i801,drm_kms_helper,i2c_algo_bi=
t,gma500_gfx=0D
iTCO_vendor_support     1929  1 iTCO_wdt=0D
video                  11540  1 gma500_gfx=0D
rfkill                 15683  1 cfg80211=0D
rtl8192c_common        55112  1 rtl8192ce=0D
coretemp                6390  0 =0D
microcode              15090  0 =0D
lpc_ich                13368  0 =0D
rtsx_pci_ms             7418  0 =0D
mii                     4027  1 r8169=0D
memstick                7504  1 rtsx_pci_ms=0D
soundcore                944  1 snd=0D
fan                     2785  0 =0D
processor              24170  0 =0D
thermal                 8556  0 =0D
button                  4477  0 =0D
ext4                  481304  4 =0D
crc16                   1359  1 ext4=0D
mbcache                 6074  1 ext4=0D
jbd2                   82736  1 ext4=0D
hid_logitech_dj        10599  0 =0D
usbhid                 40843  0 =0D
hid                    89807  2 usbhid,hid_logitech_dj=0D
sd_mod                 31817  5 =0D
rtsx_pci_sdmmc         13924  0 =0D
mmc_core               95817  1 rtsx_pci_sdmmc=0D
ahci                   23403  4 =0D
libahci                21484  1 ahci=0D
libata                172031  2 ahci,libahci=0D
scsi_mod              132830  2 libata,sd_mod=0D
ehci_pci                3960  0 =0D
uhci_hcd               33795  0 =0D
ehci_hcd               63800  1 ehci_pci=0D
usbcore               180840  4 uhci_hcd,ehci_hcd,ehci_pci,usbhid=0D
usb_common              1648  1 usbcore=0D
rtsx_pci               32831  2 rtsx_pci_ms,rtsx_pci_sdmmc=0D
mfd_core                3249  2 lpc_ich,rtsx_pci=0D
+ sleep 1=0D
+ iwconfig=0D
eth0      no wireless extensions.=0D
=0D
lo        no wireless extensions.=0D
=0D
wlan0     IEEE 802.11bgn  ESSID:off/any  =0D
          Mode:Managed  Access Point: Not-Associated   Tx-Power=3D0 dBm=
   =0D
          Retry short limit:7   RTS thr=3D2347 B   Fragment thr:off=0D
          Encryption key:off=0D
          Power Management:on=0D
          =0D
+ sleep 1=0D
+ iw dev wlan0 info=0D
Interface wlan0=0D
=09ifindex 3=0D
=09wdev 0x1=0D
=09addr e0:91:53:XX:XX:XX=0D
=09type managed=0D
=09wiphy 0=0D
+ sleep 1=0D
+ iw dev wlan0 set channel 2=0D
command failed: Device or resource busy (-16)=0D
+ sleep 1=0D
+ iw dev wlan0 scan=0D
command failed: Network is down (-100)=0D
+ sleep 1=0D
+ ip link set up wlan0=0D
+ sleep 1=0D
+ iw dev wlan0 scan=0D
BSS 48:f9:25:00:01:13(on wlan0)=0D
=09TSF: 10820542146 usec (0d, 03:00:20)=0D
=09freq: 2472=0D
=09beacon interval: 100 TUs=0D
=09capability: ESS ShortPreamble ShortSlotTime (0x0421)=0D
=09signal: -54.00 dBm=0D
=09last seen: 26 ms ago=0D
=09Information elements from Probe Response frame:=0D
=09SSID: Hermes_Mobile_Hotspot=0D
=09Supported rates: 1.0* 2.0 5.5 11.0 =0D
=09DS Parameter set: channel 13=0D
+ sleep 1=0D
+ iwlist wlan0 scanning=0D
wlan0     Scan completed :=0D
          Cell 01 - Address: 48:F9:25:00:01:13=0D
                    Channel:13=0D
                    Frequency:2.472 GHz (Channel 13)=0D
                    Quality=3D56/70  Signal level=3D-54 dBm  =0D
                    Encryption key:off=0D
                    ESSID:"Hermes_Mobile_Hotspot"=0D
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s=0D
                    Mode:Master=0D
                    Extra:tsf=3D0000000284f45ec2=0D
                    Extra: Last beacon: 1943ms ago=0D
                    IE: Unknown: 00154865726D65735F4D6F62696C655F486F74=
73706F74=0D
                    IE: Unknown: 010482040B16=0D
                    IE: Unknown: 03010D=0D
                    IE: Unknown: DD2A000C42000000011E001000000066160500=
004C563132333437000000000000000000000000000502A809=0D
=0D
+ sleep 1=0D
+ iwconfig wlan0 channel 2=0D
Error for wireless request "Set Frequency" (8B04) :=0D
    SET failed on device wlan0 ; Device or resource busy.=0D
+ sleep 1=0D
+ ip link set down wlan0=0D
+ sleep 1=0D
+ iw dev wlan0 interface add wlan2 type managed=0D
+ sleep 1=0D
+ iwconfig=0D
wlan2     IEEE 802.11bgn  ESSID:off/any  =0D
          Mode:Managed  Access Point: Not-Associated   Tx-Power=3D20 dB=
m   =0D
          Retry short limit:7   RTS thr=3D2347 B   Fragment thr:off=0D
          Encryption key:off=0D
          Power Management:on=0D
          =0D
eth0      no wireless extensions.=0D
=0D
lo        no wireless extensions.=0D
=0D
wlan0     IEEE 802.11bgn  ESSID:off/any  =0D
          Mode:Managed  Frequency:2.417 GHz  Access Point: Not-Associat=
ed   =0D
          Tx-Power=3D20 dBm   =0D
          Retry short limit:7   RTS thr=3D2347 B   Fragment thr:off=0D
          Encryption key:off=0D
          Power Management:off=0D
          =0D
+ sleep 1=0D
+ iw dev wlan2 set channel 2=0D
command failed: Device or resource busy (-16)=0D
+ sleep 1=0D
=0D
real=090m15.794s=0D
user=090m0.137s=0D
sys=090m0.417s=0D

Script done on Thu 06 Mar 2014 02:44:12 PM CET

--nextPart1978620.a9UpGo5cjN--

