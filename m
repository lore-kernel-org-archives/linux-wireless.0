Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60156
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbXISVZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:31 -0400
Date: Wed, 19 Sep 2007 14:25:29 -0700 (PDT)
Message-Id: <20070919.142529.03110023.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, gregkh@suse.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb-users@lists.sourceforge.net, zambrano@broadcom.com,
	mb@bu3sch.de
Subject: Re: Please pull 'ssb-drivers' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070919204428.GE5483@tuxdriver.com>
References: <20070919204428.GE5483@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 19 Sep 2007 16:44:28 -0400

> Jeff, Greg, Gary, and Dave,
> 
> These patches build upon the SSB bus support added to net-2.6.24 to
> support the b43 wireless driver.  Since Dave has that support in his
> tree, I'm asking him to merge these patches as well.
> 
> The first patch changes b44 from being a PCI (i.e. SSB-in-drag)
> device to being a native SSB device.  This has little effect one
> way or the other for laptop/desktop/server machines.  But, some
> embedded devices have b44 hardware but no PCI bus (i.e. just SSB).
> This patch enables the use of the b44 driver on that hardware.
> 
> The second patch adds a driver for a USB OHCI device which lives on
> the SSB bus.  Again, this is found on a number of SoC devices used
> especially in wireless routers and APs.
> 
> Thanks for reviewing/ACKing/merging!

I've merged the B44 driver conversion into my tree.

I'll let Greg take in the OHCI thing.  I would suggest that he
queue it up, and then once I get the net-2.6.24 tree into the
merge window (which contains the SSB stack) he can push the
OHCI change in afterwards.
