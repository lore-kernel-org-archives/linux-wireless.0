Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaAGXRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:17:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 12/12] mac80211_hwsim: allow creating/destroying radios on the fly
Date: Wed,  8 Jan 2014 00:15:17 +0100
Message-Id: <1389136517-21216-13-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001704_057576_9DFE218B)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add new commands to the hwsim generic netlink family to allow
creating and destroying radios on the fly. The number of channels
a radio supports can be specified when it's created, if it isn't
the module parameter will be used as default.

This should be extended in the future to allow other parameters
to be specified, e.g.
 * list of channels
 * interface combinations, particularly P2P_DEVICE support
 * regtest
 * and pretty much all other hardware capabilities

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 58 +++++++++++++++++++++++++++++++----
 drivers/net/wireless/mac80211_hwsim.h | 11 +++++++
 2 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e623a9e..d939a6f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -273,7 +273,7 @@ struct mac80211_hwsim_data {
 	struct ieee80211_iface_combination if_combination;
 
 	struct mac_address addresses[2];
-	int channels;
+	int channels, idx;
 
 	struct ieee80211_channel *tmp_chan;
 	struct delayed_work roc_done;
@@ -352,6 +352,8 @@ static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 				 .len = IEEE80211_TX_MAX_RATES *
 					sizeof(struct hwsim_tx_rate)},
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
+	[HWSIM_ATTR_CHANNELS] = { .type = NLA_U32 },
+	[HWSIM_ATTR_RADIO_ID] = { .type = NLA_U32 },
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -1818,7 +1820,7 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
-static int __init mac80211_hwsim_create_radio(void)
+static int mac80211_hwsim_create_radio(int channels)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -1873,6 +1875,7 @@ static int __init mac80211_hwsim_create_radio(void)
 	hw->wiphy->addresses = data->addresses;
 
 	data->channels = channels;
+	data->idx = idx;
 
 	if (data->channels > 1) {
 		hw->wiphy->max_scan_ssids = 255;
@@ -2023,7 +2026,7 @@ static int __init mac80211_hwsim_create_radio(void)
 	list_add_tail(&data->list, &hwsim_radios);
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	return 0;
+	return idx;
 
 failed_hw:
 	device_unregister(data->dev);
@@ -2267,6 +2270,39 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 	return 0;
 }
 
+static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	unsigned int chans = channels;
+
+	if (info->attrs[HWSIM_ATTR_CHANNELS])
+		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
+
+	return mac80211_hwsim_create_radio(chans);
+}
+
+static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	struct mac80211_hwsim_data *data, *tmp;
+	int err = -ENODEV;
+	int idx;
+
+	if (!info->attrs[HWSIM_ATTR_RADIO_ID])
+		return -EINVAL;
+	idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_for_each_entry_safe(data, tmp, &hwsim_radios, list) {
+		if (data->idx != idx)
+			continue;
+		mac80211_hwsim_destroy_radio(data);
+		err = 0;
+		break;
+	}
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	return err;
+}
+
 /* Generic Netlink operations array */
 static const struct genl_ops hwsim_ops[] = {
 	{
@@ -2285,6 +2321,16 @@ static const struct genl_ops hwsim_ops[] = {
 		.policy = hwsim_genl_policy,
 		.doit = hwsim_tx_info_frame_received_nl,
 	},
+	{
+		.cmd = HWSIM_CMD_CREATE_RADIO,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_create_radio_nl,
+	},
+	{
+		.cmd = HWSIM_CMD_DESTROY_RADIO,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_destroy_radio_nl,
+	},
 };
 
 static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
@@ -2342,7 +2388,7 @@ static int __init init_mac80211_hwsim(void)
 {
 	int i, err;
 
-	if (radios < 1 || radios > 100)
+	if (radios < 0 || radios > 100)
 		return -EINVAL;
 
 	if (channels < 1)
@@ -2377,8 +2423,8 @@ static int __init init_mac80211_hwsim(void)
 	}
 
 	for (i = 0; i < radios; i++) {
-		err = mac80211_hwsim_create_radio();
-		if (err)
+		err = mac80211_hwsim_create_radio(channels);
+		if (err < 0)
 			goto out_free_radios;
 	}
 
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index afaad5a..fb9920a 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -65,6 +65,9 @@ enum hwsim_tx_control_flags {
  * kernel, uses:
  *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
  *	%HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
+ * @HWSIM_CMD_CREATE_RADIO: create a new radio with the given parameters,
+ *	returns the radio ID (>= 0) or negative on errors
+ * @HWSIM_CMD_DESTROY_RADIO: destroy a radio
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -72,6 +75,8 @@ enum {
 	HWSIM_CMD_REGISTER,
 	HWSIM_CMD_FRAME,
 	HWSIM_CMD_TX_INFO_FRAME,
+	HWSIM_CMD_CREATE_RADIO,
+	HWSIM_CMD_DESTROY_RADIO,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
@@ -94,6 +99,10 @@ enum {
 	space
  * @HWSIM_ATTR_TX_INFO: ieee80211_tx_rate array
  * @HWSIM_ATTR_COOKIE: sk_buff cookie to identify the frame
+ * @HWSIM_ATTR_CHANNELS: u32 attribute used with the %HWSIM_CMD_CREATE_RADIO
+ *	command giving the number of channels supported by the new radio
+ * @HWSIM_ATTR_RADIO_ID: u32 attribute used with %HWSIM_CMD_DESTROY_RADIO
+ *	only to destroy a radio
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -108,6 +117,8 @@ enum {
 	HWSIM_ATTR_SIGNAL,
 	HWSIM_ATTR_TX_INFO,
 	HWSIM_ATTR_COOKIE,
+	HWSIM_ATTR_CHANNELS,
+	HWSIM_ATTR_RADIO_ID,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.8.5.1

