Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E880C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 614EA20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="o1/6Cv13"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 614EA20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbeJLRrz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:47:55 -0400
Received: from mail.toke.dk ([52.28.52.200]:36689 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbeJLRrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:47:55 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1539339373; bh=IlrknFkDl7MO8m835o32oG/5tTkiG58NrmjuI3mab7M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=o1/6Cv13bzNSIAZfT1EXrOEjsHivrpCiyf+8hGDTgR5Zw/WsX8wWIjz0JIMPq0iWY
         RQrcfJQFXVguuAdNnWI3YRjhkczk77A4+O6PPO1U4xZZV0mYYuqx1Sym7APozrXBOL
         4FlKGL1QH+mBhA8xHGrZGjtP8OJDnjiKugKvHQ7rWPIUsllNaI0hzHZWxltF7o70gS
         M4uu7kgKyBmsUqt+u9wpdw6m1kffvoVzmIf5UQk86TKECA5EvaTnjPnF1aRspxPd2T
         Qz7/anUd87Viw1MBq3lOI9uuo823V/7tHRDAvXln86FeWEEFt6wF9YuzCUhI8c1C4J
         zyncjYkAVw64Q==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau> <153908837900.9471.5394468800857658136.stgit@alrua-kau> <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org> <87zhvm832s.fsf@toke.dk> <187bade306627912c70d800819ef0b87@codeaurora.org> <87pnwg93at.fsf@toke.dk> <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org>
Date:   Fri, 12 Oct 2018 12:16:13 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875zy7qxle.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-11 03:38, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> Hmm... mine is bit different. txqs are refilled only once for all=20
>>> txqs.
>>> It will give more opportunity for non-served txqs. drv_wake_tx_queue
>>> won't be
>>> called from may_tx as the driver anyway will not push packets in
>>> pull-mode.
>>=20
>> So, as far as I can tell, this requires the hardware to "keep trying"?
>> I.e., if it just stops scheduling a TXQ after may_transmit() returns
>> false, there is no guarantee that that TXQ will ever get re-awoken
>> unless a new packet arrives for it?
>>=20
> That is true and even now ath10k operates the same way in pull mode.
> Not just packet arrival, even napi poll routine tries to pushes the
> packets.

I'm not sure I'm following? At every NAPI poll, the driver tries to push
to *all* TXQs?

> One more thing, fetch indication may pull ~4ms/8ms of packets from
> each tid. This makes deficit too low and so refilling txqs by just
> airtime_weight becomes cumbersome.

Yeah, in general we can't assume that each dequeue uses the same amount
of airtime as the quantum. This is why there's a loop; to fill up
quantum until the first stations gets into the positive.

> In may_transmit, the deficit are incremented by 20 * airtime_weight.
> In future this will be also replaced by station specific quantum. we
> can revisit this once BQL in place. Performance issue is resolved by
> this approach. Do you foresee any issues?

Just using a larger quantum will work as long as all stations send
roughly the same amount of data (airtime) at each transmission. Which is
often the case when you're benchmarking, but not in general. Think of
the size of the quantum as the granularity that the scheduler can
provide fairness at.

What I'd suggest is that instead of increasing the quantum, you do one
of the following:

- Just loop with the smaller quantum until one of the stations go into
  the positive (what we do now).

- Go through all active stations, find the one that is closest being in
  the positive, and add that amount to the quantum. I.e., something
  like (assuming no station has positive deficit; if one does, you don't
  want to add anything anyway):
=20=20
  to_add =3D -(max(stn.deficit) for stn in active stations)
  for stn in active stations:
    stn.deficit +=3D to_add + stn.weight


-Toke
