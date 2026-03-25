Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAD93D523F;
	Wed, 25 Mar 2026 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774442122; cv=none; b=jBNm5b4OkwLHuMnIbvm4/xv/6SYej27Tga7UObjZ5YdN1SASLXgMuG0AuePCxu1R9kcd+6VpGhcUDrDpnvgGU47eVfUhXH9YkQTju0QMFM0XMKiP8PXQ0HZpiin5FH9XRD/cLrxl3pr4Ee3iQzyDewBplUMBGrPvVMkJNjSqDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774442122; c=relaxed/simple;
	bh=+R+lJs41uMGINn7Rejjuy2KUgYV/nShPIqod0kgcZqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjB34fzCwoDdVOYyt35J/XBEuFsYfKY6ElQLPxlOtlBKV5pImgZntDQKS3bu17qd+2CzqN4m+murvzHM8BdZrPK5Ls02ShUWkT2JjjKAa2xAnmCiK+jXMOoGl15BtMoIWXBfIIYVnKkaocLf1wbihjx+kMcgcW2GsDDGZ3QjyGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=lSnGXOBR; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="lSnGXOBR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=/6tIYwIaFZMwKTk6frUqA8pBrrq6GpqaaxxhmVYn9gw=; b=lSnGXOBRdqt6yH+HUQ/7tQklG6
	FDt9qm2pbQJc5EHSrS5vYZlMgsKc13ZCIMXMckL2TOlg/fgCoyghu2NHaNiwObhqAo2cAoUgBwL3j
	M0CSsUwt5BlFM+o2hDemYvdCIIMVkkp+1emso/ZWPG+vjmZfKf05m/4ooTeFSJCso+KY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w5NRb-00DHcx-I7; Wed, 25 Mar 2026 13:34:43 +0100
Date: Wed, 25 Mar 2026 13:34:43 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Alexander Popov <alex.popov@linux.com>
Cc: Jakub Kicinski <kuba@kernel.org>, David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Michal Kubecek <mkubecek@suse.cz>, Gal Pressman <gal@nvidia.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	James Guan <guan_yufei@163.com>, Kees Cook <kees@kernel.org>,
	Paul Moses <p@1g4.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	security@kernel.org, notify@kernel.org
Subject: Re: [PATCH] wifi: virt_wifi: remove SET_NETDEV_DEV to avoid
 use-after-free
Message-ID: <fa3c91c3-9ceb-4fb2-9250-cc239fb0c1b6@lunn.ch>
References: <20260324224607.374327-1-alex.popov@linux.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324224607.374327-1-alex.popov@linux.com>

On Wed, Mar 25, 2026 at 01:46:02AM +0300, Alexander Popov wrote:
> Currently we execute `SET_NETDEV_DEV(dev, &priv->lowerdev->dev)` for
> the virt_wifi net devices. However, unregistering a virt_wifi device in
> netdev_run_todo() can happen together with the device referenced by
> SET_NETDEV_DEV().
> 
> It can result in use-after-free during the ethtool operations performed
> on a virt_wifi device that is currently being unregistered. Such a net
> device can have the `dev.parent` field pointing to the freed memory,
> but ethnl_ops_begin() calls `pm_runtime_get_sync(dev->dev.parent)`.
> 
> Let's remove SET_NETDEV_DEV for virt_wifi to avoid bugs like this:

Did you have a look at all user of SET_NETDEV_DEV() to see if there
are other examples of the same bug?

What i found was:

https://elixir.bootlin.com/linux/v6.19.9/source/drivers/net/ethernet/mellanox/mlx4/en_netdev.c#L3180

Does this have the same problem?

     Andrew
