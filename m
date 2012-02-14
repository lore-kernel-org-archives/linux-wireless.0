Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57226 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2BNQXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 11:23:07 -0500
Received: by pbcun15 with SMTP id un15so566023pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 08:23:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com>
References: <20120214040120.GA2077@eris.garyseven.net> <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com>
From: "Saul St. John" <saul.stjohn@gmail.com>
Date: Tue, 14 Feb 2012 10:22:46 -0600
Message-ID: <CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com> (sfid-20120214_172312_404890_4682C019)
Subject: Re: [RFC] use alternate SPROM offset for 43224
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 14, 2012 at 7:34 AM, Rafa³ Mi³ecki <zajec5@gmail.com> wrote:
> W dniu 14 lutego 2012 05:01 u¿ytkownik Saul St. John
> <saul.stjohn@gmail.com> napisa³:
>> I don't know if this is correct in the general sense, but the wireless on my
>> mid-2010 MacBook Pro doesn't work without it.
>>
>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>> ---
>>  drivers/bcma/sprom.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
>> index 6f230fb..06c87b5 100644
>> --- a/drivers/bcma/sprom.c
>> +++ b/drivers/bcma/sprom.c
>> @@ -228,8 +228,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
>>        /* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
>>         * According to brcm80211 this applies to cards with PCIe rev >= 6
>>         * TODO: understand this condition and use it */
>> -       offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
>> -               BCMA_CC_SPROM_PCIE6;
>> +       offset = (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43224) ?
>> +                       BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
>>        bcma_sprom_read(bus, offset, sprom);
>>
>>        if (bus->chipinfo.id == 0x4331)
>
> I'm quite sure it'll break my BCM43224. It's not chip-specific,
> probably some status bit specific.
>
> --
> Rafa³

My BCM43324 was broken by bmca up until "[PATCH] bcma: don't fail for
bad SPROM CRC." Even with that patch, I still get "bmca: Failed to get
SPROM: -71" in the dmesg log. Is that error harmless?

The CRC check appears to pass without issue when using the 0x800
offset on my device.

-saul
