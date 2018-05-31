Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0071.outbound.protection.outlook.com ([104.47.34.71]:24955
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754093AbeEaJLS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:11:18 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 1/6] qtnfmac: implement net_device_ops callback to set MAC address
Date: Thu, 31 May 2018 12:10:57 +0300
Message-Id: <20180531091102.28666-2-sergey.matyukevich.os@quantenna.com> (sfid-20180531_111123_571395_3D4A8726)
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Implement net_device_ops::ndo_set_mac_address callback to allow for
setting interface MAC address. Implementation is done through existing
CHANGE_INTF firmware command. All validation is to be done by firmware.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index a6a450984f9a..c318340e1bd5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -179,6 +179,30 @@ static void qtnf_netdev_tx_timeout(struct net_device *ndev)
 	}
 }
 
+static int qtnf_netdev_set_mac_address(struct net_device *ndev, void *addr)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	struct sockaddr *sa = addr;
+	int ret;
+	unsigned char old_addr[ETH_ALEN];
+
+	memcpy(old_addr, sa->sa_data, sizeof(old_addr));
+
+	ret = eth_mac_addr(ndev, sa);
+	if (ret)
+		return ret;
+
+	qtnf_scan_done(vif->mac, true);
+
+	ret = qtnf_cmd_send_change_intf_type(vif, vif->wdev.iftype,
+					     sa->sa_data);
+
+	if (ret)
+		memcpy(ndev->dev_addr, old_addr, ETH_ALEN);
+
+	return ret;
+}
+
 /* Network device ops handlers */
 const struct net_device_ops qtnf_netdev_ops = {
 	.ndo_open = qtnf_netdev_open,
@@ -186,6 +210,7 @@ const struct net_device_ops qtnf_netdev_ops = {
 	.ndo_start_xmit = qtnf_netdev_hard_start_xmit,
 	.ndo_tx_timeout = qtnf_netdev_tx_timeout,
 	.ndo_get_stats64 = qtnf_netdev_get_stats64,
+	.ndo_set_mac_address = qtnf_netdev_set_mac_address,
 };
 
 static int qtnf_mac_init_single_band(struct wiphy *wiphy,
-- 
2.11.0
