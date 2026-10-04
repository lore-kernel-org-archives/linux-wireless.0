Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB2F472528;
	Sun,  4 Oct 2026 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134554; cv=none; b=FnWSsd4gRLJsTh/1++300UMugJNdwVj+rnK0TJS6tYgseEWYelyaamnIJkIkpv5Lru8pAmQ+21+PY4dFRVpZRkSzoQZeWCiMI6JWkxrRmZUm3I7aRP6aDkutpIm/CsYVEPb6d0laQuSHWFfK2td2I9dmAYuAWAm4xOY6rcY+MAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134554; c=relaxed/simple;
	bh=GdpmcbvOL2HkmBfuLBZwuVeh0T5bgjxmA8MtF/Cgmug=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GtwugchKJqNOGLBhVLJiNa+FyK/uW3HiEZuwauGCGhgLca9osSXNZKsUexvrXdB2+tgGk0DtAcpxircmy1JdoeVO0JfU6KxvYNI6vZ6s/waze3l/r4FvkDzxRLDHcAkaaysOT1BrIjCzkHkeoDwiOW2OX9lfIRfzYpMji3GL0NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQ4Fkq0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQ4Fkq0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD671F00899;
	Sun,  4 Oct 2026 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134553;
	bh=Pn5VHpB6AATIC3j+d+ODneVr6Uv/pflDvZXcKBdZi+w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eQ4Fkq0ytHb64GkOxJnzVOhnegmqabdgUrK+ZSBAkXGyaFdemGm5mcYezc0g6ySVb
	 an/q359LEK6DUEGvb+jrs7A8ZoZ983r16YTk5QuDI+o8PFgTtNO45Lu6hh/Sh9MEoX
	 g1GrPeanFtUeR47AIYQrH77SffQLmgWg3ASbZxrKJKEIgXbrvVjwHohTTJqt4J/fOH
	 gE4rrgWYJy9Uq+IQY5PsHaMtn9Xnx3JqhIUQKdIQ9VufKKre7d4DOcTpiHe9pJb79I
	 r6wCxLvrIRDxY2mtjufylB2Jm1sPvRghH6mR4M9cGAXl73j7GjI030yHpq0xC26LkQ
	 jrPSLy+semVQg==
Subject: Re: [PATCH 07/16 net-next v3] ipv4: icmp: split IPv4 specific logic
 into icmp_ipv4.c
From: netdev-bot+sashiko@kernel.org
To: fmancera@suse.de
Cc: netdev@vger.kernel.org, horms@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sun, 04 Oct 2026 17:22:32 +0000
Message-ID: <179113455223.434549.11986614057864020926@kernel.org>
In-Reply-To: <20260930135334.4739-8-fmancera@suse.de>
References: <20260930135334.4739-8-fmancera@suse.de>
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

- [Low] The boot-only per-CPU ICMP control-socket setup loop used to be
  inside `int __init icmp_init(void)`.

--

ipv4: icmp: split IPv4 specific logic into icmp_ipv4.c

This commit moves the IPv4 specific ICMP code from net/ipv4/icmp.c into
a new file, net/ipv4/icmp_ipv4.c. That code covers packet processing,
error handling and the per-CPU control socket setup. The new file is
built only when CONFIG_IPV4 is enabled, while icmp.c is now always
built.

> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 90c0e22c29bea..5e8dcf71d135f 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c

[ ... ]

> @@ -1757,28 +366,11 @@ static struct pernet_operations __net_initdata icmp_sk_ops = {
>  
>  int __init icmp_init(void)
>  {
> -	int err, i;
> -
> -	for_each_possible_cpu(i) {
> -		struct sock *sk;
> +	if (IS_ENABLED(CONFIG_IPV4)) {
> +		int err = icmp_init_ipv4();
>  
> -		err = inet_ctl_sock_create(&sk, PF_INET,
> -					   SOCK_RAW, IPPROTO_ICMP, &init_net);
> -		if (err < 0)
> +		if (err)
>  			return err;

[ ... ]

> diff --git a/net/ipv4/icmp_ipv4.c b/net/ipv4/icmp_ipv4.c
> new file mode 100644
> index 0000000000000..24a1fb497cf6f
> --- /dev/null
> +++ b/net/ipv4/icmp_ipv4.c

[ ... ]

> +int icmp_init_ipv4(void)
> +{
> +	int err, i;
> +
> +	for_each_possible_cpu(i) {
> +		struct sock *sk;
> +
> +		err = inet_ctl_sock_create(&sk, PF_INET,
> +					   SOCK_RAW, IPPROTO_ICMP, &init_net);
> +		if (err < 0)
> +			return err;
> +
> +		per_cpu(ipv4_icmp_sk, i) = sk;

[Severity: Low]
This loop used to run inside the __init icmp_init(). The new
icmp_init_ipv4() has no __init annotation, but its only caller is still
icmp_init(). So this code is no longer freed after boot.

Should icmp_init_ipv4() be marked __init, both here and on its prototype
in include/net/icmp.h?

The prototype also sits in the public header next to the normal ICMP
entry points, which makes a boot-only helper look like a general API. If
something called it a second time, it would overwrite the per-CPU
ipv4_icmp_sk pointers and leak the old sockets. No such caller exists
today.

The annotation also appears to be missing at the end of the series.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930135334.4739-1-fmancera%40suse.de
