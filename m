Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57323 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYKZKep (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 05:34:45 -0500
Date: Wed, 26 Nov 2008 12:34:27 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Add frequency configuration (including HT40)
Message-ID: <20081126103427.GA2007@jm.kir.nu> (sfid-20081126_113451_002722_8F3DE5F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new NL80211_CMD_SET_WIPHY attributes
NL80211_ATTR_WIPHY_FREQ and NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET to allow
userspace to set the operating channel (e.g., hostapd for AP mode).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2008-11-26 09:28:51.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2008-11-26 09:36:01.000000000 +0200
@@ -26,8 +26,9 @@
  * @NL80211_CMD_GET_WIPHY: request information about a wiphy or dump request
  *	to get a list of all present wiphys.
  * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIPHY or
- *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME
- *	and/or %NL80211_ATTR_WIPHY_TXQ_PARAMS.
+ *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME,
+ *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ, and/or
+ *	%NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET.
  * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
  *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
  *	%NL80211_ATTR_WIPHY_NAME.
@@ -180,6 +181,12 @@
  *	/sys/class/ieee80211/<phyname>/index
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
  * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
+ * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
+ * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
+ *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
+ *	NL80211_SEC_CHAN_DISABLED = HT20 only
+ *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
+ *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -315,6 +322,8 @@
 	NL80211_ATTR_BSS_BASIC_RATES,
 
 	NL80211_ATTR_WIPHY_TXQ_PARAMS,
+	NL80211_ATTR_WIPHY_FREQ,
+	NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -329,6 +338,8 @@
 #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
 #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
 #define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
+#define NL80211_ATTR_WIPHY_FREQ NL80211_ATTR_WIPHY_FREQ
+#define NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -742,4 +753,10 @@
 	NL80211_TXQ_Q_BK
 };
 
+enum nl80211_sec_chan_offset {
+	NL80211_SEC_CHAN_NO_HT /* No HT */,
+	NL80211_SEC_CHAN_DISABLED /* HT20 only */,
+	NL80211_SEC_CHAN_BELOW /* HT40- */,
+	NL80211_SEC_CHAN_ABOVE /* HT40+ */
+};
 #endif /* __LINUX_NL80211_H */
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h	2008-11-26 09:28:51.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2008-11-26 09:38:12.000000000 +0200
@@ -450,6 +450,10 @@
  * @change_bss: Modify parameters for a given BSS.
  *
  * @set_txq_params: Set TX queue parameters
+ *
+ * @set_channel: Set channel (freq = frequency in MHz, sec_chan_offset:
+ *	0 = HT40 disabled; 1 = HT40 enabled, secondary channel above primary;
+ *	-1 = HT40 enabled, secondary channel below primary)
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -513,6 +517,9 @@
 
 	int	(*set_txq_params)(struct wiphy *wiphy,
 				  struct ieee80211_txq_params *params);
+
+	int	(*set_channel)(struct wiphy *wiphy, int freq, bool ht_enabled,
+			       int sec_chan_offset);
 };
 
 #endif /* __NET_CFG80211_H */
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c	2008-11-26 09:28:52.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2008-11-26 10:12:04.000000000 +0200
@@ -1095,6 +1095,23 @@
 	return 0;
 }
 
