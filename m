Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49505 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030950Ab2CFUVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 15:21:52 -0500
Received: by yhmm54 with SMTP id m54so2506782yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 12:21:52 -0800 (PST)
Message-ID: <4F5671D2.7070605@lwfinger.net> (sfid-20120306_212159_354643_1710B976)
Date: Tue, 06 Mar 2012 14:21:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <31698868.2383065.1331000548495.JavaMail.root@vms170015>
In-Reply-To: <31698868.2383065.1331000548495.JavaMail.root@vms170015>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2012 08:22 PM, alupu@verizon.net wrote:
>> On 03/05/12, Larry Finger wrote:
>
>>> On 03/05/2012 11:07 AM, alupu@verizon.net wrote:
>>> System: (B)LFS i686-pc-linux-gnu, 3.2.9
>>> Rosewill Wireless Adapter: RNX-N180UBE
>>> I compiled (as part of kernel 3.2.9) the r8712u module.
>>> Comes up OK but cannot take an essid nor a key.
>>> ...
>
>> There are a couple of bugs in 3.2.6+.
>> I don't think they have been fixed by 3.2.9.
>> Check dmesg for a "Badfw size" message.
>> If you see that, the two attached patches will fix that.
>
> Hi Larry,
> Thank you for the patches.
> Unfortunately, no cigar:
>
> <After kernel re-compile>
> usb 8-1: new high-speed USB device number 2 using ehci_hcd
> r8712u: module is from the staging directory, the quality is unknown,
>   you have been warned.
> r8712u: DriverVersion: v7_0.20100831
> r8712u: register rtl8712_netdev_ops to netdev_ops
> r8712u: USB_SPEED_HIGH with 4 endpoints
> r8712u: Boot from EFUSE: Autoload OK
> r8712u: CustomerID = 0x0000
> r8712u: MAC Address from efuse = 00:1a:ef:25:2d:f9
> r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> usbcore: registered new interface driver r8712u
> r8712u: r8711_wx_set_enc: IW_ENCODE_RESTRICTED
> usb 8-1: USB disconnect, device number 2

I tested your iwconfig statement using kernel 3.3-rc5. It worked. Then I 
downloaded a fresh copy of 3.2.9 and built it. It also worked. I have no idea 
what is wrong on your system, but it appears not to be the kernel, but something 
in your user-space tools. My tests were done with openSUSE 12.1.

Larry
