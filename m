Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48727
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbYBSDWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 22:22:55 -0500
Date: Mon, 18 Feb 2008 19:23:32 -0800 (PST)
Message-Id: <20080218.192332.174070490.davem@davemloft.net> (sfid-20080219_032301_627228_9BB59909)
To: joe@perches.com
Cc: kaber@trash.net, bruno@thinktube.com, netdev@vger.kernel.org,
	jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
From: David Miller <davem@davemloft.net>
In-Reply-To: <1203383012.7181.102.camel@localhost>
References: <20080218.164305.67586867.davem@davemloft.net>
	<20080218.165036.218650084.davem@davemloft.net>
	<1203383012.7181.102.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Mon, 18 Feb 2008 17:03:32 -0800

> Does this need to be done for all function calls
> declared with __attribute__((format(printf, x, y)))
> {
> return 0;
> }
> 
> ie: pr_debug, dev_dbg, dev_vdbg?

No, I don't think so.

We're adding the tag to teach the compiler that if the
return value isn't used, it is OK not to emit the call
altogether.
