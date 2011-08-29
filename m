Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48179 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1H2M2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:28:20 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 07/20] ath6kl: Implement mgmt_tx
Date: Mon, 29 Aug 2011 15:23:48 +0300
Message-ID: <1314620641-24257-8-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_142822_542951_61AE53E9)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a05036c..924f62f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1685,6 +1685,24 @@ static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi);
 }
 
+static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
+			  struct ieee80211_channel *chan, bool offchan,
+			  enum nl80211_channel_type channel_type,
+			  bool channel_type_valid, unsigned int wait,
+			  const u8 *buf, size_t len, u64 *cookie)
+{
+	struct ath6kl *ar = ath6kl_priv(dev);
+	u32 id;
+
+	id = ar->send_action_id++;
+	if (id == 0)
+		id = ar->send_action_id++;
+
+	*cookie = id;
+	return ath6kl_wmi_send_action_cmd(ar->wmi, id, chan->center_freq, wait,
+					  buf, len);
+}
+
 static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_virtual_intf = ath6kl_cfg80211_change_iface,
 	.scan = ath6kl_cfg80211_scan,
@@ -1714,6 +1732,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.change_station = ath6kl_change_station,
 	.remain_on_channel = ath6kl_remain_on_channel,
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
+	.mgmt_tx = ath6kl_mgmt_tx,
 };
 
 struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f0b1dff..3872edb 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -456,6 +456,7 @@ struct ath6kl {
 	struct ath6kl_node_table scan_table;
 	struct dentry *debugfs_phy;
 
+	u32 send_action_id;
 	u16 next_chan;
 };
 
-- 
1.7.4.1

