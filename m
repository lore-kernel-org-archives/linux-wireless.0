Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173021pub.verizon.net ([206.46.173.21]:64744 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964983Ab2CGBoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 20:44:19 -0500
Received: from vznit170116 ([unknown] [172.18.12.133])
 by vms173021.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0H00FQXRHUSAF0@vms173021.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 06 Mar 2012 19:44:19 -0600 (CST)
Date: Tue, 06 Mar 2012 19:44:18 -0600 (CST)
From: alupu@verizon.net
To: linux-wireless@vger.kernel.org
Message-id: <27428618.2937387.1331084658879.JavaMail.root@vznit170116> (sfid-20120307_024423_681688_F0D6257B)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: multipart/mixed;
 boundary="----=_Part_2937386_30091176.1331084658824"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2937386_30091176.1331084658824
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

 
 

 > On 03/06/12, Larry Finger wrote:



>> On 03/05/2012 08:22 PM, Alex wrote:


>>> On 03/05/2012, Larry Finger wrote:


>>>> On 03/05/2012 11:07 AM, Alex wrote:
>>>> System: (B)LFS i686-pc-linux-gnu, 3.2.9
>>>> Rosewill Wireless Adapter: RNX-N180UBE
>>>> I compiled (as part of kernel 3.2.9) the r8712u module.
>>>> Comes up OK but cannot take an essid nor a key.


>>> There are a couple of bugs in 3.2.6+.
>>> I don't think they have been fixed by 3.2.9.
>>> Check dmesg for a "Badfw size" message.
>>> If you see that, the two attached patches will fix that.


>> Hi Larry,
>> Thank you for the patches.
>> Unfortunately, no cigar: <same problem>


> I tested your iwconfig statement using kernel 3.3-rc5. It worked.
> Then I downloaded a fresh copy of 3.2.9 and built it. It also worked.
> I have no idea what is wrong on your system, but it appears not to be
> the kernel, but something in your user-space tools.
> My tests were done with openSUSE 12.1.
Hi Larry,


I re-installed "wireless-tools.29" (just in case).
Same problems as before (doesn't take essid, nor key), i.e.,
the module doesn't work here.
FWIW, I'll be attaching highlights of the latest tests.


I don't know why on your system (openSUSE) the module/tools work
while on mine (BLFS) they don't.


As opposed to "distributions", a BLFS is a system not installed but
built "by hand", so the owner feels they have more control and know
what's under the hood better.
See: <www.linuxfromscratch.org>
My subject system has been working just fine for years now:
ASUS P5E-VM HDMI, Intel E8400, 3.0 GHz, 4 GB, G35/ICH9R, SATA


REFERENCES - so we can compare notes:
[~]$ uname -a
Linux AlexLFS 3.2.9 #1 SMP Mon Mar 5 20:16:46 EST 2012 i686 i686 i386
 GNU/Linux


wireless_tools.29.tar.gz
md5sum: e06c222e186f7cc013fd272d023710cb
Unprivileged: make
Privileged: make PREFIX=/usr INSTALL_MAN=/usr/share/man install


[~]$ iwconfig --version
iwconfig Wireless-Tools version 29
 Compatible with Wireless Extension v11 to v22.


Kernel Currently compiled with Wireless Extension v22.


wlan0 Recommend Wireless Extension v16 or later,
 Currently compiled with Wireless Extension v22.


[~]$ ls -ogtr /usr/sbin
...
-rwxr-xr-x 1 12386 2012-03-06 17:26 iwspy
-rwxr-xr-x 1 13122 2012-03-06 17:26 iwpriv
-rwxr-xr-x 1 29122 2012-03-06 17:26 iwlist
-rwxr-xr-x 1 11863 2012-03-06 17:26 iwgetid
-rwxr-xr-x 1 16105 2012-03-06 17:26 iwevent
-rwxr-xr-x 1 23263 2012-03-06 17:26 iwconfig
-rwxr-xr-x 1 26473 2012-03-06 17:26 ifrename


[~]$ ls -ogtr /usr/lib 
...
-rwxr-xr-x 1 27702 2012-03-06 17:26 libiw.so.29
lrwxrwxrwx 1 11 2012-03-06 17:26 libiw.so -> libiw.so.29


[~]$ modinfo r8712u
filename: /lib/modules/3.2.9/kernel/drivers/staging/rtl8712/r8712u.ko
firmware: rtlwifi/rtl8712u.bin
author: Larry Finger
description: rtl871x wireless lan driver
license: GPL
alias: ...
depends: usbcore
staging: Y
intree: Y
vermagic: 3.2.9 SMP mod_unload CORE2 
parm: ...


[~]$ ls -l /lib/firmware/rtlwifi
-rw-r--r-- 1 alex users 129304 2012-03-04 15:42 rtl8712u.bin


Thank you for your help. We'll make it work sooner or later.
-- Alex




------=_Part_2937386_30091176.1331084658824
Content-Type: text/plain; charset=us-ascii; name=rtl8712_3.1.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=rtl8712_3.1.txt

usb 2-6: new high-speed USB device number 3 using ehci_hcd
r8712u: DriverVersion: v7_0.20100831
r8712u: register rtl8712_netdev_ops to netdev_ops
r8712u: USB_SPEED_HIGH with 4 endpoints
r8712u: Boot from EFUSE: Autoload OK
r8712u: CustomerID = 0x0000
r8712u: MAC Address from efuse = 00:1a:ef:25:2d:f9
r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
------
[~]$ ifconfig wlan0 up
r8712u: 1 RCR=0x153f00e
r8712u: 2 RCR=0x553f00e
ADDRCONF(NETDEV_UP): wlan0: link is not ready
------
[~]$ ls -og /proc/net/wireless
-r--r--r-- 1 0 2012-03-06 18:02 /proc/net/wireless
[~]$ cat /proc/net/wireless
Inter-| sta-|   Quality        |   Discarded packets               | Missed |
WE face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon
| 22 wlan0: 0000    0.    0.    0.       0      0      0      0      0
0
------
[~]$ ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:1A:EF:25:2D:F9
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
------
[~]$ iwconfig wlan0 essid "Alex" ; echo $?
0
[~]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~]$ iwconfig wlan0 essid Alex ; echo $?
0
[~]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~]$ iwconfig wlan0 key restricted 123456789ABCDEF123456789AB ; echo $?
r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
0
------
[~]$ ifconfig wlan0 down
[~]$ ifconfig
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

[~]$ iwconfig wlan0 key restricted 123456789ABCDEF123456789AB ; echo $?
r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
0
[~]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~]$ iwconfig wlan0 essid Alex ; echo $?
0
[~]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~]$ iwconfig wlan0 key 123456789ABCDEF123456789AB ; echo $?
0
[~]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~]$ usb 2-6: USB disconnect, device number 3

------=_Part_2937386_30091176.1331084658824--
