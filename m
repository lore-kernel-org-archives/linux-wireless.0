Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113544ABBCF;
	Fri,  9 Oct 2026 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547140; cv=none; b=RHomoTyY2VYfupteM9qVlS8giawqrjVrryGsoCvrFu7p4ulAEBNZBIyB5FrHM+j8Wtfu1Hvc1o7zoR086iDQNBNslAMBqCNHs0ZINtZ+bQ/4ybhP+3Ha48lw0Aj2HtlOmNdJ1nhgbHF1ZdtJkkITjK82k+xbVTeH5Fp7If/hjQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547140; c=relaxed/simple;
	bh=OQBwtG+P9kanTFGeWl6xEVSuku218Nxf3exD126VyWI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YwmvHRYlPcymxenkkgD0KjKXknwTrbzJGewgryE52VY/HVPldxaChhXyqEpXS380POl3nJD2I/edQkfEL3KjsBCk5MQ09GeYboSag3nUwurzo3PUf7f6aNUo66q/q+AxOHYPWI3ejkAxruBgxeuJ+p/Rj7aD9A6NjOjruxlYO+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjqqlWk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjqqlWk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C351F00898;
	Fri,  9 Oct 2026 11:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547134;
	bh=f/i/jS1GobhsX8cRniYOpg2sSsXl/VCEnv4JqV1Rwm4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EjqqlWk/A66fEqQrwSk63AyzIiNTGDVtuD2MJ6nFbv7xJlPsvNq96i1pEnyrsOrqi
	 FsuRRQKu2E3dF8CAZhMKTTmlkoGP/vYRvLTFJRZVxuzvuKiaT8FR3JL4rgod72kVzF
	 rZDzBENGgo0G0zsinONy4VRsz/4/7gdCeVRFiVJ4ObRi5PfNDm+lHAM8ypYqNLy99r
	 UIuX0ycpfRg802nCGYmuE2PUxyeSlYYsZ7+wuxEvaUQRmtSRdqS2cA7LrY57qKYhCP
	 dxI1mQYNRjAVpAZz+ge9dkMmNLnSXBNXGGCKxMjESPB/joLEArpNRsDDGH+q9qPdl9
	 +61L2X5SNs93A==
Subject: Re: [PATCH net-next v10 4/6] net: add AF_PACKET multicast dumps
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
Date: Fri, 09 Oct 2026 11:58:52 +0000
Message-ID: <179154713266.434549.3119718667275543634@kernel.org>
In-Reply-To: <20261007115821.11332-5-sigefriedhyy@gmail.com>
References: <20261007115821.11332-5-sigefriedhyy@gmail.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] dev_mc_dump() (net/core/dev_addr_lists.c) calls
  nl_dump_check_consistent(cb, nlmsg_hdr(skb)) once at the end of every…
- [Medium] dev_mc_dump() reads the generation (cb->seq =
  dev_mc_base_seq()) only after the walk, once dev_mc_dump_dev() has…
- [Low] At this commit, Documentation/netlink/specs/rt-addr.yaml is not
  updated for the new AF_PACKET RTM_GETMULTICAST dump.

--

net: add AF_PACKET multicast dumps

This adds RTM_GETMULTICAST dump support for ifa_family AF_PACKET. Each
dev->mc entry is reported in ifaddrmsg format with its link-layer
address, refcount and global_use flag. The dump runs under RCU and the
device addr_list_lock without RTNL, and uses a dev->mc generation counter
to set NLM_F_DUMP_INTR.

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
This isn't a bug, but this commit does not update
Documentation/netlink/specs/rt-addr.yaml for the new flag or the
AF_PACKET dump:

  - the ifa-flags enum has no entry for IFA_F_GLOBAL
  - the getmulticast doc still says "Get / dump IPv4/IPv6 multicast
    addresses."
  - the reply attribute list does not include flags or target-netnsid
  - the dump request lists no attributes

The next patch in the series, "netlink: specs: rt-addr: document
AF_PACKET multicast dumps", appears to fix all of these. The final patch,
"selftests: net: test AF_PACKET multicast dumps", adds a selftest. So the
mismatch only affects ynl decoding at this intermediate commit.

