Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdH3NjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 09:39:10 -0400
Subject: Re: brcmfmac4356-pci device not seeing 2.4Ghz channel 12 and 13
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <f1a4e94b-1fb8-f1dc-ad64-d7de3533d64b@redhat.com>
 <CAF7Mx6pPmsZektpdEVphqUzBtbGGiMh7cedexTDsGOC8myF=9w@mail.gmail.com>
 <CAF7Mx6rUwR9TLDZuQ0pDkj0xG_j+d31w7LKBuv9q9A2V0gN7mw@mail.gmail.com>
 <CAF7Mx6oVrjxYApXbO2dV8JGY7QrYy+uF6-QH=M67RW_wBM7GGA@mail.gmail.com>
 <775f1300-ce1f-0e0b-747b-bf9b34d32362@redhat.com>
 <1b37a554-a69d-53ed-1c66-ab1edceb9af4@broadcom.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <8f8aa976-67c2-05bc-9cef-adb178a2eb88@redhat.com> (sfid-20170830_153913_933385_90CB10BE)
Date: Wed, 30 Aug 2017 15:39:07 +0200
MIME-Version: 1.0
In-Reply-To: <1b37a554-a69d-53ed-1c66-ab1edceb9af4@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 06-07-17 21:43, Arend van Spriel wrote:
> On 06-07-17 21:23, Hans de Goede wrote:
>> Hi,
>>
>> On 28-06-17 14:35, Arend Van Spriel wrote:
>>> Op 28 jun. 2017 12:07 schreef "Hans de Goede" <hdegoede@redhat.com
>>> <mailto:hdegoede@redhat.com>>:
>>>   >
>>>   > Hi,
>>>   >
>>>   > I noticed today that my GPD Win (x86 clamshell mini laptop)
>>>   > which uses a brcmfmac4356-pci wifi does not see an APs which
>>>   > is using channel 13.
>>>   >
>>>   > I've tried updating brcmfmac4356-pci.txt changing "ccode=US"
>>>   > to "ccode=EU" and then rebooted, but that does not help.
>>>
>>> Some variables may be stored on the device. However, EU may not be
>>> valid. Could you try NL instead?
>>
>> Yes changing it to NL fixes this. This is still a bit problematic
>> though. Because what are we going to put in the nvram file we want
>> to put in linux-firmware ?
> 
> Agree. I am surprised (not pleasantly) that these devices are not
> properly programmed and thus need nvram for the country code.
> 
>>>   > I believe that the Linux wifi stack is supposed to automatically
>>>   > figure out the country settings based on AP provided info ?
>>>
>>> That depends. The device runs its own wifi stack which should have
>>> 802.11d support for what you describe.
>>>
>>>   > But that does not seem to be working here ? Any hints on howto
>>>   > debug this further would be appreciated.
>>>
>>> You could try doing "country" iovar get somewhere in
>>> brcmf_bus_started() to check country setting in firmware.
>>
>> Let me know if you still want me to do this given that ccode=NL fixes this.
> 
> Well. Could you try it with ccode commented out in nvram file.

That does not work, so then I looked at some of my other brcm
nvram files which use:

ccode=XY
ccode=0
ccode=ALL

I tried both 0 and ALL, which both don't work with the brcmfmac4356-pci
controller / firmware.

Then I decided to do a duckduckgo search for this problem and found:

https://wireless.wiki.kernel.org/en/users/Drivers/brcm80211

Which says:

"This generation of chips contain additional regulatory support independent of the driver. The devices use a single worldwide regulatory domain, with channels 12-14 (2.4 GHz band) and channels 52-64 and 100-140 (5 GHz band) restricted to passive operation. Transmission on those channels is suppressed until appropriate other traffic is observed on those channels. Within the driver, we use the ficticious country code “X2” to represent this worldwide regulatory domain."

So I tried:

ccode=X2

And that works :)  So case closed.

I also tried another device which has a brcmfmac43430a0 and the stock
nvram from the OS image from the manufacturer uses:

ccode=ALL

And again no joy for accessing an AP on channel 13, switching to:

ccode=X2

Fixed things there too.

Regards,

Hans
