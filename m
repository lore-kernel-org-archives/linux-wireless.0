Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40418
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbYBSAt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 19:49:59 -0500
Date: Mon, 18 Feb 2008 16:50:36 -0800 (PST)
Message-Id: <20080218.165036.218650084.davem@davemloft.net> (sfid-20080219_005004_769553_BC883250)
To: kaber@trash.net
Cc: joe@perches.com, bruno@thinktube.com, netdev@vger.kernel.org,
	jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] net/8021q/vlan_dev.c - Use print_mac
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080218.164305.67586867.davem@davemloft.net>
References: <20080218.125525.192686382.davem@davemloft.net>
	<47B9F5E7.3020905@trash.net>
	<20080218.164305.67586867.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Mon, 18 Feb 2008 16:43:05 -0800 (PST)

> I think we can fix this easily by using __attribute_const_
> on the print_mac() declaration.  Let me play with that.

Actually it seems the 'pure' attribute is more important
here.  Although it's not semantically a perfect match,
what we need to tell the compiler is basically that:

1) the return value depends upon the inputs
2) if the input is not used, it's safe to avoid the call

and 'pure' accomplishes that without any unwanted side-effects.

I think this will not result in any unwanted over-optimization.
Because if the inputs change in any way GCC has to emit the
call.

Any objections?

commit 8f789c48448aed74fe1c07af76de8f04adacec7d
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Feb 18 16:50:22 2008 -0800

    [NET]: Elminate spurious print_mac() calls.
    
    Patrick McHardy notes that print_mac() can get invoked
    even if the result it unused (f.e. as an argument to
    pr_debug() when DEBUG is not defined).
    
    Mark this function as "__pure" to eliminate this problem.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index 7a1e011..42dc6a3 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -129,7 +129,7 @@ extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len);
 /*
  *	Display a 6 byte device address (MAC) in a readable format.
  */
-extern char *print_mac(char *buf, const unsigned char *addr);
+extern __pure char *print_mac(char *buf, const unsigned char *addr);
 #define MAC_BUF_SIZE	18
 #define DECLARE_MAC_BUF(var) char var[MAC_BUF_SIZE] __maybe_unused
 
