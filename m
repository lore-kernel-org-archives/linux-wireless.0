Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaKLOmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:42:44 -0500
From: Patrik Flykt <patrik.flykt@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command
Date: Wed, 12 Nov 2014 16:42:40 +0200
Message-Id: <1415803360-4073-3-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141112_154253_218563_3F2D005A)
In-Reply-To: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com>
References: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HWSIM_CMD_GET_RADIO returns information about a specific radio id or
all of them in response to a dump. Create the netlink skb or use the
one provided by the dump functionality. Use the existing attribute
appending function to fill in the same attributes when creating a
new hwsim radio.

Save alpha2 and struct ieee80211_regdomain in the hwsim data or else
they will be lost in the depths of regulatory infrastructure.

Signed-off-by: Patrik Flykt <patrik.flykt@linux.intel.com>
---

v2: Fix dumping of hwsim radios by remembering the radio id from which
    to start the next netlink message

 drivers/net/wireless/mac80211_hwsim.c | 123 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   3 +
 2 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 804c92f..3d6059b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -415,6 +415,8 @@ struct mac80211_hwsim_data {
 	bool destroy_on_close;
 	struct work_struct destroy_work;
 	u32 portid;
+	char alpha2[2];
+	const struct ieee80211_regdomain *regd;
 
 	struct ieee80211_channel *tmp_chan;
 	struct delayed_work roc_done;
@@ -2403,6 +2405,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	if (param->reg_strict)
 		hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
 	if (param->regd) {
+		data->regd = param->regd;
 		hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 		wiphy_apply_custom_regulatory(hw->wiphy, param->regd);
 		/* give the regulatory workqueue a chance to run */
@@ -2421,8 +2424,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
-	if (param->reg_alpha2)
+	if (param->reg_alpha2) {
+		data->alpha2[0] = param->reg_alpha2[0];
+		data->alpha2[1] = param->reg_alpha2[1];
 		regulatory_hint(hw->wiphy, param->reg_alpha2);
+	}
 
 	data->debugfs = debugfs_create_dir("hwsim", hw->wiphy->debugfsdir);
 	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
@@ -2503,6 +2509,44 @@ static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
 	ieee80211_free_hw(data->hw);
 }
 
+static int mac80211_hwsim_get_radio(struct sk_buff *skb,
+				    struct mac80211_hwsim_data *data,
+				    u32 portid, u32 seq,
+				    struct netlink_callback *cb, int flags)
+{
+	void *hdr;
+	struct hwsim_new_radio_params param = { };
+	int res = -EMSGSIZE;
+
+	hdr = genlmsg_put(skb, portid, seq, &hwsim_genl_family, flags,
+			  HWSIM_CMD_GET_RADIO);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (cb)
+		genl_dump_check_consistent(cb, hdr, &hwsim_genl_family);
+
+	param.reg_alpha2 = data->alpha2;
+	param.reg_strict = !!(data->hw->wiphy->regulatory_flags &
+					REGULATORY_STRICT_REG);
+	param.p2p_device = !!(data->hw->wiphy->interface_modes &
+					BIT(NL80211_IFTYPE_P2P_DEVICE));
+	param.use_chanctx = data->use_chanctx;
+	param.regd = data->regd;
+	param.channels = data->channels;
+	param.hwname = wiphy_name(data->hw->wiphy);
+
+	res = append_radio_msg(skb, data->idx, &param);
+	if (res < 0)
+		goto out_err;
+
+	return genlmsg_end(skb, hdr);
+
+out_err:
+	genlmsg_cancel(skb, hdr);
+	return res;
+}
+
 static void mac80211_hwsim_free(void)
 {
 	struct mac80211_hwsim_data *data;
@@ -2807,6 +2851,77 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	return -ENODEV;
 }
 
+static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	struct mac80211_hwsim_data *data;
+	struct sk_buff *skb;
+	int idx, res = -ENODEV;
+
+	if (!info->attrs[HWSIM_ATTR_RADIO_ID])
+		return -EINVAL;
+	idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_for_each_entry(data, &hwsim_radios, list) {
+		if (data->idx != idx)
+			continue;
+
+		skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		if (!skb) {
+			res = -ENOMEM;
+			goto out_err;
+		}
+
+		res = mac80211_hwsim_get_radio(skb, data, info->snd_portid,
+					       info->snd_seq, NULL, 0);
+		if (res < 0) {
+			nlmsg_free(skb);
+			goto out_err;
+		}
+
+		genlmsg_reply(skb, info);
+		break;
+	}
+
+out_err:
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	return res;
+}
+
+static int hwsim_dump_radio_nl(struct sk_buff *skb,
+			       struct netlink_callback *cb)
+{
+	int idx = cb->args[0];
+	struct mac80211_hwsim_data *data = NULL;
+	int res;
+
+	spin_lock_bh(&hwsim_radio_lock);
+
+	if (idx == hwsim_radio_idx)
+		goto done;
+
+	list_for_each_entry(data, &hwsim_radios, list) {
+		if (data->idx < idx)
+			continue;
+
+		res = mac80211_hwsim_get_radio(skb, data,
+					       NETLINK_CB(cb->skb).portid,
+					       cb->nlh->nlmsg_seq, cb,
+					       NLM_F_MULTI);
+		if (res < 0)
+			break;
+
+		idx = data->idx + 1;
+	}
+
+	cb->args[0] = idx;
+
+done:
+	spin_unlock_bh(&hwsim_radio_lock);
+	return skb->len;
+}
+
 /* Generic Netlink operations array */
 static const struct genl_ops hwsim_ops[] = {
 	{
@@ -2837,6 +2952,12 @@ static const struct genl_ops hwsim_ops[] = {
 		.doit = hwsim_del_radio_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = HWSIM_CMD_GET_RADIO,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_get_radio_nl,
+		.dumpit = hwsim_dump_radio_nl,
+	},
 };
 
 static void destroy_radio(struct work_struct *work)
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index f08debd..66e1c73 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -69,6 +69,8 @@ enum hwsim_tx_control_flags {
  *	returns the radio ID (>= 0) or negative on errors, if successful
  *	then multicast the result
  * @HWSIM_CMD_DEL_RADIO: destroy a radio, reply is multicasted
+ * @HWSIM_CMD_GET_RADIO: fetch information about existing radios, uses:
+ *	%HWSIM_ATTR_RADIO_ID
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -78,6 +80,7 @@ enum {
 	HWSIM_CMD_TX_INFO_FRAME,
 	HWSIM_CMD_NEW_RADIO,
 	HWSIM_CMD_DEL_RADIO,
+	HWSIM_CMD_GET_RADIO,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
-- 
2.1.1

