Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA2C456E1E;
	Mon,  5 Oct 2026 23:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791244189; cv=none; b=ETk0YV/runBfZNml3AWt97ibVR9pdLQwbl3mJ9zVcbMXROVANJROmuswrP52xoLl7IHQMfo4uOrVYek4AU4vtEplgCfRysXSvHHulvFrCjB55BK+VORYc373lj3YR5tiUq5DtSSN/1XzFXwp2890UlzA/58cWp/t8IB4/wdXoOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791244189; c=relaxed/simple;
	bh=f7LOH7H2f4WUJs84cTbO3REd4wPdn1m4OYbzv5efXg8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4dIzMarrFCR7alFGhYDaUuP5B3Pj+yWfSSKuut7dl4bChwWKqDrAVQtqpxs93RyDU8963jCP5BGYhzAQk9oB0sXB+HuryM7Yc/VmY0Ub5pZbLLWZOze/vE1bxEKIzTOASa3JkSN2xU+ttqfeMsfEo+2GuR/XIa+NAKqKyyheFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIZkpETz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIZkpETz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A041F000FF;
	Mon,  5 Oct 2026 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791244188;
	bh=tncH384WWqvonNdxO2KdvDGijT7bz/Cse9qfsImGrcI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FIZkpETz2N7G9H5jaoB6Kyw4LPn5BrEQ6J48C5kq/eA4MjcNmOIcJONgaUxUM1r2E
	 nmTk9qspUaR0UZt9Be2Yb1CM0mUWUPnq5ud3d5iIubROwoSKdlorsO33fLpiv2oj8G
	 +ndh3ZtrW6+pU206u1xY7eIUxuPndK/7AOWM/6ShpgfroQ8RJPwQfe1tuEixttL2ph
	 hVrCvNdgvpK86cOSa3dE09XwbjZQqCXSg+CaNra7RrExRtNPH+sKkAYvSKwEgF1o8W
	 Z0pYG7RLNIMtHs1dVSrnrnQmY2IxUVgzsDoTKzh36XjyQRLFZQ++aGtJw95UdGwVDR
	 lbawhiQ5KIEkQ==
Date: Mon, 5 Oct 2026 16:49:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>, Aleksandr Loktionov
 <aleksandr.loktionov@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>, "David S. Miller"
 <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, Donald Hunter
 <donald.hunter@gmail.com>, Eric Dumazet <edumazet@google.com>, Ido Schimmel
 <idosch@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>, Johannes Berg
 <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>, Kory Maincent
 <kory.maincent@bootlin.com>, Kuniyuki Iwashima <kuniyu@google.com>, Nicolas
 Dichtel <nicolas.dichtel@6wind.com>, Nikolaos Gkarlis
 <nickgarlis@gmail.com>, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
 <sd@queasysnail.net>, Shuah Khan <shuah@kernel.org>, Simon Horman
 <horms@kernel.org>, Stanislav Fomichev <sdf.kernel@gmail.com>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, Willem de Bruijn
 <willemb@google.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next v9 4/6] net: add AF_PACKET multicast dumps
Message-ID: <20261005164946.25da19c2@kernel.org>
In-Reply-To: <20260930112842.21323-5-sigefriedhyy@gmail.com>
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
	<20260930112842.21323-5-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Sep 2026 20:28:40 +0900 Yuyang Huang wrote:
> +	netdev_for_each_mc_addr(ha, dev) {
> +		if (addr_idx < *s_addr_idx) {
> +			addr_idx++;
> +			continue;
> +		}
> +		err = dev_mc_fill_addr(skb, dev, ha, NETLINK_CB(cb->skb).portid,
> +				       cb->nlh->nlmsg_seq, flags, netnsid);
> +		if (err < 0)
> +			break;
> +		nl_dump_check_consistent(cb, nlmsg_hdr(skb));

Why are you checking this on every iteration?

> +		addr_idx++;
> +	}

The changes still lack polish IMO.
