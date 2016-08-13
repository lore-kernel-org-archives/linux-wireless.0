Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:57078 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbcHMEFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2016 00:05:42 -0400
Date: Fri, 12 Aug 2016 21:05:40 -0700 (PDT)
Message-Id: <20160812.210540.1388657411138322854.davem@davemloft.net> (sfid-20160813_060545_531632_E40574AB)
To: joe@perches.com
Cc: pgynther@google.com, linux-wireless@vger.kernel.org,
	kvalo@codeaurora.org, akarwar@marvell.com
Subject: Re: [PATCH] Modify is_zero_ether_addr() to handle byte-aligned
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1471060827.3467.5.camel@perches.com>
References: <1471047330-8153-1-git-send-email-pgynther@google.com>
	<20160812.202613.197744153887748230.davem@davemloft.net>
	<1471060827.3467.5.camel@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Fri, 12 Aug 2016 21:00:27 -0700

> One solution might be to copy a hardware interface structure
> to another struct with appropriate alignment.

Right, especially if this is a slow path that would be an appropriate
way to handle this.
