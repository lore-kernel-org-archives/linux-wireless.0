Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45979 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2IVThN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2012 15:37:13 -0400
Received: by vcbfo13 with SMTP id fo13so5105051vcb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2012 12:37:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347023063.4256.24.camel@jlt4.sipsolutions.net>
References: <5048ADFC.1010708@sonymobile.com>
	<20120906224448.GA16676@khazad-dum.debian.net>
	<CAMJBoFMd2sLEScY3j2-wsWQh3Mv_nArPC904dzJ+j-16+pdkgQ@mail.gmail.com>
	<1347006078.4256.6.camel@jlt4.sipsolutions.net>
	<CAMJBoFNQFpM_do9EVBAQu8vtbsAiZJDJkoL9pcXwVP-Cf1=ZZg@mail.gmail.com>
	<1347023063.4256.24.camel@jlt4.sipsolutions.net>
Date: Sat, 22 Sep 2012 21:37:12 +0200
Message-ID: <CAMJBoFPkdyZPubJfEEihRgL7YU_rVKKB=fH-3h+-cM23iKTicg@mail.gmail.com> (sfid-20120922_213719_523489_00C766BD)
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
From: Vitaly Wool <vitalywool@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Vitaly Wool <vitaly.wool@sonymobile.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Sep 7, 2012 at 3:04 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-09-07 at 15:02 +0200, Vitaly Wool wrote:
>
>> >> I'm not sure I got your question, but just in case, rfkill is
>> >> initialized to all zeroes so rfkill->state is 0 and on each consequent
>> >> _real_ change there (prev != curr) == true and the event will be
>> >> generated.
>> >
>> > But maybe applications were expecting an event for registration? Or do
>> > we get that anyway maybe?
>>
>> We should get them anyway. rfkill_fop_open() basically just pushes all
>> the startup events into the list so the application will see all the
>> _changes_ on registration. And at least wpa_supplicant reads out all
>> these events on rfkill registration. If an application does something
>> else, then I think it's buggy.
>
> Aha, good point. I guess I'll apply the patch then :)

provided that I don't see the patch merged, is there anything else we
should take care of before it's considered good enough?

Thanks,
   Vitaly
