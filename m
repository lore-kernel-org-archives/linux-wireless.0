Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38749 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdHHJfi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 05:35:38 -0400
Received: by mail-wm0-f53.google.com with SMTP id m85so2371345wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 02:35:37 -0700 (PDT)
Subject: Re: Problem with the wifi
To: Paolo Bettini <paolobettini@gmx.com>
References: <00515b4a-5949-3746-db71-6b2b8a82dd1a@gmx.com>
 <f801b919-d4a8-6840-23ff-9773861bce6d@broadcom.com>
 <d14706d5-cc89-223f-3b4f-933af5004168@gmx.com>
 <a0a2f322-8797-ba6c-c820-a3bd2371ed96@broadcom.com>
 <a148a442-5b5a-155d-6ca4-2e82c48c76bf@gmx.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <db2aac72-2636-fc22-74ad-9edce844ff8b@broadcom.com> (sfid-20170808_113543_090809_659CF8F1)
Date: Tue, 8 Aug 2017 11:35:35 +0200
MIME-Version: 1.0
In-Reply-To: <a148a442-5b5a-155d-6ca4-2e82c48c76bf@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless
+ Larry

Jesus christ..grow some ears!

On 08-08-17 11:21, Paolo Bettini wrote:
> Arend van Spriel ha scritto:
>> + linux-wireless
>> + Larry
>>
>> please keep linux-wireless in this thread.
>>
>> On 08-08-17 08:21, Paolo Bettini wrote:
>>> Arend van Spriel ha scritto:
>>>> + linux-wireless On 07-08-17 21:38, Paolo Bettini wrote:
>>>>> Hi , i am Paolo and i installed Debian stretch on my ezbook2 . One
>>>>> problem is the wifi , the card a SDIO device , seems to be 02d0:a9a6
>>>>> linux id or Broadcom AP6212 for windows....i installed deb package
>>>>> firmware-brcm80211 and nvram sdio txt in /lib/firmware/brcm, reloaded
>>>>> bcrmfmac module but nothing the card seems invisible or dead i don't
>>>>> know if is a problem of firmware or my system cannot detect the sdio
>>>>> card ...do you know something about this problematic ?
>>>> As always a kernel log could help or output from dmesg command. Also
>>>> can you run following commands: $ ls /sys/bus/sdio/devices $ cat
>>>> /sys/bus/sdio/devices/*/modalias Regards, Arend
>>> paolo@paolo:~$ ls /sys/bus/sdio/devices
>>> mmc1:0001:1
>>> paolo@paolo:~$
>>>
>>>
>>> paolo@paolo:~$ cat /sys/bus/sdio/devices/*/modalias sdio:c07v024CdB723
>>> paolo@paolo:~$ sorry for previous mail ....ls was from another pc....:-[
>>> it seems the system see only the card where the system is installed
>> Hi Paolo,
>>
>> Interesting. Now if Google search is correct the vendor id for this
>> device indicates this is a Realtek (v024C) WLAN (c07) device. So what
>> makes you say its linux id is 02d0:a9a6?
>>
>> In upstream linux I do not see any SDIO device drivers in realtek
>> folder. Maybe Larry can provide clue/hint if a driver for this device is
>> publicly available somewhere.
>>
>> Regards,
>> Arend
> Excuse me if i am boring you again , for me the wifi card of the ezbook2
> is a ghost ...but googling it is a broadcom infact with this command i have

You are not boring anyone, but you really should ask the manufacturer.
All I can say is your sysfs shows there is only one SDIO device with
vendor id 0x024c (Realtek) and class 0x07 (WLAN) so brcmfmac will not be
probed for that as all aliases below for brcmfmac are listing vendor id
0x02d0 (Broadcom). That is all the command below indicates.

Regards,
Arend

> paolo@paolo:~$ grep sdio /lib/modules/`uname -r`/modules.alias
> alias sdio:c*v0271d0418* ath6kl_sdio
> alias sdio:c*v0271d0402* ath6kl_sdio
> alias sdio:c*v0271d0401* ath6kl_sdio
> alias sdio:c*v0271d0400* ath6kl_sdio
> alias sdio:c*v0271d0301* ath6kl_sdio
> alias sdio:c*v0271d0300* ath6kl_sdio
> alias sdio:c*v02D0d4356* brcmfmac
> alias sdio:c*v02D0d4354* brcmfmac
> alias sdio:c*v02D0dA9BF* brcmfmac
> alias sdio:c*v02D0d4345* brcmfmac
> alias sdio:c*v02D0dA9A6* brcmfmac
> alias sdio:c*v02D0d4339* brcmfmac
> alias sdio:c*v02D0d4335* brcmfmac
> alias sdio:c*v02D0dA962* brcmfmac
> alias sdio:c*v02D0dA94D* brcmfmac
> alias sdio:c*v02D0dA94C* brcmfmac
> alias sdio:c*v02D0d4334* brcmfmac
> alias sdio:c*v02D0d4330* brcmfmac
> alias sdio:c*v02D0d4329* brcmfmac
> alias sdio:c*v02D0d4324* brcmfmac
> alias sdio:c*v02D0dA887* brcmfmac
> alias sdio:c*v02DFd9104* libertas_sdio
> alias sdio:c*v02DFd9103* libertas_sdio
> alias sdio:c*v02DFd9141* mwifiex_sdio
> alias sdio:c*v02DFd9139* mwifiex_sdio
> alias sdio:c*v02DFd9135* mwifiex_sdio
> alias sdio:c*v02DFd912D* mwifiex_sdio
> alias sdio:c*v02DFd9129* mwifiex_sdio
> alias sdio:c*v02DFd9119* mwifiex_sdio
> alias sdio:c*v02DFd9116* mwifiex_sdio
> alias sdio:c*v039Ad0800* smssdio
> alias sdio:c*v039Ad0700* smssdio
> alias sdio:c*v039Ad0600* smssdio
> alias sdio:c*v039Ad0500* smssdio
> alias sdio:c*v039Ad0302* smssdio
> alias sdio:c*v039Ad0301* smssdio
> alias sdio:c*v039Ad0300* smssdio
> alias sdio:c*v039Ad0201* smssdio
> alias sdio:c*v039Ad1100* smssdio
> alias sdio:c*v039Ad5347* smssdio
> alias sdio:c04v*d* sdio_uart
> alias sdio:c01v*d* sdio_uart
> alias sdio:c09v*d* btsdio
> alias sdio:c03v*d* btsdio
> alias sdio:c02v*d* btsdio
> alias sdio:c*v02DFd9142* btmrvl_sdio
> alias sdio:c*v02DFd912E* btmrvl_sdio
> alias sdio:c*v02DFd9136* btmrvl_sdio
> alias sdio:c*v02DFd912A* btmrvl_sdio
> alias sdio:c*v02DFd911B* btmrvl_sdio
> alias sdio:c*v02DFd911A* btmrvl_sdio
> alias sdio:c*v02DFd9105* btmrvl_sdio
> paolo@paolo:~$
> 
