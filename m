Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35193 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaTbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 15:31:05 -0400
Date: Fri, 31 Oct 2008 15:17:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	NETDEV <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/18] netdevice libertas: Fix directly reference of
	netdev->priv
Message-ID: <20081031191711.GE4310@tuxdriver.com> (sfid-20081031_203116_956333_AA1CDD27)
References: <48C0A219.2030004@cn.fujitsu.com> <48C0A76F.8090706@cn.fujitsu.com> <1220634465.6430.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220634465.6430.16.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 05, 2008 at 01:07:45PM -0400, Dan Williams wrote:
> On Fri, 2008-09-05 at 11:28 +0800, Wang Chen wrote:
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
> 
> Same comment as the other two; any reason we can't use netdev_priv()
> instead of ->ml_priv?  That would be preferable.

Actually, I think this one was OK -- the two ml_priv uses were for
the extra mesh and rtap devices, which point back to the already
allocated priv data for the main device.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
