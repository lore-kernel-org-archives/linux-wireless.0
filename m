Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967374D2EC6;
	Fri,  9 Oct 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547142; cv=none; b=R0AGBcjtXeR09QLR7KdkZIh8SHnR3f/M5sKNZ2CKaz+QYfD/WlZQSkoWZrnMgE9bVhh/ICg4Z7UyEPXJainJZjnr5rnLyGVC1D0vvzUPVKBUzxqPpiAsNRooTtuuMDaTWjsRL5d551pgGMd6RrDI2E9zg7SV0cR5u5yvfcSIbvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547142; c=relaxed/simple;
	bh=v/3a0Lh8ZrHURH8d4p13eZl66IprV2UOGdSkmI/lYyQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ldBHNlZaVomyqIS5kOr+x3viVm9w8S+ooUIK/vC4EfLKwkOE59TmgLLC+biwC3SSL1NKxEq/ZVylBR6KSpMFYsT3UF8P1FMJY4s4dvgb+PEH/Zi6QermhZXzUPryHzTLUzXUTE0njIsadDqRMaxwFRSSvECthmSCG8rChgP+15A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSxZ0M77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSxZ0M77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E947E1F000FF;
	Fri,  9 Oct 2026 11:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547130;
	bh=30ssU5210HbC7M47rvuGzutQ0pbZYYtm6BCtAsC5o+Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GSxZ0M77V20rQv8FlI7Pe8kSXhM69uiUEQoFca6t4eOJkmfu6SjPXilkhcEBM6eQ3
	 nWESW/VuJEw5HkK3Z9+OsRtnXj9AzMJDeJCLRCbHKDgFOffOuPLDeIpKqDSYT8KknH
	 mm3xJCA7JO3Ae+QOckzXFy2zLorunoewXIMXzuK84Qtoh7mhF943FvvdRy3Qet4oKv
	 PPWTdPxCjM+i+NYUbi/9WOVLrtDyPiq8k2dVB2zedfKq6wUDwEqVgjPKCvrX2vsHO2
	 P84KQn4ujO17K5+tknd7ZenjYusu/8xUYEZa5iw3GxyZyZtZjLbEYBJt/q2JD/HFzs
	 HndlaOeDLciUQ==
Subject: Re: [PATCH net-next v10 1/6] netlink: specs: rt-addr: fix the type of
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
Date: Fri, 09 Oct 2026 11:58:48 +0000
Message-ID: <179154712848.434549.1887332518398499959@kernel.org>
In-Reply-To: <20261007115821.11332-2-sigefriedhyy@gmail.com>
References: <20261007115821.11332-2-sigefriedhyy@gmail.com>
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

- [Low] Commit "netlink: specs: rt-addr: fix the type of target-netnsid"
  fixes a real defect in Documentation/netlink/specs/rt-addr.yaml but…

--

netlink: specs: rt-addr: fix the type of target-netnsid

This patch changes the type of the target-netnsid attribute in
rt-addr.yaml from binary to s32. The kernel parses IFA_TARGET_NETNSID
as NLA_S32, and rt-link.yaml already declares its own target-netnsid
as s32.

> The kernel parses IFA_TARGET_NETNSID as NLA_S32 and rt-link.yaml
> declares its target-netnsid as s32, but rt-addr.yaml has it as binary.
>
> Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[Severity: Low]
Should this have a Fixes: tag?

The binary type on target-netnsid goes back to the commit that first
added the spec. A later rename to target-netnsid kept the type as it
was. On the kernel side, IFA_TARGET_NETNSID has always been s32. It
is NLA_S32 in ifa_ipv4_policy in net/ipv4/devinet.c and in the IPv6
policy in net/ipv6/addrconf.c, and it is written with nla_put_s32()
and read with nla_get_s32().

Python YNL is affected on any tree without this fix. When an integer
is passed for target-netnsid, YnlFamily._add_attr() in
tools/net/ynl/pyynl/lib/ynl.py takes the binary branch and raises:

    raise YnlException(f'Unknown type for binary attribute, value: {value}')

Replies that carry the attribute are also decoded as raw bytes, not
as a signed int.

Would something like this be appropriate?

Fixes: dfb0f7d9d979 ("doc/netlink: Add spec for rt addr messages")

> diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
> index 0ecbd24c890c..17ead2203451 100644
> --- a/Documentation/netlink/specs/rt-addr.yaml
> +++ b/Documentation/netlink/specs/rt-addr.yaml
> @@ -119,7 +119,7 @@ attribute-sets:
>          type: u32
>        -
>          name: target-netnsid
> -        type: binary
> +        type: s32
>        -
>          name: proto
>          type: u8

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007115821.11332-1-sigefriedhyy%40gmail.com
