Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:48456 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdJROR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 10:17:59 -0400
Received: by mail-it0-f52.google.com with SMTP id c3so6419019itc.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Oct 2017 07:17:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508326655.2674.22.camel@sipsolutions.net>
References: <20171017202545.GA115810@beast> <1508322566.2674.17.camel@sipsolutions.net>
 <1508326291.2674.21.camel@sipsolutions.net> <1508326655.2674.22.camel@sipsolutions.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Oct 2017 07:17:57 -0700
Message-ID: <CAGXu5jKR1GEGwLdMUC8_Mu93+0ukr5M+TWm1Yk-ECfv37Eg1hQ@mail.gmail.com> (sfid-20171018_161821_023951_9D72C499)
Subject: Re: [PATCH] mac80211: aggregation: Convert timers to use timer_setup()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 18, 2017 at 4:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2017-10-18 at 13:31 +0200, Johannes Berg wrote:
>> On Wed, 2017-10-18 at 12:29 +0200, Johannes Berg wrote:
>>
>> > Anyway, the change here looks correct to me, so I'll apply it and then
>> > perhaps clean up more. I've only changed "u16 tid" to "u8 tid" since
>> > the valid range is 0-15 (in theory, in practice 0-7).

I started with u8 tid, but I saw it cast to u16 and in a few other
places it was u16, so I went with that ultimately.

>> Well, I guess I'm clearly wrong - it's crashing our test suite left and
>> right.
>>
>> I'll dig a little bit, but I don't have much time today, and will be
>> out for a few days starting tomorrow.
>
> Ok, it's pretty obvious - you never initialize the new fields in tid_tx
> (sta and tid), only in tid_rx. Let's see if it passes with that fixed.

Argh, whoops, thanks for working on this.

-Kees

-- 
Kees Cook
Pixel Security
