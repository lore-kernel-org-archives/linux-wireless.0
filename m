Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306634A76F;
	Mon,  5 Oct 2026 23:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791244148; cv=none; b=RhTfYgwFT4yy013bCcpKzHlYuVQp8g+wBL/fphgituiEW7h+jido+Rcodopxjj9qOr1xi0uxH7OCh5T0UpoLsPoK3qXOfGtC4XQAH4XDnrObP1FKv3kGlSuQL/gIs1G0L9CXCK/IRRBg/FoB1vIfszYmL0jlIeOH0rj5IzWYYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791244148; c=relaxed/simple;
	bh=HqLf8VVxoiTH9Udv5tH/iyyRsmrAHBfLYZ04E7n5lTY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KceicwdoE99H6HBoeFYischEz95EWlPNOol6/2fmjGlzQNFXkaerWWAORWgAwWq8z7HZASVijiWLEn9rZaOiplLG3Um25Wn+mr2gs/fx/mymE7OZluDcE4hkWMXDDemit5jBw3E9YyY+hItaoOOv0OvNqTQbRT7WrMPFKxg5sFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCQRZMpL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCQRZMpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31431F000FF;
	Mon,  5 Oct 2026 23:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791244146;
	bh=KxRdC6ToGXOVMaL534okFwCFyQQ3QITmrTk+6oG7wSQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fCQRZMpLLTe36EySszimHDMNdG92kitSzREZ6RxbFmQ4v837toY4setf9N3QkvHuf
	 1enXYmn30/PC2ia51vgL3oSXyCw1G1S2DSqXrEy9wRTzFDGLRQslE4jpr8d8thVNgd
	 T+exY4EjMW7tJT4NX+xJPgv+T6QkBUH7dmw7GphEuiNL5CGUqS/ykyVMNBBDLln8BB
	 m0iiHDVDHtYQyJ0utKHsrS9+0zNlHMcstV7hnXttt/o4U3CmaW0zRKFTkHrZZjIZFr
	 Xqgtud/WCPgLvljEk1XRGPopwiXkG27X4G9k8rZoQtGcfqcpU0SS7uB1m9UL4MaEaQ
	 BnR5kw5GjWOuA==
Date: Mon, 5 Oct 2026 16:49:05 -0700
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
Subject: Re: [PATCH net-next v9 3/6] net: add a generation counter for
 dev->mc changes
Message-ID: <20261005164905.3d5b6749@kernel.org>
In-Reply-To: <20260930112842.21323-4-sigefriedhyy@gmail.com>
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
	<20260930112842.21323-4-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Sep 2026 20:28:39 +0900 Yuyang Huang wrote:
>  void netif_rx_mode_init(struct net_device *dev)
>  {
>  	__hw_addr_init(&dev->rx_mode_addr_cache);
> +	dev->rx_mode_addr_cache.owner = dev;

There's no need to set this?

>  	timer_setup(&dev->rx_mode_retry_timer, netif_rx_mode_retry, 0);
