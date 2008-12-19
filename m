Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52943
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbYLSDhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 22:37:02 -0500
Date: Thu, 18 Dec 2008 19:37:03 -0800 (PST)
Message-Id: <20081218.193703.92433900.davem@davemloft.net> (sfid-20081219_043709_000698_2E710B63)
To: wangchen@cn.fujitsu.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jgarzik@pobox.com, netdev@vger.kernel.org
Subject: Re: [PATCH -next] netdevice zd1201: Use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <4949F36B.7080707@cn.fujitsu.com>
References: <20081031182207.GD4310@tuxdriver.com>
	<1225478896-28987-1-git-send-email-linville@tuxdriver.com>
	<4949F36B.7080707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wang Chen <wangchen@cn.fujitsu.com>
Date: Thu, 18 Dec 2008 14:53:31 +0800

> | commit 3d29b0c33d431ecc69ec778f8c236d382f59a85f
> | Author: John W. Linville <linville@tuxdriver.com>
> | Date:   Fri Oct 31 14:13:12 2008 -0400
> | 
> |     netdevice zd1201: Convert directly reference of netdev->priv to netdev_priv()
 ...
> 
> This commit changed the allocation of netdev, but didn't change
> the free method of it.
> This causes "zd" be used after the memory, which is pointed by "zd", being
> freed by free_netdev().
> 
> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>

Patch applied to net-next-2.6, thanks!
