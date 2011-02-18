Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54006 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1BRVOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:14:00 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 15/15] staging: ath6kl: Fixing disappearing of scan list due to jiffies wrap over
Date: Fri, 18 Feb 2011 13:13:16 -0800
Message-ID: <1298063596-2096-15-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When jiffies wrap-over, all the BSS in the cache is removed. Wrap-over of
jiffies is not handled in the correct way. This cause the scan list to go
empty during this time for a small duration

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    2 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index eb09d43..1957de0 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -121,7 +121,7 @@ typedef spinlock_t                      A_MUTEX_T;
 
 /* Get current time in ms adding a constant offset (in ms) */
 #define A_GET_MS(offset)    \
-	(jiffies + ((offset) / 1000) * HZ)
+	(((jiffies / HZ) * 1000) + (offset))
 
 /*
  * Timer Functions
diff --git a/drivers/staging/ath6kl/wlan/src/wlan_node.c b/drivers/staging/ath6kl/wlan/src/wlan_node.c
index 996b36d..d61cb6e 100644
--- a/drivers/staging/ath6kl/wlan/src/wlan_node.c
+++ b/drivers/staging/ath6kl/wlan/src/wlan_node.c
@@ -122,7 +122,7 @@ wlan_setup_node(struct ieee80211_node_table *nt, bss_t *ni,
 
     timeoutValue = nt->nt_nodeAge;
 
-    ni->ni_tstamp = A_GET_MS (timeoutValue);
+    ni->ni_tstamp = A_GET_MS (0);
     ni->ni_actcnt = WLAN_NODE_INACT_CNT;
 
     IEEE80211_NODE_LOCK_BH(nt);
@@ -360,7 +360,7 @@ wlan_refresh_inactive_nodes (struct ieee80211_node_table *nt)
         if (A_MEMCMP(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
         {
 
-            if (bss->ni_tstamp <= now || --bss->ni_actcnt == 0)
+            if (((now - bss->ni_tstamp) > timeoutValue)  || --bss->ni_actcnt == 0)
             {
                /*
                 * free up all but the current bss - if set
@@ -381,6 +381,7 @@ wlan_node_timeout (A_ATH_TIMER arg)
     bss_t *bss, *nextBss;
     u8 myBssid[IEEE80211_ADDR_LEN], reArmTimer = false;
     u32 timeoutValue = 0;
+    u32 now = A_GET_MS(0);
 
     timeoutValue = nt->nt_nodeAge;
 
@@ -393,7 +394,7 @@ wlan_node_timeout (A_ATH_TIMER arg)
         if (A_MEMCMP(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
         {
 
-            if (bss->ni_tstamp <= A_GET_MS(0))
+            if ((now - bss->ni_tstamp) > timeoutValue)
             {
                /*
                 * free up all but the current bss - if set
-- 
1.6.3.3

