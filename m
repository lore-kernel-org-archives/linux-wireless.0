Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630304749E9;
	Sun,  4 Oct 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134556; cv=none; b=ubLkt22WSt32SbnYz2k5NPqBZmdNaP7Sdyh5CZ3yUPVSkrr8PNv+yh0O3e1fGqhE+hQbEFP4SiGetb2iqX9Gsl32Wu+AW6sdNhLGCA/sv68/L9MVv3qef9TT39fzpBrEuXaDM1j0pLZ87hWDwU57++qbWSf/INq5d08+iVpyC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134556; c=relaxed/simple;
	bh=7EKlz4n/sCcw2PS/RnvcaR2iWzD7jE0Ar6ZB5tSA10Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q6pm5ZWqXvO/jae9D2sxvK30x9FqjZ7QE4P8qkVwEvmarNi3BASyxw1hggvOoxKEfSohn+23uk+yc414lzFgzvkaRmMxJcVFuJSNqZjbd7tY8myGlfCoIAgvxDi8z/Xea6o9YYywMrVH3cAD/vfMOgWfV4TsR7wwHQReLMOT1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5FMpNF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5FMpNF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F3E1F00893;
	Sun,  4 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134555;
	bh=2IIrHae1/F8Om1bnSbvJecoHyR+00lsfbMVFUxiko58=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h5FMpNF62kzLRibfyXWbNznvIHTq5Cu3wV8mVG/Vq7FsvTytSV4pwvjTMsrtWOXV3
	 R51kjQAr1bIXbnTX32taqJejwtOyldE01oyXjY1mipM7QNKEHeBQ2lSoGx3iJiXHa/
	 pW4Yhsk82mJL9fq+9LPyK9TyI9+Y8nIeYQfT2yM8kHNd6U3bP4M8912jknzmYxJBjm
	 PU74ihS2kdYso1X3yZLnPEJXIXZ8Ay9Ucz2o2V7xwOLG2jGhqY1gKrEEPCdR2o9jEw
	 6vt39lXdVZHZL23RjDgzzbcKXd6zlmP95ueZyXmEpcH/Yky7unvz23+mhNE4BsYBa8
	 IU3o24vrjArVA==
Subject: Re: [PATCH 11/16 net-next v3] ipv4: disable IPv4-only sysctls when
 CONFIG_IPV4=n
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:34 +0000
Message-ID: <179113455439.434549.2885225995379440090@kernel.org>
In-Reply-To: <20260930135334.4739-12-fmancera@suse.de>
References: <20260930135334.4739-12-fmancera@suse.de>
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

- [Medium] The patch moves the net.ipv4.fib_multipath_hash_seed entry of
  ipv4_net_table (net/ipv4/sysctl_net_ipv4.c, lines 1644-1650) inside…

--

ipv4: disable IPv4-only sysctls when CONFIG_IPV4=n

This commit moves the IPv4-specific entries of ipv4_net_table into a new
IS_ENABLED(CONFIG_IPV4) block at the end of the table. Those sysctls are
then not registered on kernels built without IPv4. Handlers and min/max
variables used only by those entries are marked __maybe_unused.

> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 0e7fef5973db6..6096e9e4d82d8 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c

[ ... ]

> @@ -1656,6 +1469,196 @@ static const struct ctl_table ipv4_net_table[] = {
>  		.extra1		= SYSCTL_ONE_THOUSAND,
>  		.extra2		= &tcp_rto_max_max,
>  	},
> +#if IS_ENABLED(CONFIG_IPV4)

[ ... ]

> +#ifdef CONFIG_IP_ROUTE_MULTIPATH

[ ... ]

> +	{
> +		.procname	= "fib_multipath_hash_seed",
> +		.data		= &init_net,
> +		.maxlen		= sizeof(u32),
> +		.mode		= 0644,
> +		.proc_handler	= proc_fib_multipath_hash_seed,
> +	},
> +#endif

[Severity: Medium]
Is fib_multipath_hash_seed really IPv4-only? The commit message says it
hides "the sysctls that are related to IPv4 only". However, the IPv6
datapath also uses this seed.

The shared helper in include/net/ip_fib.h is built whenever
CONFIG_IP_ROUTE_MULTIPATH is set:

include/net/ip_fib.h:fib_multipath_hash_from_keys() {
    ...
	mp_seed = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.mp_seed);
	fib_multipath_hash_construct_key(&hash_key, mp_seed);
    ...
}

IPv6 ECMP reaches it through rt6_multipath_hash() and its custom hash
helpers in net/ipv6/route.c:

rt6_multipath_hash()->fib_multipath_hash_from_keys()

IP_ROUTE_MULTIPATH depends only on IP_ADVANCED_ROUTER, not on IPV4. Also,
ipv4_sysctl_init_net() still calls proc_fib_multipath_hash_set_seed(net, 0)
for every netns.

Take a kernel with CONFIG_IPV4=n, CONFIG_IPV6=y and
CONFIG_IP_ROUTE_MULTIPATH=y. That becomes possible once "ipv4: make
CONFIG_IPV4 boolean" later in this series makes IPV4 selectable. Won't
IPv6 multipath hashing then keep using a random seed that userspace can
no longer set?

There is no net.ipv6 copy of this seed. net/ipv6/sysctl_net_ipv6.c only
has its own fib_multipath_hash_policy. The NETEVENT_IPV4_MPATH_HASH_UPDATE
notification sent from proc_fib_multipath_hash_seed() for offload drivers
would also never be sent.

Documentation/networking/ip-sysctl.rst describes this sysctl as:

  The seed value used when calculating hash for multipath routes. Applies
  to both IPv4 and IPv6 datapath. Only present for kernels built with
  CONFIG_IP_ROUTE_MULTIPATH enabled.

proc_fib_multipath_hash_seed() is marked __maybe_unused in this patch.
That suggests the IPV4=n with IP_ROUTE_MULTIPATH=y case was expected.

Should this entry stay outside the CONFIG_IPV4 block, guarded only by
CONFIG_IP_ROUTE_MULTIPATH?

> +	{
> +		.procname	= "fib_notify_on_flag_change",

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
