Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A942470136;
	Sun,  4 Oct 2026 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134551; cv=none; b=lbk8flYneYPnlKvFjPxXCyFiuh0Fz5ITlViGvTd4vb8nee3KOmIpc5qRjUIpHbQlUEOiNy6IgKejmSGnf2+0vdNEU4kTH6/uRiuomriZwesO7guXeZzCivDgDKV4/n4Nwgl2H19I3QDqQbCEtnjkjXW22ZANJqdP7muTY4gQkkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134551; c=relaxed/simple;
	bh=iWSVvItrKdVD9z33iBD/5AsqOW7bANHtPvjvnkU/2vU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DlE6qb50aTCZRkn5cPSyz1bC76h1rQyQyADeQHlayU92JE7RvnI2skLyO/zzjFgvDj/cJ9ZM37gVCeMvbNzvrPOHHwRFU8K3vdW9ZQGzwBzxH7us9qZUD+KBbLeIss7TqALN5t2U/ms+QonX4V7C7Ns/AHXwSNgZC8+omix+yj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkpAbdTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkpAbdTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CF11F00898;
	Sun,  4 Oct 2026 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134549;
	bh=XvDEY04TBmTI419C5pWTYZMsxdbHGFH7BtIty3ahjDo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XkpAbdTUmlW4ZATAhOG/6+mvCRIFNsfxBNJO07X83cNfmMCw+zW5xaZnGLUAxY5Gs
	 Zu5xJl+/uCh9NgRRTUo1a/zvNpLAoppbP4Bms4Nz8A3Ugf86dkPGHgxgfFpBHW8YWX
	 scf97XSyEIbTMUPkZ2X08SR6e0PyWBkwnmBOhrQos16mHjMon+Qz+IPb3CHziUpFij
	 ECIQ7VPAm/GCMFZ0KbWSotgPtA4TsboYNLzGpXZJE2UfdESiTXIzP0v5l/c0Ko13SU
	 4hljMCjfwc8uNukSQQ/NSBl3AAtqohUQnHnN+hj0lSRPO46Iib9fFOJSqpnUeFaU2d
	 6eaPrJQx1hVCQ==
Subject: Re: [PATCH 04/16 net-next v3] tcp: move protocol agnostic TCP
 functions out of tcp_ipv4.c
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:29 +0000
Message-ID: <179113454900.434549.10353532629691425979@kernel.org>
In-Reply-To: <20260930135334.4739-5-fmancera@suse.de>
References: <20260930135334.4739-5-fmancera@suse.de>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message understates the user-visible changes.
- [Low] union bpf_tcp_iter_batch_item and struct bpf_tcp_iter_state were
  file-local in tcp_ipv4.c and are now moved into the widely included…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but the
  relocated TCP BPF iterator can call vfree() while holding a plain…

--

tcp: move protocol agnostic TCP functions out of tcp_ipv4.c

This moves the protocol agnostic TCP code (proc and BPF iterators,
tcp_twsk_unique(), tcp_add_backlog(), the pernet ops and more) from
tcp_ipv4.c into tcp.c, so it still builds with CONFIG_IPV4=n. It also
renames tcp_v4_destroy_sock() to tcp_destroy_sock() and guards the
IPv4-mapped paths in tcp_ipv6.c. Finally, it changes the /proc/net/sockstat
and /proc/net/snmp output for IPv4-less builds.

> In addition, guard IPv4 code around IPv6 TCP implementation. This
> ensures that IPv4-mapped IPv6 sockects are rejected with a proper error
> code when IPv4 stack is disabled.
>
> Please note that this commit also addresses how /proc/net/sockstat
> output is handled for all protocols. The implementation now force the
> inuse attrtibute to be zero when CONFIG_IPV4=n but the shared stats are
> represented correctly.

