Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24395 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933049AbbFVIHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xp6B015529
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:31 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut80-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:31 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 09/17] mwifiex: add cfg80211 tdls channel switch handler
Date: Mon, 22 Jun 2015 19:06:15 +0530
Message-ID: <1434980183-2901-10-git-send-email-patila@marvell.com> (sfid-20150622_103354_999439_8CDC848B)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add cfg80211 tdls_chan_switch and tdls_cancel_chan_switch
handler.
With this handlers, mwifiex would support TDLS channel switch feature.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 72 +++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b15e4c7..ecc8278 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -19,6 +19,7 @@
 
 #include "cfg80211.h"
 #include "main.h"
+#include "11n.h"
 
 static char *reg_alpha2;
 module_param(reg_alpha2, charp, 0);
@@ -3360,6 +3361,72 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int
+mwifiex_cfg80211_tdls_chan_switch(struct wiphy *wiphy, struct net_device *dev,
+				  const u8 *addr, u8 oper_class,
+				  struct cfg80211_chan_def *chandef)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	unsigned long flags;
+	u16 chan;
+	u8 second_chan_offset, band;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	sta_ptr = mwifiex_get_sta_entry(priv, addr);
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+
+	if (!sta_ptr) {
+		wiphy_err(wiphy, "%s: Invalid TDLS peer %pM\n",
+			  __func__, addr);
+		return -ENOENT;
+	}
+
+	if (!(sta_ptr->tdls_cap.extcap.ext_capab[3] &
+	      WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH)) {
+		wiphy_err(wiphy, "%pM do not support tdls cs\n", addr);
+		return -ENOENT;
+	}
+
+	if (sta_ptr->tdls_status == TDLS_CHAN_SWITCHING ||
+	    sta_ptr->tdls_status == TDLS_IN_OFF_CHAN) {
+		wiphy_err(wiphy, "channel switch is running, abort request\n");
+		return -EALREADY;
+	}
+
+	chan = chandef->chan->hw_value;
+	second_chan_offset = mwifiex_get_sec_chan_offset(chan);
+	band = chandef->chan->band;
+	mwifiex_start_tdls_cs(priv, addr, chan, second_chan_offset, band);
+
+	return 0;
+}
+
+static void
+mwifiex_cfg80211_tdls_cancel_chan_switch(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 const u8 *addr)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	unsigned long flags;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	sta_ptr = mwifiex_get_sta_entry(priv, addr);
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+
+	if (!sta_ptr) {
+		wiphy_err(wiphy, "%s: Invalid TDLS peer %pM\n",
+			  __func__, addr);
+	} else if (!(sta_ptr->tdls_status == TDLS_CHAN_SWITCHING ||
+		     sta_ptr->tdls_status == TDLS_IN_BASE_CHAN ||
+		     sta_ptr->tdls_status == TDLS_IN_OFF_CHAN)) {
+		wiphy_err(wiphy, "tdls chan switch not initialize by %pM\n",
+			  addr);
+	} else
+		mwifiex_stop_tdls_cs(priv, addr);
+}
+
+static int
 mwifiex_cfg80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *mac, struct station_parameters *params)
 {
@@ -3575,6 +3642,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 	.tdls_mgmt = mwifiex_cfg80211_tdls_mgmt,
 	.tdls_oper = mwifiex_cfg80211_tdls_oper,
+	.tdls_channel_switch = mwifiex_cfg80211_tdls_chan_switch,
+	.tdls_cancel_channel_switch = mwifiex_cfg80211_tdls_cancel_chan_switch,
 	.add_station = mwifiex_cfg80211_add_station,
 	.change_station = mwifiex_cfg80211_change_station,
 	.get_channel = mwifiex_cfg80211_get_channel,
@@ -3709,6 +3778,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 			   NL80211_FEATURE_INACTIVITY_TIMER |
 			   NL80211_FEATURE_NEED_OBSS_SCAN;
 
+	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
+		wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
+
 	if (adapter->fw_api_ver == MWIFIEX_FW_V15)
 		wiphy->features |= NL80211_FEATURE_SK_TX_STATUS;
 
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
