Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:53289 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755713Ab2F2DbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/6] mwifiex: add change_beacon cfg80211 handler
Date: Thu, 28 Jun 2012 20:30:28 -0700
Message-Id: <1340940630-27172-5-git-send-email-bzhao@marvell.com> (sfid-20120629_053120_468044_E57C212E)
In-Reply-To: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
References: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for change_beacon handler which is needed
for setting modified management IEs to driver and FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fce8155..1c5edc2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -914,6 +914,33 @@ static int mwifiex_cfg80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	return 0;
 }
 
+/* cfg80211 operation handler for change_beacon.
+ * Function retrieves and sets modified management IEs to FW.
+ */
+static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  struct cfg80211_beacon_data *data)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
+		wiphy_err(wiphy, "%s: bss_type mismatched\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!priv->bss_started) {
+		wiphy_err(wiphy, "%s: bss not started\n", __func__);
+		return -EINVAL;
+	}
+
+	if (mwifiex_set_mgmt_ies(priv, data)) {
+		wiphy_err(wiphy, "%s: setting mgmt ies failed\n", __func__);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 /* cfg80211 operation handler for stop ap.
  * Function stops BSS running at uAP interface.
  */
@@ -1696,6 +1723,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_bitrate_mask = mwifiex_cfg80211_set_bitrate_mask,
 	.start_ap = mwifiex_cfg80211_start_ap,
 	.stop_ap = mwifiex_cfg80211_stop_ap,
+	.change_beacon = mwifiex_cfg80211_change_beacon,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 };
 
-- 
1.7.0.2

