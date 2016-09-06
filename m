Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755115AbcIFHsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 03:48:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2] bcma: use of_dma_configure() to set initial dma mask
References: <20160903140819.245F06216C@smtp.codeaurora.org>
        <6123998.NAlOfyAp5F@wuerfel>
Date: Tue, 06 Sep 2016 10:48:16 +0300
In-Reply-To: <6123998.NAlOfyAp5F@wuerfel> (Arnd Bergmann's message of "Mon, 05
        Sep 2016 17:26:27 +0200")
Message-ID: <87twdtxydb.fsf@kamboji.qca.qualcomm.com> (sfid-20160906_094847_824659_2326F277)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Saturday, September 3, 2016 2:08:19 PM CEST Kalle Valo wrote:
>> Arnd Bergmann <arnd@arndb.de> wrote:
>> > While fixing another bug, I noticed that bcma manually sets up
>> > a dma_mask pointer for its child devices. We have a generic
>> > helper for that now, which should be able to cope better with
>> > any variations that might be needed to deal with cache coherency,
>> > unusual DMA address offsets, iommus, or limited DMA masks, none
>> > of which are currently handled here.
>> > 
>> > This changes the core to use the of_dma_configure(), like
>> > we do for platform devices that are probed directly from
>> > DT.
>> > 
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> 
>> Nobody tested this, so I'll drop the patch.
>
> Should I resend it? I think it's still required.

Sorry, I misunderstood your comments then. No need to resend, I readded
this to my queue:

https://patchwork.kernel.org/patch/8608751/

-- 
Kalle Valo
