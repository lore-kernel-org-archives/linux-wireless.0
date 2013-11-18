Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3KRUSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 15:18:01 -0500
Date: Mon, 18 Nov 2013 15:17:56 -0500 (EST)
Message-Id: <20131118.151756.1326189931009402407.davem@davemloft.net> (sfid-20131118_211817_303044_0305B35F)
To: govindarajulu90@gmail.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
	samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
	isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
	ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
	jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com,
	joe@perches.com, apw@canonical.com
Subject: Re: [PATCH net-next 02/13] driver: net: remove unnecessary skb
 NULL check before calling dev_kfree_skb_irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.03.1311190055150.10646@gmail.com>
References: <20131104.151230.1978898006990867916.davem@davemloft.net>
	<alpine.LNX.2.03.1311111537020.2363@cisco.com>
	<alpine.LNX.2.03.1311190055150.10646@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Date: Tue, 19 Nov 2013 00:56:48 +0530 (IST)

> Did you have a chance to look at this? Let me know how you want me to
> fix this.

I said clearly that I don't want this change to be made, because in many
cases the "= NULL" assignment in the driver is desirable to elide when it
isn't necessary because the value is already NULL.  Therefore the NULL
check in dev_kfree_skb_irq() is basically coming for free.

Yes there are other cases, but it really doesn't matter enough to justify
your change.

Thanks.
