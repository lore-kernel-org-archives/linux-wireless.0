Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:9588 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755013AbXEJQg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 12:36:57 -0400
Message-ID: <46434596.6010908@linux.intel.com>
Date: Thu, 10 May 2007 09:17:26 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz>
In-Reply-To: <20070510132756.2ca660a0@midnight.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Wed, 09 May 2007 16:05:50 -0700 James Ketrenos wrote:
>> ieee80211_init_rate_ctrl_alg is the only function that can select the
>> rate control algorithm by name, and that symbol is not set as
>> EXPORT_SYMBOL.
> 
> That's true and it's not going to be exported.
>
>> Adding EXPORT_SYMBOL for ieee80211_init_rate_ctrl_alg would allow the
>> driver to request the algorithm known to work best with that hardware. 
> 
> A driver is not supposed to set rate control. Under no circumstances.

Algorithms which can take advantage of features exposed by specific hardware will be able to perform better than pure software solutions when you account for system latency, throughput, power consumption, etc. 

> If you know about a bug in default rate control algorithm, fix it and
> send a patch. 

AFAIK, the default rate control algorithm is fine for software only solutions that don't take advantage of any driver specific capabilities.

> Otherwise, fix your driver.

The driver isn't broken.

We've written an open source rate control algorithm that can take advantage of features our hardware has, that our users, testing, research, and development has shown to be advantageous in terms of solid performance, system overhead, power consumption, etc.

We want to be able to use that rate control algorithm with our driver.

>> we can change ieee80211_register_hw() to take a 'name' parameter
>> specifying the rate control algorithm to use.  Drivers that don't care
>> can pass NULL and the stack will do what it does now (pick the first
>> algorithm registered with the stack)
> 
> NACK.
> 
>> Preference?
> 
> Write a patch for nl80211/cfg80211.

nl80211/cfg80211 isn't broken.  mac80211's inability to let the driver specify the rate control algorithm is.  I proposed two solutions, both of which are simple, clean, and add zero complexity to the stack.

Below is the patch for changing the API.  I can submit as a two part series (one to change the API, and the second to update all in-tree drivers to use it) if you'd rather.  Simply exporting ieee80211_init_rate_ctrl_alg requires no API changes, but anyway...

James

[PATCH] mac80211: Add rate algorithm selection to ieee80211_register_hw

There may be a hardware specific rate control algorithm a driver wishes
to use.  Currently, however, the stack assigns the first loaded 
algorithm to all drivers calling ieee80211_register_hw.

This commit simply adds an optional rate control algorithm name
parameter to ieeee80211_register_hw.

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
 include/net/mac80211.h   |    8 ++++++--
 net/mac80211/ieee80211.c |    9 +++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ef9b613..5e30890 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -750,8 +750,12 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 /* Register hardware device to the IEEE 802.11 code and kernel. Low-level
  * drivers must call this function before using any other IEEE 802.11
- * function except ieee80211_register_hwmode. */
-int ieee80211_register_hw(struct ieee80211_hw *hw);
+ * function except ieee80211_register_hwmode. 
+ *
+ * rc_name specifies the rate control algorithm name.  If NULL the stack 
+ * will assign a rate control algorithm based on the order in which the
+ * algorithms were registered with the stack. */
+int ieee80211_register_hw(struct ieee80211_hw *hw, const char *rc_name);
 
 /* driver can use this and ieee80211_get_rx_led_name to get the
  * name of the registered LEDs after ieee80211_register_hw
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 823a7ba..988a266 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4828,7 +4828,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
 
-int ieee80211_register_hw(struct ieee80211_hw *hw)
+int ieee80211_register_hw(struct ieee80211_hw *hw, const char *rc_name)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	const char *name;
@@ -4876,10 +4876,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 
-	result = ieee80211_init_rate_ctrl_alg(local, NULL);
+	result = ieee80211_init_rate_ctrl_alg(local, rc_name);
 	if (result < 0) {
-		printk(KERN_DEBUG "%s: Failed to initialize rate control "
-		       "algorithm\n", local->mdev->name);
+		printk(KERN_DEBUG "%s: Failed to initialize %s rate control "
+		       "algorithm\n", local->mdev->name, 
+			rc_name ? rc_name : "default");
 		goto fail_rate;
 	}
 
-- 
1.5.1.3
