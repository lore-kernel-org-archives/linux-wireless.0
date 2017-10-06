Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59783 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdJFKRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 06:17:24 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: converting mac80211 to TXQs entirely
In-Reply-To: <1507283082.19300.6.camel@sipsolutions.net>
References: <1507205618.2387.19.camel@sipsolutions.net> <1507217947.2387.60.camel@sipsolutions.net> <87efqhsgni.fsf@toke.dk> <1507221836.2387.66.camel@sipsolutions.net> <878tgps1o7.fsf@toke.dk> <1507283082.19300.6.camel@sipsolutions.net>
Date: Fri, 06 Oct 2017 12:17:20 +0200
Message-ID: <87376wshqn.fsf@toke.dk> (sfid-20171006_121727_635334_D3EF126E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> The obvious alternative is to do a token-based airtime scheduler,
>> where the airtime used by one station is immediately divided out to
>> all active stations. But that requires walking over all active
>> stations on every TX completion, and there's a lot of housekeeping to
>> make sure we don't accidentally starve everyone. So I'd prefer to
>> stick with the DRR scheduler :)
>
> Sure, works for me.
>
> I have no objection to defining a special error code (we can always
> use ERR_PTR(-EAGAIN) or something like that, after all) - we just need
> to be careful with driver updates.

Right. I'll see if I can cook up an RFC.

Do you have any opinion on whether to use ERR_PTR or change the function
to an int return and pass the pointer as an argument? At least ath10k
seems to do the latter (returning -ENOENT when no packet is available).

-Toke
