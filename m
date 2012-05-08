Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54597 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2EHSZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 14:25:21 -0400
Received: by qcro28 with SMTP id o28so2974581qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 11:25:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120508175536.GF25400@localhost>
References: <loom.20101104T140201-178@post.gmane.org> <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com>
 <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com>
 <20120508163018.GE25400@localhost> <CAB=NE6Xx_KKjk5s_CMRopwBuHDxajgn=Jdc_Nbb1DN2s=2QL0A@mail.gmail.com>
 <20120508175536.GF25400@localhost>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 8 May 2012 11:24:59 -0700
Message-ID: <CAB=NE6Wbc_U+6dWTx3kc5qdMTSbhSDw=dWH0BWd2ioPQAO8Bag@mail.gmail.com> (sfid-20120508_202530_981217_A6ED5522)
Subject: Re: Adding custom channels to ath5k for researching purposes
To: Bob Copeland <me@bobcopeland.com>
Cc: Vadim <Vadims.Kurmis@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 8, 2012 at 10:55 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, May 08, 2012 at 09:49:22AM -0700, Luis R. Rodriguez wrote:
>> > I still like the idea of exporting more stuff to userspace and letting
>> > CRDA handle the card-based restrictions, but ISTR you had reasons that
>> > didn't work for everything.
>>
>> What do you mean?
>
> /me digs in the archives...
>
> http://marc.info/?l=linux-wireless&m=125752855010045&w=2
>
> I guess I "still" liked it back then :)
>
> So with that setup people who want to fiddle with the card in 'expert'
> mode could override the card's eeprom reg domain stuff by suitably
> changing crda db instead of recompiling the kernel.
>
> But if I read your follow-ups correctly, going that way wasn't actually
> a big win.  I didn't then (much less now) have the time to explore it
> in actual code.
>
> That doesn't cover the person who wanted to use all_channels, but at
> least that is exported by a modparam today.  There are probably other
> things that an 'expert' would want to do beyond these two, though.

I don't think at that point the idea of CONFIG_EXPERT went through my
mind, I think its reasonable now to start considering this. For
example we could start off first with replacing that module parameter
under a CONFIG_WIRELESS_EXPERT. The goal of such flag is to not have
everyone enabling it and by everyone I mean every Linux distribution.
If we can work toward that I think this is a win given that there is
code we can add that otherwise is introduced by crap module parameters
or crap external patches.

  Luis
