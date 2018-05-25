Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57826 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S968315AbeEYUj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 16:39:29 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: skip sending GT_REKEY_OFFLOAD_CFG if firmware has no support
Date: Sat, 26 May 2018 02:09:22 +0530
Message-ID: <1527280762-5648-1-git-send-email-gbhat@marvell.com> (sfid-20180525_223950_152590_AF504903)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If firmware does not support embedded supplicant, then it in turn
will not support GT rekey offloading. If this is the case, then
driver must not advertise WOWLAN flags related to GTK rekey and
it must also skip sending the GT_REKEY_OFFLOAD_CFG command.

Signed-off-by: Shrenik Shikhare <shrenik@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 18 +++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/fw.h        |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  3 +++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 54a2297..d04a599 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3555,6 +3555,9 @@ static int mwifiex_set_rekey_data(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
+	if (!ISSUPP_FIRMWARE_SUPPLICANT(priv->adapter->fw_cap_info))
+		return -EOPNOTSUPP;
+
 	return mwifiex_send_cmd(priv, HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG,
 				HostCmd_ACT_GEN_SET, 0, data, true);
 }
@@ -4190,6 +4193,16 @@ static int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
 	.max_nd_match_sets = MWIFIEX_MAX_ND_MATCH_SETS,
 };
+
+static const struct wiphy_wowlan_support mwifiex_wowlan_support_no_gtk = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT |
+		 WIPHY_WOWLAN_NET_DETECT,
+	.n_patterns = MWIFIEX_MEF_MAX_FILTERS,
+	.pattern_min_len = 1,
+	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
+	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
+	.max_nd_match_sets = MWIFIEX_MAX_ND_MATCH_SETS,
+};
 #endif
 
 static bool mwifiex_is_valid_alpha2(const char *alpha2)
@@ -4308,7 +4321,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
 #ifdef CONFIG_PM
-	wiphy->wowlan = &mwifiex_wowlan_support;
+	if (ISSUPP_FIRMWARE_SUPPLICANT(priv->adapter->fw_cap_info))
+		wiphy->wowlan = &mwifiex_wowlan_support;
+	else
+		wiphy->wowlan = &mwifiex_wowlan_support_no_gtk;
 #endif
 
 	wiphy->coalesce = &mwifiex_coalesce_support;
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index c5dc518..b73f99d 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -249,6 +249,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_SDIO_SPA_ENABLED(FwCapInfo) (FwCapInfo & BIT(16))
 #define ISSUPP_ADHOC_ENABLED(FwCapInfo) (FwCapInfo & BIT(25))
 #define ISSUPP_RANDOM_MAC(FwCapInfo) (FwCapInfo & BIT(27))
+#define ISSUPP_FIRMWARE_SUPPLICANT(FwCapInfo) (FwCapInfo & BIT(21))
 
 #define MWIFIEX_DEF_HT_CAP	(IEEE80211_HT_CAP_DSSSCCK40 | \
 				 (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) | \
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 93dfb76..03a6492 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -241,6 +241,9 @@ void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code,
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
 
+	if (!ISSUPP_FIRMWARE_SUPPLICANT(priv->adapter->fw_cap_info))
+		return;
+
 	mwifiex_send_cmd(priv, HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG,
 			 HostCmd_ACT_GEN_REMOVE, 0, NULL, false);
 }
-- 
1.9.1
