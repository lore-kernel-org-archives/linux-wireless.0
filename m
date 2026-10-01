Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC56408615;
	Thu,  1 Oct 2026 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790897489; cv=none; b=GlnTpf/6RqsLnPz3EntiuaHmwPE7pm9ytr7Ww/IqynEphnr9h0tErW4q4ZxT+BvlzdIVhvKTFXcpYVRgyZv3hASL3dLGTVeNeweln3v/Ze+MV1AipFsQE3ShaA2OW+BJfQ/uG4oEgsh5s1xzpY2OyaycJZz+kwoMParVKrVlq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790897489; c=relaxed/simple;
	bh=yHoK5/M9JnTz7Ng6K1DHM5c7dOYEWdkOYo30j3alhnY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o8nnr2S6pjsrQOSzKpQa7YfMAoEHRO3WvSAoB1BiIEgl/V+gjdJ9BdZWSceOh8QrPlYFf1Xc/5o7xjBoB+bHW5WQ3qvpG4GV1bO2W8/KZpBT95joOvGAHC5Pk4L81AGasbN/GVPnt1yYXBcSP4d5VhYsM6UP+qd2vkaKE60Oh0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBqd2it8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBqd2it8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CFA1F000FF;
	Thu,  1 Oct 2026 23:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790897483;
	bh=yiXcC5dhj1ExtDQ3X8mwdkDL4YYrIXwmL6+zTcnQGf0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oBqd2it8kMlVkLpqxllavkWr9L35Qfrk9Sb1Ij2qiEGfbG7j7U0bBn74ufdODNYLC
	 23I1rk5YvcbVuWUa2bOMT3WlqW7TxeOABc07/1UsDzC/v+YFfgeApM4bO1I1ZO4D4D
	 TH1rHYowaJWYQGABj+ix7IRtSzedQhU6nMb774/mh7oxYxvH09rRq++aBFO3a3367L
	 bsaGgSE8jg4wlKJ60rqjovYZJSs+j+lVOO9Ev9y7rjgkA01IXS9InLhjJ/FVX04wu7
	 9B9uzP9tI33MSEZUn9LrpOjSgAhwdMJQNIKOfjt+6b5eYd8PoGk4SVR15YSA/Wz66L
	 hgwehQGk94+Qg==
Subject: Re: [PATCH net-next v9 4/6] net: add AF_PACKET multicast dumps
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
Date: Thu, 01 Oct 2026 23:31:21 +0000
Message-ID: <179089748154.434549.15968186317991628500@kernel.org>
In-Reply-To: <20260930112842.21323-5-sigefriedhyy@gmail.com>
References: <20260930112842.21323-5-sigefriedhyy@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Concurrent device removal can end an unfiltered AF_PACKET
  RTM_GETMULTICAST dump early without setting NLM_F_DUMP_INTR.
- [Low] The commit message gives a false reason for not extending the FDB
  dump.
- [Low] At this commit, Documentation/netlink/specs/rt-addr.yaml does not
  describe the new AF_PACKET multicast dump: - The ifa-flags enum stops…
- [Low] dev_mc_genid is only bumped through the __hw_addr_count_*
  helpers, i.e. when a dev->mc entry is added or removed.

--

net: add AF_PACKET multicast dumps

This adds an unlocked RTM_GETMULTICAST dump handler for ifa_family
AF_PACKET. For each device it reports every dev->mc entry in the ifaddrmsg
format, with IFA_MULTICAST, IFA_MC_USERS and a new IFA_F_GLOBAL flag. Dump
consistency comes from sampling dev_mc_genid plus dev_base_seq into cb->seq,
so NLM_F_DUMP_INTR gets set when either changes.

> The default FDB dump also walks dev->mc, but only for Ethernet devices
> without an ndo_fdb_dump of their own, so bridge, vxlan or macvlan
> devices never show their multicast filter there, and it has no users
> count or global_use bit.

[Severity: Low]
Is this accurate for bridge and macvlan?

macvlan uses the default helper directly:

drivers/net/macvlan.c:
	.ndo_fdb_dump		= ndo_dflt_fdb_dump,

br_fdb_dump() also falls back to it for unfiltered dumps:

