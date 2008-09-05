Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYIERGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 13:06:16 -0400
Subject: Re: [PATCH 14/18] netdevice airo: Convert directly reference of
	netdev->priv to netdev->ml_priv
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	NETDEV <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20080905125036.GA3027@tuxdriver.com>
References: <48C0A219.2030004@cn.fujitsu.com>
	 <48C0A72B.9050407@cn.fujitsu.com>  <20080905125036.GA3027@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 13:06:23 -0400
Message-Id: <1220634383.6430.14.camel@localhost.localdomain> (sfid-20080905_190622_411347_46D8DCFB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-05 at 08:50 -0400, John W. Linville wrote:
> On Fri, Sep 05, 2008 at 11:27:39AM +0800, Wang Chen wrote:
> > We have some reasons to kill netdev->priv:
> > 1. netdev->priv is equal to netdev_priv().
> > 2. netdev_priv() wraps the calculation of netdev->priv's offset, obviously
> >    netdev_priv() is more flexible than netdev->priv.
> > But we cann't kill netdev->priv, because so many drivers reference to it
> > directly.
> > 
> > OK, becasue Dave S. Miller said, "every direct netdev->priv usage is a bug",
> > and I want to kill netdev->priv later, I decided to convert all the direct
> > reference of netdev->priv first.
> > 
> > Different to readonly reference of netdev->priv, in this driver, netdev->priv
> > was changed. I use netdev->ml_priv to replace netdev->priv.
> > 
> > Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
> 
> Thank you for your patch.  However, I do not understand why you didn't
> simply replace netdev->priv with netdev_priv()?  Can you explain?

Yeah, that would have been my first choice too...

Dan

