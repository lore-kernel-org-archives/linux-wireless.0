Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38557 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbcHTTaV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Aug 2016 15:30:21 -0400
Received: by mail-wm0-f54.google.com with SMTP id o80so86200691wme.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Aug 2016 12:30:20 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
To: Ismael Luceno <ismael@iodev.co.uk>
References: <20160621001841.5383-1-ismael@iodev.co.uk>
 <57698F43.3050303@broadcom.com> <20160622183622.uo5avhsjzmnn6jgf@pirotess>
 <576AE1DC.7050203@broadcom.com> <20160622205407.sh6w64thsygavbvt@pirotess>
 <20160820151703.b5gxbfruvf3riuwf@pirotess.bf.iodev.co.uk>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7f9b0d90-f76b-b7e0-8932-2ded5c39145f@broadcom.com> (sfid-20160820_213025_381352_26B3031D)
Date: Sat, 20 Aug 2016 21:22:43 +0200
MIME-Version: 1.0
In-Reply-To: <20160820151703.b5gxbfruvf3riuwf@pirotess.bf.iodev.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-08-16 17:17, Ismael Luceno wrote:
> Ping.
> 
> On 22/Jun/2016 17:54, Ismael Luceno wrote:
>> On 22/Jun/2016 21:07, Arend van Spriel wrote:
>>> On 22-06-16 20:36, Ismael Luceno wrote:
>>>> On 21/Jun/2016 21:02, Arend van Spriel wrote:
>>>>> On 21-06-16 02:18, Ismael Luceno wrote:
>>>>>> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
>>>>>
>>>>> A bit more description would be nice. I am actually wondering why you
>>>>> would be adding this. If I am not mistaken the AE1200 can not be handled
>>>>> by brcmfmac. Otherwise I am interested in a kernel log showing the
>>>>> device probe sequence with brcmfmac loaded with parameter debug=0x1416.

As can be seen in patchwork the state is "Changes Requested". Above is
my initial response starting with "A bit more description would be nice"
in which I refer to the empty commit message. Here a suggestion based on
the revision info provided below and info found on [1]:

The Linksys AE1200 comes with different revisions of the bcm43235 all of
which use the same USB ID. This chipset can only be supported by
brcmfmac as of revision 3.

Regards,
Arend

[1] https://wikidevi.com/wiki/Linksys_AE1200

>>>> Log attached.
>>>>
>>>> I was surprised it works without any tweaking.
>>>
>>> Nice. What kernel version are you running on.
>>
>> Commit c3695331f3a326a468bd6a5b6f05b481b399726b.
>>
>>> Can you also dump a debugfs file,
>>> ie. /sys/kernel/debug/brcmfmac/*/revinfo.
>>
>> vendorid: 0x14e4
>> deviceid: 0x4347
>> radiorev: 114.5.112
>> chipnum: 43235 (a8e3)
>> chiprev: 3
>> chippkg: 4
>> corerev: 24
>> boardid: 0x0571
>> boardvendor: 0x14e4
>> boardrev: P523
>> driverrev: 5.90.188.22
>> ucoderev: 0
>> bus: 0
>> phytype: 4
>> phyrev: 9
>> anarev: 0
>> nvramrev: 00000000
>>
>>
>>> I want to know what chip id and revision is reported. I have tried an
>>> AE1200 in the past, but it had a chip revision that had insufficient
>>> memory to run fullmac firmware.
>>
>> That's going to be confusing for anyone having the hardware :(.
>>
>>> Is there FCC registration number on it?
>>
>> Yes: Q87-AE1200
