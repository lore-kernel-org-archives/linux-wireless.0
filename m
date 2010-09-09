Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41293 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0IIWDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 18:03:41 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o89M3ejF027934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 9 Sep 2010 15:03:40 -0700
Message-ID: <4C8959BC.7040501@candelatech.com>
Date: Thu, 09 Sep 2010 15:03:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RFC:  Allow multiple STA connected to same AP.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the patch below against latest wireless-testing, I can create two
STA on the same ath9k phy0 and have them send traffic to each other.
I tested only un-encrypted STAs at this point.

It seems the tx logic hangs after a bit, so there are still issues, but
I'm not sure if that is something introduced by my patch or some
existing ath9k bug.

Please let me know if this is a viable approach.

Thanks,
Ben


diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4935b84..21401c9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -44,6 +44,8 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
         u64 mc;
         unsigned int changed_flags;
         unsigned int new_flags = 0;
+       int avifs = 0;
+       struct ieee80211_sub_if_data *sdata;

         if (atomic_read(&local->iff_promiscs))
                 new_flags |= FIF_PROMISC_IN_BSS;
@@ -78,6 +80,22 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
         /* be a bit nasty */
         new_flags |= (1<<31);

+       /* If we have more than one virtual station, turn on PROMISC_IN_BSS
+        *  --Ben
+        */
+       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+               if (!sdata->dev || !netif_running(sdata->dev))
+                       continue;
+
+               if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+                       avifs++;
+                       if (avifs > 1)
+                               break;
+               }
+       }
+       if (avifs > 1)
+               new_flags |= FIF_PROMISC_IN_BSS;
+
         drv_configure_filter(local, changed_flags, &new_flags, mc);

         WARN_ON(new_flags & (1<<31));
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 687077e..db751f1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)

         spin_lock_irqsave(&local->sta_lock, flags);
         /* check if STA exists already */
-       if (sta_info_get_bss(sdata, sta->sta.addr)) {
+       if (sta_info_get(sdata, sta->sta.addr)) {
                 spin_unlock_irqrestore(&local->sta_lock, flags);
                 mutex_unlock(&local->sta_mtx);
                 rcu_read_lock();

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

