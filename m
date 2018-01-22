Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0074.outbound.protection.outlook.com ([104.47.38.74]:1664
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751113AbeAVMrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:06 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 05/11] qtnfmac: report hardware/firmware information via ethtool
Date: Mon, 22 Jan 2018 15:46:28 +0300
Message-Id: <20180122124634.8430-6-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134712_978381_829D976F)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

Enable reporting of qtnfmac hardware and firmware details
using ethtool command.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 4 ++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 +++
 drivers/net/wireless/quantenna/qtnfmac/core.c     | 5 +++++
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 2 ++
 4 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index c417a67b0291..03f819076197 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -972,6 +972,10 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
 	}
 
+	strlcpy(wiphy->fw_version, hw_info->fw_version,
+		sizeof(wiphy->fw_version));
+	wiphy->hw_version = hw_info->hw_version;
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index d6bfb257cdae..2017532477c9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1107,6 +1107,9 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		(unsigned long)plat_id,
 		hw_id, calibration_ver, uboot_ver, hw_ver);
 
+	strlcpy(hwinfo->fw_version, bld_label, sizeof(hwinfo->fw_version));
+	hwinfo->hw_version = hw_ver;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index c10f24f0a0ce..1acbe30dfc66 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -331,6 +331,10 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 	return mac;
 }
 
+static const struct ethtool_ops qtnf_ethtool_ops = {
+	.get_drvinfo = cfg80211_get_drvinfo,
+};
+
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 			 const char *name, unsigned char name_assign_type)
 {
@@ -358,6 +362,7 @@ int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	dev->watchdog_timeo = QTNF_DEF_WDOG_TIMEOUT;
 	dev->tx_queue_len = 100;
+	dev->ethtool_ops = &qtnf_ethtool_ops;
 
 	qdev_vif = netdev_priv(dev);
 	*((void **)qdev_vif) = vif;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 09fa5d28cc2a..e47198cbcceb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -145,6 +145,8 @@ struct qtnf_hw_info {
 	struct ieee80211_regdomain *rd;
 	u8 total_tx_chain;
 	u8 total_rx_chain;
+	char fw_version[ETHTOOL_FWVERS_LEN];
+	u32 hw_version;
 };
 
 struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
-- 
2.11.0
