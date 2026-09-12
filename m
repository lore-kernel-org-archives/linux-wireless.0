Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDC1493D53;
	Sat, 12 Sep 2026 20:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789245385; cv=none; b=Bfp1fR1oqumnmTsrgj1s309wzAEGEN/U8RtnsHiSTFH6kt8654Gjwq5QduzK4qCKQzIHn+tcwTh4wCZ+pFT9a5VjXxT2QYtgFsiuqf6NHXaRRS3A1w4md67rW7RZM74ZLbcxqAx1D/GCnnP5TjKEtETnI/udk7b16amTkR1th6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789245385; c=relaxed/simple;
	bh=7fFeOFI8O1dlWk9HtX2ESLYB8IUByGJZuBhi0dUslEY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b0v39B7LOOidfLB0dgXLwHDml+N3p3KNuBuBX9ld0GBXoGscL6sIAI7zA+Kdm8qyI/OwK8Gctwag/Ovo5bzX5xN/36AUZhXsWiQGnR1+DajxGppTbfQg4nteCaLsu0FbIbJ/LLl1vL0dGTI1c2CR/kAjys+waNgmliXdCDgU5uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ9DH4BD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ9DH4BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCF91F00893;
	Sat, 12 Sep 2026 20:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789245381;
	bh=p9M/IAzBQZKgl4w2ddg7iyD5jSghv/BGxykmdqWcfY0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RZ9DH4BDpWdz0d/2FRygE7X3n2jO+tARtlDAk93urxho8QE4yUD+ctAPlcsPYZ3rs
	 8yaUlgJMdni4oKa5rhho9cEjNXClQ4Yfk6CEq8455gEUWbrZhd0Fev/7awFcQ2dnAL
	 o2ZpDeiSZPDdgCZlbH7GSiMnX/I2+8EaYiYTY642AKG+fj44qvXYV+y/OsrH4/43zk
	 bJjDcZKG741dofnrhnjMArH8P3UkkaODoTBzGXc3gDLmw150gvYQau4pL+yPylR4nL
	 mNBq+AcXH1BIXe6ubPyBVY1Yu4riPdEL1i6I78acZ6hJHfTsPL387m8AVlM90WR5ym
	 YgAKytV97dTGA==
Subject: Re: [PATCH net repost 1/2] net/sched: codel: bound the dropping loop
 per dequeue call
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 victor@mojatatu.com, johannes@sipsolutions.net,
 linux-wireless@vger.kernel.org, shuah@kernel.org, vega@nebusec.ai
Date: Sat, 12 Sep 2026 20:36:20 +0000
Message-ID: <178924538043.3125.18096491736359251092@kernel.org>
In-Reply-To: <QDISC-1L5H.v1.20260912080102@mojatatu.com>
References: <QDISC-1L5H.v1.20260912080102@mojatatu.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 · Low: 0

- [High] The new drop cap in codel_dequeue()
  (include/net/codel_impl.h:189) is enforced with a function-local…

--

net/sched: codel: bound the dropping loop per dequeue call

The patch clamps the CoDel control law increment to at least one tick so
the dropping loop always advances, and caps the loop at
CODEL_MAX_DROPS_PER_DEQUEUE (256) drops per codel_dequeue() call,
resyncing drop_next to now when the cap trips.

