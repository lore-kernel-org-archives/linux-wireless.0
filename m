Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:34022 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475AbcCKHMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 02:12:41 -0500
Received: by mail-yw0-f181.google.com with SMTP id h129so87546319ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 23:12:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG4k0fCd7Q-0Nz+XH1U-A9jwFRdX_SbVJNO=m_qP_ZpVADQkVw@mail.gmail.com>
References: <CAG4k0fCqB1KNLyHV5--pi1nSoDPnV3qM-yTB0T2jmgbnjmqvww@mail.gmail.com>
	<42847572.gSex6kjQ2f@debian64>
	<CAG4k0fCd7Q-0Nz+XH1U-A9jwFRdX_SbVJNO=m_qP_ZpVADQkVw@mail.gmail.com>
Date: Fri, 11 Mar 2016 09:12:40 +0200
Message-ID: <CAG4k0fDJ6KjK14Ja5fKpy8L4aGzWVwLTOGT6EvkVEDwS9qVdhw@mail.gmail.com> (sfid-20160311_081244_667490_C23295CB)
Subject: Re: carl1970: stops working at random periods on Ubuntu 15.05
From: alexander nekrasov <i.sinister@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for an answer, Christian! Adapter is getting hot sometimes
indeed. Also my adapter is usb2.0 but it was on extender with another
usb1.1 device. I plugged it into motherboards port directly but issue
still continue to happens. I  also tried reload host controller but it
did not help. However I discovered strange behavior. Here is my
scenario:
1. boot system
2. check device is displayed by 'lsusb' and 'lsusb -t'
3. unbind and bind root hub where device is plugged into
4. this time 'lsusb' does list device and 'lsusb -t' does not

Is it ok?

After unbind/bind device definitely is not working - there is led
indicator and it is off. Should I 'enable' device after binding root
hub with another command?

On 28 February 2016 at 23:33, alexander nekrasov <i.sinister@gmail.com> wrote:
> Thanks for an answer, Christian! Adapter is getting hot sometimes
> indeed. I will try reload host controller next time it happens, but
> I'm afraid Im to newbie to do the 'usb data stream debugging' =) I'm
> also reading link maybe it'll help me. Thanks again
>
> On 28 February 2016 at 14:27, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
>> Hello,
>>
>> On Sunday, February 28, 2016 03:06:35 AM alexander nekrasov wrote:
>>> I'm using TP-LINK TL-WN821N and encountering very annoying behaviour -
>>> adapter 'hangs' at random period of time - sometimes it is 1 hour,
>>> sometimes 2. After it hangs Network manager does not see any wireless
>>> networks and the only way to make it work is to reboot system (also
>>> tried unplugging/plugging adapter and removing/adding module but it
>>> did not work)
>> Did it get hot? Or Have you tried unloading/reloading the ohci/ehci/xhci?
>> The used USB-PHY FUSB200 (in the AR9170) is known to misbehave. If you
>> want to read more about the implications and possible solution, you can
>> visit the ath9k_htc firmware community. They have written a wiki entry
>> which describes the issues in detail [0].
>>
>>> Heres lsusb -v:
>>> Bus 004 Device 004: ID 0cf3:1002 Atheros Communications, Inc. TP-Link
>>> TL-WN821N v2 / TL-WN822N v1 802.11n [Atheros AR9170]
>>>
>>> And here what i have in syslog right before the hang:
>>> Following messages are also relevant to adapter failure but i guess it
>>> will be to long to post it here.
>>>
>>> Feb 28 01:46:53 evren kernel: [ 4978.753087] usb 4-1.4: no command
>>> feedback received (-90).
>>> Feb 28 01:46:53 evren kernel: [ 4978.753098] usb 4-1.4: restart device (6)
>>> Feb 28 01:46:54 evren kernel: [ 4979.891093] usb 4-1.4: device
>>> restarted successfully.
>>> Feb 28 01:46:54 evren kernel: [ 4979.899273] ieee80211 phy1: Hardware
>>> restart was requested
>> Commands are issued on the devices end point #4.... And the response the
>> driver is waiting for doesn't get through. If you want to debug this,
>> you'll need to look at the usb data stream and check which party (host
>> controller (ehci/ohci), device (AR9170) or cable?) is at fault.
>>
>> Regards,
>> Christian
>>
>> [0] <https://github.com/qca/open-ath9k-htc-firmware/wiki/usb-related-issues>
