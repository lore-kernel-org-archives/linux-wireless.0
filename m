Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3010 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYBSBEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 20:04:14 -0500
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, bruno@thinktube.com, netdev@vger.kernel.org,
	jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20080218.165036.218650084.davem@davemloft.net>
References: <20080218.125525.192686382.davem@davemloft.net>
	 <47B9F5E7.3020905@trash.net> <20080218.164305.67586867.davem@davemloft.net>
	 <20080218.165036.218650084.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 17:03:32 -0800
Message-Id: <1203383012.7181.102.camel@localhost> (sfid-20080219_010418_476618_88076289)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-18 at 16:50 -0800, David Miller wrote:
> Actually it seems the 'pure' attribute is more important
> here.  Although it's not semantically a perfect match,
> what we need to tell the compiler is basically that:
> 
> 1) the return value depends upon the inputs
> 2) if the input is not used, it's safe to avoid the call
> 
> and 'pure' accomplishes that without any unwanted side-effects.
> 
> I think this will not result in any unwanted over-optimization.
> Because if the inputs change in any way GCC has to emit the
> call.
> 
> Any objections?

Does this need to be done for all function calls
declared with __attribute__((format(printf, x, y)))
{
return 0;
}

ie: pr_debug, dev_dbg, dev_vdbg?

Perhaps it's more sensible to go back to

#ifdef DEBUG
#define pr_debug(fmt, arg...) do {} while (0)
#endif

and give up the printf argument verification

