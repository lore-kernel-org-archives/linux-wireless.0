Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F4B3CE0A7;
	Sun,  4 Oct 2026 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134550; cv=none; b=KRFRS+O/8A8Hub+N9ggNcEccZtMI7nkmSgyyEYyTQsdpZPO52QZWcqiTP/RxBCYLw81saARnx6y70HnZDfaW/vcmGqElPNUByj1BBDo4n4JserUoa3qucFW5J559lVw2VO8u86/+pgKj5G2wj+DGlQlg2iCkZM9VNaT69uG23RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134550; c=relaxed/simple;
	bh=sOjIy8vMcvdUVTr2Rm5CJ/+C732zG6WL4Zm3oBqdVcQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nof3rgEXD2GsL+f9aw2UM3fXWz2W3mKzni0EsgEBUF4v+yEkuN57b+SuhWm2n3A8IvSqVDahBFKTJ77KbsC9ixAFEum9pfJefogB6OHFEL98iJB7pUbwA8Hms4sT9EchEBQsCHKllFR04aX6R3SB5SxEe9vDPrxAEK8lYD3P8bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEzkomZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEzkomZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545251F00893;
	Sun,  4 Oct 2026 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134548;
	bh=Ox5PicThKcTKUH1oAfZmNYAoTGVYCoNsV39Vcm0+seg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WEzkomZGrQgqyeNOexm4UlJPGl1tUrx8YjOPPBbcSiJLKwznLF1hLKpcKLLLyxeDH
	 +x5UZonp1blmLYdv7it/br4r6nphh9gV5B+uM6/U400LoHF6W3iuTB9rvbK0IqsjOm
	 2VUMfu+5b4Whbze8DaHy37dcNbIlny2PCaWxwKrWn7NBZOzY17+XaxKszr/37WMFK9
	 3Pl2zLyRlMS9nPhhQcnkoggtZc2eyombbYUthaZybwd1TQfh7qhp9KRh9SD64M/aGy
	 SAR07uecgHsFesYrPW28NgcLonWemnr2tDbm4xtuUrpf0YDl4pr1Bw+D8lUGZw8i0E
	 n7y7r2NF75IkA==
Subject: Re: [PATCH 03/16 net-next v3] net: inet: relocate ip_generic_getfrag
 and guard IPv4 socket logic
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:27 +0000
Message-ID: <179113454791.434549.11395243650100357877@kernel.org>
In-Reply-To: <20260930135334.4739-4-fmancera@suse.de>
References: <20260930135334.4739-4-fmancera@suse.de>
X-sashiko-severity: Critical
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

Critical: 1 · High: 0 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] This patch makes inet_init() skip inet4_init() when
  CONFIG_IPV4=n.
- [Medium] When CONFIG_IPV4=n, inet_gso_segment() now always returns
  ERR_PTR(-EPROTONOSUPPORT).
- [Low] The commit message does not describe the boot-time init
  restructuring, which changes behaviour on every kernel because…
- [Low] Baseline decision: false (resolved later in the series).
- [Low] Baseline decision: false (resolved later in the series).

--

net: inet: relocate ip_generic_getfrag and guard IPv4 socket logic

This patch moves ip_generic_getfrag() from ip_output.c to af_inet.c and
adds CONFIG_IPV4 guards in af_inet.c for IPv4 ioctls, protocol
registration, bind, release and GSO. It splits inet_init() into
inet4_init() and inet4_late_init() so the IPv4-only parts can be skipped.
It also rejects IPv4-mapped IPv6 addresses in __inet6_bind() and
__ip6_datagram_connect() when IPv4 is disabled.

> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index d9421ac38d78c..a9d46a178f9ab 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c

[ ... ]

> @@ -1371,6 +1412,9 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
>  	int ihl;
>  	int id;
>  
> +	if (!IS_ENABLED(CONFIG_IPV4))
> +		return ERR_PTR(-EPROTONOSUPPORT);
> +
>  	skb_reset_network_header(skb);
>  	nhoff = skb_network_header(skb) - skb_mac_header(skb);
>  	if (unlikely(!pskb_may_pull(skb, sizeof(*iph))))

