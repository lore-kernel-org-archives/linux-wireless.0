Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:5584 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbZETTXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 15:23:04 -0400
Received: by yw-out-2324.google.com with SMTP id 5so395660ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 12:23:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877i0begt7.fsf@litku.valot.fi>
References: <20090518180957.GD2580@hash.localnet>
	 <20090519040239.GA12911@hash.localnet> <877i0begt7.fsf@litku.valot.fi>
Date: Wed, 20 May 2009 15:23:04 -0400
Message-ID: <b6c5339f0905201223n4c8c4811h25a397e69a642c2a@mail.gmail.com>
Subject: Re: [WIP PATCH] sdio support for wl12xx
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2009 at 3:05 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Bob Copeland <me@bobcopeland.com> writes:
>> So much for hubris!
>
> Don't feel down about this, this is always difficult and you are making
> good progress already.

Heh, just a joke :)

> Current wl12xx code assumes that user space provides the NVS file. I'm
> guessing that Android has NVS file stored in chip's EEPROM. Check the
> !pWhalBus->pEEPROMBuf code path from TI's driver how to implement it.

If you don't mind, check my work -- the shmFwCtrl.c code seems to do
the equivalent of:

   // initiate eeprom transfer
   wl12xx_reg_write32(wl, ACX_REG_EE_START, ACX_REG_EEPROM_START_BIT); // ***
   msleep(40);
   msleep(40);

   // sets spad4 to 0, I guess this is some kind of address register?
   wl12xx_reg_write32(wl, ACX_EEPROMLESS_IND_REG, 0);

   // everything from here on out is the same - read spad2 and 3 then boot.

*** NB: I redefined ACX_REG_EEPROM_START_BIT to BIT(0) -- BIT(1) looked
wrong unless that define is meant for something else.

The state machine is kind of hard to read, but it seems like there should
be more to it.  Did I miss anything as far as you can tell?  I get all
zeros from spad2 and spad3 so it's not working with just the above...

> Please let me know if you have any questions. I try to get hold of
> pandora, it has wl1251 using SDIO, so that I could help you with
> testing.
>
> http://www.openpandora.org/

I'll take one too :)

-- 
Bob Copeland %% www.bobcopeland.com
