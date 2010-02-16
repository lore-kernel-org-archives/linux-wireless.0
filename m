Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f178.google.com ([209.85.222.178]:53390 "EHLO
	mail-pz0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487Ab0BPW7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 17:59:50 -0500
Received: by pzk8 with SMTP id 8so5679788pzk.22
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 14:59:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266358340.2659.37.camel@mj>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	<1266124222.13902.42.camel@mj> <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	<1266358340.2659.37.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 14:59:30 -0800
Message-ID: <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 2:12 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Tue, 2010-02-16 at 13:23 -0800, Luis R. Rodriguez wrote:
>
>> > It looks like compat-wireless-2.6.33-rc8 and compat-wireless-2010-02-13
>> > don't have the patches to deal with the lack of netif_tx_wake_queue and
>> > select_queue in Linux 2.6.26.  compat-wireless-2.6.32.8 has such
>> > patches.
>>
>> Oh right, so I was hoping to get some reports on results of MQ
>> backport on 2.6.32.y, I guess its OK enough to merge now and if its
>> borked we can remove older kernel support or something.
>
> I confirm that ath5k and ath9k actually work on that kernel, so the
> results are good.

Sweet!

> There are some funny messages from ath9k, but scanning still works, and
> I don't think it's related to compat-wireless:
>
> ath9k 0000:00:01.0: alloc_safe_buffer: could not alloc dma memory (size=3872)
> ath9k 0000:00:01.0: map_single: unable to map unsafe buffer c6ffe020!
> ath9k 0000:00:01.0: alloc_safe_buffer: could not alloc dma memory (size=3872)
> ath9k 0000:00:01.0: map_single: unable to map unsafe buffer c6800020!

Interesting, not sure what could cause this.

>> > That appears to be caused by the lack of
>> > dma_sync_single_range_for_device on the arm architecture.
>>
>> Interesting... well that would just mean we have to lift SSB off of
>> 2.6.28 kernels.
>
> Perhaps you mean 2.6.26?

Sorry, for some reason I misunderstood and though you were using
2.6.28. Since you did use 2.6.26 it means you did test the new MQ
code, so great :) I'll move that stuff to bleeding edge code + 2.6.33
branch.

> Anyway, I'd rather see
> dma_sync_single_range_for_device() for ARM backported.

Patches are welcomed for it indeed.

  Luis
