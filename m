Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s31.bay0.hotmail.com ([65.54.246.231]:30713 "EHLO
	bay0-omc3-s31.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbYK1GIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 01:08:21 -0500
Message-ID: <BAY104-DAV12C684E461A14C31A996999040@phx.gbl> (sfid-20081128_070823_496875_94C2D125)
Message-ID: <492F8ACA.5080606@hotmail.com>
Date: Fri, 28 Nov 2008 17:08:10 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: use unaligned safe memcmp() in-place of compare_ether_addr()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After fixing zd1211rw: use unaligned safe memcmp() in-place of
compare_ether_addr(), I started to see kernel log messages detailing
unaligned access:

  Kernel unaligned access at TPC[100f7f44] sta_info_get+0x24/0x68 [mac80211]

As with the aforementioned patch, the unaligned access was eminating
from a compare_ether_addr() call. Concerned that whilst it was safe to
assume that unalignment was the norm for the zd1211rw, and take
preventative measures, it may not be the case or acceptable to use the
easy fix of changing the call to memcmp().

My research however indicated that it was OK to do this, as there are
a few instances where memcmp() is the preferred mechanism for doing
mac address comparisons throughout the module.

Signed-off-by: Shaddy Baddah <shaddy_baddah@hotmail.com>

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7fef8ea..d254446 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -99,7 +99,7 @@ struct sta_info *sta_info_get(struct ieee80211_local 
*local, const u8 *addr)
 
     sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
     while (sta) {
-        if (compare_ether_addr(sta->sta.addr, addr) == 0)
+        if (memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
             break;
         sta = rcu_dereference(sta->hnext);
     }


