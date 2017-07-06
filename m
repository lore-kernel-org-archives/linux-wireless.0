Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751871AbdGFTXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 15:23:11 -0400
Subject: Re: brcmfmac4356-pci device not seeing 2.4Ghz channel 12 and 13
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <f1a4e94b-1fb8-f1dc-ad64-d7de3533d64b@redhat.com>
 <CAF7Mx6pPmsZektpdEVphqUzBtbGGiMh7cedexTDsGOC8myF=9w@mail.gmail.com>
 <CAF7Mx6rUwR9TLDZuQ0pDkj0xG_j+d31w7LKBuv9q9A2V0gN7mw@mail.gmail.com>
 <CAF7Mx6oVrjxYApXbO2dV8JGY7QrYy+uF6-QH=M67RW_wBM7GGA@mail.gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <775f1300-ce1f-0e0b-747b-bf9b34d32362@redhat.com> (sfid-20170706_212315_248954_25B0881D)
Date: Thu, 6 Jul 2017 21:23:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6oVrjxYApXbO2dV8JGY7QrYy+uF6-QH=M67RW_wBM7GGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 28-06-17 14:35, Arend Van Spriel wrote:
> Op 28 jun. 2017 12:07 schreef "Hans de Goede" <hdegoede@redhat.com <mailto:hdegoede@redhat.com>>:
>  >
>  > Hi,
>  >
>  > I noticed today that my GPD Win (x86 clamshell mini laptop)
>  > which uses a brcmfmac4356-pci wifi does not see an APs which
>  > is using channel 13.
>  >
>  > I've tried updating brcmfmac4356-pci.txt changing "ccode=US"
>  > to "ccode=EU" and then rebooted, but that does not help.
> 
> Some variables may be stored on the device. However, EU may not be valid. Could you try NL instead?

Yes changing it to NL fixes this. This is still a bit problematic
though. Because what are we going to put in the nvram file we want
to put in linux-firmware ?

>  > I believe that the Linux wifi stack is supposed to automatically
>  > figure out the country settings based on AP provided info ?
> 
> That depends. The device runs its own wifi stack which should have 802.11d support for what you describe.
> 
>  > But that does not seem to be working here ? Any hints on howto
>  > debug this further would be appreciated.
> 
> You could try doing "country" iovar get somewhere in brcmf_bus_started() to check country setting in firmware.

Let me know if you still want me to do this given that ccode=NL fixes this.

Regards,

Hans
