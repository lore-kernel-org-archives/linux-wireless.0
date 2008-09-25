Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYIYPsp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 11:48:45 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, hmh@hmh.eng.br
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Date: Thu, 25 Sep 2008 18:48:39 +0300
Message-Id: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com> (sfid-20080925_174849_864347_2A53EC09)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Currently mac80211 is not notified about rfill state of low level driver
and doesn't now when it's disconnected and when to restart connection
There also there is conflict or no synchronization between 'wext txpower
disable' and rfkill events coming from rfkill subsystem

This patch is just a sketch of possible solution, it probably even doesn't
compile

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/main.c |   34 ++++++++++++++++++++++++++++++++++
 net/mac80211/wext.c |   18 +++++++++++++++---
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d608c44..df2dd7d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -21,6 +21,7 @@
 #include <linux/wireless.h>
 #include <linux/rtnetlink.h>
 #include <linux/bitmap.h>
+#include <linux/rfkill.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 
@@ -704,6 +705,33 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
+static int ieee80211_rfkill_notifier(struct notifier_block *nb, unsigned long eventid,
+					void *data)
+{
+	struct rfkill *rfkill = (struct rfkill *)data;
+	struct ieee80211_hw *hw = rfkill->data;
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	switch (eventid) {
+	case RFKILL_STATE_CHANGED:
+		hw->conf.radio_enabled =
+			(rfkill->state == RFKILL_STATE_UNBLOCKED);
+		printk(KERN_DEBUG "%s %d RADIO %d\n", __func__, __LINE__, hw->conf.radio_enabled);
+		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
+		ieee80211_hw_config(local);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+struct notifier_block ieee80211_rfkill_notifier_nb = {
+	.notifier_call	= ieee80211_rfkill_notifier,
+	.priority	= 0,
+};
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -932,6 +960,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	ieee80211_led_init(local);
 
+	if (local->hw.rfkill)
+		register_rfkill_notifier(&ieee80211_rfkill_notifier_nb);
+
 	return 0;
 
 fail_wep:
@@ -961,6 +992,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
+	if (local->hw.rfkill)
+		unregister_rfkill_notifier(&ieee80211_rfkill_notifier_nb);
+
 	rtnl_lock();
 
 	/*
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 7e0d53a..6b96edf 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -16,6 +16,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
+#include <linux/rfkill.h>
 #include <net/iw_handler.h>
 #include <asm/uaccess.h>
 
@@ -684,9 +685,20 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 	}
 
 	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
-		local->hw.conf.radio_enabled = !(data->txpower.disabled);
-		need_reconfig = 1;
-		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
+		if (!local->hw.rfkill) {
+			local->hw.conf.radio_enabled = !(data->txpower.disabled);
+			need_reconfig = 1;
+			ieee80211_led_radio(local, local->hw.conf.radio_enabled);
+		} else {
+			if (data->txpower.disabled)
+				rfkill_force_state(local->hw.rfkill,
+					RFKILL_STATE_SOFT_BLOCKED);
+			else
+				/* XXXX: do we make sure there is no HW RFKILL? */
+				rfkill_force_state(local->hw.rfkill,
+					RFKILL_STATE_UNBLOCKED);
+		}
+		return 0;
 	}
 
 	if (need_reconfig) {
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

