Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA1433E37C;
	Thu,  1 Oct 2026 23:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790897480; cv=none; b=XEKWB3JAOwYTBPML7zUKDtwH2hq33Txkbln9DyZRMu27hdABZE+frhZb7iaEK4Z+kCq9u0hGLbCvdvJBhV0xvdiR1J8PWLg0JKM3hKqTMVbnbIlMBAxKPxxi7re/tIt0VVewrz3wHjbUOs2JwYbbpCgGrEShI8GetKXtEOmN64o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790897480; c=relaxed/simple;
	bh=P1+qC6QMcvsNqQi8vL9sAGTCsIAKk4aFLZwe3gqiKrU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VIFcUUhJl+yM7+5tpOjYGPlOIVyuNh6a6a+lkwPOK38cHkckCJJGbxVjDmTD4g7N/FH470Enpu8Vwx/6u1Ek27v5RqIgKiFOqw1rC0bZz4Y3+x2bJsG6s7mMe9qyo95HVejZa3SkuU1E4YH5MlXfT/BWCoIPpjRNDWM0z81xw84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3PGcKAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3PGcKAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA7E1F000FF;
	Thu,  1 Oct 2026 23:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790897479;
	bh=8Yd3WzxEXuLjcx2PTW67B8euJHw5K1GAhQXQ5b9k29U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=B3PGcKAG9PjvEGgHgo33xYcWg9IxTibWmg1wb8GHcdCCZtgMPC+7irolwa+M6g7bx
	 Kdu4Vx+9cWWDMthbFOA69DIgrUpBwN+f9xtki8BJ/lhGMweR8Yr+mzE88QY4bfBr0V
	 ouer3q5pLMgAfvTZh16Xd0Y+YySqht85KY0z+CtOQmKs3besOd6dmOC+l+9D2TnRhk
	 sOxyb0MpM1hdBHLOiXDBcETiZ2/Wsraufyj9uGQZBFTjeJvisYdk4jqZzMSM+95YDc
	 wx+SCGxVJ0Kggti5WnLJT46yUo0GKtwNRDmuiRNnD6gWNnYbKNVuEVAmLS0Oo9lWf6
	 jb/iTTY9ShhkQ==
Subject: Re: [PATCH net-next v9 1/6] netlink: specs: rt-addr: fix the type of
 target-netnsid
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
Date: Thu, 01 Oct 2026 23:31:17 +0000
Message-ID: <179089747717.434549.10025971158678601177@kernel.org>
In-Reply-To: <20260930112842.21323-2-sigefriedhyy@gmail.com>
References: <20260930112842.21323-2-sigefriedhyy@gmail.com>
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

- [Low] The commit "netlink: specs: rt-addr: fix the type of target-
  netnsid" fixes a bug in one specific earlier commit, but its message…

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but after this
  commit rt-addr.yaml still lists target-netnsid in no operation's…

--

netlink: specs: rt-addr: fix the type of target-netnsid

This commit changes the type of the target-netnsid attribute in the rt-addr
netlink spec from binary to s32. That matches the NLA_S32 policy the kernel
uses for IFA_TARGET_NETNSID and the type rt-link.yaml already declares.

> diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
> index 0ecbd24c890c6..17ead22034515 100644
> --- a/Documentation/netlink/specs/rt-addr.yaml
> +++ b/Documentation/netlink/specs/rt-addr.yaml
> @@ -119,7 +119,7 @@ attribute-sets:
>          type: u32
>        -
>          name: target-netnsid
> -        type: binary
> +        type: s32

[Severity: Low]
Should this patch carry a Fixes: tag?

The binary type for target-netnsid has been there since the spec was first
added, when the file was still named rt_addr.yaml. Commit 0c8e30252d9f
later renamed the attribute but did not change its type.

The kernel has always treated this attribute as s32. In net/ipv4/devinet.c
and net/ipv6/addrconf.c the policy entry is:

	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },

The value is written with nla_put_s32() and read with nla_get_s32().

Perhaps:

Fixes: dfb0f7d9d979 ("doc/netlink: Add spec for rt addr messages")

[Severity: Low]
This is a pre-existing issue and was not introduced by this patch. Even with
the type corrected, no operation in rt-addr.yaml lists target-netnsid. The
getaddr dump in particular leaves it out:

      name: getaddr
      doc: Dump address information.
      attribute-set: addr-attrs
      dump:
        request:
          value: 22
          attributes: []
        reply:
          value: 20
          attributes: *ifaddr-all

The kernel accepts IFA_TARGET_NETNSID in RTM_GETADDR dump requests:

net/ipv4/devinet.c:inet_valid_dump_ifaddr_req() {
    ...
		if (i == IFA_TARGET_NETNSID) {
			struct net *net;

			fillargs->netnsid = nla_get_s32(tb[i]);
    ...
}

inet6_rtm_valid_getaddr_req() and inet6_rtm_getaddr() in
net/ipv6/addrconf.c accept it too.

The kernel also puts it in replies, from inet_fill_ifaddr() and
inet6_fill_ifaddr():

	if (args->netnsid >= 0 &&
	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))

Could getaddr's request and reply attribute lists include target-netnsid?
Without it, YNL-generated code cannot dump addresses from another netns
through getaddr.

A later commit in this series, "netlink: specs: rt-addr: document AF_PACKET
multicast dumps", adds target-netnsid to the getmulticast request and reply
lists. getaddr is still unchanged at the end of the series.

>        -
>          name: proto
>          type: u8

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930112842.21323-1-sigefriedhyy%40gmail.com
