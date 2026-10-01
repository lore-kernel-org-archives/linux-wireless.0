Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED82840927A;
	Thu,  1 Oct 2026 23:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790897489; cv=none; b=OwGR2nlGApSV4oEA0/XGr3ezK/HMEfnJIqQr+3Ey5mgWgVdUPtG40VC4imSEj3e//YF2cJVoOOHMxT/Qy2g/ycrB0+OBmnjPvZfKaCtcAuhbpEjbWc4jxB3CDVltS0goU8OyDFzCxHdqziwmrBvRrUPgazCCgRx538053HjGmFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790897489; c=relaxed/simple;
	bh=pwHPDa/Tey4Qe6zpcdGiiWrYA/xnEqKp5tI0eJyTrWE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JvzxiKUl8Cnz4J85V1VH8bNfPEsm7JA6568cquSF2PW/Kb6w9rey88Ww/Xjg5VJxnvhbBd8BTGbD3/eodAitlhlON97GQdF3KR4mh8VZxag+62unaVBHZq5oPvGk04cTN15kx6UFqxDRB26ukTEkzsowyc0WWTfmjjpjlBE0bSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zrtzrr9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zrtzrr9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C721F00893;
	Thu,  1 Oct 2026 23:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790897485;
	bh=uP+1s2+mY1X4WWdkyQ/vldJBuw30/RBWRbWtWgr7AC8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Zrtzrr9zPJsOiKTXG3kkBP1ptv4Kpcn4jJDmajzn2rNm67+CK+4e+wIVt8MHEJjc9
	 xfbEOZe9wkuo+SgWIcui+vLTyDddTcDBroo0UCIxkNXMcGEXLBE1HdytYdJXYAv/7D
	 WCm7Bs5SLkq0asFMX4sESmhGeK1t+zlTp4vitXtjehZe1ccFhjW255nvmhg0wcr86O
	 cGYcBgZMnOlll+/AvTFDyFdJNtQHAVScTX3CguTAn5LlLi3TsRd7LawDhSY57u42lD
	 7z6woJPK3nopLaNV5qcGxcLn63ze64BSTbpDdzLJIYqyAXbE/jko9TvhBlbCsAUY8o
	 McvSnxEkc6PRA==
Subject: Re: [PATCH net-next v9 5/6] netlink: specs: rt-addr: document
 AF_PACKET multicast dumps
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
Date: Thu, 01 Oct 2026 23:31:23 +0000
Message-ID: <179089748368.434549.14167408771777474746@kernel.org>
In-Reply-To: <20260930112842.21323-6-sigefriedhyy@gmail.com>
References: <20260930112842.21323-6-sigefriedhyy@gmail.com>
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

- [Low] The patch adds `target-netnsid` to the getmulticast dump request
  with no condition, and writes doc text on which request semantics…

Pre-existing issues:
- [Low] In Documentation/netlink/specs/rt-addr.yaml, the getmulticast
  operation still has a `do` section, and its doc still starts with "Get…

--

netlink: specs: rt-addr: document AF_PACKET multicast dumps

This updates the rt-addr spec to cover AF_PACKET RTM_GETMULTICAST dumps.
It adds a global ifa-flags value and expands the getmulticast doc. It also
adds flags and target-netnsid to the multicast reply attributes and lists
target-netnsid as a dump request attribute.

> diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
> index 17ead22034515..1bd1184d1e202 100644
> --- a/Documentation/netlink/specs/rt-addr.yaml
> +++ b/Documentation/netlink/specs/rt-addr.yaml

[ ... ]

