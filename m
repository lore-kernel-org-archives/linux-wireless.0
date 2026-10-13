Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06F13F1064;
	Tue, 13 Oct 2026 02:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857106; cv=none; b=hIOw6QiUPw64vFfkTnhjtlFCZMHFQ3kwuKTxMkLwO+txoGZZTn/8D9RkAkUCL9uCYfzDyuO9S6wVGTTCahpSPgED/uQrvMLNYryfhDBeQafkxriaqofYLhxuAA8x1axLOk97l6TGt9A1mD4/284qDp/RDjgvfFxkBP+hqYWDrXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857106; c=relaxed/simple;
	bh=Yafkd1Ko+GR7Fm2scZFoGSPWX16GSPl5aY+tos+AddI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LiOYtmUtwlj7LZbYxv82b4qGueHBIRJcooESRWCo2q0gqqC5gVcWNtQ0xW256zeiRSW68us9Gk4WgLSdFm5Vuf2XS1i+g4EnwF8nJSHL0d1pZLyTy3FtVpKiilegp590aJgoHqO+b2q97/7qkCdBlyfcIFSMLJQosMiWlDL3EIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iB1ZvK9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iB1ZvK9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34161F000FF;
	Tue, 13 Oct 2026 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791857104;
	bh=Ab0qE5OkmRI2l0Jp2s1HEzACuFvv1a8SHMl12Jh81QA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iB1ZvK9MxznlZOPCxZg2aHwZwinmmgWU2CwAeNHQPWkKTZADJaNWGsiHXfJl0zjoi
	 Fx+DKpJr/A8k+VRGSSM4/r069lY8RGnRPJ+gfO0siBG4dh8i+YP0DhkHFZIzBJk16v
	 K53HowzFlD+KuK9nM1a5gt88j63O9rrVkYhRswD3k2q76vqS0mzkDW1g1aHjfOEATm
	 l6TVNrtAu5LZtzYgBa+BwUo9U2o7kY18dVcfO+pEQg9trGKHBNUsicm9BXbCjM0OO3
	 xZ+WqblLtexpmO2+eX1tHgN9ouxLAotMdfBCcDf4QFoDsgyjKrJ8HUcd1iL7/dN1af
	 K9/XCqwK9G/6g==
Subject: Re: [PATCH net-next v11 4/6] net: add AF_PACKET multicast dumps
From: netdev-bot+sashiko@kernel.org
To: sigefriedhyy@gmail.com
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com,
 andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net,
 dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com,
 idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org,
 johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com,
 kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com,
 pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org,
 sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 13 Oct 2026 02:05:02 +0000
Message-ID: <179185710223.434549.6133926948819737320@kernel.org>
In-Reply-To: <20261012011707.3378-5-sigefriedhyy@gmail.com>
References: <20261012011707.3378-5-sigefriedhyy@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] dev_mc_dump() is registered with RTNL_FLAG_DUMP_UNLOCKED.
- [Low] Under this patch alone, the uAPI and the YAML spec disagree.

--

net: add AF_PACKET multicast dumps

This adds an RTM_GETMULTICAST dump handler for ifa_family AF_PACKET. The
handler reports every entry of dev->mc in the ifaddrmsg format, using
IFA_MULTICAST, IFA_MC_USERS and a new IFA_F_GLOBAL bit in IFA_FLAGS. The
dump runs without RTNL, under RCU and netif_addr_lock_bh(), and uses
dev_mc_genid plus dev_base_seq to set NLM_F_DUMP_INTR.

> diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
> index 7fb630b7fe311..0a1ad9ebb47be 100644
> --- a/include/uapi/linux/if_addr.h
> +++ b/include/uapi/linux/if_addr.h
> @@ -57,6 +57,7 @@ enum {
>  #define IFA_F_NOPREFIXROUTE	0x200
>  #define IFA_F_MCAUTOJOIN	0x400
>  #define IFA_F_STABLE_PRIVACY	0x800
> +#define IFA_F_GLOBAL		0x1000

[Severity: Low]
This isn't a bug, but with only this patch applied, the uAPI and
Documentation/netlink/specs/rt-addr.yaml don't match.

The ifa-flags enum in the spec still ends at stable-privacy and has no
entry for IFA_F_GLOBAL.

The getmulticast reply in the spec lists only multicast, mc-users and
cacheinfo. dev_mc_fill_addr() now also emits IFA_FLAGS and
IFA_TARGET_NETNSID.

The dump request attributes in the spec are still empty. The op doc still
covers only IPv4/IPv6.

The next patch in the series, "netlink: specs: rt-addr: document AF_PACKET
multicast dumps", adds the global flag, the flags and target-netnsid
attributes and the AF_PACKET doc. After it, the series is consistent.

Could the spec update be folded into this patch, so the uAPI and the spec
land together?

> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 3ab053cbf8b99..d827cc21867bc 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c

[ ... ]

> @@ -1215,6 +1219,194 @@ void dev_mc_init(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(dev_mc_init);
>  
> +static int dev_mc_fill_addr(struct sk_buff *skb, const struct net_device *dev,
> +			    const struct netdev_hw_addr *ha, u32 portid,
> +			    u32 seq, unsigned int flags, int netnsid)
> +{

[ ... ]

> +	if ((netnsid >= 0 &&
> +	     nla_put_s32(skb, IFA_TARGET_NETNSID, netnsid)) ||
> +	    nla_put(skb, IFA_MULTICAST, dev->addr_len, ha->addr) ||

[Severity: Medium]
Is it safe to take the IFA_MULTICAST length from the live dev->addr_len
here?

dev_mc_dump() is registered with RTNL_FLAG_DUMP_UNLOCKED. While it calls
this function it holds only RCU and addr_list_lock. Code that writes
addr_len at runtime holds RTNL but not addr_list_lock. One example is
TUNSETLINK in __tun_chr_ioctl():

drivers/net/tun.c:__tun_chr_ioctl() {
    ...
			tun->dev->type = (int) arg;
			tun->dev->addr_len = tun_get_addr_len(tun->dev->type);
    ...
}

Nothing flushes dev->mc when the type changes. Entries added through
SIOCADDMULTI and dev_mc_add_global() remain after the change, because
that path doesn't require IFF_UP.

Those entries were created by __hw_addr_create(), which initializes only
as many bytes as the address length at creation time:

net/core/dev_addr_lists.c:__hw_addr_create() {
    ...
	ha = kmalloc(alloc_size, GFP_ATOMIC);
	if (!ha)
		return NULL;
	memcpy(ha->addr, addr, addr_len);
    ...
}

Suppose a TAP device is switched from ARPHRD_ETHER (addr_len 6) to
ARPHRD_IP6GRE (addr_len 16). Would this dump then copy the uninitialized
bytes in ha->addr[6..15] to userspace?

There are two related points.

First, if TUNSETLINK runs during a dump, its plain write to dev->addr_len
races with the read here.

Second, in a dump that takes several rounds, entries from the same device
can be emitted with different lengths. A type change doesn't touch
dev_mc_genid or dev_base_seq, so NLM_F_DUMP_INTR isn't set in that case.

dev_mc_seq_show() for /proc/net/dev_mcast already reads dev->addr_len
the same way. This patch adds a second path to existing behavior rather
than a new exposure, but the new uAPI picks up the same problem.

> +	    nla_put_u32(skb, IFA_MC_USERS, ha->refcount) ||
> +	    nla_put_u32(skb, IFA_FLAGS, ha->global_use ? IFA_F_GLOBAL : 0)) {
> +		nlmsg_cancel(skb, nlh);
> +		return -EMSGSIZE;
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012011707.3378-1-sigefriedhyy%40gmail.com
