Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E5C41DE02;
	Tue, 13 Oct 2026 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857103; cv=none; b=mhPwNKVTFHOMZpViLvl/b/pV2ij24KWs2WbqOVCg+oBC+M27jkEvDCRcxROlQAJnSInSZiGVtQDqGb1/Q9fewK9htTMn0gHiIRmv+0YfNRohA6nDzeGezIhAObJp4pFR/8yznjgaCtAiMQ2R6S6LHo5tHRO5XlhF4gR54MtxVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857103; c=relaxed/simple;
	bh=52DzKKtQSMUW/kfNaNzeB201m9Ru1aODVf0x6ktaDYA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JgcXVHvzYQyXsiBWwFGd4I8FeqeKRgZwW34XKMDGtEt3MjGyJPx2JnQEL/UrD819AzCe3cvEBaboap78rApAMgmq6FQI1t1/+H/u6Hq2BE2MEyqh/Gxlv+zBlBzedwTs7b1k+ky4Iw/SqicAtlPv5jW6Ng/xPt2HhalDEr1YtQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaHvIGMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaHvIGMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767F81F00898;
	Tue, 13 Oct 2026 02:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791857102;
	bh=pXk2JIKRCvMAxTrsqzZaEh3EGvfZBCqCTFxXl1fXQzg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DaHvIGMtOnN1+19j0rzD+QWuBF+oMbtVx9RImbMx9mk95KWEStZe0WKIK6JsscqF4
	 jTULyAQzTXYZiDK+9HpqVX/A0HEmyiC7FZZ9SxGkznY2dBdMsKyTg1di7s8zmDo70a
	 w17cKCgOY9/DT4KWinunNBDes8RiHu9JABg5Vkf1+NtJVdp3HKemeuZQru8+XjA1iS
	 OcysHa3A6ZEkoXEMm9A8M3Eq5ToRYXKj+o5pUNBy465lOGkf9ul7J+9y+Ucw63vKPb
	 TvS+UMct4mZ+Rle7qu8XN7KxboRBu/Z5ksc17rvkIuEuHwP6Pebo0WH5Xz6u3WyhjQ
	 pxDWMS+OR/0zA==
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
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
Date: Tue, 13 Oct 2026 02:04:59 +0000
Message-ID: <179185709988.434549.15422498299449004512@kernel.org>
In-Reply-To: <20261012011707.3378-4-sigefriedhyy@gmail.com>
References: <20261012011707.3378-4-sigefriedhyy@gmail.com>
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

- [Low] The commit message misdescribes the precedent it copies.
- [Low] The patch adds an 8-byte 'struct net_device *mc_dev' to every
  struct netdev_hw_addr_list (include/linux/netdevice.h:253), but only…
- [Low] __hw_addr_changed() (net/core/dev_addr_lists.c:22-26) reads the
  device netns with plain dev_net(list->mc_dev).

--

net: add a generation counter for dev->mc changes

This adds a per netns atomic counter, dev_mc_genid. It is bumped whenever
an entry is added to or removed from any dev->mc list. To find the netns
from the list helpers, a new mc_dev back pointer is added to struct
netdev_hw_addr_list and set only for dev->mc. The counter is meant for the
AF_PACKET multicast dump in the following patch.

> The IPv4 and IPv6 dumps report that with NLM_F_DUMP_INTR by
> stamping cb->seq from a per netns generation counter combined with
> dev_base_seq, see inet_base_seq().

[Severity: Low]
Is this accurate for the multicast dumps?

inet_base_seq() reads net->ipv4.dev_addr_genid, and inet6_base_seq() reads
net->ipv6.dev_addr_genid. inet_dump_addr() and inet6_dump_addr() also use
these for RTM_GETMULTICAST and MULTICAST_ADDR.

The only writers of dev_addr_genid are the unicast ifaddr and netdev event
paths: fib_inetaddr_event() and fib_netdev_event() for IPv4, and
__ipv6_ifa_notify() for IPv6. Neither net/ipv4/igmp.c nor net/ipv6/mcast.c
touches it.

