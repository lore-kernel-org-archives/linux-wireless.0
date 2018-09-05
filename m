Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36237 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbeIERCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 13:02:11 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
In-Reply-To: <1536147865.3528.14.camel@sipsolutions.net>
References: <20180905113402.7665-1-johannes@sipsolutions.net> <1536147453.3528.11.camel@sipsolutions.net> <87k1o05g04.fsf@toke.dk> <1536147683.3528.12.camel@sipsolutions.net> <1536147865.3528.14.camel@sipsolutions.net>
Date: Wed, 05 Sep 2018 14:32:05 +0200
Message-ID: <87efe8yvju.fsf@toke.dk> (sfid-20180905_143315_514223_F457A59A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 13:41 +0200, Johannes Berg wrote:
>> On Wed, 2018-09-05 at 13:40 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> >=20
>> > Guess we'll have to deal with everything else if we ever move manageme=
nt
>> > frames onto the TXQ path as well...
>>=20
>> Depends on whether we care for management frame priorities or not ... so
>> far we haven't really.
>
> Actually, for the most part we have implemented that properly. Except
> for the TXQ I added for bufferable management ... oh well, I think we're
> the only user thereof now.
>
> I'm not sure we want to have a TXQ per TID for management, that seems
> overkill. But I'm also not sure how to solve this otherwise ...

Graft it to an existing TXQ, similar to how the fragments queue is used
now? Saves a TXQ at the expense of having to special-case it...

-Toke
