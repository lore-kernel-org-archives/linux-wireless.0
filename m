Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbYBSAm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 19:42:28 -0500
Date: Mon, 18 Feb 2008 16:43:05 -0800 (PST)
Message-Id: <20080218.164305.67586867.davem@davemloft.net> (sfid-20080219_004233_575488_E6BF3902)
To: kaber@trash.net
Cc: joe@perches.com, bruno@thinktube.com, netdev@vger.kernel.org,
	jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
From: David Miller <davem@davemloft.net>
In-Reply-To: <47B9F5E7.3020905@trash.net>
References: <47B9A20C.10304@trash.net>
	<20080218.125525.192686382.davem@davemloft.net>
	<47B9F5E7.3020905@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Feb 2008 22:17:27 +0100

> The way pr_debug is implemented it still results in two function
> calls per packet since the compiler doesn't know that it doesn't
> have visible side-effects besides modifying the (unused) buffer.
> I confirmed this using codiff.

That's a bug.

I think we can fix this easily by using __attribute_const_
on the print_mac() declaration.  Let me play with that.