[Severity: Medium]

With CONFIG_IPV4=n, this rejects all IPv4 GSO. However, ipv4_offload_init()
still registers the IPv4 GRO callbacks without any guard:

	net_hotdata.ip_packet_offload = (struct packet_offload) {
		.type = cpu_to_be16(ETH_P_IP),
		.callbacks = {
			.gso_segment = inet_gso_segment,
			.gro_receive = inet_gro_receive,
			.gro_complete = inet_gro_complete,
		},
	};

An IPv6-only kernel can still forward IPv4 frames at L2, for example
through a bridge, OVS, tc redirect, VXLAN/Geneve over an IPv6 underlay, or
ip4ip6 via ip4ip6_gso_segment(). In that case IPv4 TCP/UDP traffic still
gets GRO-merged. TSO skbs from tap, virtio and packet sockets are also
still accepted.

If the egress device needs software GSO, are these packets dropped?

validate_xmit_skb()
  skb_gso_segment()
    skb_mac_gso_segment()
      inet_gso_segment()
        return ERR_PTR(-EPROTONOSUPPORT);

The guard seems to be needed only because ip_send_check() is out of line
in ip_output.c. Would moving ip_send_check() into shared code avoid this?

This is still present at the end of the series. The commit message also
doesn't mention the GSO change.

[ ... ]

> @@ -1959,6 +2001,45 @@ static int __init inet_init(void)
>  
>  	ip_init();
>  
> +	return 0;

[ ... ]

