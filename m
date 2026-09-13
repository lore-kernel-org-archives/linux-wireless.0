Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6233E1692
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 10:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789295294; cv=pass; b=XE1vsKtXkqk3SVCbYAINC5M4HolltoQRWZO0EKjTKAQuh6UMyIX/FaCfS8uQULqbcDjFk87i544K7mdqKQaEXD5UafhLUWFgeA9D5iod8v3kjy2bXi2EEiHYGAcYcdrZxk74zFu4B0g1JuGcszaKPiyudUCfqgMu28Uu2sgnr/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789295294; c=relaxed/simple;
	bh=kNWvEQCyRjaLgM1p3aLM1Srie9RvonzVk2ryxCAmXVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f9SVd55c8xuB8avs2OJkXn01VMVKKkrqC4kX2x7S9dLdCDsConkj/L1vm0mXynVLM1objUvH89Myv8JDy8mtRuedIynb+A6a4FQe3A93Gn+5cLmqi9+O6R81FyoUojlUs20MP4lYACacwz1R5dPcnrgZQeOHN93ATmYF1rTVWDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=CKdSDQbX; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="CKdSDQbX"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86b90133ae8so876628b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 03:28:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789295284; cv=none;
        d=google.com; s=arc-20260327;
        b=UioeRPGw+h8ZEo+dxYnk+wrKyPc1CYNmI3HBepHhghdoTsyIgJNIiwEQ/AEHwROaKT
         sXBJgJz64KaTkSqcV3nOQjudE3cwhj0AqdeMBvUh68Y0vn5qVZozp4q7Gm3iXGPd/vTj
         LCruv7ydVZqbCDmHDLmmlOBX7LOA/Emae5e2RnyqVfCS6FnyZSRnAmJ0vGJNhT145LRO
         yrCBCxM+8aGibrlGibUYXvvczBnV0Cp45bmU+C8BA4q/BNUEPdjtGFRmR+fFz0/Us9td
         JyVkVS2BS4598S35R5KPubNnBGxZi9ynh/feRN0zuhXVNBhx2+wDa6if5BE9BjSy0uai
         2hVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hsJ1mHljxJwgy+8P0gqKctZDw60QtGQTkeLg/Pxi3DM=;
        fh=L9Kh4GipGGx+CiuJ6uxzvKu/Od9A5WQyY1173ak3CQw=;
        b=rvaaL3nIxiO///psxoUSublbElwarda0ARy2NCGo0pRItHqeVOA4FNrEAD9emJ9OTv
         Otd28Cya1onHLJGET0Zm3ZFvHpTBNE2K7eWCaBhHfPPYlloHStmudyJ57L3wvkjEMA9z
         GzOVtvjVqCJo/GYyCT+aFX0DndtWNgtWvh4CqZzLfqfx5kIUwPUjyCc927fWI2XpWBxy
         0abVvQoyiiOFkvwPEPgldIGWdJEEdy6UGRUelS8EDfsmXtoojVBsNal0LP6Z1aebmlOn
         bXmHynauYJ6TKJXw6T3mR7fQhguqS1YKnSekd4eJhED2Hxdcj+qOs1coCAWx+kAN63Y1
         dGWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1789295284; x=1789900084; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hsJ1mHljxJwgy+8P0gqKctZDw60QtGQTkeLg/Pxi3DM=;
        b=CKdSDQbXWL2Bg6tFOjrI8wV+bSNMvLHV8s+7340F/5Pi00N57+Z//RcNAn0Qg0/uJc
         nKLw7ArraE5MOYzAitJjEvxwSzOiWbPcqBFbtlUP0SvKwgspEIR9kF26pH7meCLVGPg0
         vm4yTh9Q2lkcpEVaGrXgdl5d/tKptyxXaekgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789295284; x=1789900084;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hsJ1mHljxJwgy+8P0gqKctZDw60QtGQTkeLg/Pxi3DM=;
        b=m31O3/tE7cpiJWR1UWl7TgW+7hT+V35Vmli2iM/QhHOzd0HjOJtpwXua0DiC5CipCl
         JJTBMFiNaGxA851GGbv05gGRuOcDJ5HACwE/oXRg0Tm4zIHp5DlU70YVjMoI+hC6/c7/
         ke0O7Jxn4OPsTmwvBZN5z9cwnWpDx/SHuJltcQ8LWxBenO/miqDxIotVBFJwaX89NwBc
         SsFfknYROHadhkg4w7UCiChnFOwDJLDCyG5zterwCMz8z6zNzIX6I+XctZj5M1mRfz48
         8NGECsKTFs0bzAbXZ16SR5Qy2PzPCJz8KUXU0FD1IMl2NCTt0SmajdYWmrwWCC3DD2ry
         U0Rw==
