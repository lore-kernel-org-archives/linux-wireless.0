Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:13716 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZBWT43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 14:56:29 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2652154wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 11:56:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090223193704.GC3553@tuxdriver.com>
References: <87wsbobfza.wl%peter@chubb.wattle.id.au>
	 <20090223193704.GC3553@tuxdriver.com>
Date: Mon, 23 Feb 2009 14:56:26 -0500
Message-ID: <b6c5339f0902231156r6498fb6as219b7ba18b8cce5e@mail.gmail.com> (sfid-20090223_205632_819034_F11D84B3)
Subject: Re: [ath5k-devel] [PATCH] Fix transmit LED on Acer Aspire One
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	lrodriguz@atheros.com, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 2:37 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Feb 18, 2009 at 02:07:05PM +1100, Peter Chubb wrote:
>> +     /* Enable softled on Acer Aspire One */
>> +     else if (pdev->subsystem_vendor == 0x105b && pdev->subsystem_device == 0xe008) {
>> +             __set_bit(ATH_STAT_LEDSOFT, sc->status);
>> +             sc->led_pin = 3;
>> +             sc->led_on = 0;
>> +     }
>>       if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
>>               goto out;
>
> Any comment on this from the ath5k guys?  That 0x105b subvendor ID
> would seem to correspond to "Foxconn International, Inc.", which
> doesn't sound much like "Acer"...

It's already in wireless-testing with similar values.

Not quite apropos to this patch, someone with the ambit chipset said
the values didn't match up with his laptop, so we do need to add a
subsystem_device test I think, but it should have a #define in pci.h.
In any case there's usually no harm in enabling the wrong gpio pin,
unless rfkill happens to sit there.

-- 
Bob Copeland %% www.bobcopeland.com
