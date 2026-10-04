Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379A6471416;
	Sun,  4 Oct 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134552; cv=none; b=tOBdRdM3yFE4LO2OffSXgfAisWIgrBI8uhTR9YhZhxT33IsMfHxmyp9kbS4Lxosm4nwkGNSzeRtBKSwUA49fyHWUCgup1nQC/NuNefIqrxsaDRwzia/ThmWej7XLf4sBKTrw+S/oNwsU3xVJVtSVwFE2H6ABSCexzHXE3EsOti4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134552; c=relaxed/simple;
	bh=y4U9sdqSX+SLCuphJSOPDyoLN+z8g/18/bdkc0CU+0I=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hdGc2y4ZqHvbtMP83tMpDm6MsA/LPNvdGDzGLBjOZMPM/zrpY7Vs5RHqZUSUm04Pfig36kXPhnPrC4/H4mOnFF8q4j+5PWw5MflVc8+GtZMcLzErTra3aHEMCxxpr+maxbANCfwVgQDvPlI5wnqqrNWhOyl7Z+eXrnd11qls4B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ib8N+P52; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ib8N+P52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7861F000FF;
	Sun,  4 Oct 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134551;
	bh=LWs0IUeZgaWXavRPwPbOu8D++xZzQdiH6/SUvFQVmnY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ib8N+P52mCayHObolwmiBuVkkETv3jgXQe2175L8iBotjHlx0I81BIWs+NrW+WEcl
	 /PCNFxr/KaVvgRJ//v8V/59DoSQvRmIUaTRaaXHr/kO6P0aXbY7pYDpaEH3NmICFk7
	 R3fotKFHgBf7W5fAz/5VDUIDuCN9ByZihfksoIr2N3bBQ564/kd4YHNlMpR/puOHWY
	 0l8Ti/ZB7kfsiQQqIX+wIvLcdaad18LtviaQjG1wLto9eP337gsVixCQz8hTd/TnpW
	 9bT75/I2jbuTjHH+hu5GssZCsT3CgZHnDrV5IG/zIVvjAjRnGfWDuDgLf4+iuBK614
	 +NMICCWROPtqw==
Subject: Re: [PATCH 05/16 net-next v3] ipv4: raw: split IPv4 specific logic
 into raw_ipv4.c
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:30 +0000
Message-ID: <179113455008.434549.12574408611696347699@kernel.org>
In-Reply-To: <20260930135334.4739-6-fmancera@suse.de>
References: <20260930135334.4739-6-fmancera@suse.de>
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

- [Low] The IPv4-only `struct raw_frag_vec` is left behind in
  net/ipv4/raw.c (line 72) and a second, identical copy is added in…
- [Low] The new file net/ipv4/raw_ipv4.c uses
  `EXPORT_SYMBOL_GPL(raw_v4_match);` at line 61 but does not include…

--

ipv4: raw: split IPv4 specific logic into raw_ipv4.c

This commit moves the IPv4-specific RAW socket code (packet matching,
input/output processing, ICMP filtering and the AF_INET raw_prot) from
net/ipv4/raw.c into a new net/ipv4/raw_ipv4.c. The new file is built only
when CONFIG_IPV4 is enabled. raw_diag.c now wraps raw_v4_match() in an
IS_ENABLED(CONFIG_IPV4) check.

> diff --git a/net/ipv4/raw_ipv4.c b/net/ipv4/raw_ipv4.c
> new file mode 100644
> index 0000000000000..0419026683b08
> --- /dev/null
> +++ b/net/ipv4/raw_ipv4.c
> @@ -0,0 +1,884 @@

[ ... ]

> +#include <asm/ioctls.h>
> +#include <linux/igmp.h>
> +#include <linux/mroute.h>
> +#include <linux/netfilter.h>
> +#include <linux/sockios.h>
> +#include <linux/stddef.h>
> +#include <linux/types.h>
> +#include <linux/compat.h>
> +#include <net/icmp.h>
> +#include <net/ip.h>
> +#include <net/raw.h>
> +#include <net/sock.h>
> +#include <net/udp.h>
> +#include <net/xfrm.h>
> +
> +struct raw_frag_vec {
> +	struct msghdr *msg;
> +	union {
> +		struct icmphdr icmph;
> +		char c[1];
> +	} hdr;
> +	int hlen;
> +};

[Severity: Low]
This isn't a bug, but should the original copy of struct raw_frag_vec be
removed from net/ipv4/raw.c? After this patch, raw.c still contains:

net/ipv4/raw.c:
struct raw_frag_vec {
	struct msghdr *msg;
	union {
		struct icmphdr icmph;
		char c[1];
	} hdr;
	int hlen;
};

All of its users (raw_probe_proto_opt(), raw_getfrag() and raw_sendmsg())
are now in raw_ipv4.c, so nothing in raw.c uses it.

Can the raw.c copy be dropped as part of the move? That would leave a single
definition of this IPv4-only structure.

> +
> +bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
> +		  __be32 raddr, __be32 laddr, int dif, int sdif)
> +{

[ ... ]

> +	return raw_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if),
> +				   dif, sdif);
> +}
> +EXPORT_SYMBOL_GPL(raw_v4_match);

[Severity: Low]
Should raw_ipv4.c include <linux/export.h>? It uses
EXPORT_SYMBOL_GPL(raw_v4_match), but <linux/export.h> is not in its
include list. raw.c includes that header directly for
EXPORT_SYMBOL_GPL(raw_v4_hashinfo).

With W=2, check_missing_include_linux_export_h() in scripts/misc-check
would warn:

  net/ipv4/raw_ipv4.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing

The file still compiles, because the header is pulled in indirectly.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
