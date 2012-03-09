Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:56011 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031375Ab2CIUGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 15:06:18 -0500
Received: from vms170029 ([unknown] [192.168.1.3]) by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0M007BNT2AJ121@vms173007.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Fri, 09 Mar 2012 13:06:11 -0600 (CST)
Date: Fri, 09 Mar 2012 13:06:10 -0600 (CST)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <30444020.391741.1331319970885.JavaMail.root@vms170029> (sfid-20120309_210627_620036_E0910B30)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: multipart/mixed;
 boundary="----=_Part_391739_19625791.1331319970691"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_391739_19625791.1331319970691
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

 > On 03/07/12 11:16 AM, Larry Finger wrote:
 
> To help debug the problem, the attached patch will log the setting of
> the ESSID in the driver.
> For some reason, there is one garbage printout and the correct 
> one for every call, but that should not cause a problem.

Hi Larry,

I applied the "debug" patch you sent and I followed your test instructions.
Still, the same problem.
Moreover I didn't see any debug output; maybe I'm missing something.
The log of my test is attached.

Regards,
-- Alex


------=_Part_391739_19625791.1331319970691
Content-Type: text/plain; charset=us-ascii; name=temp3.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=temp3.txt

[/linux-3.2.9/drivers/staging/rtl8712]$ ls -og rtl871x_ioctl_linux*
-rw-rw-r-- 1  70837 2012-03-09 12:58 rtl871x_ioctl_linux.c
-rw-rw-r-- 1  70549 2012-02-29 19:32 rtl871x_ioctl_linux.c-orig
-rw-r--r-- 1 237684 2012-03-09 13:11 rtl871x_ioctl_linux.o
------
[/linux-3.2.9/drivers/staging/rtl8712]$ diff rtl871x_ioctl_linux.c-orig \
 rtl871x_ioctl_linux.c

1296c1296,1297
< 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
---
> 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
> 		printk(KERN_INFO "*********** in %s - Returned -EBUSY\n", __func__);
1298c1299,1301
< 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))
---
> 	}
> 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING)) {
> 		printk(KERN_INFO "*********** in %s - Returned 0\n", __func__);
1300c1303,1305
< 	if (wrqu->essid.length > IW_ESSID_MAX_SIZE)
---
> 	}
> 	if (wrqu->essid.length > IW_ESSID_MAX_SIZE) {
> 		printk(KERN_INFO "*********** in %s - Returned -E2BIG\n", __func__);
1301a1307
> 	}
1340a1347
> 		printk(KERN_INFO "r8712u: Set ESSID to %s\n", ndis_ssid.Ssid);

-----------------------------------------------------------------
[~/Temp]$ iwconfig --version
iwconfig  Wireless-Tools version 29
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.
------
usb 8-1: new high-speed USB device number 2 using ehci_hcd
r8712u: module is from the staging directory, the quality is unknown, you have
been warned.
r8712u: DriverVersion: v7_0.20100831
r8712u: register rtl8712_netdev_ops to netdev_ops
r8712u: USB_SPEED_HIGH with 4 endpoints
r8712u: Boot from EFUSE: Autoload OK
r8712u: CustomerID = 0x0000
r8712u: MAC Address from efuse = 00:1a:ef:25:2d:f9
r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
usbcore: registered new interface driver r8712u
------
[~/Temp]$ iwconfig --version
iwconfig  Wireless-Tools version 29
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan0     Recommend Wireless Extension v16 or later,
          Currently compiled with Wireless Extension v22.
------
[~/Temp]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~/Temp]$ iwconfig wlan0 essid radius
r8712u: Set ESSID to radius
------
[~/Temp]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
[~/Temp]$ iwconfig wlan0 key restricted 1234f0033edaebf3f7dab4ceca
r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
------
[~/Temp]$ iwconfig wlan0
wlan0     unassociated  Nickname:"rtl_wifi"
          Mode:Auto  Access Point: Not-Associated   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
------
Excerpt from 'dmesg':
usb 8-1: new high-speed USB device number 2 using ehci_hcd
r8712u: module is from the staging directory, the quality is unknown, you have
been warned.
r8712u: DriverVersion: v7_0.20100831
r8712u: register rtl8712_netdev_ops to netdev_ops
r8712u: USB_SPEED_HIGH with 4 endpoints
r8712u: Boot from EFUSE: Autoload OK
r8712u: CustomerID = 0x0000
r8712u: MAC Address from efuse = 00:1a:ef:25:2d:f9
r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
usbcore: registered new interface driver r8712u
r8712u: Set ESSID to radius
r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
------
Tail of 'kern.log':
Mar  9 13:23:25 AlexLFS kernel: usb 8-1: new high-speed USB device number 2
using ehci_hcd
Mar  9 13:23:25 AlexLFS kernel: r8712u: module is from the staging directory,
the quality is unknown, you have been warned.
Mar  9 13:23:25 AlexLFS kernel: r8712u: DriverVersion: v7_0.20100831
Mar  9 13:23:25 AlexLFS kernel: r8712u: register rtl8712_netdev_ops to
netdev_ops
Mar  9 13:23:25 AlexLFS kernel: r8712u: USB_SPEED_HIGH with 4 endpoints
Mar  9 13:23:25 AlexLFS kernel: r8712u: Boot from EFUSE: Autoload OK
Mar  9 13:23:25 AlexLFS kernel: r8712u: CustomerID = 0x0000
Mar  9 13:23:25 AlexLFS kernel: r8712u: MAC Address from efuse =
00:1a:ef:25:2d:f9
Mar  9 13:23:25 AlexLFS kernel: r8712u: Loading firmware from
"rtlwifi/rtl8712u.bin"
Mar  9 13:23:25 AlexLFS kernel: usbcore: registered new interface driver
r8712u
Mar  9 13:26:48 AlexLFS kernel: r8712u: Set ESSID to radius
Mar  9 13:29:59 AlexLFS kernel: r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
Mar  9 13:42:39 AlexLFS kernel: usb 8-1: USB disconnect, device number 2

------=_Part_391739_19625791.1331319970691--
