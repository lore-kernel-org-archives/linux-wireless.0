Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173013pub.verizon.net ([206.46.173.13]:40577 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab2CFCWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 21:22:53 -0500
Received: from vms170015 ([unknown] [172.18.12.133]) by vms173013.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0F002ALYLGGLK3@vms173013.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Mon, 05 Mar 2012 20:22:28 -0600 (CST)
Date: Mon, 05 Mar 2012 20:22:28 -0600 (CST)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <31698868.2383065.1331000548495.JavaMail.root@vms170015> (sfid-20120306_032256_894020_5477D86B)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 03/05/12, Larry Finger wrote:

>> On 03/05/2012 11:07 AM, alupu@verizon.net wrote:
>> System: (B)LFS i686-pc-linux-gnu, 3.2.9
>> Rosewill Wireless Adapter: RNX-N180UBE
>> I compiled (as part of kernel 3.2.9) the r8712u module.
>> Comes up OK but cannot take an essid nor a key.
>> ...

> There are a couple of bugs in 3.2.6+.
> I don't think they have been fixed by 3.2.9.
> Check dmesg for a "Badfw size" message.
> If you see that, the two attached patches will fix that.

Hi Larry,
Thank you for the patches.
Unfortunately, no cigar:

<After kernel re-compile>
usb 8-1: new high-speed USB device number 2 using ehci_hcd
r8712u: module is from the staging directory, the quality is unknown,
 you have been warned.
r8712u: DriverVersion: v7_0.20100831
r8712u: register rtl8712_netdev_ops to netdev_ops
r8712u: USB_SPEED_HIGH with 4 endpoints
r8712u: Boot from EFUSE: Autoload OK
r8712u: CustomerID = 0x0000
r8712u: MAC Address from efuse = 00:1a:ef:25:2d:f9
r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
usbcore: registered new interface driver r8712u
r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
usb 8-1: USB disconnect, device number 2


NOTE: I haven't seen any "Badfw size" message.
            I applied the patches, hope against hope.
            (maybe, as a side effect, it can fix my problem)
------
iwconfig
lo         no wireless extensions.

wlan0 unassociated Nickname:"rtl_wifi"
 Mode:Auto Access Point: Not-Associated Sensitivity:0/0
 Retry:off RTS thr:off Fragment thr:off
 Encryption key:off
 Power Management:off
 Link Quality:0 Signal level:0 Noise level:0
 Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
 Tx excessive retries:0 Invalid misc:0 Missed beacon:0



eth0  no wireless extensions.
------
iwconfig wlan0 essid <ESSIS>  key restricted <Encryption Key>

r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED


iwconfig wlan0
wlan0 unassociated Nickname:"rtl_wifi"
 Mode:Auto Access Point: Not-Associated Sensitivity:0/0
 Retry:off RTS thr:off Fragment thr:off
 Encryption key:off
 Power Management:off
 Link Quality:0 Signal level:0 Noise level:0
 Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
 Tx excessive retries:0 Invalid misc:0 Missed beacon:0
NOTE: 'iwconfig wlan0 essid ' and 'iwconfig wlan0 key restricted '
 can be tried separately, with or without double quotes
 (for the particular ESSID or KEY), with the same failed result.
------
iwconfig wlan0 Mode managed
iwconfig wlan0
wlan0 unassociated Nickname:"rtl_wifi"
 Mode:Managed Access Point: Not-Associated Sensitivity:0/0
 Retry:off RTS thr:off Fragment thr:off
 Encryption key:off
 Power Management:off
 Link Quality:0 Signal level:0 Noise level:0
 Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
 Tx excessive retries:0 Invalid misc:0 Missed beacon:0
------
Any idea what's happening?
Thanks,
-- Alex
---------------------------------------------------
For reference:
[/linux-3.2.9/drivers/staging/rtl8712]$ ls -og os_intfs.c* usb_intf.c*
-rw-rw-r-- 1 15584 2012-03-05 19:25 os_intfs.c
-rw-rw-r-- 1 15781 2012-02-29 19:32 os_intfs.c-orig
-rw-rw-r-- 1 18798 2012-03-05 19:25 usb_intf.c
-rw-rw-r-- 1 18609 2012-02-29 19:32 usb_intf.c-orig
------
[/linux-3.2.9/drivers/staging/rtl8712]$ diff os_intfs.c os_intfs.c.orig
478a479,483
> /* The interface is no longer Up: */
> padapter->bup = false;
> release_firmware(padapter->fw);
> /* never exit with a firmware callback pending */
> wait_for_completion(&padapter->rtl8712_fw_ready);
------
[/linux-3.2.9/drivers/staging/rtl8712]$ diff usb_intf.c usb_intf.c.orig
33d32
< #include 

625,628d623
< if (padapter->fw_found)
< release_firmware(padapter->fw);
< /* never exit with a firmware callback pending */
< wait_for_completion(&padapter->rtl8712_fw_ready);
