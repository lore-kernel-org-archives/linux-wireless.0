Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:51480 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdJRVCR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 17:02:17 -0400
Received: by mail-io0-f169.google.com with SMTP id b186so7712178iof.8
        for <linux-wireless@vger.kernel.org>; Wed, 18 Oct 2017 14:02:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508359811.2674.56.camel@sipsolutions.net>
References: <20171017202545.GA115810@beast> <1508322566.2674.17.camel@sipsolutions.net>
 <CAGXu5jKY5rTuR_w=zj5Bz06f9OrW35eD4sYfkai2Gac_edG4ag@mail.gmail.com> <1508359811.2674.56.camel@sipsolutions.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Oct 2017 14:02:15 -0700
Message-ID: <CAGXu5jLC4FAXvHxn+N1d_6nSz-MnBAPMeNFKbt4W+fERAxTHZg@mail.gmail.com> (sfid-20171018_230305_014291_0365D149)
Subject: Re: [PATCH] mac80211: aggregation: Convert timers to use timer_setup()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 18, 2017 at 1:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2017-10-18 at 07:19 -0700, Kees Cook wrote:
>> On Wed, Oct 18, 2017 at 3:29 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > > This has been the least trivial timer conversion yet. Given the use of
>> > > RCU and other things I may not even know about, I'd love to get a close
>> > > look at this. I *think* this is correct, as it will re-lookup the tid
>> > > entries when firing the timer.
>> >
>> > I'm not really sure why you're doing the lookup again? That seems
>> > pointless, since you already have the right structure, and already rely
>> > on it being valid. You can't really get a new struct assigned to the
>> > same TID without the old one being destroyed.
>>
>> I couldn't tell what the lifetime expectation was, so I left the
>> re-lookup. I assumed it was possible to have a timer fire after the
>> structure had been removed from the station structure.
>
> Oh, right, I guess that would've been possible in theory. It's not
> actually possible though since the aggregation sessions can't live on
> without a station, so I've already made a follow-up patch to remove the
> indirection.

Okay, cool, thanks.

It seems like I have a similar case in the iwlwifi driver too, but
it's different enough that I'm not sure about that one either. I'll
send that when I've got it ready.

-Kees

-- 
Kees Cook
Pixel Security