X-Forwarded-Encrypted: i=1; AKwUvByik7DmUnr5jycYLDajAN5L6CQ/1sfqAr74QuA3BUyjzWCMsOxeNneKiXFYow03J9uqFevcmE4GfKzz32uzTw==@vger.kernel.org
X-Gm-Message-State: AFuF++kp8LHOX+VZd7qKYo3tLEkWKe2bK1w7H0mwGURhWiT7lznbBNEw
	/mmX11Ew7CbSUIxDz419qwt7+vk2nO1r3RdTO+ok2PUiEV22d7+oiQ7lhJIJjgrGJ0otMldEXs7
	sn9gZ2I5S2XUDxscXKRk5rMa3oPemkXXcAHMcqsAv
X-Gm-Gg: AYBFou1bcFr0M9O01htjDxiNA5iRkplso6FFGzA6xvJvA2580InSzMGGIO/u8nV/t/H
	orM/NSjFKs41RUTTKepvwWEPB5ImT8KvYNARy6b1lD9Mf9ShL4Xe03Y45sKPGzI4jVMF6uwH1tM
	zLwbI03eNxvpoQxi0dp3gw/mUdUBA3QAEoW9QO5fJBXrSKA1z4RRqM+hEDTkH/CXyLHkzDh7Tlo
	mQh3AJ6hyOfN85/RU7C9sJJnu2DYNbcOggtNU1EaAjXrBrGVfKNrM/h5US1e/DnNsPad8v/ZyUp
	cb9/pW/J93IC10OQokAVqvxXV+wRohfrkDhLfSQkAITAiQrVEeHytb1SL+gVY9Ue11NYwTYocPQ
	mBZm+Im4jH+YGIEJt3Ubzjv6cZgvQgMu9XQ==
X-Received: by 2002:a05:6a00:3391:b0:848:2ab3:ddeb with SMTP id
 d2e1a72fcca58-86b31805fdamr21826359b3a.14.1789295283791; Sun, 13 Sep 2026
 03:28:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <QDISC-1L5H.v1.20260912080102@mojatatu.com> <178924538043.3125.18096491736359251092@kernel.org>
In-Reply-To: <178924538043.3125.18096491736359251092@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 13 Sep 2026 06:27:52 -0400
X-Gm-Features: AcwNN1V4nwgk76kDIMu53KNM_DcPMOoQmUOn28RRe2W8o2zUuB1mNfvpULddFLY
Message-ID: <CAM0EoMk6Di3L7=qTW2H=NWcU1MV0eb3ywNGFnmK=5x4g+8K_xg@mail.gmail.com>
Subject: Re: [PATCH net repost 1/2] net/sched: codel: bound the dropping loop
 per dequeue call
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	victor@mojatatu.com, johannes@sipsolutions.net, 
	linux-wireless@vger.kernel.org, shuah@kernel.org, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 4:36=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 0 =C2=B7 Low: 0
>
> - [High] The new drop cap in codel_dequeue()
>   (include/net/codel_impl.h:189) is enforced with a function-local=E2=80=
=A6
>

Commenting on both this and the tdc tests:
All findings are accurate, but they are arguments against the
changelog and selftest-quality nits against an already-sent; IOW, none
is a code defect requiring a revised patch.

There is one substantive item regarding the per-flow vs per-dequeue
cap comment; i have captured it  is as a follow-up candidate and dont
see as a blocker.

cheers,
jamal

