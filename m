Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313046D096;
	Sun,  4 Oct 2026 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134549; cv=none; b=blea7/hB4aULEDUtlLTmq71WEIkP5Tf8pk2HuZCEKUZuXF+LcpYieSAM8gAUBA2K0BSKtRK10p3UPP8/pwbW8T2Ot1sOajGcplxMHRpiPx56kKYZpxsbnSNtkdk5BQXkjDA2l8fC0MQcsZFC+hPuqJmYNNl0EF5XLXj6WYNKrz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134549; c=relaxed/simple;
	bh=a5U+72tKI9vxb9cehQbCiyroyWRVx59lcQpxUFkcpMw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UaAcCA3FjfCZEAEaiJmYmqMMCaJ3pTn7td0KIyiFpM9FPB0aCU+1963pSlhPofMl1dKSgHm8cs7czvhf9sUENmkQl7QODTZEsjvkv/wTLeiwKtqRX5U/568GfktY01/yZolArdQgsw0TC7jAY2Uyq3V/9v/Cv5p0Z/CrILA1wNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIC/M/UM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIC/M/UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E27D1F000FF;
	Sun,  4 Oct 2026 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134547;
	bh=eNDOPZYZSMHNd1Bs7oNDiHexizZgAb5SQSZyBYVU8FY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fIC/M/UMgvYKdKP+wVB3ybwVreqsK7r5T0sUW9wMGVw6PfdSfW1pfbaZJiwTHiFbI
	 Tb3ZdCp9MDfB6CPQSv8XH0zgR+O+vP5Hh6QcpRRpFWzV57mbhpkkW3xJCJ3JdrPh9P
	 76/PKTkfRk87kDT86LrYHXvad5sb2CSovAuOZhQi/n7BJlqxi1pammob9TbnDydYDf
	 YDONp+wAgujSd985iZm1hvvPS9r9OChHl118GnyrKis9me7VV3b/DmeKvuKxBhOdzo
	 vIKJfFMorXZDAH2ReC6kYGZzuVopJ94ht53oyz8ggomY+jnlBsrq8foLeYV3zatlmj
	 NPBdRbM3niYWw==
Subject: Re: [PATCH 02/16 net-next v3] net: core: add IPv4 fallback stubs and
 guards for CONFIG_IPV4=n
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:26 +0000
Message-ID: <179113454679.434549.8561549828918413865@kernel.org>
In-Reply-To: <20260930135334.4739-3-fmancera@suse.de>
References: <20260930135334.4739-3-fmancera@suse.de>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] With CONFIG_IPV4=n, the new ip_setsockopt()/ip_getsockopt()
  stubs make every SOL_IP option return -EAFNOSUPPORT.
- [Medium] The patch adds `if (!IS_ENABLED(CONFIG_IPV4)) return
  -EAFNOSUPPORT;` at the top of dev_ifconf() (net/core/dev_ioctl.c).
- [Low] Baseline decision: false (not a real bug by the end of the
  series).
- [Low] The patch changes the INDIRECT_CALL_INET_1() gate in
  include/linux/indirect_call_wrapper.h from CONFIG_INET to CONFIG_IPV4.
- [Low] The CONFIG_IPV4=n stub of ip_route_output_flow() in
  include/net/route.h is a function definition with an unnamed first…

--

net: core: add IPv4 fallback stubs and guards for CONFIG_IPV4=n

This commit adds static inline stubs to include/net/ip.h and
include/net/route.h for use when CONFIG_IPV4 is disabled. It also adds
IS_ENABLED(CONFIG_IPV4) guards to generic networking code so that code
links without IPv4. Finally, it gates the INDIRECT_CALL_INET() and
INDIRECT_CALL_INET_1() helpers on CONFIG_IPV4 instead of CONFIG_INET.

> diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
> index 0e4340ecd857a..583efbc034466 100644
> --- a/include/linux/indirect_call_wrapper.h
> +++ b/include/linux/indirect_call_wrapper.h

[ ... ]

> -#if IS_ENABLED(CONFIG_INET)
> +#if IS_ENABLED(CONFIG_IPV4)
>  #define INDIRECT_CALL_INET_1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
>  #else
>  #define INDIRECT_CALL_INET_1(f, f1, ...) f(__VA_ARGS__)

[Severity: Low]
Does INDIRECT_CALL_INET_1() need to be gated on CONFIG_IPV4?

Every f1 passed to this macro is a TCP core function that is still built
when IPV4=n: tcp_release_cb, tcp_leave_memory_pressure,
tcp_stream_memory_free and tcp_bpf_bypass_getsockopt. tcpv6_prot uses
all of them as well.

For example, release_sock() in net/core/sock.c has:

	INDIRECT_CALL_INET_1(sk->sk_prot->release_cb,
			     tcp_release_cb, sk);

Consider a CONFIG_IPV4=n, CONFIG_IPV6=y kernel with retpolines. There,
release_sock(), sk_leave_memory_pressure(), sk_stream_memory_free() and
BPF_CGROUP_RUN_PROG_GETSOCKOPT would make an indirect call instead of
the direct tcp_* call.

INDIRECT_CALL_INET() above keeps an IPv6 fast path, but
INDIRECT_CALL_INET_1() loses it. Could this macro stay gated on
CONFIG_INET?

> diff --git a/include/net/ip.h b/include/net/ip.h
> index 6f602df72ee62..194a464c443af 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h