Doesn't that mean the IPv4 and IPv6 multicast dumps also miss group joins
and leaves between dump rounds? If so, they share the gap this patch closes
for dev->mc rather than being a working precedent. Could the commit message
be reworded to say that?

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ad17c5b8a6036..e3cae73a4255e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -259,6 +259,9 @@ struct netdev_hw_addr_list {
>  
>  	/* Auxiliary tree for faster lookup on addition and deletion */
>  	struct rb_root		tree;
> +
> +	/* Set for dev->mc only, the device the list belongs to */
> +	struct net_device	*mc_dev;
>  };

[Severity: Low]
This isn't a functional bug, but the pointer makes every
netdev_hw_addr_list bigger, and only dev_mc_init() ever sets it. On 64-bit
the struct goes from 32 to 40 bytes.

Some examples of the cost:

- struct net_device embeds four of these lists (uc, mc, dev_addrs,
  rx_mode_addr_cache), so it grows by 32 bytes.
- vlan_mcast_list[MAX_VLAN_ID] in drivers/net/ethernet/ti/icssg/icssg_prueth.h
  grows by about 2 KiB per emac.
- netif_rx_mode_run() has four on-stack snapshot lists, so its frame grows
  by 32 bytes.
- Other users, such as the mac80211 mc_list, carry a pointer that is
  always NULL.

There is a 4-byte hole after _count. Would a bool or 1-bit flag there,
combined with container_of(list, struct net_device, mc), work instead? It
would give the same information without growing the struct.

[ ... ]

> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index d615192d1c3b1..3ab053cbf8b99 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c
> @@ -16,9 +16,19 @@
>  
>  #include "dev.h"
>  
> +/* RTM_GETMULTICAST dumps use the netns generation counter to detect
> + * changes of dev->mc between dump rounds.
> + */
> +static void __hw_addr_changed(struct netdev_hw_addr_list *list)
> +{
> +	if (list->mc_dev)
> +		atomic_inc(&dev_net(list->mc_dev)->dev_mc_genid);

[Severity: Low]
Can this dev_net() read race with a netns move of mc_dev?

dev_net() becomes read_pnet(), which is rcu_dereference_protected(pnet->net,
true), a plain load. Some callers here hold only addr_list_lock. They don't
hold RTNL or the device instance lock. Meanwhile __dev_change_net_namespace()
writes nd_net under RTNL and netdev_lock(dev):

net/core/dev.c:__dev_change_net_namespace() {
    ...
	netdev_lock(dev);
	dev_net_set(dev, net);
	netdev_unlock(dev);
    ...
}

One path that isn't serialized against this goes through net_failover. That
driver is not ops-locked and has no ndo_change_rx_flags, so it uses the
legacy synchronous rx mode path. An IPv6 multicast join on the failover
master runs with only idev->mc_lock held:

__ipv6_dev_mc_inc()
  igmp6_group_added()
    dev_mc_add(failover)
      __dev_set_rx_mode(failover)
        net_failover_set_rx_mode()
          dev_mc_sync_multiple(primary_dev, dev)
            __hw_addr_add_ex(&primary_dev->mc, ...)
              __hw_addr_count_inc()
                __hw_addr_changed()
                  dev_net(primary_dev)

When the primary slave moves to another netns,
net_failover_slave_unregister() clears the pointer without waiting for a
grace period:

	RCU_INIT_POINTER(nfo_info->primary_dev, NULL);

An rx mode call already in flight can then still be reading
dev_net(primary_dev) when dev_net_set() runs. KCSAN would likely report
this.

The BH-disabled addr_list_lock already provides an RCU read side here.
Would dev_net_rcu() be the better accessor? The worst outcome is one
increment landing on the old netns counter, and the move also bumps
dev_base_seq in the new netns.

> +}
> +
>  static void __hw_addr_count_add(struct netdev_hw_addr_list *list, int value)
>  {
>  	list->_count += value;
> +	__hw_addr_changed(list);
>  }

[ ... ]

> @@ -1197,6 +1211,7 @@ EXPORT_SYMBOL(dev_mc_flush);
>  void dev_mc_init(struct net_device *dev)
>  {
>  	__hw_addr_init(&dev->mc);
> +	dev->mc.mc_dev = dev;
>  }
>  EXPORT_SYMBOL(dev_mc_init);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012011707.3378-1-sigefriedhyy%40gmail.com
