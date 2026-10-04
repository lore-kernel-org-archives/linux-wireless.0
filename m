Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1AE4734F5;
	Sun,  4 Oct 2026 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134555; cv=none; b=PH6KS9P7GMgqrIQC68B9AK9qNp5EBmucKZyXw/slByDj3tRsTNvSt+BA+PrSeLpf7OVrmTQgl4pn5llYnaGXGVbcB7DHCY0DxMRWfmaVUAOdkeefRvCLVn3Ttj1++Nyf5vAIV+kcI1ul1D881bSDDR3OtNQ1zWW2nnDPI6vDD1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134555; c=relaxed/simple;
	bh=cgM39JgT0JhEMdTkME3rZIou5+AOOyImjiKx6rsTU5A=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gjWcs7uUOQd+e6XxRL8+6nePBdQR/EkJiVclwrw/rMQzaX9kVvgL2u3pJ7ypN5E6fkPaljzdI1yQR3knllx026kmTq0K41QsfZwTmteRuau7r9r8C0PsQH5diz9sukKjraX0svl27nbaesvl04cV7Q/biFF0EjQ2Uq+x0LuVf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXDad1kC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXDad1kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B501B1F000FF;
	Sun,  4 Oct 2026 17:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134554;
	bh=IbGfhZZ3o4EK+nriuG8tV3snE42Nz3NPGV26T9e9aq8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RXDad1kC8PvcZXiwCMBPkHvN2NEfEk+GquoNqxi1TB+D9pxMoUTgVVI803MWU5Fyz
	 JsOM2TWa5YWNxdaEqnwY9N97NZkbXy1QZfftNrqfLWSy0cIktH2suFUzPQCi5utn8w
	 54X7aaK24nXh3zaAcctaFqoCQ9TJPQgpc01XLd6/DpZbykRLHPsZ5RYhM52RxR5QD2
	 wMUPvd8uFtnGumtmIdma20VtdDDdxgTq6/eHS5m0eEqXak70pPFbMW50+obo58kc3x
	 GNE9vaEIxNXeBvQY/ci/XdhGM+xSETcJqZkTn+BLLpZ6+HaqL1tIsVtCY0P7GyZfkZ
	 bqeOs+PpjvDcQ==
Subject: Re: [PATCH 09/16 net-next v3] ipv4: fib: split common nexthop logic
 to fib_core.c
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:33 +0000
Message-ID: <179113455332.434549.11224802436845886459@kernel.org>
In-Reply-To: <20260930135334.4739-10-fmancera@suse.de>
References: <20260930135334.4739-10-fmancera@suse.de>
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

- [Low] net/core/Makefile adds fib_core.o to the unconditional obj-y list
  next to fib_notifier.o, so it is built into every CONFIG_NET kernel,…
- [Low] The patch rewrote the section comment in include/net/ip_fib.h
  from "/* Exported by fib_frontend.c */" to "/* Exported by…

--

ipv4: fib: split common nexthop logic to fib_core.c

This moves the shared nexthop init/release helpers, fib_nexthop_info(),
fib_add_nexthop(), rtm_ipv4_policy and ip_valid_fib_dump_req() out of
net/ipv4 into a new net/core/fib_core.c. The goal is to let IPv6 use them
without the IPv4 routing stack. It also adds CONFIG_IPV4=n stubs for
several FIB helpers in ip_fib.h and route.h.

> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 0a35355fb0f33..6058e53fa3dec 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h

[ ... ]

> @@ -442,7 +448,7 @@ static inline bool fib_dscp_masked_match(dscp_t dscp, const struct flowi4 *fl4)
>  	return dscp == (fl4->flowi4_dscp & INET_DSCP_LEGACY_TOS_MASK);
>  }
>  
> -/* Exported by fib_frontend.c */
> +/* Exported by net/core/fib_core.c */
>  extern const struct nla_policy rtm_ipv4_policy[];
>  void ip_fib_init(void);
>  int fib_gw_from_via(struct fib_config *cfg, struct nlattr *nla,

[Severity: Low]
Does this heading still describe the whole block? Only rtm_ipv4_policy
moved to fib_core.c. The other declarations under it are still defined in
net/ipv4/fib_frontend.c:

  ip_fib_init()
  fib_gw_from_via()
  fib_compute_spec_dst()
  fib_info_nh_uses_dev()
  fib_validate_source()
  fib_unmerge()

The reverse happens further down in the same header.
fib_nh_common_init() and fib_nh_common_release() are now defined in
net/core/fib_core.c, but their declarations are still under the older
heading:

/* Exported by fib_semantics.c */
...
int fib_nh_common_init(struct net *net, struct fib_nh_common *nhc,
...
void fib_nh_common_release(struct fib_nh_common *nhc);

Could rtm_ipv4_policy get its own fib_core.c heading, with the
fib_nh_common_* declarations moved under it? As written, ip_fib_init() or
fib_validate_source() could look available when CONFIG_IPV4=n. The
headings are still like this at the end of the series.

[ ... ]

> diff --git a/net/core/Makefile b/net/core/Makefile
> index c20e520358b8e..315e437a49d8c 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -12,7 +12,7 @@ obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
>  obj-y		     += dev.o dev_api.o dev_addr_lists.o dst.o netevent.o \
>  			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
>  			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
> -			fib_notifier.o xdp.o flow_offload.o gro.o \
> +			fib_notifier.o fib_core.o xdp.o flow_offload.o gro.o \
>  			netdev-genl.o netdev-genl-gen.o netdev_work.o gso.o

[Severity: Low]
Should fib_core.o be gated on CONFIG_INET? As written, it is built into
every CONFIG_NET kernel, including CONFIG_INET=n ones.

Everything in fib_core.c is INET specific. That covers the fnhe and
rtable cache teardown, rtm_ipv4_policy, ip_valid_fib_dump_req(),
fib_nexthop_info() and fib_add_nexthop(). The callers are in net/ipv4 and
net/ipv6, and both of those need INET.

The only caller outside INET is net/mpls/af_mpls.c, and it already
skips ip_valid_fib_dump_req() when INET is off:

#if IS_ENABLED(CONFIG_INET)
static int mpls_valid_fib_dump_req(...)
{
	return ip_valid_fib_dump_req(net, nlh, filter, cb);
}
#else

So on !INET kernels this is unused code plus an unused
EXPORT_SYMBOL_GPL(ip_valid_fib_dump_req). The same Makefile already gates
an INET-only object this way:

ifdef CONFIG_INET
obj-$(CONFIG_BPF_SYSCALL) += bpf_ksock.o
endif

This does not break the !INET build today. The rule is still
unconditional at the end of the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
