Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:50557 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbdLAPyR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:54:17 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "akolli\@codeaurora.org" <akolli@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "linux-wireless-owner\@vger.kernel.org"
        <linux-wireless-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
In-Reply-To: <1512143142.25588.17.camel@sipsolutions.net>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com> <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com> <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com> <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk> <87bmjjzppd.fsf@kamboji.qca.qualcomm.com> <5080a68538fd2d883e15bacaa969661b@codeaurora.org> <87r2se36rq.fsf@toke.dk> <87k1y6y04i.fsf@kamboji.qca.qualcomm.com> <87d13y31r0.fsf@toke.dk> <1512143142.25588.17.camel@sipsolutions.net>
Date: Fri, 01 Dec 2017 16:54:12 +0100
Message-ID: <87a7z230m3.fsf@toke.dk> (sfid-20171201_165425_202553_22EA5335)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-12-01 at 16:29 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> Yeah, figures. Well, maybe we'll just have to support an asynchronous
>> callback into mac80211 to register airtime usage. Will probably have to
>> add some asynchronicity anyway to avoid doing too much work in the fast
>> path.
>
> I really think we should have that anyway. In fact, perhaps we should
> just enforce it that way? Then ath9k would have to do a bit more work,
> but it's also the slower of the devices :-)
>
> But this plays in with the whole multi-queue RX we discussed before.

Yeah, that's what I meant by 'add some asynchronicity anyway' :)

I guess that once we have an asynchronous scheduler task of some kind,
supporting the callback is easy, but pulling the data out of each packet
needs more work. But since we'll have to do that for ath9k anyway it
becomes more a question of whether it's something that should be
supported in mac80211 or if it should be implemented in each driver.
But since that logic will have to be written from scratch anyway, is
there any reason to not just do it in mac80211 from the beginning?

-Toke