> diff --git a/include/net/codel.h b/include/net/codel.h
> index aa80f744826cd..183d43c2bd434 100644
> --- a/include/net/codel.h
> +++ b/include/net/codel.h
> @@ -140,6 +140,11 @@ struct codel_vars {
>  /* needed shift to get a Q0.32 number from rec_inv_sqrt */
>  #define REC_INV_SQRT_SHIFT (32 - REC_INV_SQRT_BITS)
>  
> +/* Cap on drops per codel_dequeue() call: the loop's work depends on the
> + * idle gap and backlog, both outside our control; resync when exceeded.
> + */
> +#define CODEL_MAX_DROPS_PER_DEQUEUE 256
> +
>  /**
>   * struct codel_stats - contains codel shared variables and stats
>   * @maxpacket:	largest packet we've seen so far

[ ... ]

> diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> index 2c1f0ec309e9f..8f26132d45b7f 100644
> --- a/include/net/codel_impl.h
> +++ b/include/net/codel_impl.h

[ ... ]

> @@ -154,6 +159,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
>  				     codel_skb_dequeue_t dequeue_func)
>  {
>  	struct sk_buff *skb = dequeue_func(vars, ctx);
> +	unsigned int drops = 0;
>  	codel_time_t now;
>  	bool drop;
>  
> @@ -180,6 +186,14 @@ static struct sk_buff *codel_dequeue(void *ctx,
>  			 */
>  			while (vars->dropping &&
>  			       codel_time_after_eq(now, vars->drop_next)) {
> +				if (++drops > CODEL_MAX_DROPS_PER_DEQUEUE) {
> +					/* fell far behind the schedule */
> +					WRITE_ONCE(vars->drop_next,
> +						   codel_control_law(now,
> +								     params->interval,
> +								     vars->rec_inv_sqrt));
> +					break;
> +				}

[Severity: High]

Since drops is a local of codel_dequeue(), does the cap actually bound the
work done in one fq_codel ->dequeue() call, or only the work done for one
flow?

When the dropping loop empties a flow (any flow holding no more than 256
packets), dequeue_func() returns NULL, codel_should_drop(NULL, ...) clears
vars->dropping and codel_dequeue() returns NULL.  __fq_codel_dequeue() in
net/sched/sch_fq_codel.c treats that NULL as "flow is empty" and restarts:

net/sched/sch_fq_codel.c:__fq_codel_dequeue() {
	...
	skb = codel_dequeue(sch, &sch->qstats.backlog, &q->cparams,
			    &flow->cvars, &q->cstats, qdisc_pkt_len,
			    codel_get_enqueue_time, drop_func, dequeue_func);

	if (!skb) {
		/* force a pass through old_flows to prevent starvation */
		if ((head == &q->new_flows) && !list_empty(&q->old_flows))
			list_move_tail(&flow->flowchain, &q->old_flows);
		else
			list_del_init(&flow->flowchain);
		goto begin;
	}
	...
}

The goto begin re-enters codel_dequeue() for the next flow with drops back
at 0, still inside the same fq_codel_dequeue() call and the same qdisc lock
hold.  With flows configurable up to 65536, doesn't that make the aggregate
per ->dequeue() drop count O(active_flows * 256) rather than 256?

fq_codel_peek() calls the same __fq_codel_dequeue() loop, so does the same
amplification apply on the peek path?

The same reproducer from the changelog, with the flood spread over many UDP
source ports so each flow holds at most 256 packets, looks like it would
still walk the whole backlog in one dequeue under the lock:

  tc qdisc add dev lo root handle 1: tbf rate 1kbit burst 2kb limit 1000000
  tc qdisc add dev lo parent 1:1 handle 10: fq_codel interval 2us \
      target 1ms noecn limit 1000000 flows 65536

Given that, is this changelog text accurate for fq_codel?

    "The cap applies to fq_codel (4b549a2ef4be) and the mac80211 TXQ path
    (fixed interval, cap only)."

    "patched kernel: same setup, at most 256 drops per dequeue call,
     no soft lockup"

Would a budget shared across the fq outer loop work better here, either
passed in by the caller or signalled back so that __fq_codel_dequeue()
stops retrying when the budget is exhausted?  Otherwise, could the
changelog state the residual multi-flow exposure?

The mac80211 TXQ path has the same shape in fq_tin_dequeue()
(include/net/fq_impl.h), which also does goto begin while fq->lock is held,
so the per-call counter resets there too; its fixed 100ms interval keeps
the per-flow loops short, but is the structural reset worth a note as well?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-1L5H.v1.20260912080102%40mojatatu.com
