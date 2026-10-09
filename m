Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB364D7D2C;
	Fri,  9 Oct 2026 11:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547137; cv=none; b=tQ/YPgXL3KNRxzYwIPSzJtMbNQCeseq5PY1z2YUUOz+fCgBQXTvxGLuzilq4VCiIxEDpMwoiSR8NVJkPlvcYyypc/++2qeGDOJixFXxyacS3S1nhBO+D1uHs1mhq0TpbMg2sDjnkXYZpWvbNorS568H//VTZQoRBDtTId6QhN5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547137; c=relaxed/simple;
	bh=keCw4JklAnUtBzjIBtrgg0wyQxcqkxo6DfAROena4CM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fw+sgsnd++3PEQsaO6iVVWlKP1G8KkI9MbSh9qheiMkC5B38/MBc5GTHWM2dA/9pOJYxKrnmwYek6qkvUIzp/k+0+fbBHcSLa88w5rlPv/dV9msRu7Jvzvk2SPDXSa/Cj5yuO19JCnpMW5XBOKS3CTKy36bNwK/gPtlLigYIx7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eie1cvU8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eie1cvU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00631F00893;
	Fri,  9 Oct 2026 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547132;
	bh=XjSa8BZ6E/qZMUBiBDIIDAIfAUgfdrDgAn/Tx1MO5sA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Eie1cvU88zwby0sCcUEIPMTCyeouw0+rOY7811AXsiMZ+7vTzU2g+i+lL7mk7P/iN
	 /FxKslyew7BwA+0xb3GvdF2U5IIIxFmRpU4RkRs12E7N64yRWPXej0OQX7CgMCdwXv
	 hS5GpNYelivOO+aTmMT9JntK4w3EsODJ9vSXZ20xKnjwehGWXOFe7h1aZANjFZY9CT
	 LHWve2U65A9Dbyn9BG+t+73LvcnJmMTXytcMCKDV874Y0SPLRXaJYlFmZavxUZcqiJ
	 MrMwQyyTF3c1z/V2+AfLLxk5F03/HgX6YiaifpqqGkq3rmtdKYpWklsPO4CJrovzGh
	 Be5cE/YgxHOQA==
Subject: Re: [PATCH net-next v10 3/6] net: add a generation counter for
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
Date: Fri, 09 Oct 2026 11:58:50 +0000
Message-ID: <179154713053.434549.11454657718901075006@kernel.org>
In-Reply-To: <20261007115821.11332-4-sigefriedhyy@gmail.com>
References: <20261007115821.11332-4-sigefriedhyy@gmail.com>
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

- [Medium] netlink: AF_PACKET multicast dump misses changes due to
  reading sequence after loop
- [Low] __hw_addr_changed() (net/core/dev_addr_lists.c) does
  atomic_inc(&dev_net(list->mc_dev)->dev_mc_genid).

--

net: add a generation counter for dev->mc changes

This commit adds a per netns generation counter, dev_mc_genid, that is
bumped whenever an entry is added to or removed from any dev->mc list.
To find the netns, netdev_hw_addr_list gets an mc_dev pointer, which is
set only for dev->mc, and the count helpers bump
dev_net(mc_dev)->dev_mc_genid. The counter will be used by a following
patch for the AF_PACKET multicast dump.

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

[Severity: Medium]
This counter only catches changes if the dump samples it before it
walks the lists, but the user in the following patch seems to sample it
afterwards. dev_mc_dump() assigns cb->seq from
dev_mc_base_seq(filter.tgt_net) only after the for_each_netdev_dump()
loop has finished.

The reader holds netif_addr_lock_bh() while it walks each dev->mc, so
the ordering of the atomic_inc() against the list update is not the
problem. The problem is the window between releasing the address lock
of the last device dumped in a round and taking the sample. For
example:

  - a round fills the skb partway through eth0's dev->mc and stops,
    recording the resume position
  - eth0's addr_list_lock is released
  - another CPU deletes an eth0 entry that sits before the resume
    position and bumps dev_mc_genid
  - dev_mc_dump() then stores the already bumped value in cb->seq
  - the next round resumes eth0 at the stored position and skips one
    entry, but the genid it sees matches the value stamped at the end
    of the previous round, so nl_dump_check_consistent() has nothing
    to flag and NLM_F_DUMP_INTR is never set

An add in the same window gives a duplicated entry instead. Either way
user space receives an inconsistent dump with no hint that it should
retry, which is what this counter is meant to prevent.

The commit message names inet_base_seq() as the model. In
inet_dump_ifaddr() it is sampled under rcu_read_lock() before
for_each_netdev_dump() is entered, so any change made during or after
the traversal shows up as a different value in the next round. Should
dev_mc_dump() take its sample before the loop in the same way?

[Severity: Low]
Is dev_net() safe to use here? __hw_addr_changed() runs with only the
device's addr_list_lock held. __dev_change_net_namespace() switches
dev->nd_net under RTNL and netdev_lock(dev), and it never takes
addr_list_lock:

net/core/dev.c:__dev_change_net_namespace() {
    ...
	netdev_lock(dev);
	dev_net_set(dev, net);
	netdev_unlock(dev);
    ...
}

So a dev->mc writer that holds neither RTNL nor the instance lock can
run at the same time as a netns move. The rxe driver looks like one such
caller:

rxe_attach_mcast()
  rxe_get_mcg()
    rxe_mcast_add()
      dev_mc_add(ndev)
        __dev_mc_add()
          __hw_addr_add_ex()
            __hw_addr_count_inc()
              __hw_addr_changed()
                dev_net(ndev)

rxe_mcast_add() only holds the reference it gets from
ib_device_get_netdev(). On NETDEV_UNREGISTER, rxe_notify() only queues
the ib device unregistration, and rxe_net_del() does not clear the port
netdev. That means this path can still run while something like
"ip link set <ndev> netns X" executes.

dev_net() is read_pnet(), which does a plain load through
rcu_dereference_protected(pnet->net, true). That load races with the
rcu_assign_pointer() in dev_net_set().

Would KCSAN report this as a data race? And could the increment then
land on the old netns's dev_mc_genid instead of the new one?

The old struct net can't be freed under the BH-disabled spinlock, and
dev_base_seq covers the device appearing in the new netns. So the impact
looks limited to the race report and one bump going to the wrong netns.

Would dev_net_rcu() be a better fit for this reader?

> +}
> +
>  static void __hw_addr_count_add(struct netdev_hw_addr_list *list, int value)
>  {
>  	list->_count += value;
> +	__hw_addr_changed(list);
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007115821.11332-1-sigefriedhyy%40gmail.com
