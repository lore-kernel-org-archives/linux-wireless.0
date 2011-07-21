Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50569 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1GUW1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 18:27:06 -0400
Date: Thu, 21 Jul 2011 15:25:59 -0700 (PDT)
Message-Id: <20110721.152559.855176188727471095.davem@davemloft.net> (sfid-20110722_002716_718959_06F4FDF2)
To: bhutchings@solarflare.com
Cc: linville@tuxdriver.com, kvalo@qca.qualcomm.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-2.6] ethtool: Allow zero-length register dumps again
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311270840.28569.34.camel@localhost>
References: <20110720143611.GA18231@tuxdriver.com>
	<1311270409.28569.32.camel@localhost>
	<1311270840.28569.34.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 21 Jul 2011 19:54:00 +0200

> Some drivers (ab)use the ethtool_ops::get_regs operation to expose
> only a hardware revision ID.  Commit
> a77f5db361ed9953b5b749353ea2c7fed2bf8d93 ('ethtool: Allocate register
> dump buffer with vmalloc()') had the side-effect of breaking these, as
> vmalloc() returns a null pointer for size=0 whereas kmalloc() did not.
> 
> For backward-compatibility, allow zero-length dumps again.
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> Cc: stable@kernel.org [2.6.37+]

Applied to net-next-2.6, I left the CC: stable tag in there so
-stable will pick it up once it hits Linus's tree during the
merge window.

Thanks.
