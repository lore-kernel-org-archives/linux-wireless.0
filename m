Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53418 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3AJH5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 02:57:39 -0500
Date: Wed, 09 Jan 2013 23:57:38 -0800 (PST)
Message-Id: <20130109.235738.467651533138068641.davem@davemloft.net> (sfid-20130110_085748_042466_4D66D1E1)
To: sgruszka@redhat.com
Cc: netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, bhutchings@solarflare.com,
	mirqus@gmail.com
Subject: Re: [PATCH v2] net: set default_ethtool_ops in register_netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130108153850.GA10464@redhat.com>
References: <20130108153850.GA10464@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Tue, 8 Jan 2013 16:38:51 +0100

> Since:
> 
> commit 2c60db037034d27f8c636403355d52872da92f81
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Sun Sep 16 09:17:26 2012 +0000
> 
>     net: provide a default dev->ethtool_ops
> 
> wireless core does not correctly assign ethtool_ops. In order to fix
> the problem, move assignement of default_ethtool_ops to
> register_netdevice(). This is safe because both register_netdevice()
> and dev_ethtool() are protected by RTNL lock.
> 
> Patch is besed on hint of Micha©© Miros©©aw.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: stable@vger.kernel.org # 3.7+
> ---
> v1 -> v2: change order of default_ethtool_ops initialization to avoid
> the problem. Change the subject accordingly.

I don't understand this.  Why is the assignment of default_ethtool_ops
at netdev allocation time not working?  Is wireless really not using
alloc_netdev*()?
