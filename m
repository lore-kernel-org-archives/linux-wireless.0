Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50665 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcCXNxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 09:53:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [1/2] bcma: fix building without OF_IRQ
References: <20160323155243.D1AB4615C6@smtp.codeaurora.org>
	<9767564.jLc8Ig1W5l@wuerfel>
Date: Thu, 24 Mar 2016 15:53:14 +0200
In-Reply-To: <9767564.jLc8Ig1W5l@wuerfel> (Arnd Bergmann's message of "Thu, 24
	Mar 2016 14:19:08 +0100")
Message-ID: <871t70dlth.fsf@kamboji.qca.qualcomm.com> (sfid-20160324_145326_693380_D8810822)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday 23 March 2016 15:52:43 Kalle Valo wrote:
>> > The bcma driver core can be built with or without DT support, but
>> > it fails to build when CONFIG_OF=y and CONFIG_OF_IRQ=n, which
>> > can happen on platforms that do not support IRQ domains.
>> > 
>> > ERROR: "irq_create_of_mapping" [drivers/bcma/bcma.ko] undefined!
>> > ERROR: "of_irq_parse_raw" [drivers/bcma/bcma.ko] undefined!
>> > ERROR: "of_irq_parse_one" [drivers/bcma/bcma.ko] undefined!
>> > 
>> > This adds another compile-time check for OF_IRQ, but also
>> > gets rid of now unneeded #ifdef checks: Using the simpler
>> > IS_ENABLED() check for OF_IRQ also covers the case of not
>> > having CONFIG_OF enabled. The check for CONFIG_OF_ADDRESS
>> > was added to allow building on architectures without
>> > OF_ADDRESS, but that has been addressed already in
>> > b1d06b60e90c ("of: Provide static inline function for
>> > of_translate_address if needed").
>> > 
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> 
>> Thanks, applied to wireless-drivers.git.
>> 
>
> Thanks! I see you have applied patch 1/2 but not patch 2/2.
>
> As mentioned in the comment for patch 2, it should be tested
> better, but I want to make sure that someone still has it
> on their radar.

Just to avoid any confusions I assume you are talking about this patch:

[v2] bcma: use of_dma_configure() to set initial dma mask
https://patchwork.kernel.org/patch/8608751/

It's on my patchwork queue and I'm planning to apply it to
wireless-drivers-next once it opens again. But I'm not able to test the
patch myself, I hope someone else could do it.

-- 
Kalle Valo
