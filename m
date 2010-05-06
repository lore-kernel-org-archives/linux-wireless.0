Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:38235 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab0EFNLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 09:11:43 -0400
Received: by pzk42 with SMTP id 42so1965319pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 06:11:43 -0700 (PDT)
Message-ID: <4BE2C009.8020002@lwfinger.net>
Date: Thu, 06 May 2010 08:11:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ssb: resolve alternate SPROM offset for 14e4:4315
References: <4be24cdd.Yg6pH2Z4OwSotB+K%Larry.Finger@lwfinger.net> <201005061153.01488.mb@bu3sch.de> (sfid-20100506_055308_804338_0079B086) <201005061201.18469.mb@bu3sch.de>
In-Reply-To: <201005061201.18469.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2010 05:01 AM, Michael Buesch wrote:
> On Thursday 06 May 2010 11:53:01 Michael Buesch wrote:
>> On Thursday 06 May 2010 07:00:13 Larry Finger wrote:
>>> This patch and the patch by Gabor entitled "[PATCH] ssb: Implement
>>> fast powerup delay calculation" are enough to allow the netbook from
>>> John to work with ssb/b43. As this patch tampers with the SPROM offset for
>>> 14e4:4315 devices, it should be tested by anyone with an LP PHY that works
>>> to ensure that it is not killed.
>>>
>>> The essential elements of this patch will also be tested as part of kernel Bug
>>> #15825.
>>>
>>> Larry
>>>  
>>> Index: wireless-testing/drivers/ssb/pci.c
>>> ===================================================================
>>> --- wireless-testing.orig/drivers/ssb/pci.c
>>> +++ wireless-testing/drivers/ssb/pci.c
>>> @@ -631,8 +631,17 @@ static int ssb_pci_sprom_get(struct ssb_
>>>  		return -ENODEV;
>>>  	}
>>>  
>>> -	bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
>>> -		SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
>>> +	/* get SPROM offset: SSB_SPROM_BASE1 except for chipcommon rev >= 31
>>> +	 * or chip ID is 0x4312 and bit 0x2 is set in chipcommon status
>>> +	 */
>>> +	if (bus->chipco.dev->id.revision >= 31)
>>> +		bus->sprom_offset = SSB_SPROM_BASE31;
>>> +	else if (bus->chip_id == 0x4312 && (bus->chipco.status & 0x02))
>>> +		bus->sprom_offset = SSB_SPROM_BASE31;
>>> +	else
>>> +		bus->sprom_offset = SSB_SPROM_BASE1;
>>> +
>>> +	ssb_dprintk(KERN_INFO PFX "SPROM offset is 0x%x\n", bus->sprom_offset);
>>>  
>>>  	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
>>>  	if (!buf)
>>> Index: wireless-testing/drivers/ssb/scan.c
>>> ===================================================================
>>> --- wireless-testing.orig/drivers/ssb/scan.c
>>> +++ wireless-testing/drivers/ssb/scan.c
>>> @@ -306,6 +306,11 @@ int ssb_bus_scan(struct ssb_bus *bus,
>>>  		}
>>>  		tmp = scan_read32(bus, 0, SSB_CHIPCO_CAP);
>>>  		bus->chipco.capabilities = tmp;
>>> +		if (bus->chip_rev >= 11)
>>
>> This still is wrong. the chip_rev is not the chipcommon core revision.
> 
> Although technically in most (all?) cases it might be the same number.
> I'm not sure on that one.
> But it is read from an entirely different register and I think it's plain
> wrong to assume that chip_rev equals the chipcommon core rev.

Is it OK to read the chipcommon capabilities here?

>> We already went through this and we decided to read the chipstat later.
>> Read it in chipcommon init. The bus scan is _way_ too early to read this.

I missed that, but found it now.

Larry
