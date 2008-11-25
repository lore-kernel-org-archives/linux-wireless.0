Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:58659 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYKYTFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 14:05:45 -0500
Date: Tue, 25 Nov 2008 21:05:33 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] nl80211: Add frequency configuration (including HT40)
Message-ID: <20081125190533.GA27879@jm.kir.nu> (sfid-20081125_200549_734853_D6D3CC6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new NL80211_CMD_SET_WIPHY attributes
NL80211_ATTR_WIPHY_FREQ and NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET to allow
userspace to set the operating channel (e.g., hostapd for AP mode).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

--
Userspace example of a user for this is available in hostap.git/hostapd
where this gets rid of one more WEXT ioctl and adds support for enabling
HT40. Drivers supporting AP mode can add HT40 support based on the new
struct ieee80211_ht_conf variable sec_chan_offset in their config()
handler.


Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2008-11-25 18:44:19.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2008-11-25 19:10:27.000000000 +0200
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
@@ -180,6 +181,11 @@
  *	/sys/class/ieee80211/<phyname>/index
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
  * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
+ * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
+ * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
+ *	if HT40 (40 MHz channels) are allowed:
+ *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
+ *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -315,6 +321,8 @@
 	NL80211_ATTR_BSS_BASIC_RATES,
 
 	NL80211_ATTR_WIPHY_TXQ_PARAMS,
+	NL80211_ATTR_WIPHY_FREQ,
+	NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -329,6 +337,8 @@
 #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
 #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
 #define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
+#define NL80211_ATTR_WIPHY_FREQ NL80211_ATTR_WIPHY_FREQ
+#define NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -742,4 +752,9 @@
 	NL80211_TXQ_Q_BK
 };
 
+enum nl80211_sec_chan_offset {
+	NL80211_SEC_CHAN_DISABLED /* HT20 only */,
+	NL80211_SEC_CHAN_BELOW /* HT40- */,
+	NL80211_SEC_CHAN_ABOVE /* HT40+ */
+};
 #endif /* __LINUX_NL80211_H */
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h	2008-11-25 18:50:47.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2008-11-25 18:52:51.000000000 +0200
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
+	int	(*set_channel)(struct wiphy *wiphy, int freq,
+			       int sec_chan_offset);
 };
 
 #endif /* __NET_CFG80211_H */
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c	2008-11-25 18:53:13.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2008-11-25 20:46:36.000000000 +0200
@@ -1095,6 +1095,22 @@
 	return 0;
 }
 
+static int ieee80211_set_channel(struct wiphy *wiphy, int freq,
+				 int sec_chan_offset)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_channel *chan;
+
+	chan = ieee80211_get_channel(local->hw.wiphy, freq);
+	if (!chan)
+		return -EINVAL;
+
+	local->oper_channel = chan;
+	local->hw.conf.ht.sec_chan_offset = sec_chan_offset;
+
+	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1122,4 +1138,5 @@
 #endif
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
+	.set_channel = ieee80211_set_channel,
 };
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2008-11-25 18:55:20.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2008-11-25 19:24:03.000000000 +0200
@@ -59,6 +59,8 @@
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] = { .type = NLA_U8 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -359,6 +361,32 @@
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		int sec_chan_offset = 0;
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
+			if (val == NL80211_SEC_CHAN_BELOW)
+				sec_chan_offset = -1;
+			else if (val == NL80211_SEC_CHAN_ABOVE)
+				sec_chan_offset = 1;
+		}
+		result = rdev->ops->set_channel(
+			&rdev->wiphy,
+			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+			sec_chan_offset);
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
--- wireless-testing.orig/include/net/mac80211.h	2008-11-25 19:32:20.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2008-11-25 19:33:16.000000000 +0200
@@ -507,6 +507,9 @@
 
 struct ieee80211_ht_conf {
 	bool enabled;
+	int sec_chan_offset; /* 0 = HT40 disabled; -1 = HT40 enabled, secondary
+			      * channel below primary; 1 = HT40 enabled,
+			      * secondary channel above primary */
 };
 
 /**

-- 
Jouni Malinen                                            PGP id EFC895FA
