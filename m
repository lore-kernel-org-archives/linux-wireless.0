Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41855C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 093222075A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="HYKF4Hx9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfBVNkP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:40:15 -0500
Received: from mail.toke.dk ([52.28.52.200]:51773 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfBVNkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 08:40:15 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1550842813; bh=H6iIspkFhBFfQtKWrzTUwRJ2+ZN734gWWFeMNNp2YrY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HYKF4Hx9wHNPwVE//MCDwd65slvfY3JLdfbJ/IInhIXgrs4bbJ+KMzZZN9kmfqKQg
         1g4tMPCUP6BrK6tE1aPhyny3vYnNjR6WCAIJdHvh+FIK722V5DVemOF8hKTmQWH9Ia
         v0/NO88PfYm5Jky6QxqEUqrvXbeoQxSUGRMpXoES2FCEWgQN0oxREisjqLGI+omj4n
         BXfJABX8wrZ4n9QX8nU3Yo/WtQh5+93UVBqrhoPqRqlwdNDcXSF3Yxsq8Qp9LmCoVG
         pnLlCsme1tY6bC983YlmZ2w9H0PQie2Md+eI7lQ1FBLT3Yj4Y+n8kElZkM0D7Kap/+
         KUis4R4sbisAA==
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Grant Grundler <grundler@google.com>,
        Kalle Valo <kvalo@codeaurora.org>, wgong@qti.qualcomm.com,
        ath10k@lists.infradead.org, wgong@codeaurora.org,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH] mac80211: Change default tx_sk_pacing_shift to 7
In-Reply-To: <a5151441bdfe02cb11043aa0786185b8ee3c3ee9.camel@sipsolutions.net>
References: <20190221172936.21816-1-toke@redhat.com> <E1gx9x3-0002j0-1J@sipsolutions.net> <87lg28vup0.fsf@toke.dk> <a5151441bdfe02cb11043aa0786185b8ee3c3ee9.camel@sipsolutions.net>
Date:   Fri, 22 Feb 2019 14:40:12 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87imxcvt4z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2019-02-22 at 14:06 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >=20
>> > > When we did the original tests for the optimal value of sk_pacing_sh=
ift, we
>> > > came up with 6 ms of buffering as the default. Sadly, 6 is not a pow=
er of
>> > > two, so when picking the shift value I erred on the size of less buf=
fering
>> > > and picked 4 ms instead of 8. This was probably wrong; those 2 ms of=
 extra
>> > > buffering makes a larger difference than I thought.
>> > >=20
>> > > So, change the default pacing shift to 7, which corresponds to 8 ms =
of
>> > > buffering. The point of diminishing returns really kicks in after 8 =
ms, and
>> > > so having this as a default should cut down on the need for extensive
>> > > per-device testing and overrides needed in the drivers.
>> > >=20
>> > > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >=20
>> > Patch applied to wireless.git, thanks.
>> >=20
>> > a41f56b9a17a (HEAD -> mac80211) mac80211: Change default
>> > tx_sk_pacing_shift to 7
>
> This mess came from Kalle's tool btw, so I can't really use it yet :-)
>
>> Cool, thanks! What's the easiest way to backport this? I figure it's
>> easier to just update sk_pacing_shift_update() in tx.c for 4.19 (which
>> predates the addition of the driver override hook); shall I just send a
>> separate patch to stable for that? Or do we need to backport the driver
>> override hook as well?
>
> Just update the value, no need to backport the hook.

And send it directly to stable, or does it need to go through you?

-Toke
