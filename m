Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36156 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdHIQkX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 12:40:23 -0400
Received: by mail-oi0-f54.google.com with SMTP id g131so66306201oic.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Aug 2017 09:40:23 -0700 (PDT)
Subject: Re: Problem with the wifi
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Paolo Bettini <paolobettini@gmx.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <00515b4a-5949-3746-db71-6b2b8a82dd1a@gmx.com>
 <f801b919-d4a8-6840-23ff-9773861bce6d@broadcom.com>
 <d14706d5-cc89-223f-3b4f-933af5004168@gmx.com>
 <a0a2f322-8797-ba6c-c820-a3bd2371ed96@broadcom.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <dacdc512-87a3-3007-0877-ac1f90c1fd5d@lwfinger.net> (sfid-20170809_184026_968064_ADEFEE21)
Date: Wed, 9 Aug 2017 11:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <a0a2f322-8797-ba6c-c820-a3bd2371ed96@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2017 04:10 AM, Arend van Spriel wrote:
> + linux-wireless
> + Larry
> 
> please keep linux-wireless in this thread.
> 
> On 08-08-17 08:21, Paolo Bettini wrote:
>> Arend van Spriel ha scritto:
>>> + linux-wireless On 07-08-17 21:38, Paolo Bettini wrote:
>>>> Hi , i am Paolo and i installed Debian stretch on my ezbook2 . One
>>>> problem is the wifi , the card a SDIO device , seems to be 02d0:a9a6
>>>> linux id or Broadcom AP6212 for windows....i installed deb package
>>>> firmware-brcm80211 and nvram sdio txt in /lib/firmware/brcm, reloaded
>>>> bcrmfmac module but nothing the card seems invisible or dead i don't
>>>> know if is a problem of firmware or my system cannot detect the sdio
>>>> card ...do you know something about this problematic ?
>>> As always a kernel log could help or output from dmesg command. Also
>>> can you run following commands: $ ls /sys/bus/sdio/devices $ cat
>>> /sys/bus/sdio/devices/*/modalias Regards, Arend
>> paolo@paolo:~$ ls /sys/bus/sdio/devices
>> mmc1:0001:1
>> paolo@paolo:~$
>>
>>
>> paolo@paolo:~$ cat /sys/bus/sdio/devices/*/modalias sdio:c07v024CdB723
>> paolo@paolo:~$ sorry for previous mail ....ls was from another pc....:-[
>> it seems the system see only the card where the system is installed
> 
> Hi Paolo,
> 
> Interesting. Now if Google search is correct the vendor id for this
> device indicates this is a Realtek (v024C) WLAN (c07) device. So what
> makes you say its linux id is 02d0:a9a6?
> 
> In upstream linux I do not see any SDIO device drivers in realtek
> folder. Maybe Larry can provide clue/hint if a driver for this device is
> publicly available somewhere.

Paolo,

The only Realtek SDIO device in common distribution is the RTL8723BS, which has 
been packaged with some Intel processors, and may now be part of other SBC's. 
This driver has been in staging since V4.12. It handles SDIO Vendor code 0x024c 
with device codes 0x0523, 0x0623, 0x0626, and 0xb723. If your device is one of 
these, then you only need to build a kernel with this driver enabled.

I have had very little to do with this driver, other than posting the original 
version on GitHub. From there, many users have modified it until it was 
submitted to staging by Hans de Goede of RedHat.

Larry
