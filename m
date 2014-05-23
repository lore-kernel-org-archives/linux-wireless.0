Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43568 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEWJfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:35:23 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so811592wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 02:35:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400836074.4358.12.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-5-git-send-email-michal.kazior@tieto.com>
	<1400770484.4174.35.camel@jlt4.sipsolutions.net>
	<CA+BoTQmdNV3XMmiAmA=bP4ZQ7dRZOwX8=_NYqmZW+orEA=OysA@mail.gmail.com>
	<1400834656.4358.1.camel@jlt4.sipsolutions.net>
	<CA+BoTQnLPEqTnyr98TmDETP_iBOAza_XLZ53Jd+GdG6sRc3=5Q@mail.gmail.com>
	<1400836074.4358.12.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 11:35:21 +0200
Message-ID: <CA+BoTQmdLub9wRb03_M5bcFn5ruMcj8k-p-ELWBu516Gh14+sQ@mail.gmail.com> (sfid-20140523_113526_704633_6914F454)
Subject: Re: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 11:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-23 at 10:58 +0200, Michal Kazior wrote:
>
>> If you keep on beaconing for too long on a DFS channel after detecting
>> a radar you risk breaking local law (ETSI and FCC specify quiescing
>> periods).
>
> Yes, this is true.
>
>> > You could technically just return NULL in this period, but I don't know
>> > how well drivers would cope with that (though technically they have to
>> > cope with it due to memory allocation failures anyway)
>>
>> Sounds good to me.
>>
>> I guess you'd use ieee80211_csa_is_complete (or
>> ieee80211_csa_update_counter) for template-based drivers to stop
>> beaconing.
>
> The thing is, I don't see that template based drivers would be able to
> stop beaconing :-)
>
> This whole design that requires it seems a bit fishy to start with, so I
> can't really imagine anyone writing firmware that supports it. That
> said, ours only supports a single beacon at a time anyway, so we'll
> switch immediately and don't have to do that anyway.

What if you have AP+STA and STA switches too? It might delay your AP
interface switch, no? We could assume userspace always requests us to
do The Right Thing, but should we trust it so much?


Michał
