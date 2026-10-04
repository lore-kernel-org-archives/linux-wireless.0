Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87688476CFF;
	Sun,  4 Oct 2026 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134559; cv=none; b=iAFcR2L/aiZo6fCvvvkrAsH+kQ94/00rBEm2WPOr9IRk8NGCembR2OohSxLf61H2jXlsA1wff37DILFN00kn602l/Y5u5FzUHeajSjmCtHAvKqzRCfTsgFw84uuN2bt6vuXA7GqQrwFfeH8Dm0/WYkLINeOL/R9vm2JpffZ9xKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134559; c=relaxed/simple;
	bh=n9wlJRG1lZU7OIST8vkT34hSLuA8r9FUXk8yobl1cIg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rdBsgGvoyUVeswGbnZkkHqs80PG9lfT+lfjk8lfTAxYLaQmuxxh9wOTfLW4BqU68LLjuB1zN6WZCligiYBOfh74XvlrcjsWbvtmU+s1sOTGeZxtg8ElEwMyn6SQ/IF5goh1SaNhhLnc2R0Si7cAFF+YEu67wE6HAYNrZ7aj0UMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+EU4n+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+EU4n+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7B51F00893;
	Sun,  4 Oct 2026 17:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134557;
	bh=r7UYAqzYebzMBiZey0sYATeG+yRUiJqegUoGVO5ayyA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=X+EU4n+C/847vm+BHyhPf5kZcflOWxPiGibRub8AKHdE9Ai5cNIaId2v5olGR0LpJ
	 RG1OW2PtJGoQ0YVZ9A37diiGsOjKka7upPIIlPaJTjTTu461+gpuCncWtl7MU2wRzR
	 +Zk05veG9pmW4CKWirYRp/NaQrExL8buwNDl8mnxSroEWBcUCsLOJv6LmO9L9i817o
	 veiIg33gBgTtVrj6aXND0NbKK61Knx5+FO3txsYsw4HpDtoyv/JSDS9rVHNKXX28Yu
	 b/gwG0XtUJiFRhJUP7erq5CpnA/T/wFYqxekvhSQQeeZu8wtoBEtwIKxv7kAON7ZmQ
	 t2axYJzoQgUJg==
Subject: Re: [PATCH 16/16 net-next v3] ipv4: make CONFIG_IPV4 boolean
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:36 +0000
Message-ID: <179113455655.434549.6974473678038348969@kernel.org>
In-Reply-To: <20260930135334.4739-17-fmancera@suse.de>
References: <20260930135334.4739-17-fmancera@suse.de>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] ipv4: exposing CONFIG_IPV4 without BROKEN guard silently drops
  Netfilter
- [Medium] Making CONFIG_IPV4 user-selectable makes an s390 configuration
  reachable that does not link.
- [Low] Now that IPV4 can be disabled, several IPv4-only prompts in
  net/ipv4/Kconfig stay visible and settable with IPV4=n, because they…

--

ipv4: make CONFIG_IPV4 boolean

This commit changes CONFIG_IPV4 from a hidden def_bool y into a bool
prompt that users can see. The prompt appears when IPV6 is enabled and
defaults to INET, which makes an IPv6-only kernel build possible.

> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 51bf05d9770c5..c7d36cfa4a1d2 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -3,7 +3,15 @@
>  # IP configuration
>  #
>  config IPV4
> -	def_bool y
> +	bool "The IPv4 protocol" if IPV6

[Severity: High]
With IPV4=n, does this silently turn off all of netfilter, including
the IPv6 firewall?

Earlier patches in this series made both netfilter menus depend on
IPV4:

net/netfilter/Kconfig:
menu "Core Netfilter Configuration"
	depends on INET && IPV4 && NETFILTER

net/ipv6/netfilter/Kconfig:
menu "IPv6: Netfilter Configuration"
	depends on INET && IPV6 && NETFILTER && IPV4

Take INET=y, IPV6=y and NETFILTER=y, then answer N to the new prompt.
Kconfig then drops every symbol under both menus without any warning.
That includes NF_CONNTRACK, NF_TABLES, IP6_NF_IPTABLES, IP6_NF_FILTER
and the rest. The help text only says the result is an IPv6-only
system. Nothing tells the user that the firewall went with it.