[Severity: Low]
Is this description complete? sockstat_seq_show() zeroes the TCP, UDP and
RAW inuse counters, but it drops the FRAG: line entirely instead of
zeroing it:

    if (IS_ENABLED(CONFIG_IPV4))
        seq_printf(seq,  "FRAG: inuse %u memory %lu\n",
    ...

/proc/net/snmp changes too, and the message doesn't mention it:

- snmp_seq_show() leaves out the Ip:, Icmp: and IcmpMsg: sections.
- snmp_seq_show_tcp_udp() gains a first argument, so the output starts
  with "Tcp:" instead of "\nTcp:".

These output formats only show up in CONFIG_IPV4=n builds. Those become
selectable in the later commit "ipv4: make CONFIG_IPV4 boolean", so
IPv6-only kernels would see procfs format changes that aren't documented.

Some structural changes are not mentioned either:

- register_pernet_subsys(&tcp_sk_ops) and bpf_iter_register() move from
  tcp_v4_init() into tcp_init(), where they now run unconditionally.
- tcp_bpf_v4_build_proto() is now gated on CONFIG_IPV4.
- struct bpf_tcp_iter_state and union bpf_tcp_iter_batch_item move into
  include/net/tcp.h.

About "rejected with a proper error code": only tcp_v6_connect() returns
an error (-ENETUNREACH). The other guards return no error to anyone:

- tcp_v6_conn_request() does goto drop.
- tcp_v6_syn_recv_sock() returns NULL.
- tcp_v6_do_rcv() calls kfree_skb() and returns 0.

These guards seem to be there to avoid references to IPv4 symbols on
paths that can't run once IPv4 is compiled out.

Could the commit message describe these changes more precisely?

> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 96a1a23e47fac..04d487a19b178 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h

[ ... ]

> @@ -2855,6 +2855,20 @@ struct sk_psock;
>  #ifdef CONFIG_BPF_SYSCALL
>  int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
> +
> +union bpf_tcp_iter_batch_item {
> +	struct sock *sk;
> +	__u64 cookie;
> +};
> +
> +struct bpf_tcp_iter_state {
> +	struct tcp_iter_state state;
> +	unsigned int cur_sk;
> +	unsigned int end_sk;
> +	unsigned int max_sk;
> +	union bpf_tcp_iter_batch_item *batch;
> +};
> +

[Severity: Low]
Do these definitions need to go into include/net/tcp.h?

After this patch, and still at the end of the series, net/ipv4/tcp.c is
the only user of union bpf_tcp_iter_batch_item and struct
bpf_tcp_iter_state. All of the BPF TCP iterator code now lives there, so
both types could stay file-local in tcp.c. That would keep iterator
internals out of a widely included header.

>  #ifdef CONFIG_BPF_STREAM_PARSER
>  struct strparser;
>  int tcp_bpf_strp_read_sock(struct strparser *strp, read_descriptor_t *desc,

[ ... ]

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 3ac4856852794..1f0fc46136ead 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c

[ ... ]

> @@ -1458,6 +1464,1115 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)

[ ... ]

> +static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
> +				      unsigned int new_batch_sz, gfp_t flags)
> +{
> +	union bpf_tcp_iter_batch_item *new_batch;
> +
> +	new_batch = kvmalloc_objs(*new_batch, new_batch_sz,
> +				   flags | __GFP_NOWARN);
> +	if (!new_batch)
> +		return -ENOMEM;
> +
> +	memcpy(new_batch, iter->batch, sizeof(*iter->batch) * iter->end_sk);
> +	kvfree(iter->batch);
> +	iter->batch = new_batch;
> +	iter->max_sk = new_batch_sz;
> +
> +	return 0;
> +}

[ ... ]

> +	/* Batch size was too small. */
> +	bpf_iter_tcp_unlock_bucket(seq);
> +	bpf_iter_tcp_put_batch(iter);
> +	err = bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2,
> +					 GFP_USER);
> +	if (err) {
> +		iter->cur_sk = 0;
> +		iter->end_sk = 0;
> +		return ERR_PTR(err);
> +	}
> +
> +	sk = bpf_iter_tcp_resume(seq);
> +	if (!sk)
> +		return NULL; /* Done */
> +
> +	expected = bpf_iter_fill_batch(seq, &sk);
> +	if (likely(!sk))
> +		goto done;
> +
> +	/* Batch size was still too small. Hold onto the lock while we try
> +	 * again with a larger batch to make sure the current bucket's size
> +	 * does not change in the meantime.
> +	 */
> +	err = bpf_iter_tcp_realloc_batch(iter, expected, GFP_NOWAIT);

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch; the same
code is already in tcp_ipv4.c. Since it is being moved anyway: can this
call vfree() while a plain spinlock is held?

The first reallocation uses GFP_USER with the bucket unlocked. For more
than about 512 entries the size exceeds PAGE_SIZE. kvmalloc() then tries
kmalloc() with __GFP_NORETRY and can fall back to vmalloc(), so
iter->batch may end up vmalloc-backed.

In the listening state, bpf_iter_tcp_resume() retakes the bucket lock in
listening_get_first() with a plain spin_lock:

    spin_lock(&ilb2->lock);

Concurrent listen() calls may have grown the bucket past the new capacity
in the meantime. If so, this GFP_NOWAIT reallocation runs with the lock
held, and on success:

bpf_iter_tcp_realloc_batch()
    kvfree(iter->batch)
        vfree()

vfree() only defers when in_interrupt() is true:

    if (unlikely(in_interrupt())) {
        vfree_atomic(addr);
        return;
    }
    ...
    might_sleep();

This runs in process context under a plain spin_lock with BH enabled, so
in_interrupt() is false. vfree() would then call might_sleep() and tear
down the area synchronously while ilb2->lock is held. GFP_NOWAIT only
limits the new allocation, not the freeing of the old buffer. The
established case uses spin_lock_bh(), so vfree_atomic() is used there.

With CONFIG_DEBUG_ATOMIC_SLEEP this would give a "sleeping function
called from invalid context" splat.

Would it make sense to free the old batch only after the bucket has been
unlocked?

> +	if (err) {
> +		bpf_iter_tcp_unlock_bucket(seq);
> +		return ERR_PTR(err);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
