Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15638 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDAIrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:49 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 6/7] staging: wilc1000: adds a cfg80211_disconnected() function
Date: Fri, 1 Apr 2016 17:44:18 +0900
Message-ID: <1459500259-27873-6-git-send-email-leo.kim@atmel.com> (sfid-20160401_104753_253861_2F2C5F76)
In-Reply-To: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
References: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is adds a cfg80211_disconnected() when connection is lost already.
We was find this situation while test the 'rmmod sdio'.
SDIO remove function are include both remove mac_close and unregister net_device.
That is received one more a disconnect cmd from cfg80211.
Driver was already performed disconnect.
If wilc->close value was set to true, adds a call to cfg80211_disconnected().

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 358632b..1ac835b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -819,11 +819,22 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	struct wilc_priv *priv;
 	struct host_if_drv *pstrWFIDrv;
 	struct wilc_vif *vif;
+	struct wilc *wilc;
 	u8 NullBssid[ETH_ALEN] = {0};
 
 	wilc_connecting = 0;
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
+	wilc = vif->wilc;
+
+	if (!wilc)
+		return -EIO;
+
+	if (wilc->close) {
+		/* already disconnected done */
+		cfg80211_disconnected(dev, 0, NULL, 0, true, GFP_KERNEL);
+		return 0;
+	}
 
 	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
 	if (!pstrWFIDrv->p2p_connect)
-- 
1.9.1

