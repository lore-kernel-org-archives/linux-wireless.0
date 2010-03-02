Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54733 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0CBHnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:43:52 -0500
Received: by pva4 with SMTP id 4so797362pva.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 23:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19340.37002.731064.872605@gargle.gargle.HOWL>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
	<20100302002759.GH8069@bombadil.infradead.org> <19340.37002.731064.872605@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 23:43:32 -0800
Message-ID: <43e72e891003012343l655bacc1i57ebe9ca55262878@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 8:14 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> Apart from that there's one long term objective which I noticed
>> was removed from my initial implementation approach. On this driver
>> the the hif/htc code linked all together while I had these separated.
>> The reason for separation was in the future different buses would be
>> supported and so a different HIF transport would be required. The
>> typical HTC Atheros driver tends to bundle HTC together and re-build
>> HTC for a new driver sort of how you've used lib.o for ath9k and
>> ath9k_htc only that each htc.o would be modified to suit each new
>> driver and firmware API. I think that's pointless and gross and tried
>> to work on a way HTC can exist as a registrar, sharing all things HTC
>> that are possible. Consider PCI support for a device similar to AR9271
>> with, say a AR9280 MAC and radios. In such a case (and very possible)
>> we'd need an HIF PCI added, so you will need to eventually address
>> separation anyway.
>
> I am not sure what your original approach was - but a new bus implementation
> would just be a hif_bleh.c.

Right, only I just had these as separate modules. I suppose its not
important to have these as independent modules, you either want USB
HIF linked in or not, same was with PCI.

> HTC would remain unchanged for the most part.
> Well almost, except if credit distribution is required, it would be added to HTC.
>
> Or am I missing something ?

My modular approach most things were I had hope the AR6003 driver
could also make use of the HTC/HIF framework, they would just register
a ath9k_hif_sdio module, register itself to HTC, and use a separate
hardware family mac80211 core driver for ar6k devices. After review of
the current AR6003 driver architecture later on though I found out
this was not possible, but for future mobile device I do have hope its
possible, just as well as sharing a common ath9k_hw.

We can cross that bridge if and when get to it though.

  Luis