> +static int __init inet_init(void)
> +{
> +	int rc;
> +
> +	sock_skb_cb_check_size(sizeof(struct inet_skb_parm));
> +
> +	if (IS_ENABLED(CONFIG_IPV4)) {
> +		rc = inet4_init();
> +		if (rc)
> +			return rc;
> +	}
> +

[Severity: Critical]

With CONFIG_IPV4=n, is the inet_peer slab cache ever created?

The only way to reach ip_init() is through inet4_init(). ip_init() is also
the only caller of inet_initpeers():

net/ipv4/ip_output.c:ip_init() {
	ip_rt_init();
	inet_initpeers();
	...
}

inet_initpeers() is the only place that sets peer_cachep:

net/ipv4/inetpeer.c:inet_initpeers() {
	...
	peer_cachep = KMEM_CACHE(inet_peer, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
}

inetpeer.o is built as obj-y and IPv6 still uses it. For example, a remote
host that sends a UDP datagram to a closed IPv6 port ends up here:

icmpv6_send()
  icmp6_send()
    icmpv6_xrlim_allow()
      inet_getpeer_v6(net->ipv6.peers, &fl6->daddr)
        inet_getpeer()
          kmem_cache_alloc(peer_cachep, GFP_ATOMIC)

On a lookup miss, peer_cachep is NULL at this point. Would that cause a
NULL pointer dereference in softirq context?

ip6_forward() redirect handling and ndisc_send_redirect() reach the same
allocation through inet_getpeer_v6().

CONFIG_IPV4 is still def_bool y at this commit. The problem remains at the
end of the series, where the final patch makes CONFIG_IPV4 selectable.
Should inet_initpeers() be moved out of the IPv4-only init path?

>  	/* Initialise per-cpu ipv4 mibs */
>  	if (init_ipv4_mibs())
>  		panic("%s: Cannot init ipv4 mibs\n", __func__);
> @@ -1980,35 +2061,20 @@ static int __init inet_init(void)
>  	if (icmp_init() < 0)
>  		panic("Failed to create the ICMP control socket.\n");
>  
> -	/*
> -	 *	Initialise the multicast router
> -	 */
> -#if defined(CONFIG_IP_MROUTE)
> -	if (ip_mr_init())
> -		pr_crit("%s: Cannot init ipv4 mroute\n", __func__);
> -#endif
> -
>  	if (init_inet_pernet_ops())
>  		pr_crit("%s: Cannot init ipv4 inet pernet ops\n", __func__);
>  
> -	ipv4_proc_init();
> -
> -	ipfrag_init();
> +#ifdef CONFIG_PROC_FS
> +	if (ip_misc_proc_init())
> +		pr_crit("%s: Cannot init ipv4 misc proc\n", __func__);
> +#endif

[Severity: Low]

ip_misc_proc_init() now runs even when CONFIG_IPV4=n. In that
configuration, net->ipv4.fqdir (set up through ipfrag_init()) and
net->ipv4.devconf_all (set up by devinet) are never initialized.

Would reading /proc/net/sockstat or /proc/net/snmp make sockstat_seq_show()
or snmp_seq_show_ipstats() dereference NULL?

This looks resolved later in the series. The patch "tcp: move protocol
agnostic TCP functions out of tcp_ipv4.c" wraps two things in
IS_ENABLED(CONFIG_IPV4):

- the FRAG line in sockstat_seq_show()
- the snmp_seq_show_ipstats(), icmp_put() and icmpmsg_put() calls in
  snmp_seq_show()

netstat_seq_show() only reads net->mib counters, which init_ipv4_mibs()
always allocates. Since CONFIG_IPV4 is def_bool y at this commit, the
intermediate state can't be reached.

>  
> -	dev_add_pack(&ip_packet_type);
> +	if (IS_ENABLED(CONFIG_IPV4))
> +		inet4_late_init();
>  

[ ... ]

> @@ -2028,12 +2094,8 @@ static int __init ipv4_proc_init(void)
>  		goto out_udp;
>  	if (ping_proc_init())
>  		goto out_ping;
> -	if (ip_misc_proc_init())
> -		goto out_misc;
>  out:
>  	return rc;
> -out_misc:
> -	ping_proc_exit();
>  out_ping:
>  	udp4_proc_exit();
>  out_udp:

[Severity: Low]

This isn't a bug, but the commit message doesn't describe the init
restructuring. That restructuring changes behaviour on default kernels,
since CONFIG_IPV4 is def_bool y at this commit.

ip_mr_init() calls register_pernet_subsys(&ipmr_net_ops). It now runs after
init_inet_pernet_ops() and ip_misc_proc_init() instead of before them. This
changes the pernet init order and the reverse exit order.

ip_misc_proc_init() has also moved out of ipv4_proc_init():

- it now runs before the raw, tcp4, udp4 and ping proc registrations
- it runs even if those registrations fail
- if it fails, it only prints pr_crit() and no longer unwinds the ping,
  udp4, tcp4 and raw proc entries

The message also doesn't mention the new guards in inet_gso_segment(),
around ip_mc_drop_socket() in inet_release(), and in
inet_sk_reselect_saddr().

There is also a typo in the commit message:

    This patch moves the generic ip_generec_getfrag() from ip_output.c to
    af_inet.c.

ip_generec_getfrag() should be ip_generic_getfrag().

Could the commit message be updated to cover these changes?

[ ... ]

> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 191c9733ff9fa..079d1951405b9 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c

[ ... ]

> @@ -186,7 +186,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
>  	if (addr_type & IPV6_ADDR_MAPPED) {
>  		struct sockaddr_in sin;
>  
> -		if (ipv6_only_sock(sk)) {
> +		if (!IS_ENABLED(CONFIG_IPV4) || ipv6_only_sock(sk)) {
>  			err = -ENETUNREACH;
>  			goto out;
>  		}

[Severity: Low]

The v4-mapped rejection here and in __inet6_bind() doesn't cover
tcp_v6_connect()->tcp_v4_connect() or udpv6_sendmsg()->udp_sendmsg(). With
CONFIG_IPV4=n, can those paths still be reached at this commit?

This looks handled later in the series. "tcp: move protocol agnostic TCP
functions out of tcp_ipv4.c" adds this to tcp_v6_connect():

	if (!IS_ENABLED(CONFIG_IPV4) || ipv6_only_sock(sk))
		return -ENETUNREACH;

The same patch also guards tcp_v6_conn_request(), tcp_v6_syn_recv_sock()
and tcp_v6_do_rcv().

The UDP split later in the series guards the v4-mapped paths in
udpv6_sendmsg(), udp_v6_push_pending_frames() and udp6_hash4(). CONFIG_IPV4
can't be disabled until the final patch, so no intermediate state is
affected.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
