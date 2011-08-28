Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53863 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1H1RH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 13:07:27 -0400
Received: by pzk37 with SMTP id 37so7123008pzk.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 10:07:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5A74C9.1050909@lwfinger.net>
References: <1314550043-6220-1-git-send-email-zajec5@gmail.com>
	<1314550043-6220-2-git-send-email-zajec5@gmail.com>
	<4E5A74C9.1050909@lwfinger.net>
Date: Sun, 28 Aug 2011 19:07:26 +0200
Message-ID: <CACna6rxVhv2Rf2NM9U-cc4cf5XQhSMpbGYmrVSW_KH-e2ETc0Q@mail.gmail.com> (sfid-20110828_190730_624467_BFB6E660)
Subject: Re: [PATCH 2/2] bcma: extract some basic info about board from SPROM
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 28 sierpnia 2011 19:03 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 08/28/2011 11:47 AM, Rafał Miłecki wrote:
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>>  drivers/bcma/sprom.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
>> index 166ed13..d729239 100644
>> --- a/drivers/bcma/sprom.c
>> +++ b/drivers/bcma/sprom.c
>> @@ -133,6 +133,15 @@ static void bcma_sprom_extract_r8(struct bcma_bus
>> *bus, const u16 *sprom)
>>                v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
>>                *(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
>>        }
>> +
>> +       bus->sprom.board_rev = sprom[SPOFF(SSB_SPROM8_BOARDREV)];
>> +
>> +       bus->sprom.boardflags_lo = sprom[SPOFF(SSB_SPROM8_BFLLO)];
>> +       bus->sprom.boardflags_hi = sprom[SPOFF(SSB_SPROM8_BFLHI)];
>> +       bus->sprom.boardflags2_lo = sprom[SPOFF(SSB_SPROM8_BFL2LO)];
>> +       bus->sprom.boardflags2_hi = sprom[SPOFF(SSB_SPROM8_BFL2HI)];
>> +
>> +       bus->sprom.country_code = sprom[SPOFF(SSB_SPROM8_CCODE)];
>>  }
>>
>>  int bcma_sprom_get(struct bcma_bus *bus)
>
> Does the card in question not need any other info from the SPROM, or is this
> just a first step? Is the usual SPROM Rev 8 code part of ssb, and is that
> the reason you don't use it here?

It will need more info, I just didn't add everything yet. I think we
should review ssb's code anyway, so I didn't copy&paste it. For
example ssb doesn't read board_rev at the moment for SPROM rev 8.

-- 
Rafał