>  
>  struct ifa_cacheinfo {
>  	__u32	ifa_prefered;
> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 3ab053cbf8b99..7b9abeca431f6 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c

[ ... ]

> +/* Combine dev_mc_genid and dev_base_seq to detect changes, like
> + * inet_base_seq().
> + */
> +static u32 dev_mc_base_seq(const struct net *net)
> +{
> +	u32 res = atomic_read(&net->dev_mc_genid) +
> +		  READ_ONCE(net->dev_base_seq);

[ ... ]

> +static int dev_mc_dump_dev(struct net_device *dev, struct sk_buff *skb,
> +			   struct netlink_callback *cb, int *s_addr_idx,
> +			   unsigned int flags, int netnsid)
> +{
> +	struct netdev_hw_addr *ha;
> +	int addr_idx = 0;
> +	int err = 0;
> +
> +	netif_addr_lock_bh(dev);
> +	netdev_for_each_mc_addr(ha, dev) {
> +		if (addr_idx < *s_addr_idx) {
> +			addr_idx++;
> +			continue;
> +		}
> +		err = dev_mc_fill_addr(skb, dev, ha, NETLINK_CB(cb->skb).portid,
> +				       cb->nlh->nlmsg_seq, flags, netnsid);
> +		if (err < 0)
> +			break;
> +		addr_idx++;
> +	}
> +	netif_addr_unlock_bh(dev);
> +
> +	*s_addr_idx = err < 0 ? addr_idx : 0;
> +
> +	return err;
> +}

[ ... ]

> +int dev_mc_dump(struct sk_buff *skb, struct netlink_callback *cb)
> +{

[ ... ]

> +	rcu_read_lock();
> +
> +	if (filter.ifindex) {
> +		cb->answer_flags |= NLM_F_DUMP_FILTERED;
> +		flags |= NLM_F_DUMP_FILTERED;
> +		dev = dev_get_by_index_rcu(filter.tgt_net, filter.ifindex);
> +		if (dev)
> +			err = dev_mc_dump_dev(dev, skb, cb, &ctx->addr_idx,
> +					      flags, filter.netnsid);
> +		else
> +			err = -ENODEV;
> +	} else {
> +		s_ifindex = ctx->ifindex;
> +		for_each_netdev_dump(filter.tgt_net, dev, ctx->ifindex) {
> +			/* The device the dump stopped at is gone, do not
> +			 * skip entries of the next one.
> +			 */
> +			if (dev->ifindex != s_ifindex)
> +				ctx->addr_idx = 0;
> +			err = dev_mc_dump_dev(dev, skb, cb, &ctx->addr_idx,
> +					      flags, filter.netnsid);
> +			if (err < 0)
> +				break;
> +		}
> +	}
> +	cb->seq = dev_mc_base_seq(filter.tgt_net);

[Severity: Medium]
Is the generation read too late for the first round?

cb->seq is read here, after dev_mc_dump_dev() has already dropped
addr_list_lock with netif_addr_unlock_bh(). On the first round
cb->prev_seq is 0, so the value read here becomes the baseline.

Suppose another CPU changes dev->mc on the device where round 1 stopped,
between that unlock and the atomic_read() in dev_mc_base_seq(). That
change then becomes part of the baseline:

  round 1 stops at index 5 of dev A
  netif_addr_unlock_bh(A)
                                 other CPU deletes entry 2 of A
                                 __hw_addr_changed() bumps dev_mc_genid
  round 1 reads G1, cb->prev_seq = G1
  round 2 resumes at index 5, old entry 5 (now index 4) is skipped
  round 2 reads G1, no NLM_F_DUMP_INTR

An addition in the same window would produce a duplicate entry instead.
The window covers local_bh_enable() in the unlock, which can run
softirqs. Under PREEMPT_RCU the task can also be preempted there.

This ordering matches rtnl_dump_ifinfo(), but that dump resumes by
ifindex, not by list position. inet_dump_addr() in net/ipv4/devinet.c,
which resumes by position, reads the generation before the walk:

	cb->seq = inet_base_seq(tgt_net);

	for_each_netdev_dump(tgt_net, dev, ctx->ifindex) {

Should cb->seq be read before the walk here too?

> +	nl_dump_check_consistent(cb, nlmsg_hdr(skb));

[Severity: Medium]
Can NLM_F_DUMP_INTR be lost when a round emits no messages?

This check runs on every round, even when nothing was added to the skb.
Dumps resume by list position through ctx->addr_idx. Consider this
sequence:

  round N-1 returns -EMSGSIZE at the last dev->mc entry of device D,
  where D is the last device with entries or the one selected by
  ifa_index

  before the next recvmsg(), an earlier entry of D is deleted, for
  example by a socket leaving an IP multicast group, which reaches
  dev_mc_del() and bumps dev_mc_genid

  round N resumes at the saved addr_idx, which is now past the end of
  D's list, so it emits nothing and returns 0

In round N, cb->seq differs from cb->prev_seq, so
nl_dump_check_consistent() sets NLM_F_DUMP_INTR in nlmsg_hdr(skb). With
skb->len == 0 that address is unused tailroom, not a message. The call
then sets cb->prev_seq to cb->seq.

Next, netlink_dump() calls netlink_dump_done():

net/netlink/af_netlink.c:netlink_dump_done() {
    ...
	nlh = nlmsg_put_answer(skb, cb, NLMSG_DONE, sizeof(nlk->dump_done_errno),
			       NLM_F_MULTI | cb->answer_flags);
    ...
	nl_dump_check_consistent(cb, nlh);
    ...
}

NLMSG_DONE is written at the same address, and __nlmsg_put() overwrites
nlmsg_flags. The second check then finds seq == prev_seq and sets
nothing.

Wouldn't the entry that moved into the deleted slot be missing from the
dump, with no NLM_F_DUMP_INTR reported? That seems to contradict the
commit message:

  "so an entry added or removed since the previous round sets
  NLM_F_DUMP_INTR"

in_dev_dump_ifaddr() in net/ipv4/devinet.c only calls the check after it
has filled a message:

		err = inet_fill_ifaddr(skb, ifa, fillargs);
		if (err < 0)
			goto done;

		nl_dump_check_consistent(cb, nlmsg_hdr(skb));

Would the same approach work here?

> +
> +	rcu_read_unlock();
> +	if (filter.netnsid >= 0)
> +		put_net_track(filter.tgt_net, &filter.ns_tracker);
> +	return err;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007115821.11332-1-sigefriedhyy%40gmail.com
