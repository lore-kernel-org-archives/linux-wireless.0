Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52475 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaAVKYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:24:00 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so4458124eae.33
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 02:23:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390384700.4334.24.camel@jlt4.sipsolutions.net>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	<1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	<1390318236.6199.45.camel@jlt4.sipsolutions.net>
	<CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	<1390381261.4334.12.camel@jlt4.sipsolutions.net>
	<CA+BoTQmE3TdT=oQbAjzUi5vGo0FA0opz1S9Z6-9UEQ_miSEpXQ@mail.gmail.com>
	<1390384700.4334.24.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 11:23:58 +0100
Message-ID: <CA+BoTQ=7h5beyTa-8fF-7D+3uK8f9K+8-uJP0vG-GWOJiKJERw@mail.gmail.com> (sfid-20140122_112404_236257_372CC6E4)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 10:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 10:40 +0100, Michal Kazior wrote:
>> > That's true, so maybe you just need to explain this chandef thing
>> > better? I don't really see the utility (admittedly without actually
>> > checking carefully in the code where you need it)
>>
>> Since you can CSA multiple interfaces you can have different chandefs
>> for those interfaces. This means you need to know the chandef for the
>> final channel switch.
>>
>> You could probably cache this to local->csa_chandef when processing
>> the channel switch request itself, but that means you explicitly limit
>> yourself to single CSA against a given hw/driver.
>>
>> At one point I was contemplating having a dedicated structure for
>> channel switches, and have a list of channel switch structures in
>> ieee80211_local, but perhaps that's just an overkill.
>
> But if we bind all interfaces against a 'pending' chanctx, then that's
> all implicit in that chanctx calculating/binding, no?

Correct.

Hmm. How do you bind a pending chanctx? Does this mean an interface
can have two channel contexts - the current one, and the pending one?

I suppose you'd still need to iterate over interfaces (through
local->interfaces or the [non-existent yet] chanctx->interfaces)
anyway for validate/sanity check if the final switch is really okay,
and/or possibly disconnect/stop some interfaces that didn't get a
chance to request a channel switch (I'm thinking of your STA-CSA-GO
case).


Michał
