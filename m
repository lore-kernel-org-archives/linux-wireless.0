Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33496 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbcB2G5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 01:57:23 -0500
Received: by mail-ob0-f175.google.com with SMTP id jq7so125894894obb.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 22:57:23 -0800 (PST)
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <loom.20160128T003525-188@post.gmane.org>
 <wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
 <wrfjd1scmkz6.fsf@redhat.com> <wrfj60xxd2f5.fsf@redhat.com>
 <56BA8E5D.5090402@lwfinger.net> <wrfjlh6tb9zt.fsf@redhat.com>
 <CAOhKHAXH-PCyWQSpuuZ=-6BnE0PeDks-4p9A3G_86OHLfEdU=w@mail.gmail.com>
 <56BB5C16.8070206@lwfinger.net> <wrfjk2lomobj.fsf@redhat.com>
Cc: dsadsa sadsad <natserver2@gmail.com>,
	linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56D3EBCF.7000206@lwfinger.net> (sfid-20160229_075737_980375_15780EBA)
Date: Mon, 29 Feb 2016 00:57:19 -0600
MIME-Version: 1.0
In-Reply-To: <wrfjk2lomobj.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2016 05:01 PM, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> On 02/10/2016 06:01 AM, dsadsa sadsad wrote:
>>> So do i have to patch and recompile or not?
>>
>> It will not change a thing for the AWUS036NHR. It will fix a bug in
>> 1T2R devices.
>
> After pulling my hairs out over this one for days (if not weeks), I
> think I finally figured it out.
>
> I just pushed a patch into the rtl8xxxu-nextgen repository which makes
> the AWUS036NHR v2 work for me.

Jes,

On my unit, which seems to be V1, things are worse. The logged output is

[   31.833290] usb 3-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   31.833292] usb 3-6: Product: ALFA  AWUS036NHR
[   31.833294] usb 3-6: SerialNumber: 00e04c000001
[   32.066835] fuse init (API version 7.24)
[   33.201094] usb 3-6: Vendor: ^R^CALFA
[   33.201097] usb 3-6: Product: US036NHR
[   33.201099] usb 3-6: rtl8192cu_parse_efuse: dumping efuse (0x80 bytes):
[   33.201101] usb 3-6: 00: 29 81 00 74 cd 00 00 00
[   33.201102] usb 3-6: 08: ff 00 da 0b 7f 81 03 41
[   33.201103] usb 3-6: 10: 32 00 85 62 9e ad 00 c0
[   33.201105] usb 3-6: 18: ca 52 c3 c9 02 03 12 03
[   33.201106] usb 3-6: 20: 41 4c 46 41 20 20 41 57
[   33.201107] usb 3-6: 28: 55 53 30 33 36 4e 48 52
[   33.201108] usb 3-6: 30: 00 00 00 00 00 00 00 00
[   33.201110] usb 3-6: 38: 00 00 00 00 00 00 00 00
[   33.201111] usb 3-6: 40: 00 00 00 00 00 00 00 00
[   33.201112] usb 3-6: 48: 00 00 00 00 00 00 00 00
[   33.201113] usb 3-6: 50: 00 00 00 00 00 00 00 00
[   33.201114] usb 3-6: 58: 06 00 19 19 19 00 00 00
[   33.201116] usb 3-6: 60: 27 26 25 00 00 00 00 00
[   33.201117] usb 3-6: 68: 00 00 00 00 00 00 00 00
[   33.201118] usb 3-6: 70: 00 00 00 00 00 0a 40 00
[   33.201119] usb 3-6: 78: 0e 20 00 00 36 00 04 00
[   33.201121] usb 3-6: RTL8188RU rev A (TSMC) 1T1R, TX queues 2, WiFi=1, BT=0, 
GPS=0, HI PA=1
[   33.201122] usb 3-6: RTL8188RU MAC: 00:c0:ca:52:c3:c9
[   33.201124] usb 3-6: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[   33.203491] usb 3-6: Firmware revision 80.0 (signature 0x88c1)
[   33.348885] usb 3-6: Failed to initialize RF
[   33.661460] usbcore: registered new interface driver rtl8xxxu
[   33.675077] rtl8xxxu 3-6:1.0 wlp0s20u6: renamed from wlan0
[   33.749780] usb 3-6: rtl8xxxu_int_complete: Error -71

Larry

