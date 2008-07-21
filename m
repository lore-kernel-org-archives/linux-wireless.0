Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:61025 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYGUWwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 18:52:41 -0400
Received: by an-out-0708.google.com with SMTP id d40so403239and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 15:52:38 -0700 (PDT)
Message-ID: <43e72e890807211552t367d536ft1939cd127e6ddb85@mail.gmail.com> (sfid-20080722_005245_524026_92B438BF)
Date: Mon, 21 Jul 2008 15:52:38 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] ath9k: fix build errors and warnings on 64-bit systems
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1216680279.11291.45.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080721000313.24845.10866.stgit@dv.roinet.com>
	 <15B47C78534E094AA9A41F58FB8D74F3D6EF4A7EEE@SC1EXMB-MBCL.global.atheros.com>
	 <43e72e890807211539p358fa0cbw2c9868ed8f9c9b4e@mail.gmail.com>
	 <1216680279.11291.45.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 3:44 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2008-07-21 at 15:39 -0700, Luis R. Rodriguez wrote:
>> > diff --git a/ksrc/hw.c b/ksrc/hw.c
>> > index b8a9321..5a24cbe 100644
>> > --- a/ksrc/hw.c
>> > +++ b/ksrc/hw.c
>> > @@ -852,9 +852,11 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
>> >        else
>> >                el = ahp->ah_eeprom.baseEepHeader.length;
>> >
>> > +       if (el < sizeof(struct ar5416_eeprom) / sizeof(u_int16_t))
>> > +               el = sizeof(struct ar5416_eeprom) / sizeof(u_int16_t);
>> > +
>> >        eepdata = (u_int16_t *) (&ahp->ah_eeprom);
>> > -       for (i = 0; i <
>> > -               min(el, sizeof(struct ar5416_eeprom)) / sizeof(u_int16_t); i++)
>> > +       for (i = 0; i < el; i++)
>> >                sum ^= *eepdata++;
>> >
>> >        if (need_swap) {
>>
>> Its a good thing indeed I split this into two patches, as your first
>> hunk breaks the check. Had you tested this??? Anyway I've fixed this
>> now.
>
> Sorry, I only compile tested it.  Indeed, the first comparison should be
> inverted, or we get maximum, not minimum.  I didn't want to change the
> code so much, but I wanted to avoid breaking the 80 character limit with
> casts.

We'll need to get you hardware then :)

 Luis
