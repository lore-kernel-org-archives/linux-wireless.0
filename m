Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:37643 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab2HGHSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 03:18:45 -0400
Message-ID: <5020BF4F.2090304@posedge.com> (sfid-20120807_091900_916311_F7A0B90E)
Date: Tue, 07 Aug 2012 12:40:07 +0530
From: Srinivasan B <srinivasanb@posedge.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] cfg80211: Fix for crash in cfg80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch Description:
                     cfg80211 module crashes when cfg80211 & mac80211 
loaded and unloading lmac driver.

Scenario Explanation:
                     (Step 1) : cfg80211, mac80211 and lmac driver 
modules are loaded initially.
                     (Step 2) : unload the lmac driver.
                                     then any dev calls to stack causes 
the crash.
Code Changes:
                     dev->ethtools_ops is assigned during 
NETDEV_REGISTER and the same can be cleared during NETDEV_UNREGISTER.

Signed-off-by: Srinivasan Chandrasekaran <srinivasb@posedge.com>
---

diff --git a/net/wireless/core.c b/net/wireless/core.c
index dcd64d5..74bb7c4 100755
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -944,6 +944,10 @@ static int cfg80211_netdev_notifier_call(struct 
notifier_block *nb,
  #endif
          }
          mutex_unlock(&rdev->devlist_mtx);
+
+        if (dev->ethtool_ops)
+            dev->ethtool_ops = NULL;
+
          /*
           * synchronise (so that we won't find this netdev
           * from other code any more) and then clear the list