[ ... ]

> @@ -225,27 +235,58 @@ int ip_append_data(struct sock *sk, struct flowi4 *fl4,

[ ... ]

> +static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
> +{
> +	return ERR_PTR(-EAFNOSUPPORT);
> +}

[Severity: Low]
The real ip_finish_skb() calls __ip_make_skb(), which only returns NULL
or a valid skb. Its callers check only for NULL:

	skb = ip_finish_skb(sk, fl4);
	if (!skb)
		goto out;

Later in the series, both callers, udp_push_pending_frames() and
ip_push_pending_frames(), end up in objects that are built only with
CONFIG_IPV4. udp_v6_push_pending_frames() also guards its call with
IS_ENABLED(CONFIG_IPV4).

So this stub looks unreachable. At this commit CONFIG_IPV4 is still
def_bool y, so the stub isn't compiled at all.

Should the stub return NULL to match the return contract of the real
function?

[ ... ]

> @@ -813,24 +854,60 @@ int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev);

[ ... ]

> +static inline int ip_setsockopt(struct sock *sk, int level, int optname,
> +				sockptr_t optval, unsigned int optlen)
> +{
> +	return -EAFNOSUPPORT;
> +}
> +
> +static inline int ip_getsockopt(struct sock *sk, int level, int optname,
> +				char __user *optval, int __user *optlen)
> +{
> +	return -EAFNOSUPPORT;
> +}
> +#endif

[Severity: Medium]
With CONFIG_IPV4=n, do these stubs remove SOL_IP options that IPv6
sockets rely on?

ipv6_setsockopt() and ipv6_getsockopt() forward SOL_IP to these
functions for AF_INET6 sockets:

net/ipv6/ipv6_sockglue.c:ipv6_setsockopt() {
    ...
	if (level == SOL_IP && sk->sk_type != SOCK_RAW)
		return ip_setsockopt(sk, level, optname, optval, optlen);
    ...
}

MPTCP also calls ip_setsockopt() directly, from
mptcp_setsockopt_sol_ip_set() and mptcp_setsockopt_v4_set_tos().

Some of these options work for any address family and have no SOL_IPV6
equivalent, such as IP_BIND_ADDRESS_NO_PORT and IP_LOCAL_PORT_RANGE.
The only code that sets INET_FLAGS_BIND_ADDRESS_NO_PORT and the
per-socket local_port_range is in ip_sockglue.c. By the end of the
series that file is built only with CONFIG_IPV4. However, __inet6_bind()
and the port range selection still read that state for IPv6 sockets.

On an IPv6-only kernel, this call would then fail with EAFNOSUPPORT:

	setsockopt(fd6, SOL_IP, IP_BIND_ADDRESS_NO_PORT, ...)

The commit message says:

    This behaves as IPv6 code does.

However, CONFIG_IPV6=n doesn't remove any options from IPv4 sockets. Is
this loss of IPv6 socket functionality intended?

> diff --git a/include/net/route.h b/include/net/route.h
> index 6b55de2e4df88..8c21881eb5f4f 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -169,8 +169,16 @@ static inline struct rtable *__ip_route_output_key(struct net *net,
>  	return ip_route_output_key_hash(net, flp, NULL);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV4)
>  struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
>  				    const struct sock *sk);
> +#else
> +static inline struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
> +						  const struct sock *sk)
> +{
> +	return ERR_PTR(-EAFNOSUPPORT);
> +}
> +#endif

[Severity: Low]
Will this stub build with all supported compilers once the later patch
in the series makes CONFIG_IPV4=n selectable?

The stub is a function definition whose first parameter has no name.
gnu11 doesn't allow that; only C23 does. GCC 8 through 10 reject it with
"parameter name omitted", and Documentation/process/changes.rst lists
GCC 8.1 as the minimum version. Clang warns that this is a C23
extension, which breaks CONFIG_WERROR builds.

Naming the parameter (struct net *net) would avoid this.

> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 164643140a523..a10921aa3e23f 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -44,6 +44,9 @@ int dev_ifconf(struct net *net, struct ifconf __user *uifc)
>  	size_t size;
>  	int len, total = 0, done;
>  
> +	if (!IS_ENABLED(CONFIG_IPV4))
> +		return -EAFNOSUPPORT;
> +

[Severity: Medium]
Does this early return change SIOCGIFCONF behaviour on existing
CONFIG_INET=n kernels?

CONFIG_IPV4 is only defined inside "if INET" in net/Kconfig. That means
IS_ENABLED(CONFIG_IPV4) evaluates to 0 whenever CONFIG_INET=n.

Before this patch, those kernels used the !CONFIG_INET stub in
include/linux/inetdevice.h:

static inline int inet_gifconf(struct net_device *dev, char __user *buf,
			       int len, int size)
{
	return 0;
}

So SIOCGIFCONF succeeded and returned ifc_len = 0.

sock_ioctl() passes SIOCGIFCONF to dev_ifconf() for any socket family,
for example AF_UNIX, AF_PACKET or AF_NETLINK. On CONFIG_INET=n kernels
the ioctl now fails with EAFNOSUPPORT. The inet_gifconf() stub also
becomes unreachable.

Could the inet_gifconf() stub be gated on CONFIG_IPV4 instead, and this
early return dropped? That would keep the existing result of success
with an empty list.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
