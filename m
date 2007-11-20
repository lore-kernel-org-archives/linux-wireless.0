Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57491
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755818AbXKTLds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 06:33:48 -0500
Date: Tue, 20 Nov 2007 03:33:47 -0800 (PST)
Message-Id: <20071120.033347.197068845.davem@davemloft.net> (sfid-20071120_113353_618630_708F8EB6)
To: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org, shaddy_baddah@hotmail.com
Subject: [PATCH]: Fix WEXT userland corruption on 64-bit
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This bug affects WEXT usage on all 64-bit platforms, compat mode or
not.  It overwrites 8 bytes past the end of the userland iwreq.

I've checked the following patch into my net-2.6 tree and will queue
it up for -stable too.

Shaddy, this should fix the "encryption key is too long" iwconfig
issue.

I'll try to figure out why iwlist gets a bus error and
the zd1211rw driver generates all of those unaligned
access errors next.

commit 0a06ea87185531705e4417e3a051f81b64f210c1
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Tue Nov 20 03:29:53 2007 -0800

    [WIRELESS] WEXT: Fix userspace corruption on 64-bit.
    
    On 64-bit systems sizeof(struct ifreq) is 8 bytes larger than
    sizeof(struct iwreq).
    
    For GET calls, the wireless extension code copies back into userspace
    using sizeof(struct ifreq) but userspace and elsewhere only allocates
    a "struct iwreq".  Thus, this copy writes past the end of the iwreq
    object and corrupts whatever sits after it in memory.
    
    Fix the copy_to_user() length.
    
    This particularly hurts the compat case because the wireless compat
    code uses compat_alloc_userspace() and right after this allocated
    buffer is the current bottom of the user stack, and that's what gets
    overwritten by the copy_to_user() call.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 85e5f9d..47e80cc 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -1094,7 +1094,7 @@ int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
 	rtnl_lock();
 	ret = wireless_process_ioctl(net, ifr, cmd);
 	rtnl_unlock();
-	if (IW_IS_GET(cmd) && copy_to_user(arg, ifr, sizeof(struct ifreq)))
+	if (IW_IS_GET(cmd) && copy_to_user(arg, ifr, sizeof(struct iwreq)))
 		return -EFAULT;
 	return ret;
 }