> @@ -168,7 +170,16 @@ operations:
>            attributes: *ifaddr-all
>      -
>        name: getmulticast
> -      doc: Get / dump IPv4/IPv6 multicast addresses.
> +      doc: |
> +        Get / dump multicast addresses. ifa-family must select the address
> +        family: AF_INET or AF_INET6 for the IP multicast groups joined on
> +        a device, AF_PACKET for the link-layer multicast addresses in the
> +        device filter. Link-layer entries added explicitly, e.g. with
> +        SIOCADDMULTI or "bridge fdb add ... self", rather than by a
> +        protocol join are reported with the global flag set. For AF_PACKET
> +        a non-zero ifa-index restricts the dump to that device and
> +        ifa-prefixlen, ifa-flags and ifa-scope must be zero, AF_INET and
> +        AF_INET6 apply this with NETLINK_GET_STRICT_CHK only.
>        attribute-set: addr-attrs
>        fixed-header: ifaddrmsg
>        do:
> @@ -181,10 +192,13 @@ operations:
>              - multicast
>              - mc-users
>              - cacheinfo
> +            - flags
> +            - target-netnsid

[Severity: Low]
This is a pre-existing issue, but does any family actually implement the
do side of getmulticast?

The do block and the "Get / dump" wording were already in the spec before
this patch. Every RTM_GETMULTICAST registration is dump-only:

net/core/rtnetlink.c:
	{.protocol = PF_PACKET, .msgtype = RTM_GETMULTICAST,
	 .dumpit = dev_mc_dump, .flags = RTNL_FLAG_DUMP_UNLOCKED},

net/ipv4/devinet.c:
	{.owner = THIS_MODULE, .protocol = PF_INET, .msgtype = RTM_GETMULTICAST,
	 .dumpit = inet_dump_ifmcaddr, .flags = RTNL_FLAG_DUMP_UNLOCKED},

net/ipv6/addrconf.c:
	{.owner = THIS_MODULE, .protocol = PF_INET6, .msgtype = RTM_GETMULTICAST,
	 .dumpit = inet6_dump_ifmcaddr,
	 .flags = RTNL_FLAG_DUMP_UNLOCKED},

If NLM_F_DUMP is not set, rtnetlink_rcv_msg() finds no doit for the
family or for PF_UNSPEC and returns -EOPNOTSUPP. A spec-driven do
getmulticast (ynl --do, or the generated C do helper) will therefore
always fail.

The rewritten doc still begins with "Get / dump". The &mcaddr-attrs anchor
is defined under do.reply, so the patch also adds flags and target-netnsid
to the reply of an operation that cannot succeed.

Since this doc is being rewritten anyway, could the do block be dropped,
the attribute list moved under dump.reply, and "Get" removed from the doc?

>        dump:
>          request:
>            value: 58
> -          attributes: []
> +          attributes:
> +            - target-netnsid

[Severity: Low]
Do all three families honour target-netnsid here? The new doc says:

    For AF_PACKET
    a non-zero ifa-index restricts the dump to that device and
    ifa-prefixlen, ifa-flags and ifa-scope must be zero, AF_INET and
    AF_INET6 apply this with NETLINK_GET_STRICT_CHK only.

That caveat covers the ifa-index filter and the zero header checks.
However, target-netnsid is listed as a request attribute with no
condition.

For AF_INET, inet_dump_addr() parses IFA_TARGET_NETNSID only through
inet_valid_dump_ifaddr_req(), and only when strict checking is on:

net/ipv4/devinet.c:inet_dump_addr() {
    ...
	if (cb->strict_check) {
		err = inet_valid_dump_ifaddr_req(nlh, &fillargs, &tgt_net,
						 skb->sk, cb);
    ...
}

inet6_dump_addr() in net/ipv6/addrconf.c does the same with
inet6_valid_dump_ifaddr_req(). On the AF_PACKET side,
dev_mc_valid_dump_req() parses it unconditionally.

As a result, a non-strict AF_INET or AF_INET6 RTM_GETMULTICAST dump that
carries IFA_TARGET_NETNSID ignores the attribute without any error and
dumps the caller's own netns. AF_PACKET honours it.

The C YNL library in tools/net/ynl/lib/ynl.c sets only NETLINK_CAP_ACK
and NETLINK_EXT_ACK and never NETLINK_GET_STRICT_CHK, so spec-driven C
clients will hit this. The Python YNL library does set it.

Could the doc also say that AF_INET and AF_INET6 honour target-netnsid
only with NETLINK_GET_STRICT_CHK?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930112842.21323-1-sigefriedhyy%40gmail.com
