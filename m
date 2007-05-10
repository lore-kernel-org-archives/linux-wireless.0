Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:57957 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962AbXEJSFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 14:05:48 -0400
Message-ID: <46437446.6030302@linux.intel.com>
Date: Thu, 10 May 2007 12:36:38 -0700
From: jketreno <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com>	 <20070510132756.2ca660a0@midnight.suse.cz>	 <46434596.6010908@linux.intel.com> <1178817104.3806.33.camel@johannes.berg>
In-Reply-To: <1178817104.3806.33.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-05-10 at 09:17 -0700, James Ketrenos wrote:
> 
>> This commit simply adds an optional rate control algorithm name
>> parameter to ieeee80211_register_hw.
> 
> Why don't we just add a char *preferred_rate_control; to the hw
> definition structure instead? That way, we can even show it in
> sys/debugfs later so the user will still know what the driver preferred
> after changing it.
> 
> johannes

How's this?


[PATCH] mac80211: Add preferred_rate_control to ieee80211_hw

There may be a hardware specific rate control algorithm a driver wishes
to use.  Currently, however, the stack assigns the first loaded
algorithm to all drivers calling ieee80211_register_hw.

This commit simply adds an preferred_rate_control to ieee80211_hw and
updates ieee80211_register_hw to use it.

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
 include/net/mac80211.h   |    4 ++++
 net/mac80211/ieee80211.c |   10 +++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ef9b613..f9ad839 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -533,6 +533,10 @@ struct ieee80211_hw {
 	/* Number of available hardware TX queues for data packets.
 	 * WMM requires at least four queues. */
 	int queues;
+
+	/* Preferred rate control algorithm. Leave as NULL for stack
+	 * to select algorithm */
+	char *preferred_rate_control;
 };
 
 static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev)
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 873ccb0..6dcc002 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4875,10 +4875,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 
-	result = ieee80211_init_rate_ctrl_alg(local, NULL);
+	result = ieee80211_init_rate_ctrl_alg(local, 
+					      hw->preferred_rate_control);
+
 	if (result < 0) {
-		printk(KERN_DEBUG "%s: Failed to initialize rate control "
-		       "algorithm\n", local->mdev->name);
+		printk(KERN_DEBUG "%s: Failed to initialize %s rate control "
+		       "algorithm\n", local->mdev->name,
+		       hw->preferred_rate_control ? 
+		       hw->preferred_rate_control : "default");
 		goto fail_rate;
 	}
 
-- 
1.5.1.3
