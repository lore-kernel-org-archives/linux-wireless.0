Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73D0C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8EA4207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="MmJo2rWN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfBVNGi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:06:38 -0500
Received: from mail.toke.dk ([52.28.52.200]:45589 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfBVNGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 08:06:37 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1550840796; bh=f24yHwngh8o++0Ca0Cw6BVw00eFHMY+e3ydp+UyOWLU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MmJo2rWNsGJVLAxoZAftELR/YRvDuiBR3samsP+sjjVG1S0zObWxBqDBPSulvAUmR
         kP/7rHUPc40G3q+gBwcmSLRVpB/C4xfrpq3dmILU2wi3g2e0/fbf012DZjCKPJaG3r
         aV1aMZHMpfeUDAQPpR3DKg/FGkrhcTyfaMIGxQXm8EauFfDtm+UBbUHlGT31tg6TZL
         nc5tc4zPIwSWvNl7jCYlVCOuOJtE3+PJjfZlTyiciwimDcJNsZ847cEtkHGLUw+X3K
         Q44v606QdHvNZktrFVskBGjveT2nuMX++edUTyV4rjao9d5cDb47M3zdRVWYarLEPs
         G+5X6/ZeooHCA==
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Grant Grundler <grundler@google.com>,
        Kalle Valo <kvalo@codeaurora.org>, wgong@qti.qualcomm.com,
        ath10k@lists.infradead.org, wgong@codeaurora.org,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH] mac80211: Change default tx_sk_pacing_shift to 7
In-Reply-To: <E1gx9x3-0002j0-1J@sipsolutions.net>
References: <20190221172936.21816-1-toke@redhat.com> <E1gx9x3-0002j0-1J@sipsolutions.net>
Date:   Fri, 22 Feb 2019 14:06:35 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lg28vup0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> When we did the original tests for the optimal value of sk_pacing_shift,=
 we
>> came up with 6 ms of buffering as the default. Sadly, 6 is not a power of
>> two, so when picking the shift value I erred on the size of less bufferi=
ng
>> and picked 4 ms instead of 8. This was probably wrong; those 2 ms of ext=
ra
>> buffering makes a larger difference than I thought.
>>=20
>> So, change the default pacing shift to 7, which corresponds to 8 ms of
>> buffering. The point of diminishing returns really kicks in after 8 ms, =
and
>> so having this as a default should cut down on the need for extensive
>> per-device testing and overrides needed in the drivers.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Patch applied to wireless.git, thanks.
>
> a41f56b9a17a (HEAD -> mac80211) mac80211: Change default
> tx_sk_pacing_shift to 7

Cool, thanks! What's the easiest way to backport this? I figure it's
easier to just update sk_pacing_shift_update() in tx.c for 4.19 (which
predates the addition of the driver override hook); shall I just send a
separate patch to stable for that? Or do we need to backport the driver
override hook as well?

-Toke
