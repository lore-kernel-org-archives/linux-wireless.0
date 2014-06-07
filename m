Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28817 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbaFGCsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 22:48:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Chin-Ran Lo <crlo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: get rid of 'ethtool wol' code
Date: Fri, 6 Jun 2014 19:47:43 -0700
Message-ID: <1402109264-7095-2-git-send-email-bzhao@marvell.com> (sfid-20140607_044808_803624_72BC9577)
In-Reply-To: <1402109264-7095-1-git-send-email-bzhao@marvell.com>
References: <1402109264-7095-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

"iw wowlan" command takes care all wake on wlan use cases.
So we will remove older configuration option through 'ethtool'
utility.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile   |  1 -
 drivers/net/wireless/mwifiex/cfg80211.c |  1 -
 drivers/net/wireless/mwifiex/ethtool.c  | 70 ---------------------------------
 drivers/net/wireless/mwifiex/main.h     |  2 -
 4 files changed, 74 deletions(-)
 delete mode 100644 drivers/net/wireless/mwifiex/ethtool.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 2aa208f..855a376 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -39,7 +39,6 @@ mwifiex-y += sta_tx.o
 mwifiex-y += sta_rx.o
 mwifiex-y += uap_txrx.o
 mwifiex-y += cfg80211.o
-mwifiex-y += ethtool.o
 mwifiex-y += 11h.o
 mwifiex-y += tdls.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9afac2b..a045f66 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2296,7 +2296,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
 	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
-	dev->ethtool_ops = &mwifiex_ethtool_ops;
 
 	mdev_priv = netdev_priv(dev);
 	*((unsigned long *) mdev_priv) = (unsigned long) priv;
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
deleted file mode 100644
index bfb3990..0000000
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Marvell Wireless LAN device driver: ethtool
- *
- * Copyright (C) 2013, Marvell International Ltd.
- *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available by writing to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
- * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- */
-
-#include "main.h"
-
-static void mwifiex_ethtool_get_wol(struct net_device *dev,
-				    struct ethtool_wolinfo *wol)
-{
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	u32 conditions = le32_to_cpu(priv->adapter->hs_cfg.conditions);
-
-	wol->supported = WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY;
-
-	if (conditions == HS_CFG_COND_DEF)
-		return;
-
-	if (conditions & HS_CFG_COND_UNICAST_DATA)
-		wol->wolopts |= WAKE_UCAST;
-	if (conditions & HS_CFG_COND_MULTICAST_DATA)
-		wol->wolopts |= WAKE_MCAST;
-	if (conditions & HS_CFG_COND_BROADCAST_DATA)
-		wol->wolopts |= WAKE_BCAST;
-	if (conditions & HS_CFG_COND_MAC_EVENT)
-		wol->wolopts |= WAKE_PHY;
-}
-
-static int mwifiex_ethtool_set_wol(struct net_device *dev,
-				   struct ethtool_wolinfo *wol)
-{
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	u32 conditions = 0;
-
-	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
-		return -EOPNOTSUPP;
-
-	if (wol->wolopts & WAKE_UCAST)
-		conditions |= HS_CFG_COND_UNICAST_DATA;
-	if (wol->wolopts & WAKE_MCAST)
-		conditions |= HS_CFG_COND_MULTICAST_DATA;
-	if (wol->wolopts & WAKE_BCAST)
-		conditions |= HS_CFG_COND_BROADCAST_DATA;
-	if (wol->wolopts & WAKE_PHY)
-		conditions |= HS_CFG_COND_MAC_EVENT;
-	if (wol->wolopts == 0)
-		conditions |= HS_CFG_COND_DEF;
-	priv->adapter->hs_cfg.conditions = cpu_to_le32(conditions);
-
-	return 0;
-}
-
-const struct ethtool_ops mwifiex_ethtool_ops = {
-	.get_wol = mwifiex_ethtool_get_wol,
-	.set_wol = mwifiex_ethtool_set_wol,
-};
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1398afa..d8f3bea 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1215,8 +1215,6 @@ int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
 			    struct device_node *node, const char *prefix);
 void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv);
 
-extern const struct ethtool_ops mwifiex_ethtool_ops;
-
 void mwifiex_del_all_sta_list(struct mwifiex_private *priv);
 void mwifiex_del_sta_entry(struct mwifiex_private *priv, const u8 *mac);
 void
-- 
1.8.2.3

