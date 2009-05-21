Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47061 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZEUO6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 10:58:47 -0400
Received: by bwz22 with SMTP id 22so1066409bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 07:58:48 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WIP PATCH] sdio support for wl12xx
References: <20090518180957.GD2580@hash.localnet>
	<20090519040239.GA12911@hash.localnet> <877i0begt7.fsf@litku.valot.fi>
	<b6c5339f0905201223n4c8c4811h25a397e69a642c2a@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 21 May 2009 17:58:45 +0300
In-Reply-To: <b6c5339f0905201223n4c8c4811h25a397e69a642c2a@mail.gmail.com> (Bob Copeland's message of "Wed\, 20 May 2009 15\:23\:04 -0400")
Message-ID: <87d4a2wli2.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Wed, May 20, 2009 at 3:05 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Bob Copeland <me@bobcopeland.com> writes:
>>> So much for hubris!
>>
>> Don't feel down about this, this is always difficult and you are making
>> good progress already.
>
> Heh, just a joke :)

Good :)

>> Current wl12xx code assumes that user space provides the NVS file. I'm
>> guessing that Android has NVS file stored in chip's EEPROM. Check the
>> !pWhalBus->pEEPROMBuf code path from TI's driver how to implement it.
>
> If you don't mind, check my work

Definitely not, feel free to ask me.

> -- the shmFwCtrl.c code seems to do the equivalent of:
>
>    // initiate eeprom transfer
>    wl12xx_reg_write32(wl, ACX_REG_EE_START, ACX_REG_EEPROM_START_BIT); // ***
>    msleep(40);
>    msleep(40);
>
>    // sets spad4 to 0, I guess this is some kind of address register?
>    wl12xx_reg_write32(wl, ACX_EEPROMLESS_IND_REG, 0);
>
>    // everything from here on out is the same - read spad2 and 3 then boot.

To me the code looks same. Only difference I found was that the TI
driver had only one msleep(40), but that won't make any difference.

> *** NB: I redefined ACX_REG_EEPROM_START_BIT to BIT(0) -- BIT(1) looked
> wrong unless that define is meant for something else.

I think BIT(1) is wrong, most probably I introduced the bug.

> The state machine is kind of hard to read, but it seems like there
> should be more to it. Did I miss anything as far as you can tell?

My understanding is that nothing else is needed, but I can be wrong.

> I get all zeros from spad2 and spad3 so it's not working with just the
> above...

Not good. Can you somehow check if Google stores the NVS file to the
chip or somewhere else?

-- 
Kalle Valo
