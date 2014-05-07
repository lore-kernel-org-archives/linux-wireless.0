Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:63924 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaEGGFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 02:05:21 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so484067wgg.24
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2014 23:05:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399385141.4218.37.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	<1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	<1399372915.4218.17.camel@jlt4.sipsolutions.net>
	<CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	<1399385141.4218.37.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 08:05:20 +0200
Message-ID: <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com> (sfid-20140507_080533_055503_294C54A9)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 16:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-05-06 at 14:47 +0200, Michal Kazior wrote:
[...]
>> If I consider non-chanctx drivers we would need to do:
>>   if (!local->chanctx) { del_chanctx(); add_chanctx(); } else {
>> switch_vif_chanctx(); }
>
> Not sure - we still need to do the right book-keeping inside mac80211 to
> remove/add the chanctx around (after) the new driver operation, that
> might in itself do enough. Depends on how the code is structured, I
> guess. But yeah, something will probably be needed.
>
>> Btw. Do you intend the new switch_vif_chanctx() to take over
>> unassign_vif_chanctx() too?
>
> It has to, yeah. There are two cases for the new op - the ones you
> called "use_reserved_incompat" and "use_reserved_compat".
>
> For the former, our driver will behave as though you'd called
>
>  unassign_vif_chanctx(vif, old)
>  delete_chanctx(old)
>  add_chanctx(new)
>  assign_vif_chanctx(vif, new)
>
> [though other drivers may behave differently]
>
> For the latter, drivers will behave as though you'd called
>
>  unassign_vif_chanctx(vif, old)
>  assign_vif_chanctx(vif, new)
>
> [but depending on how the driver operates it'll be able to do this in a
> single atomic step, similar to how mac80211 never goes through NULL in
> either of these cases for the vif chanctx pointer]

Hmm... Now that I think about the atomic swap - it actually becomes a
little bit of an issue in some cases.

For one you might need to overcommit number of chanctx since swapping
requires both chanctx (old and new) to exist but that's the least of
the eproblem. If you have more than one interface you end up with
temporarily breaking interface combinations from driver point of view
while switching (first swap breaks it, last swap fixes it). Driver
won't know whether given swap is first/last unless we somehow pass it
through the switch_vif_chanctx(). IOW we actually need a "chanctx
transaction" (sort of a start-stop) that can batch up a couple of
chanctx switches for different vifs as an atomic op.


>> > Separately, I think due to the complexities involved in the driver
>> > implementation we'll probably need a bitmap indicating which interface
>> > types are supported (this is not something we do today, and this would
>> > be broken in iwlwifi for sure.)
>>
>> Care to elaborate?
>
> It's a separate issue really - but sure: the iwlwifi firmware API will
> likely not allow doing such trickery in the IBSS case, so we should have
> a bitmap of supported interface types (e.g. BIT(NL80211_IFTYPE_STATION)
> | ...) for the channel switch operation.

Ah, I get it now. Thanks.


Michał
