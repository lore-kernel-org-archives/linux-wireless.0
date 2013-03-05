Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:47589 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:36 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/7] mwifiex: add "ethtool wol" command support
Date: Mon,  4 Mar 2013 16:27:58 -0800
Message-Id: <1362443279-6064-7-git-send-email-bzhao@marvell.com> (sfid-20130305_012839_059636_F0D35006)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Host sleep wakeup condition is configured using this command.

Supports Wake-on: pumb

For examples:

wake-on any unicast packets:
ethtool -s mlan0 wol u

wake-on multicast/broadcast packet:
ethtool -s mlan0 wol mb

wake-on unicast packets and MAC events:
ethtool -s mlan0 wol pu

wake-on unicast/multicast/broadcast packets and MAC events:
ethtool -s mlan0 wol pmbu

disable all wake-on options:
ethtool -s mlan0 wol d

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile   |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c |    1 +
 drivers/net/wireless/mwifiex/ethtool.c  |   70 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h       |    4 ++
 drivers/net/wireless/mwifiex/main.h     |    2 +
 5 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/ethtool.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 97b245c..ecf2846 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -39,6 +39,7 @@ mwifiex-y += sta_tx.o
 mwifiex-y += sta_rx.o
 mwifiex-y += uap_txrx.o
 mwifiex-y += cfg80211.o
+mwifiex-y += ethtool.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a44023a..45790fa 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2235,6 +2235,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
 	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
+	dev->ethtool_ops = &mwifiex_ethtool_ops;
 
 	mdev_priv = netdev_priv(dev);
 	*((unsigned long *) mdev_priv) = (unsigned long) priv;
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
new file mode 100644
index 0000000..bfb3990
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -0,0 +1,70 @@
+/*
+ * Marvell Wireless LAN device driver: ethtool
+ *
+ * Copyright (C) 2013, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "main.h"
+
+static void mwifiex_ethtool_get_wol(struct net_device *dev,
+				    struct ethtool_wolinfo *wol)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	u32 conditions = le32_to_cpu(priv->adapter->hs_cfg.conditions);
+
+	wol->supported = WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY;
+
+	if (conditions == HS_CFG_COND_DEF)
+		return;
+
+	if (conditions & HS_CFG_COND_UNICAST_DATA)
+		wol->wolopts |= WAKE_UCAST;
+	if (conditions & HS_CFG_COND_MULTICAST_DATA)
+		wol->wolopts |= WAKE_MCAST;
+	if (conditions & HS_CFG_COND_BROADCAST_DATA)
+		wol->wolopts |= WAKE_BCAST;
+	if (conditions & HS_CFG_COND_MAC_EVENT)
+		wol->wolopts |= WAKE_PHY;
+}
+
+static int mwifiex_ethtool_set_wol(struct net_device *dev,
+				   struct ethtool_wolinfo *wol)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	u32 conditions = 0;
+
+	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
+		return -EOPNOTSUPP;
+
+	if (wol->wolopts & WAKE_UCAST)
+		conditions |= HS_CFG_COND_UNICAST_DATA;
+	if (wol->wolopts & WAKE_MCAST)
+		conditions |= HS_CFG_COND_MULTICAST_DATA;
+	if (wol->wolopts & WAKE_BCAST)
+		conditions |= HS_CFG_COND_BROADCAST_DATA;
+	if (wol->wolopts & WAKE_PHY)
+		conditions |= HS_CFG_COND_MAC_EVENT;
+	if (wol->wolopts == 0)
+		conditions |= HS_CFG_COND_DEF;
+	priv->adapter->hs_cfg.conditions = cpu_to_le32(conditions);
+
+	return 0;
+}
+
+const struct ethtool_ops mwifiex_ethtool_ops = {
+	.get_wol = mwifiex_ethtool_get_wol,
+	.set_wol = mwifiex_ethtool_set_wol,
+};
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 270685e..5a5d066 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -380,6 +380,10 @@ enum P2P_MODES {
 #define HS_CFG_COND_DEF			0x00000000
 #define HS_CFG_GPIO_DEF			0xff
 #define HS_CFG_GAP_DEF			0
+#define HS_CFG_COND_BROADCAST_DATA	0x00000001
+#define HS_CFG_COND_UNICAST_DATA	0x00000002
+#define HS_CFG_COND_MAC_EVENT		0x00000004
+#define HS_CFG_COND_MULTICAST_DATA	0x00000008
 
 #define MWIFIEX_TIMEOUT_FOR_AP_RESP		0xfffc
 #define MWIFIEX_STATUS_CODE_AUTH_TIMEOUT	2
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 553adfb..989e05e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1103,6 +1103,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv);
 u8 *mwifiex_11d_code_2_region(u8 code);
 
+extern const struct ethtool_ops mwifiex_ethtool_ops;
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
-- 
1.7.0.2

