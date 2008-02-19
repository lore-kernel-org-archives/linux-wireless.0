Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:53648 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753042AbYBSBVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 20:21:32 -0500
Message-ID: <47BA3131.3080907@snapgear.com> (sfid-20080219_012137_467003_A49D5E06)
Date: Tue, 19 Feb 2008 11:30:25 +1000
From: Philip Craig <philipc@snapgear.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, kaber@trash.net,
	bruno@thinktube.com, netdev@vger.kernel.org, jgarzik@pobox.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
References: <20080218.125525.192686382.davem@davemloft.net>	 <47B9F5E7.3020905@trash.net> <20080218.164305.67586867.davem@davemloft.net>	 <20080218.165036.218650084.davem@davemloft.net> <1203383012.7181.102.camel@localhost>
In-Reply-To: <1203383012.7181.102.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches wrote:
> Perhaps it's more sensible to go back to
> 
> #ifdef DEBUG
> #define pr_debug(fmt, arg...) do {} while (0)
> #endif
> 
> and give up the printf argument verification

I think argument verification is important.   Can you keep it
like this:

#ifdef DEBUG
#define pr_debug(fmt, arg...) \
	do { \
		if (0) \
			printk(KERN_DEBUG fmt, ##arg); \
	} while (0)
#endif

We still lose the return value though, I'm not sure how to keep that
safely in macros.

But does anything rely on the side effects already?  This would
introduce bugs if so.

