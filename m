Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbaJIM1z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 08:27:55 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211-hwsim: Add support for HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
Date: Thu,  9 Oct 2014 15:27:51 +0300
Message-Id: <1412857671-23273-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141009_142758_740231_0962183D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for new attribute HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
which can be set by the user space component. The attribute
will cause the kernel to destroy all those radios that were
created by a process if that process dies. The old behaviour
i.e., radios are persistent is still the default.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
Hi,

v2:
- embed the work_struct into mac80211_hwsim_data which makes
  the code simpler

Cheers,
Jukka

 drivers/net/wireless/mac80211_hwsim.c | 40 ++++++++++++++++++++++++++++++++---
 drivers/net/wireless/mac80211_hwsim.h |  3 +++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index babbdc1..e95ae0a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -412,6 +412,9 @@ struct mac80211_hwsim_data {
 	struct mac_address addresses[2];
 	int channels, idx;
 	bool use_chanctx;
+	bool destroy_on_close;
+	struct work_struct destroy_work;
+	u32 portid;
 
 	struct ieee80211_channel *tmp_chan;
 	struct delayed_work roc_done;
@@ -496,6 +499,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_REG_CUSTOM_REG] = { .type = NLA_U32 },
 	[HWSIM_ATTR_REG_STRICT_REG] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_SUPPORT_P2P_DEVICE] = { .type = NLA_FLAG },
+	[HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE] = { .type = NLA_FLAG },
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -1946,7 +1950,8 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx)
+				       bool use_chanctx, bool destroy_on_close,
+				       u32 portid)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2006,6 +2011,8 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	data->channels = channels;
 	data->use_chanctx = use_chanctx;
 	data->idx = idx;
+	data->destroy_on_close = destroy_on_close;
+	data->portid = portid;
 
 	if (data->use_chanctx) {
 		hw->wiphy->max_scan_ssids = 255;
@@ -2434,6 +2441,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	const struct ieee80211_regdomain *regd = NULL;
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
+	bool destroy_on_close = info->attrs[HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE];
 	bool use_chanctx;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
@@ -2456,7 +2464,8 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx);
+					   p2p_device, use_chanctx,
+					   destroy_on_close, info->snd_portid);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2514,6 +2523,29 @@ static const struct genl_ops hwsim_ops[] = {
 	},
 };
 
+static void destroy_radio(struct work_struct *work)
+{
+	struct mac80211_hwsim_data *data =
+		container_of(work, struct mac80211_hwsim_data, destroy_work);
+
+	mac80211_hwsim_destroy_radio(data);
+}
+
+static void remove_user_radios(u32 portid)
+{
+	struct mac80211_hwsim_data *entry, *tmp;
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
+		if (entry->destroy_on_close && entry->portid == portid) {
+			list_del(&entry->list);
+			INIT_WORK(&entry->destroy_work, destroy_radio);
+			schedule_work(&entry->destroy_work);
+		}
+	}
+	spin_unlock_bh(&hwsim_radio_lock);
+}
+
 static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
 					 unsigned long state,
 					 void *_notify)
@@ -2523,6 +2555,8 @@ static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
 	if (state != NETLINK_URELEASE)
 		return NOTIFY_DONE;
 
+	remove_user_radios(notify->portid);
+
 	if (notify->portid == wmediumd_portid) {
 		printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
 		       " socket, switching to perfect channel medium\n");
@@ -2676,7 +2710,7 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1);
+						  channels > 1, false, 0);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index c9d0315..b96d867 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -111,6 +111,8 @@ enum {
  * @HWSIM_ATTR_USE_CHANCTX: used with the %HWSIM_CMD_CREATE_RADIO
  *	command to force use of channel contexts even when only a
  *	single channel is supported
+ * @HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE: used with the %HWSIM_CMD_CREATE_RADIO
+ *	command to force radio removal when process that created the radio dies
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -132,6 +134,7 @@ enum {
 	HWSIM_ATTR_REG_STRICT_REG,
 	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
 	HWSIM_ATTR_USE_CHANCTX,
+	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.8.3.1