The resulting kernel has no packet filtering at all. That is likely
the opposite of what someone building an IPv6-only host wants, and it
seems more serious than a missing feature in a minimal build.

I see from the note after the commit message that this is meant to
provide a minimal build and that follow-ups will fill the gaps. Until
netfilter works without IPv4, should the prompt stay hidden behind
something like "depends on BROKEN" or "depends on EXPERT"? Or should
the help text at least warn that netfilter, including ip6tables and
nf_tables, is unavailable with IPV4=n?

[Severity: Medium]
Does this make an s390 configuration reachable that fails to link?

In drivers/s390/net/Kconfig, QETH needs IP_MULTICAST, but nothing in its
dependencies requires IPV4, and IP_MULTICAST itself does not depend on
IPV4:

config QETH
	def_tristate y
	prompt "Gigabit Ethernet device support"
	depends on CCW && NETDEVICES && IP_MULTICAST && QDIO && ETHERNET

QETH_L3 is also def_tristate y and depends only on QETH.

qeth_l3_main.c calls the inetaddr notifier helpers with no CONFIG_IPV4
guard:

drivers/s390/net/qeth_l3_main.c:qeth_l3_register_notifiers() {
	...
	rc = register_inetaddr_notifier(&qeth_l3_ip_notifier);
	...
		unregister_inetaddr_notifier(&qeth_l3_ip_notifier);
	...
}

qeth_l3_unregister_notifiers() calls unregister_inetaddr_notifier() as
well.

Both helpers are defined only in net/ipv4/devinet.c. That file is built
only under obj-$(CONFIG_IPV4), and include/linux/inetdevice.h has no
stub for the !CONFIG_IPV4 case.

Take INET=y, IPV6=y, IPV4=n, with QETH and QETH_L3 left at their
defaults. Would that give an undefined reference at vmlinux link time
when QETH_L3=y, or at modpost when QETH_L3=m?

Other drivers in this effort got a "depends on IPV4 || !INET" guard, for
example IXGBE_IPSEC, MLX5_CORE, SFC, STMMAC_ETH, PPTP and IWLWIFI.
Should QETH or QETH_L3 get the same guard? Or should the notifier calls
be guarded in the code instead?

> +	default INET
> +	help
> +	  Support for IP version 4 (IPv4).
> +
> +	  Disabling this option compiles the kernel networking stack without
> +	  IPv4 support, resulting in a IPv6-only system.
> +
> +	  If unsure, say Y.
>  
>  config IP_MULTICAST
>  	bool "IP: multicasting"

[Severity: Low]
This isn't a bug, but now that IPV4 can be disabled, should the
IPv4-only prompts in net/ipv4/Kconfig also depend on IPV4?

None of these depend on IPV4, so users can still see and set them with
IPV4=n:

  IP_MULTICAST ("IP: multicasting")
  IP_ADVANCED_ROUTER ("IP: advanced router")
  IP_FIB_TRIE_STATS, IP_ROUTE_MULTIPATH and IP_ROUTE_VERBOSE, which
  depend only on IP_ADVANCED_ROUTER
  NET_IPGRE_DEMUX ("IP: GRE demultiplexer")

Most of the code behind these options is in route.o, igmp.o,
fib_frontend.o, fib_semantics.o and fib_trie.o. net/ipv4/Makefile builds
those files only under CONFIG_IPV4:

obj-$(CONFIG_IPV4) += route.o ip_input.o ip_fragment.o ip_forward.o ip_options.o \

In af_inet.c, the CONFIG_IP_MULTICAST IGMP registration sits inside
inet4_init(), which is only called under IS_ENABLED(CONFIG_IPV4). Every
in-tree user of NET_IPGRE_DEMUX (NET_IPGRE, PPTP, IPV6_GRE) already
depends on IPV4.

IP_MULTIPLE_TABLES, IP_PNP, NET_IPIP and IP_MROUTE already have
"depends on IPV4", so these options may simply have been missed.

With IPV4=n, menuconfig still offers these routing and multicast
options, they have no effect, and they are not nested under the new
IPV4 prompt. Would adding "depends on IPV4", or wrapping the block in
"if IPV4", make this consistent?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
