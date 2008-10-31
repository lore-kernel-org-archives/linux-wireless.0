Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44246 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYJaSxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:53:38 -0400
Date: Fri, 31 Oct 2008 14:22:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	NETDEV <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/18] netdevice zd1201: Convert directly reference of
	netdev->priv to netdev->ml_priv
Message-ID: <20081031182207.GD4310@tuxdriver.com> (sfid-20081031_195342_478105_13C5BFB0)
References: <48C0A219.2030004@cn.fujitsu.com> <48C0A7A0.9030200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48C0A7A0.9030200@cn.fujitsu.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 05, 2008 at 11:29:36AM +0800, Wang Chen wrote:
> We have some reasons to kill netdev->priv:
> 1. netdev->priv is equal to netdev_priv().
> 2. netdev_priv() wraps the calculation of netdev->priv's offset, obviously
>    netdev_priv() is more flexible than netdev->priv.
> But we cann't kill netdev->priv, because so many drivers reference to it
> directly.
> 
> OK, becasue Dave S. Miller said, "every direct netdev->priv usage is a bug",
> and I want to kill netdev->priv later, I decided to convert all the direct
> reference of netdev->priv first.
> 
> Different to readonly reference of netdev->priv, in this driver, netdev->priv
> was changed. I use netdev->ml_priv to replace netdev->priv.
> 
> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>

I don't think this is the right approach for this driver.  Alternative
patch to follow...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
