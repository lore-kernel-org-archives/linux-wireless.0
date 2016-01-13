Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33699 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbcAMG4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 01:56:00 -0500
Received: by mail-ob0-f182.google.com with SMTP id is5so47766027obc.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 22:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3=R+14jNctCsXHbE-dzCEUrb1SRGy9NDwY-b_1WNCYiA@mail.gmail.com>
References: <CALCETrWP=cv_3Q6BheFm=edFfSJ6Vs5NdeMtRJrBBk6bFQuoTQ@mail.gmail.com>
 <CANUX_P3=R+14jNctCsXHbE-dzCEUrb1SRGy9NDwY-b_1WNCYiA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 12 Jan 2016 22:55:39 -0800
Message-ID: <CALCETrW7Jmkd=41oEHv6FBntjA=ELEP8_D0xFFEjNuOUuZ5sDA@mail.gmail.com> (sfid-20160113_075604_229278_2338713B)
Subject: Re: Invalid SPLX
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 2, 2015 at 1:23 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Hi,
>
>
> On Wed, Dec 2, 2015 at 10:35 PM, Andy Lutomirski <luto@kernel.org> wrote:
>> Hi-
>>
>> My laptop has SPLC implemented like this:
>>
>>         Name (SPLX, Package (0x04)
>>         {
>>             Zero,
>>             Package (0x03)
>>             {
>>                 0x80000000,
>>                 0x80000000,
>>                 0x80000000
>>             },
>>
>>             Package (0x03)
>>             {
>>                 0x80000000,
>>                 0x80000000,
>>                 0x80000000
>>             },
>>
>>             Package (0x03)
>>             {
>>                 0x80000000,
>>                 0x80000000,
>>                 0x80000000
>>             }
>>         })
>>         Method (SPLC, 0, Serialized)
>>         {
>>             Index (DerefOf (Index (SPLX, One)), Zero) = DOM1 /* \DOM1 */
>>             Index (DerefOf (Index (SPLX, One)), One) = LIM1 /* \LIM1 */
>>             Index (DerefOf (Index (SPLX, One)), 0x02) = TIM1 /* \TIM1 */
>>             Index (DerefOf (Index (SPLX, 0x02)), Zero) = DOM2 /* \DOM2 */
>>             Index (DerefOf (Index (SPLX, 0x02)), One) = LIM2 /* \LIM2 */
>>             Index (DerefOf (Index (SPLX, 0x02)), 0x02) = TIM2 /* \TIM2 */
>>             Index (DerefOf (Index (SPLX, 0x03)), Zero) = DOM3 /* \DOM3 */
>>             Index (DerefOf (Index (SPLX, 0x03)), One) = LIM3 /* \LIM3 */
>>             Index (DerefOf (Index (SPLX, 0x03)), 0x02) = TIM3 /* \TIM3 */
>>             Return (SPLX) /* \_SB_.PCI0.RP14.PXSX.SPLX */
>>         }
>>
>> splx_get_power_limit rejects this because it has more than one entry.
>> I don't see a spec for SPLC, but I'd guess that splx_get_power_limit
>> should iterate all the entries to find one that indicates wifi.
>>
>> Also, should this be in common code instead of just in iwleifi?
>>
>
> TBH, I don't know much about that. I'll ask internally and get back to
> you. I am badly overloaded, so feel free to ping me in a few days if
> you haven't heard from me.

Happy new year!  Consider yourself pinged :)

--Andy