+static int ieee80211_set_channel(struct wiphy *wiphy, int freq,
+				 bool ht_enabled, int sec_chan_offset)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_channel *chan;
+
+	chan = ieee80211_get_channel(local->hw.wiphy, freq);
+	if (!chan)
+		return -EINVAL;
+
+	local->oper_channel = chan;
+	local->oper_ht_enabled = ht_enabled;
+	local->oper_sec_chan_offset = sec_chan_offset;
+
+	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1122,4 +1139,5 @@
 #endif
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
+	.set_channel = ieee80211_set_channel,
 };
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2008-11-26 09:28:52.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2008-11-26 10:25:36.000000000 +0200
@@ -59,6 +59,8 @@
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] = { .type = NLA_U8 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -359,6 +361,60 @@
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		int sec_chan_offset = 0;
+		bool ht_enabled = false;
+		struct ieee80211_channel *chan;
+		u32 freq;
+
+		if (!rdev->ops->set_channel) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		if (info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
+			u8 val = nla_get_u8(
+				info->attrs[
+					NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]);
+			switch (val) {
+			case NL80211_SEC_CHAN_BELOW:
+				ht_enabled = true;
+				sec_chan_offset = -1;
+				break;
+			case NL80211_SEC_CHAN_ABOVE:
+				ht_enabled = true;
+				sec_chan_offset = 1;
+				break;
+			case NL80211_SEC_CHAN_DISABLED:
+				ht_enabled = true;
+				break;
+			}
+		}
+
+		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+		chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
+			/* Primary channel not allowed */
+			result = -EINVAL;
+			goto bad_res;
+		}
+		if (sec_chan_offset) {
+			chan = ieee80211_get_channel(
+				&rdev->wiphy, freq + sec_chan_offset * 20);
+			if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
+				/* Secondary channel not allowed */
+				result = -EINVAL;
+				goto bad_res;
+			}
+		}
+
+		result = rdev->ops->set_channel(&rdev->wiphy, freq, ht_enabled,
+						sec_chan_offset);
+		if (result)
+			goto bad_res;
+	}
+
+
 bad_res:
 	cfg80211_put_dev(rdev);
 	return result;
Index: wireless-testing/include/net/mac80211.h
===================================================================
--- wireless-testing.orig/include/net/mac80211.h	2008-11-26 09:28:52.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2008-11-26 09:28:54.000000000 +0200
@@ -507,6 +507,9 @@
 
 struct ieee80211_ht_conf {
 	bool enabled;
+	int sec_chan_offset; /* 0 = HT40 disabled; -1 = HT40 enabled, secondary
+			      * channel below primary; 1 = HT40 enabled,
+			      * secondary channel above primary */
 };
 
 /**
Index: wireless-testing/net/mac80211/util.c
===================================================================
--- wireless-testing.orig/net/mac80211/util.c	2008-11-26 10:00:57.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2008-11-26 10:09:01.000000000 +0200
@@ -641,6 +641,8 @@
 		    chan->flags & IEEE80211_CHAN_NO_IBSS)
 			return ret;
 		local->oper_channel = chan;
+		local->oper_ht_enabled = false;
+		local->oper_sec_chan_offset = 0;
 
 		if (local->sw_scanning || local->hw_scanning)
 			ret = 0;
Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2008-11-26 10:12:16.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2008-11-26 10:12:34.000000000 +0200
@@ -626,6 +626,8 @@
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	struct ieee80211_channel *oper_channel, *scan_channel;
+	bool oper_ht_enabled;
+	int oper_sec_chan_offset;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
 	struct list_head bss_list;
Index: wireless-testing/net/mac80211/main.c
===================================================================
--- wireless-testing.orig/net/mac80211/main.c	2008-11-26 10:09:09.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2008-11-26 10:11:49.000000000 +0200
@@ -195,20 +195,30 @@
 	struct ieee80211_channel *chan;
 	int ret = 0;
 	int power;
+	bool ht_enabled;
+	int sec_chan_offset;
 
 	might_sleep();
 
-	if (local->sw_scanning)
+	if (local->sw_scanning) {
 		chan = local->scan_channel;
-	else
+		ht_enabled = false;
+		sec_chan_offset = 0;
+	} else {
 		chan = local->oper_channel;
+		ht_enabled = local->oper_ht_enabled;
+		sec_chan_offset = local->oper_sec_chan_offset;
+	}
 
-	if (chan != local->hw.conf.channel) {
+	if (chan != local->hw.conf.channel ||
+	    ht_enabled != local->hw.conf.ht.enabled ||
+	    sec_chan_offset != local->hw.conf.ht.sec_chan_offset) {
 		local->hw.conf.channel = chan;
+		local->hw.conf.ht.enabled = ht_enabled;
+		local->hw.conf.ht.sec_chan_offset = sec_chan_offset;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
-
 	if (!local->hw.conf.power_level)
 		power = chan->max_power;
 	else

-- 
Jouni Malinen                                            PGP id EFC895FA
