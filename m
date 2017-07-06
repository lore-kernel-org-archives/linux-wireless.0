Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36373 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbdGFTn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 15:43:59 -0400
Received: by mail-wr0-f175.google.com with SMTP id c11so16866678wrc.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 12:43:59 -0700 (PDT)
Subject: Re: brcmfmac4356-pci device not seeing 2.4Ghz channel 12 and 13
To: Hans de Goede <hdegoede@redhat.com>
Cc: "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <f1a4e94b-1fb8-f1dc-ad64-d7de3533d64b@redhat.com>
 <CAF7Mx6pPmsZektpdEVphqUzBtbGGiMh7cedexTDsGOC8myF=9w@mail.gmail.com>
 <CAF7Mx6rUwR9TLDZuQ0pDkj0xG_j+d31w7LKBuv9q9A2V0gN7mw@mail.gmail.com>
 <CAF7Mx6oVrjxYApXbO2dV8JGY7QrYy+uF6-QH=M67RW_wBM7GGA@mail.gmail.com>
 <775f1300-ce1f-0e0b-747b-bf9b34d32362@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1b37a554-a69d-53ed-1c66-ab1edceb9af4@broadcom.com> (sfid-20170706_214403_233413_E1DDF96A)
Date: Thu, 6 Jul 2017 21:43:56 +0200
MIME-Version: 1.0
In-Reply-To: <775f1300-ce1f-0e0b-747b-bf9b34d32362@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-07-17 21:23, Hans de Goede wrote:
> Hi,
> 
> On 28-06-17 14:35, Arend Van Spriel wrote:
>> Op 28 jun. 2017 12:07 schreef "Hans de Goede" <hdegoede@redhat.com
>> <mailto:hdegoede@redhat.com>>:
>>  >
>>  > Hi,
>>  >
>>  > I noticed today that my GPD Win (x86 clamshell mini laptop)
>>  > which uses a brcmfmac4356-pci wifi does not see an APs which
>>  > is using channel 13.
>>  >
>>  > I've tried updating brcmfmac4356-pci.txt changing "ccode=US"
>>  > to "ccode=EU" and then rebooted, but that does not help.
>>
>> Some variables may be stored on the device. However, EU may not be
>> valid. Could you try NL instead?
> 
> Yes changing it to NL fixes this. This is still a bit problematic
> though. Because what are we going to put in the nvram file we want
> to put in linux-firmware ?

Agree. I am surprised (not pleasantly) that these devices are not
properly programmed and thus need nvram for the country code.

>>  > I believe that the Linux wifi stack is supposed to automatically
>>  > figure out the country settings based on AP provided info ?
>>
>> That depends. The device runs its own wifi stack which should have
>> 802.11d support for what you describe.
>>
>>  > But that does not seem to be working here ? Any hints on howto
>>  > debug this further would be appreciated.
>>
>> You could try doing "country" iovar get somewhere in
>> brcmf_bus_started() to check country setting in firmware.
> 
> Let me know if you still want me to do this given that ccode=NL fixes this.

Well. Could you try it with ccode commented out in nvram file.

Regards,
Arend
