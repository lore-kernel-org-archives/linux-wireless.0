Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7506F22B8AB;
	Wed, 25 Mar 2026 08:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774427772; cv=none; b=XN9F7UY5qP86O6S/fVFoTlBm9WS9ctOnokr3ztEFbg4g1/vynnS+h9hit+0v/uonoZin9Msdu8EjH9QX/uTO3ne7wKCXtK0vnlau6mfzrJ2ZBVizBecktJIsHaczncign6cK4ftzOM7hC7tt+ZYH14brsuStwVAF7Cx8Ko+Xi9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774427772; c=relaxed/simple;
	bh=29bEWiwR+EqjRfeboZRwARrs+O69fEWBTWWdn6MYycQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuxwayJSweuwqWjJUgNCEDcOsSw0IblxVrRRhnPlhbvYo+Mc106okyncqwWptg5DFhJHuhA+8A8Rnhzn94Kc14rtHWw+tMj5oxRILIoH/x8YS6WNXlbTXuU+iyuVr4G8enEgFeQEJZ4286xwiQWRSFoosJCYUgWhNr2ZqZQT32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ay2TBjMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ay2TBjMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384B0C4CEF7;
	Wed, 25 Mar 2026 08:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774427772;
	bh=29bEWiwR+EqjRfeboZRwARrs+O69fEWBTWWdn6MYycQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ay2TBjMR4aWLKyR0/R90Rf8TG7cmgnh9QKGfYc3yixPrqWezhuEofBiWsIJONiXKO
	 5wzGRGfam0gXVZexdUkQEaesUdv0j0sf3FdUFMhvx9S1PXaJOH49RDzCUGg6OJ5UTy
	 0OS32fmd/DpI05U4xrcGsgGtqcZJHqlPBYilBo3I=
Date: Wed, 25 Mar 2026 09:35:47 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Michal Kubecek <mkubecek@suse.cz>, Gal Pressman <gal@nvidia.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	James Guan <guan_yufei@163.com>, Kees Cook <kees@kernel.org>,
	Paul Moses <p@1g4.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	security@kernel.org, notify@kernel.org
Subject: Re: [PATCH] wifi: virt_wifi: remove SET_NETDEV_DEV to avoid
 use-after-free
Message-ID: <2026032538-footpath-mystified-1381@gregkh>
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
> 
>  ==================================================================
>  BUG: KASAN: slab-use-after-free in __pm_runtime_resume+0xe2/0xf0
>  Read of size 2 at addr ffff88810cfc46f8 by task pm/606
> 
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x4d/0x70
>   print_report+0x170/0x4f3
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   kasan_report+0xda/0x110
>   ? __pm_runtime_resume+0xe2/0xf0
>   ? __pm_runtime_resume+0xe2/0xf0
>   __pm_runtime_resume+0xe2/0xf0
>   ethnl_ops_begin+0x49/0x270
>   ethnl_set_features+0x23c/0xab0
>   ? __pfx_ethnl_set_features+0x10/0x10
>   ? kvm_sched_clock_read+0x11/0x20
>   ? local_clock_noinstr+0xf/0xf0
>   ? local_clock+0x10/0x30
>   ? kasan_save_track+0x25/0x60
>   ? __kasan_kmalloc+0x7f/0x90
>   ? genl_family_rcv_msg_attrs_parse.isra.0+0x150/0x2c0
>   genl_family_rcv_msg_doit+0x1e7/0x2c0
>   ? __pfx_genl_family_rcv_msg_doit+0x10/0x10
>   ? __pfx_cred_has_capability.isra.0+0x10/0x10
>   ? stack_trace_save+0x8e/0xc0
>   genl_rcv_msg+0x411/0x660
>   ? __pfx_genl_rcv_msg+0x10/0x10
>   ? __pfx_ethnl_set_features+0x10/0x10
>   netlink_rcv_skb+0x121/0x380
>   ? __pfx_genl_rcv_msg+0x10/0x10
>   ? __pfx_netlink_rcv_skb+0x10/0x10
>   ? __pfx_down_read+0x10/0x10
>   genl_rcv+0x23/0x30
>   netlink_unicast+0x60f/0x830
>   ? __pfx_netlink_unicast+0x10/0x10
>   ? __pfx___alloc_skb+0x10/0x10
>   netlink_sendmsg+0x6ea/0xbc0
>   ? __pfx_netlink_sendmsg+0x10/0x10
>   ? __futex_queue+0x10b/0x1f0
>   ____sys_sendmsg+0x7a2/0x950
>   ? copy_msghdr_from_user+0x26b/0x430
>   ? __pfx_____sys_sendmsg+0x10/0x10
>   ? __pfx_copy_msghdr_from_user+0x10/0x10
>   ___sys_sendmsg+0xf8/0x180
>   ? __pfx____sys_sendmsg+0x10/0x10
>   ? __pfx_futex_wait+0x10/0x10
>   ? fdget+0x2e4/0x4a0
>   __sys_sendmsg+0x11f/0x1c0
>   ? __pfx___sys_sendmsg+0x10/0x10
>   do_syscall_64+0xe2/0x570
>   ? exc_page_fault+0x66/0xb0
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
> 
> This fix may be combined with another one in the ethtool subsystem:
> https://lore.kernel.org/all/20260322075917.254874-1-alex.popov@linux.com/T/#u
> 
> Fixes: d43c65b05b848e0b ("ethtool: runtime-resume netdev parent in ethnl_ops_begin")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> ---
>  drivers/net/wireless/virtual/virt_wifi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/virtual/virt_wifi.c b/drivers/net/wireless/virtual/virt_wifi.c
> index 885dc7243e8d..97bd39d89e98 100644
> --- a/drivers/net/wireless/virtual/virt_wifi.c
> +++ b/drivers/net/wireless/virtual/virt_wifi.c
> @@ -557,7 +557,6 @@ static int virt_wifi_newlink(struct net_device *dev,
>  	eth_hw_addr_inherit(dev, priv->lowerdev);
>  	netif_stacked_transfer_operstate(priv->lowerdev, dev);
>  
> -	SET_NETDEV_DEV(dev, &priv->lowerdev->dev);
>  	dev->ieee80211_ptr = kzalloc_obj(*dev->ieee80211_ptr);
>  
>  	if (!dev->ieee80211_ptr) {
> -- 
> 2.53.0

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
