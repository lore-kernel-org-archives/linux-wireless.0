Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DEB4718F2;
	Sun,  4 Oct 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134553; cv=none; b=uwkw6fkRNZTCQFul3+B3GoIaAMNxWIn7OgZU1Rq9wUrfdQhugiEm5qPN13ZYEMnKtALS4Vjqr/78svSNbqwonSk6l8U7fW3825Ya0O0VnjrHGXCNS4qwt+MvO8HdyLpUo8346sMANFoUs1hw5nZ8hYEn7ekgTt8dS+ytNYSOryU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134553; c=relaxed/simple;
	bh=ZyjyuexdIVYN+vwBoT4V1u0YW7hGbGGAp8yKBz+Agd4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CHUBb29R1cMPghqxFvGKIdlpNt+ZLh50mGbg858nqLnnqr88BACzDMU7a1mjzP9vA/J4o2Qi3Zsw6yWkG/DweR7Zvmh+LBEn4R62QQrfjURQyNiCNGm3+sFEfgq1IB5vj1n4pZh31VYd9Lz4h5h5CbQQoVG2JlMx5OVwcM3F/sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hp426FrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hp426FrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4701F00893;
	Sun,  4 Oct 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134552;
	bh=UrzyhIwxbo19PHzKX5XarHFz+2yT8oAbmmMsKKCFlO0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hp426FrR4wqENgOesIwBXA/EBgA4d9L5hSOHaw/g+DghQ55+nOxmr6HrOKfyIYui6
	 aNTJFNXf2sORF+5rzWgyl6n4bBpyBdzMlo4EmabfqaLJr1/knGicNYO9s1r4iV0t1u
	 W80ncwIInR6CZltO1JRhkcXjNz5e5vRmblAKIRLiqxP5JPnM59gjsv4QZSecDyeBnS
	 HOwN3HNN2b+Il0BVJF00k/OpQhP6/zh0mnHnpFkcK+sbhuPD+xGcPp181eLw1oDp5q
	 4NlYdZxaPbztkMMeOpKU8/QIJW3TlUZHvOMnh2dUgs+EyhDVdluLh010UKm9LGm9P0
	 Y8VfqdDfjNdgA==
Subject: Re: [PATCH 06/16 net-next v3] ipv4: udp: split IPv4 specific logic
 into udp_ipv4.c
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:31 +0000
Message-ID: <179113455115.434549.17562988532168582470@kernel.org>
In-Reply-To: <20260930135334.4739-7-fmancera@suse.de>
References: <20260930135334.4739-7-fmancera@suse.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When CONFIG_IPV4=n, udp4_gro_complete()
  (net/ipv4/udp_offload.c) returns -EAFNOSUPPORT for every merged IPv4…

--

ipv4: udp: split IPv4 specific logic into udp_ipv4.c

This commit moves the IPv4-specific UDP socket code out of udp.c and into
a new file, udp_ipv4.c. That covers lookup, input/output, multicast
delivery and the AF_INET udp_prot. The new file is built only when
CONFIG_IPV4 is enabled. Callers in af_inet.c, udp_bpf.c, udp_offload.c and
ipv6/udp.c get IS_ENABLED(CONFIG_IPV4) guards.

> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index cf07c3c6611a2..bea037d6b4eb7 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -958,6 +958,9 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>  	const struct iphdr *iph = (struct iphdr *)(skb->data + offset);
>  	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +	if (!IS_ENABLED(CONFIG_IPV4))
> +		return -EAFNOSUPPORT;
> +

[Severity: Medium]
With CONFIG_IPV4=n, can this make every merged IPv4 UDP GRO packet get
dropped silently?

The IPv4 GRO offloads are still registered when IPv4 is disabled.
ipv4_offload_init() in af_inet.c still calls udpv4_offload_init() and
dev_add_offload(&net_hotdata.ip_packet_offload) with no guard. So
inet_gro_receive()->udp4_gro_receive()->udp_gro_receive() still runs for
IPv4 UDP packets.

The socket lookup there ends up in the new __udp4_lib_lookup() stub,
which returns NULL. Even so, udp_gro_receive() still aggregates:

	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_test_bit(GRO_ENABLED, sk) : 1;

	if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
	    (sk && udp_test_bit(GRO_ENABLED, sk)) || NAPI_GRO_CB(skb)->is_flist)
		return call_gro_receive(udp_gro_receive_segment, head, skb);

At flush time, gro_complete()->inet_gro_complete()->udp4_gro_complete()
now returns -EAFNOSUPPORT, and gro_complete() in net/core/gro.c frees
the whole aggregate:

	if (err) {
		WARN_ON(&ptype->list == head);
		kfree_skb(skb);
		return;
	}

The WARN_ON doesn't fire because a ptype was found, so all segments are
lost with no warning. This would affect an IPv6-only kernel that bridges
or forwards IPv4 UDP with NETIF_F_GRO_UDP_FWD or NETIF_F_GRO_FRAGLIST
enabled on the ingress device. Inner IPv4 carried in IPv6 tunnels would
be hit too.

The fraglist branch and the udp_gro_complete() path don't need IPv4
socket state. The only IPv4-only dependency looks like the
udp4_lib_lookup_skb reference. Would it work to stub or skip only the
lookup, for example with a NULL-returning udp4_lib_lookup_skb when
CONFIG_IPV4=n, and keep the rest of udp4_gro_complete()? Or should IPv4
UDP GRO receive also be disabled in that configuration, so packets
aren't aggregated only to be dropped at completion?

The later patch in the series, "ipv4: make CONFIG_IPV4 boolean", makes
this configuration selectable. udp4_gro_complete() and
ipv4_offload_init() are unchanged at the end of the series.

>  	/* do fraglist only if there is no outer UDP encap (or we already processed it) */
>  	if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
>  		udp_set_len(uh, skb->len - nhoff);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
