Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3653E3179;
	Tue, 13 Oct 2026 02:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857100; cv=none; b=my8qHU6/NOxSCevLIdj9OF5DoYq429fPsISr9VlHyyo96b3XL3Q4WR18vGeSjsHKIF+Z2XlfEhTmOH0Jr8folcv0apg5BfsHwJvofOBssybGlnHJqT3iRwtC0hIWyAH2CK5+AJwPxWz/6TxLodvm1BoGPOHBV3q0d03UuYTP1Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857100; c=relaxed/simple;
	bh=Ni9xdFQRsu7xhU2pHZcPfawAA3TKlxPNiaw/TvoTEz0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OSBbcWRbusdh7k/rgD7mkyQPf1BnB9pfLhgsdHNLSlirQ5gFLrfA282d13IIqUuiak2N/t1KgsBRQWrfraOHxQvTcMdAHhnZYQErRkZ6Okz7U4V1Iy8ewBMpXgAxy6jGq34IEb6/R4SQ/CXt8gcJ31ZzxghCUgzwMFUNxdLsJUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oG45VgRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oG45VgRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E64A1F00893;
	Tue, 13 Oct 2026 02:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791857099;
	bh=v1rjribMsJ9Sp01nQ2z04+fvF4TfD4+dw4GlsPuNIAw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oG45VgRO3L9zJ+JGVTKuU5NYr+E/cMK7JpMs3egdzEtuvicj1bhbZmOY8+0MCJ3Pf
	 V22oopBNlj+i295+XXsigWc2JCd1Bfa4Qsso1u+73oNCp4TJizeQAOeXrODHZgSq1V
	 BD+rfbk/u9OWl7cNJBLPKglusa4QelucZNCzrQ6/LZzbIjZ9eHIetItRnt8G/JP/bA
	 mWB0O+PIU4vke9xnAMCuvgoM71J+MkwXD6nxWd+Yo1lCZWehkzBWNgdnolhRgePrpl
	 cWYM5oVzyDhyD22cj+4e2OGRcHRUohyS8ep8lsKe9a7V0KdMG7VBeODZXqqdEJcEb1
	 HAtHvafyfWJkQ==
Subject: Re: [PATCH net-next v11 1/6] netlink: specs: rt-addr: fix the type of
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
Date: Tue, 13 Oct 2026 02:04:57 +0000
Message-ID: <179185709784.434549.17899680533305071231@kernel.org>
In-Reply-To: <20261012011707.3378-2-sigefriedhyy@gmail.com>
References: <20261012011707.3378-2-sigefriedhyy@gmail.com>
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

- [Low] The commit fixes a real type mismatch in
  Documentation/netlink/specs/rt-addr.yaml.

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but the getaddr
  operation in Documentation/netlink/specs/rt-addr.yaml still doesn't…
- [Low] This problem wasn't introduced by this patch, but
  Documentation/netlink/specs/ovs_vport.yaml has the same kind of…

--

netlink: specs: rt-addr: fix the type of target-netnsid

This patch changes the type of target-netnsid in the rt-addr YNL spec from
binary to s32. That matches the NLA_S32 policy the kernel uses for
IFA_TARGET_NETNSID and the s32 type rt-link.yaml already uses.

> The kernel parses IFA_TARGET_NETNSID as NLA_S32 and rt-link.yaml
> declares its target-netnsid as s32, but rt-addr.yaml has it as binary.
>
> Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[Severity: Low]
Should this have a Fixes: tag? The type: binary line comes from the
commit that first added the spec. The later rename commit only changed the
attribute name:

Fixes: dfb0f7d9d979 ("doc/netlink: Add spec for rt addr messages")

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
This is a pre-existing issue and was not introduced by this patch. The
getaddr operation in this spec still doesn't list target-netnsid anywhere:

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

Here *ifaddr-all contains only address, label, local and cacheinfo.

The kernel accepts the attribute in RTM_GETADDR dump requests. This is
from net/ipv4/devinet.c:inet_valid_dump_ifaddr_req():

	if (i == IFA_TARGET_NETNSID) {
		struct net *net;

		fillargs->netnsid = nla_get_s32(tb[i]);

The IPv6 dump request handling in net/ipv6/addrconf.c does the same. The
kernel also puts the attribute in replies, from inet_fill_ifaddr() and
inet6_fill_ifaddr():

	if (args->netnsid >= 0 &&
	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))

The spec also has no do block for getaddr. IPv6 registers RTM_GETADDR
with .doit = inet6_rtm_getaddr, and inet6_rtm_valid_getaddr_req() accepts
IFA_TARGET_NETNSID, IFA_ADDRESS and IFA_LOCAL.

Could target-netnsid be added to the getaddr request and reply lists,
along with a do block? Right now, generated per-op C code can't set or
parse the attribute whose type this patch fixes. The Python YNL tools
still work because they encode and decode against the whole attribute set.

A later patch in this series fixes the getmulticast case: "netlink: specs:
rt-addr: document AF_PACKET multicast dumps" adds target-netnsid to the
getmulticast dump request and to &mcaddr-attrs. getaddr is still
unchanged at the end of the series.

>        -
>          name: proto
>          type: u8

[Severity: Low]
This isn't a bug introduced by this patch, but
Documentation/netlink/specs/ovs_vport.yaml seems to have the same kind of
netnsid type mismatch. Should it be s32 as well? That spec declares the
attribute as unsigned:

        name: netnsid
        type: u32

But vport_policy in net/openvswitch/datapath.c uses a signed type:

	[OVS_VPORT_ATTR_NETNSID] = { .type = NLA_S32 },

ovs_vport_cmd_fill_info() sends the value with nla_put_s32(). The value
comes from peernet2id_alloc(), which can return NETNSA_NSID_NOT_ASSIGNED
(-1). A YNL client using the ovs_vport spec would decode -1 as 4294967295.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012011707.3378-1-sigefriedhyy%40gmail.com