> --
>
> net/sched: codel: bound the dropping loop per dequeue call
>
> The patch clamps the CoDel control law increment to at least one tick so
> the dropping loop always advances, and caps the loop at
> CODEL_MAX_DROPS_PER_DEQUEUE (256) drops per codel_dequeue() call,
> resyncing drop_next to now when the cap trips.
>
> > diff --git a/include/net/codel.h b/include/net/codel.h
> > index aa80f744826cd..183d43c2bd434 100644
> > --- a/include/net/codel.h
> > +++ b/include/net/codel.h
> > @@ -140,6 +140,11 @@ struct codel_vars {
> >  /* needed shift to get a Q0.32 number from rec_inv_sqrt */
> >  #define REC_INV_SQRT_SHIFT (32 - REC_INV_SQRT_BITS)
> >
> > +/* Cap on drops per codel_dequeue() call: the loop's work depends on t=
he
> > + * idle gap and backlog, both outside our control; resync when exceede=
d.
> > + */
> > +#define CODEL_MAX_DROPS_PER_DEQUEUE 256
> > +
> >  /**
> >   * struct codel_stats - contains codel shared variables and stats
> >   * @maxpacket:       largest packet we've seen so far
>
> [ ... ]
>
> > diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> > index 2c1f0ec309e9f..8f26132d45b7f 100644
> > --- a/include/net/codel_impl.h
> > +++ b/include/net/codel_impl.h
>
> [ ... ]
>
> > @@ -154,6 +159,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
> >                                    codel_skb_dequeue_t dequeue_func)
> >  {
> >       struct sk_buff *skb =3D dequeue_func(vars, ctx);
> > +     unsigned int drops =3D 0;
> >       codel_time_t now;
> >       bool drop;
> >
> > @@ -180,6 +186,14 @@ static struct sk_buff *codel_dequeue(void *ctx,
> >                        */
> >                       while (vars->dropping &&
> >                              codel_time_after_eq(now, vars->drop_next))=
 {
> > +                             if (++drops > CODEL_MAX_DROPS_PER_DEQUEUE=
) {
> > +                                     /* fell far behind the schedule *=
/
> > +                                     WRITE_ONCE(vars->drop_next,
> > +                                                codel_control_law(now,
> > +                                                                  para=
ms->interval,
> > +                                                                  vars=
->rec_inv_sqrt));
> > +                                     break;
> > +                             }
>
> [Severity: High]
>
> Since drops is a local of codel_dequeue(), does the cap actually bound th=
e
> work done in one fq_codel ->dequeue() call, or only the work done for one
> flow?
>
> When the dropping loop empties a flow (any flow holding no more than 256
> packets), dequeue_func() returns NULL, codel_should_drop(NULL, ...) clear=
s
> vars->dropping and codel_dequeue() returns NULL.  __fq_codel_dequeue() in
> net/sched/sch_fq_codel.c treats that NULL as "flow is empty" and restarts=
:
>
> net/sched/sch_fq_codel.c:__fq_codel_dequeue() {
>         ...
>         skb =3D codel_dequeue(sch, &sch->qstats.backlog, &q->cparams,
>                             &flow->cvars, &q->cstats, qdisc_pkt_len,
>                             codel_get_enqueue_time, drop_func, dequeue_fu=
nc);
>
>         if (!skb) {
>                 /* force a pass through old_flows to prevent starvation *=
/
>                 if ((head =3D=3D &q->new_flows) && !list_empty(&q->old_fl=
ows))
>                         list_move_tail(&flow->flowchain, &q->old_flows);
>                 else
>                         list_del_init(&flow->flowchain);
>                 goto begin;
>         }
>         ...
> }
>
> The goto begin re-enters codel_dequeue() for the next flow with drops bac=
k
> at 0, still inside the same fq_codel_dequeue() call and the same qdisc lo=
ck
> hold.  With flows configurable up to 65536, doesn't that make the aggrega=
te
> per ->dequeue() drop count O(active_flows * 256) rather than 256?
>
> fq_codel_peek() calls the same __fq_codel_dequeue() loop, so does the sam=
e
> amplification apply on the peek path?
>
> The same reproducer from the changelog, with the flood spread over many U=
DP
> source ports so each flow holds at most 256 packets, looks like it would
> still walk the whole backlog in one dequeue under the lock:
>
>   tc qdisc add dev lo root handle 1: tbf rate 1kbit burst 2kb limit 10000=
00
>   tc qdisc add dev lo parent 1:1 handle 10: fq_codel interval 2us \
>       target 1ms noecn limit 1000000 flows 65536
>
> Given that, is this changelog text accurate for fq_codel?
>
>     "The cap applies to fq_codel (4b549a2ef4be) and the mac80211 TXQ path
>     (fixed interval, cap only)."
>
>     "patched kernel: same setup, at most 256 drops per dequeue call,
>      no soft lockup"
>
> Would a budget shared across the fq outer loop work better here, either
> passed in by the caller or signalled back so that __fq_codel_dequeue()
> stops retrying when the budget is exhausted?  Otherwise, could the
> changelog state the residual multi-flow exposure?
>
> The mac80211 TXQ path has the same shape in fq_tin_dequeue()
> (include/net/fq_impl.h), which also does goto begin while fq->lock is hel=
d,
> so the per-call counter resets there too; its fixed 100ms interval keeps
> the per-flow loops short, but is the structural reset worth a note as wel=
l?
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/QDISC-1L5H.v1.20260912080102%40mojatatu.com
