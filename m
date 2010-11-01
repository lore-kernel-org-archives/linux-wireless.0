Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63666 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0KASt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 14:49:26 -0400
Received: by ywc21 with SMTP id 21so1056946ywc.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 11:49:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinVu-DPdS43rMjDc0MMVDXMPHvKtbVfQJE8Ny=C@mail.gmail.com>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
	<20101005131744.GB4074@tuxdriver.com>
	<20101005195039.GD11831@tux>
	<AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
	<4CB0890D.3050208@openwrt.org>
	<4CCA0908.6000105@candelatech.com>
	<4CCA0B26.5010008@openwrt.org>
	<AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com>
	<AANLkTi=+L+R1HowfmcLc7fTP+p0=u0T8bcYcob-TNyNb@mail.gmail.com>
	<AANLkTinVu-DPdS43rMjDc0MMVDXMPHvKtbVfQJE8Ny=C@mail.gmail.com>
Date: Mon, 1 Nov 2010 19:49:25 +0100
Message-ID: <AANLkTikqw5oVTd66DeQGrPgyPAqh66dm6jCvNFSeHpQi@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/1 Bob Copeland <me@bobcopeland.com>:
> 2010/11/1 Björn Smedman <bjorn.smedman@venatech.se>:
[snip]
>> IMHO there is a right and wrong, at the very least inside a computer.
>> If we can't read the documentation (Documentation/memory-barriers.txt)
>> and decide if the patch is correct or incorrect (I'm not saying I can
>> with 100% certainty) then perhaps we should ask somebody who can?
>
[snip]
> One thing such a patch _does_ need, though, is a comment that describes
> why there is a barrier.  Otherwise when people reorganize the code,
> they may forget to take the barrier with it, and it also lets
> late-comers know which data is serialized by the barrier.  In the best
> case, said late-comers are more knowledgeable than me and fix the crap
> code that I write.

First let me apologize for the tone in my previous mail. It came out
too hard this Monday (due to a long and unwanted weekend of debugging
ath9k DMA errors). I did not mean to suggest that any code is crap
regardless of origin (except maybe if I wrote it).

Thanx Bob for your input. If we agree the memory barriers are needed
for correctness I will add comments and post as PATCH.

/Björn
