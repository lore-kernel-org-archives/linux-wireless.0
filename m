Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51395 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0KARRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 13:17:13 -0400
Received: by vws13 with SMTP id 13so3848138vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 10:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=+L+R1HowfmcLc7fTP+p0=u0T8bcYcob-TNyNb@mail.gmail.com>
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>
	<20101005131744.GB4074@tuxdriver.com>
	<20101005195039.GD11831@tux>
	<AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com>
	<4CB0890D.3050208@openwrt.org>
	<4CCA0908.6000105@candelatech.com>
	<4CCA0B26.5010008@openwrt.org>
	<AANLkTinu4_EcvzgS6AhxRYtSg=y=iwfcFtk0AhgOK-bS@mail.gmail.com>
	<AANLkTi=+L+R1HowfmcLc7fTP+p0=u0T8bcYcob-TNyNb@mail.gmail.com>
Date: Mon, 1 Nov 2010 13:17:12 -0400
Message-ID: <AANLkTinVu-DPdS43rMjDc0MMVDXMPHvKtbVfQJE8Ny=C@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/1 Björn Smedman <bjorn.smedman@venatech.se>:
> On Fri, Oct 29, 2010 at 2:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> [snip]
>> I'd rather not add it if its not fixing anything. I hate code that is
>> there just because we have a fuzzy feeling it helps.
>>
>> So NACK unless it fixes something.
>>
>>  Luis
>
> IMHO there is a right and wrong, at the very least inside a computer.
> If we can't read the documentation (Documentation/memory-barriers.txt)
> and decide if the patch is correct or incorrect (I'm not saying I can
> with 100% certainty) then perhaps we should ask somebody who can?

For what it's worth, I agree that there should be a memory barrier
between updating the contents of descriptors and linking them into
the linked list seen by the hardware.  If I may quote dma-mapping.txt:

"Consistent DMA memory does not preclude the usage of proper memory
barriers.  The CPU may reorder stores to consistent memory just as
it may normal memory."  .. and then it gives an example which is
exactly this case.

I had proposed such a patch for ath5k a while ago, but I never pushed
it upstream since it didn't seem to help any of the synchronization
problems we were seeing on the platforms for which we have hardware,
while better locking did.  If anyone in PPC land wants to see if
an eieio helps them let me know :)

One thing such a patch _does_ need, though, is a comment that describes
why there is a barrier.  Otherwise when people reorganize the code,
they may forget to take the barrier with it, and it also lets
late-comers know which data is serialized by the barrier.  In the best
case, said late-comers are more knowledgeable than me and fix the crap
code that I write.

-- 
Bob Copeland %% www.bobcopeland.com