net/bridge/br_fdb.c:br_fdb_dump() {
	...
	if (!filter_dev) {
		err = ndo_dflt_fdb_dump(skb, cb, dev, NULL, idx);
	...
}

rtnl_fdb_dump() calls a device's own ndo_fdb_dump with filter_dev == NULL.
ndo_dflt_fdb_dump() then walks both dev->uc and dev->mc for ARPHRD_ETHER
devices.

So "bridge fdb show" seems to already list dev->mc for bridge masters and
macvlan devices. Only vxlan fits the description.

The other reasons (no users count, no global_use bit, changing the
"bridge fdb show" output) may still hold. Could this paragraph be
corrected?

> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 783c62895249b..948dc25635938 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c

[ ... ]

> @@ -1219,6 +1223,197 @@ void dev_mc_init(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(dev_mc_init);
>  
> +static int dev_mc_fill_addr(struct sk_buff *skb, const struct net_device *dev,
> +			    const struct netdev_hw_addr *ha, u32 portid,
> +			    u32 seq, unsigned int flags, int netnsid)
> +{
> +	u32 ifa_flags = ha->global_use ? IFA_F_GLOBAL : 0;

[ ... ]

> +	if ((netnsid >= 0 &&
> +	     nla_put_s32(skb, IFA_TARGET_NETNSID, netnsid)) ||
> +	    nla_put(skb, IFA_MULTICAST, dev->addr_len, ha->addr) ||
> +	    nla_put_u32(skb, IFA_MC_USERS, ha->refcount) ||
> +	    nla_put_u32(skb, IFA_FLAGS, ifa_flags)) {

[Severity: Low]
At this commit, Documentation/netlink/specs/rt-addr.yaml doesn't yet
describe this dump:

  - the ifa-flags enum ends at stable-privacy, so bit 12 (IFA_F_GLOBAL),
    emitted here in IFA_FLAGS, has no name
  - the getmulticast op doc still says "Get / dump IPv4/IPv6 multicast
    addresses."
  - the reply attributes do not include flags or target-netnsid, and the
    dump request declares no attributes even though target-netnsid is
    accepted

The next patch in the series, "netlink: specs: rt-addr: document AF_PACKET
multicast dumps", fixes all of this. It adds global after stable-privacy,
adds flags and target-netnsid to the reply and target-netnsid to the
request, and rewrites the op doc. Nothing is left over at the end of the
series.

Would it make sense to fold the spec update into this patch, so the spec
and the kernel match at every commit?

> +	    nla_put_u32(skb, IFA_FLAGS, ifa_flags)) {
> +		nlmsg_cancel(skb, nlh);
> +		return -EMSGSIZE;
> +	}
> +
> +	nlmsg_end(skb, nlh);
> +	return 0;
> +}
> +
> +/* Combine dev_mc_genid and dev_base_seq to detect changes, like
> + * inet_base_seq().
> + */
> +static u32 dev_mc_base_seq(const struct net *net)
> +{
> +	u32 res = atomic_read(&net->dev_mc_genid) +
> +		  READ_ONCE(net->dev_base_seq);

[Severity: Low]
This isn't a bug, but dev_mc_genid is only bumped from the __hw_addr_count_*
helpers, i.e. when a dev->mc entry is added or removed. In-place updates to
the two fields exported here don't bump it:

net/core/dev_addr_lists.c:__hw_addr_add_ex() {
	...
			if (global) {
				/* check if addr is already used as global */
				if (ha->global_use)
					return 0;
				else
					ha->global_use = true;
			}
	...
			ha->refcount++;
			return 0;
	...
}

net/core/dev_addr_lists.c:__hw_addr_del_entry() {
	...
	if (global)
		ha->global_use = false;
	...
	if (--ha->refcount)
		return 0;
	...
}

The dump resumes by list position, and these updates never add, remove or
reorder entries. So nothing is skipped or repeated, which matches the IPv4
dev_addr_genid convention.

However, the struct net comment ("bumped on dev->mc changes") and the
commit message ("so a change since the previous device or dump round sets
NLM_F_DUMP_INTR") describe more than that. Could they say membership
changes instead?

[ ... ]

> +	s_ifindex = ctx->ifindex;
> +	for_each_netdev_dump(filter.tgt_net, dev, ctx->ifindex) {
> +		/* The device the dump stopped at is gone, do not skip
> +		 * entries of the next one.
> +		 */
> +		if (dev->ifindex != s_ifindex)
> +			ctx->addr_idx = 0;
> +		err = dev_mc_dump_dev(dev, skb, cb, &ctx->addr_idx, flags,
> +				      filter.netnsid);
> +		if (err < 0)
> +			break;
> +	}
> +out:
> +	/* A round that dumps no device, e.g. the one it stopped at is gone,
> +	 * still needs the NLMSG_DONE check to see the change.
> +	 */
> +	cb->seq = dev_mc_base_seq(filter.tgt_net);

[Severity: Medium]
Can a concurrent unregister still end this dump early without
NLM_F_DUMP_INTR?

unlist_netdevice() removes the device from the xarray before it bumps
dev_base_seq:

net/core/dev.c:unlist_netdevice() {
	...
	xa_erase(&net->dev_by_index, dev->ifindex);

	netdev_for_each_altname(dev, name_node)
		netdev_name_node_del(name_node);

	/* Unlink dev from the device chain */
	list_del_rcu(&dev->dev_list);
	netdev_name_node_del(dev->name_node);
	hlist_del_rcu(&dev->index_hlist);

	dev_base_seq_inc(dev_net(dev));
}

The handler is registered with RTNL_FLAG_DUMP_UNLOCKED. So the next dump
round can run while the RTNL holder is preempted between xa_erase() and
dev_base_seq_inc().

Take a round that returns -EMSGSIZE partway through device D. That leaves
ctx->ifindex == D->ifindex, ctx->addr_idx == k, and
cb->prev_seq == cb->seq == G.

D, which is down, is then unregistered or moved to another netns. dev->mc
isn't flushed until later in unregister_netdevice_many_notify(), so
dev_mc_genid doesn't change either.

In the next round, for_each_netdev_dump() no longer finds D. The
dev_mc_dump_dev() calls on later devices and the sample at out: both read
G again. netlink_dump_done()->nl_dump_check_consistent() then sees
seq == prev_seq, and NLMSG_DONE is sent without NLM_F_DUMP_INTR.

Userspace would get entries 0..k-1 of D and no sign that the rest are
missing. The unlocked IPv4 and IPv6 dumps rely on the same dev_base_seq
ordering, but this path is new in this patch.

The commit message says this case is covered ("also when the last round
dumps nothing because the device it stopped at is gone"). Does that fully
hold with this ordering?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930112842.21323-1-sigefriedhyy%40gmail.com
