Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64805 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966209AbeAJQnr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 11:43:47 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option for new radios
Date: Wed, 10 Jan 2018 17:42:54 +0100
In-Reply-To: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de> (sfid-20180110_174354_571148_D95869F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If simulation needs predictable permanent mac addresses of hwsim wireless
phy, this patch add the ability to create a new radio with a user defined
permanent mac address. Allowed mac addresses needs to be locally
administrated mac addresses (as also the former fixed 42:* and 02:* were).

To do not break the operation with legacy software using hwsim, the new
address is set twice. The problem here is, the netlink call backs use
wiphy->addresses[1] as identification of a radio and not the proposed
permanent address (wiphy->addresses[0]). This design decision is not
documented in the kernel repo, therefore this patch simply reproduces this,
but with the same address.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 53 +++++++++++++++++++++++++++++------
 drivers/net/wireless/mac80211_hwsim.h |  9 +++++-
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2d4e97b6dc8f..1e0d651c43fc 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2375,6 +2375,7 @@ struct hwsim_new_radio_params {
 	bool destroy_on_close;
 	const char *hwname;
 	bool no_vif;
+	u8 *perm_addr;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -2539,15 +2540,25 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	skb_queue_head_init(&data->pending);
 
 	SET_IEEE80211_DEV(hw, data->dev);
-	eth_zero_addr(addr);
-	addr[0] = 0x02;
-	addr[3] = idx >> 8;
-	addr[4] = idx;
-	memcpy(data->addresses[0].addr, addr, ETH_ALEN);
-	memcpy(data->addresses[1].addr, addr, ETH_ALEN);
-	data->addresses[1].addr[0] |= 0x40;
-	hw->wiphy->n_addresses = 2;
-	hw->wiphy->addresses = data->addresses;
+	if (!param->perm_addr) {
+		eth_zero_addr(addr);
+		addr[0] = 0x02;
+		addr[3] = idx >> 8;
+		addr[4] = idx;
+		memcpy(data->addresses[0].addr, addr, ETH_ALEN);
+		/* Why need here second address ? */
+		data->addresses[1].addr[0] |= 0x40;
+		memcpy(data->addresses[1].addr, addr, ETH_ALEN);
+		hw->wiphy->n_addresses = 2;
+		hw->wiphy->addresses = data->addresses;
+		/* possible address clash is checked at hash table insertion */
+	} else {
+		memcpy(data->addresses[0].addr, param->perm_addr, ETH_ALEN);
+		/* compatibility with automatically generated mac addr */
+		memcpy(data->addresses[1].addr, param->perm_addr, ETH_ALEN);
+		hw->wiphy->n_addresses = 2;
+		hw->wiphy->addresses = data->addresses;
+	}
 
 	data->channels = param->channels;
 	data->use_chanctx = param->use_chanctx;
@@ -3172,6 +3183,30 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.regd = hwsim_world_regdom_custom[idx];
 	}
 
+	if (info->attrs[HWSIM_ATTR_PERM_ADDR]) {
+		if (nla_len(info->attrs[HWSIM_ATTR_PERM_ADDR]) != ETH_ALEN) {
+			pr_debug("mac80211_hwsim: MAC has wrong size\n");
+			return -EINVAL;
+		}
+		if (!is_valid_ether_addr(
+				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
+			pr_debug("mac80211_hwsim: MAC is no valid source addr\n");
+			return -EINVAL;
+		}
+		if (!is_local_ether_addr(
+				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
+			pr_debug("mac80211_hwsim: MAC is not locally administered\n");
+			return -EINVAL;
+		}
+		if (get_hwsim_data_ref_from_addr(
+				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
+			pr_debug("mac80211_hwsim: perm MAC already in use\n");
+			return -EINVAL;
+		}
+
+		param.perm_addr = nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]);
+	}
+
 	ret = mac80211_hwsim_new_radio(info, &param);
 	kfree(hwname);
 	return ret;
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 3f5eda591dba..e2592b596090 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -67,7 +67,12 @@ enum hwsim_tx_control_flags {
  *	%HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
  * @HWSIM_CMD_NEW_RADIO: create a new radio with the given parameters,
  *	returns the radio ID (>= 0) or negative on errors, if successful
- *	then multicast the result
+ *	then multicast the result, uses optional parameter:
+ *	%HWSIM_ATTR_REG_STRICT_REG, %HWSIM_ATTR_SUPPORT_P2P_DEVICE,
+ *	%HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE, %HWSIM_ATTR_CHANNELS,
+ *	%HWSIM_ATTR_NO_VIF, %HWSIM_ATTR_RADIO_NAME, %HWSIM_ATTR_USE_CHANCTX,
+ *	%HWSIM_ATTR_REG_HINT_ALPHA2, %HWSIM_ATTR_REG_CUSTOM_REG,
+ *	%HWSIM_ATTR_PERM_ADDR
  * @HWSIM_CMD_DEL_RADIO: destroy a radio, reply is multicasted
  * @HWSIM_CMD_GET_RADIO: fetch information about existing radios, uses:
  *	%HWSIM_ATTR_RADIO_ID
@@ -123,6 +128,7 @@ enum {
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
  * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
  * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
+ * @HWSIM_ATTR_PERM_ADDR: permanent mac address of new radio
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -149,6 +155,7 @@ enum {
 	HWSIM_ATTR_NO_VIF,
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
+	HWSIM_ATTR_PERM_ADDR,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.15.1
