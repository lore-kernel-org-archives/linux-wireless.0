Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58179 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2LNUlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 15:41:51 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so6587333ieb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 12:41:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CB3058.6020206@hauke-m.de>
References: <CAKoT1EZh=u3bA6Jcftmsj8cNbGEctVfm_Boi7umzHe1T4EZuTw@mail.gmail.com>
	<50CB1D7D.2030301@hauke-m.de>
	<CAKoT1EYRi9pCc9A9mGs3OKGhgrNOL6OJFm87qfmp+hSRaNhZjA@mail.gmail.com>
	<50CB3058.6020206@hauke-m.de>
Date: Sat, 15 Dec 2012 09:41:50 +1300
Message-ID: <CAKoT1EY_DsjtaoZFbCi7+m22X-xAMfXJ0VwPK2O+7mhaxD8tWQ@mail.gmail.com> (sfid-20121214_214155_688509_5E0009D0)
Subject: Re: Problem in FAQ
From: Kevin McCready <kevin1mccready@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I apologise for top posting and have googled it and now understand (it
took me a while since I've never heard of it before). So after I hit
"reply all", I deleted everything in the email and started again. If
this email is another top post, please excuse me and tell me how not
to do it. I am using gmail on their website.

Here is the output of lspci -nn. There is nowhere where it says PCI
ID= . So if someone could help me extract the information from this
output I would be grateful.

lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 2nd Generation Core
Processor Family DRAM Controller [8086:0104] (rev 09)
00:02.0 VGA compatible controller [0300]: Intel Corporation 2nd
Generation Core Processor Family Integrated Graphics Controller
[8086:0106] (rev 09)
00:16.0 Communication controller [0780]: Intel Corporation 6
Series/C200 Series Chipset Family MEI Controller #1 [8086:1c3a] (rev
04)
00:1a.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series
Chipset Family USB Enhanced Host Controller #2 [8086:1c2d] (rev 05)
00:1b.0 Audio device [0403]: Intel Corporation 6 Series/C200 Series
Chipset Family High Definition Audio Controller [8086:1c20] (rev 05)
00:1c.0 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series
Chipset Family PCI Express Root Port 1 [8086:1c10] (rev b5)
00:1c.2 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series
Chipset Family PCI Express Root Port 3 [8086:1c14] (rev b5)
00:1c.4 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series
Chipset Family PCI Express Root Port 5 [8086:1c18] (rev b5)
00:1d.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series
Chipset Family USB Enhanced Host Controller #1 [8086:1c26] (rev 05)
00:1f.0 ISA bridge [0601]: Intel Corporation HM65 Express Chipset
Family LPC Controller [8086:1c49] (rev 05)
00:1f.2 SATA controller [0106]: Intel Corporation 6 Series/C200 Series
Chipset Family 6 port SATA AHCI Controller [8086:1c03] (rev 05)
00:1f.3 SMBus [0c05]: Intel Corporation 6 Series/C200 Series Chipset
Family SMBus Controller [8086:1c22] (rev 05)
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller [10ec:8136]
(rev 05)
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS5116 PCI Express Card Reader [10ec:5209] (rev 01)

On Sat, Dec 15, 2012 at 2:57 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 12/14/2012 01:50 PM, Kevin McCready wrote:
>> It seems the output of lspci -nn and lspci are the same in this case.
>> I don't know how to extract the pci ID from the output.
>
> No lspci -nn has a different output, it also prints the pci id of the
> devices.
>
> Please do not remove the mailing list from cc and stop top posting.
>
> Hauke
>>
>> On Sat, Dec 15, 2012 at 1:37 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> On 12/14/2012 09:35 AM, Kevin McCready wrote:
>>>>
>>>> FAQ says: Forget about XXX, what really matters is PCI or USB
>>>> (depending on the bus your device uses) ID pair: VID:PID. So to find
>>>> out if your device is supported, use lspci -nn or lsusb to learn the
>>>> ID pair.
>>>>
>>>> I have no idea what this means.
>>>>
>>>> I did lspci and got
>>>> k@k-Presario-CQ57-Notebook-PC:
>>>> ~$ lspci
>>> ...
>>>> 02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
>>>> 802.11b/g/n WiFi Adapter (rev 01)
>>> ...
>>>
>>> You have a Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi
>>> Adapter and it should be supported by Linux since 2.6.38. If you are
>>> using such a kernel version or a more recent one and this device is
>>> still not recognized by Linux, please run "lspci -nn" like the FAQ says
>>> to get the pci id.
>>>
>>>>
>>>> I have no idea whether my wireless problem is a usb or pci problem.
>>>> I have no idea what the pair is.
>>>>
>>>> I would be grateful for a better FAQ to help me.
>>>
>>
>>
>>
>



-- 
cheers
kevin1mccready@gmail.com
32 Hawera Rd
Kohimarama 1071
Auckland, New Zealand
+64 (0)9 528 1174 home
+64 (0)226 710 335 cell
http://kmccready.wordpress.com
