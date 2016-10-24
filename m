Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37206 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941049AbcJXOHv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:07:51 -0400
Received: by mail-wm0-f51.google.com with SMTP id f193so122450277wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 07:07:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3178350.ZYYEYN7rIx@prime>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
 <20161024121129.GA8925@prodigo.lan> <1477316004.4085.17.camel@sipsolutions.net>
 <3178350.ZYYEYN7rIx@prime>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 24 Oct 2016 16:07:48 +0200
Message-ID: <CA+BoTQnGTr3tL1tiJCuKECtkzXU4tcLNZzqVbQ95r1quR2U4Mw@mail.gmail.com> (sfid-20161024_160835_588123_A034612D)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Antonio Quartulli <a@unstable.cc>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2016 at 15:42, Simon Wunderlich <sw@simonwunderlich.de> wrote=
:
> On Monday, October 24, 2016 3:33:24 PM CEST Johannes Berg wrote:
>> > > I think it would be reasonable only if the target channel is the
>> > > one we are using and we have done CSA. But when scanning non-
>> > > operative channels I don't think this could work.
>> >
>> > this has been sleeping for a while.. :)
>> > Would it make sense to rebase it and resubmit it for inclusion?
>> >
>> > Given the previous discussion we could change the logic as:
>> > * always passively scan DFS channels that are not usable
>> > * always actively scan DFS channels that are usable (i.e. CAC was
>> > performed).
>>
>> Doesn't that contradict what you said above?
>>
>> If we scan, don't we possibly lose our CAC result anyway, since we went
>> off-channel? In FCC at least? In ETSI I think we're allowed to do that
>> for a bit?
>
> I believe going off-channel was allowed in general - in fact, some router=
s CAC
> all channels on boot up and then keep the "usable" state forever.

I recall a discussion around this behavior [scan all on boot] a long
time ago. I believe earlier ETSI spec revisions allowed it but recent
ones made it more explicit that you can't cache CAC results like that
but don't take my word for it. I don't have have the spec on me now so
can't check.


Micha=C5=82
