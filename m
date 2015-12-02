Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34520 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbbLBVXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 16:23:14 -0500
Received: by lffu14 with SMTP id u14so68033373lff.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2015 13:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALCETrWP=cv_3Q6BheFm=edFfSJ6Vs5NdeMtRJrBBk6bFQuoTQ@mail.gmail.com>
References: <CALCETrWP=cv_3Q6BheFm=edFfSJ6Vs5NdeMtRJrBBk6bFQuoTQ@mail.gmail.com>
Date: Wed, 2 Dec 2015 23:23:13 +0200
Message-ID: <CANUX_P3=R+14jNctCsXHbE-dzCEUrb1SRGy9NDwY-b_1WNCYiA@mail.gmail.com> (sfid-20151202_222404_525428_C9384DEA)
Subject: Re: Invalid SPLX
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Wed, Dec 2, 2015 at 10:35 PM, Andy Lutomirski <luto@kernel.org> wrote:
> Hi-
>
> My laptop has SPLC implemented like this:
>
>         Name (SPLX, Package (0x04)
>         {
>             Zero,
>             Package (0x03)
>             {
>                 0x80000000,
>                 0x80000000,
>                 0x80000000
>             },
>
>             Package (0x03)
>             {
>                 0x80000000,
>                 0x80000000,
>                 0x80000000
>             },
>
>             Package (0x03)
>             {
>                 0x80000000,
>                 0x80000000,
>                 0x80000000
>             }
>         })
>         Method (SPLC, 0, Serialized)
>         {
>             Index (DerefOf (Index (SPLX, One)), Zero) = DOM1 /* \DOM1 */
>             Index (DerefOf (Index (SPLX, One)), One) = LIM1 /* \LIM1 */
>             Index (DerefOf (Index (SPLX, One)), 0x02) = TIM1 /* \TIM1 */
>             Index (DerefOf (Index (SPLX, 0x02)), Zero) = DOM2 /* \DOM2 */
>             Index (DerefOf (Index (SPLX, 0x02)), One) = LIM2 /* \LIM2 */
>             Index (DerefOf (Index (SPLX, 0x02)), 0x02) = TIM2 /* \TIM2 */
>             Index (DerefOf (Index (SPLX, 0x03)), Zero) = DOM3 /* \DOM3 */
>             Index (DerefOf (Index (SPLX, 0x03)), One) = LIM3 /* \LIM3 */
>             Index (DerefOf (Index (SPLX, 0x03)), 0x02) = TIM3 /* \TIM3 */
>             Return (SPLX) /* \_SB_.PCI0.RP14.PXSX.SPLX */
>         }
>
> splx_get_power_limit rejects this because it has more than one entry.
> I don't see a spec for SPLC, but I'd guess that splx_get_power_limit
> should iterate all the entries to find one that indicates wifi.
>
> Also, should this be in common code instead of just in iwleifi?
>

TBH, I don't know much about that. I'll ask internally and get back to
you. I am badly overloaded, so feel free to ping me in a few days if
you haven't heard from me.
