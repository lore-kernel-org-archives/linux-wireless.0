Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53984 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbcCRM0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 08:26:07 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: fixed kernel panic when firmware is not started
Date: Fri, 18 Mar 2016 21:23:16 +0900
Message-ID: <1458303796-547-1-git-send-email-leo.kim@atmel.com> (sfid-20160318_132611_271289_1323AFA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixed the problems caused by if firmware is not started.
That is why, in nl80211 put current TX power in interface info.
If firmware is not started, this function(get_tx_power) does not work.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b76622d..448a5c8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2170,6 +2170,13 @@ static int get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	int ret;
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 	struct wilc_vif *vif = netdev_priv(priv->dev);
+	struct wilc *wl;
+
+	wl = vif->wilc;
+
+	/* If firmware is not started, return. */
+	if (!wl->initialized)
+		return -EIO;
 
 	ret = wilc_get_tx_power(vif, (u8 *)dbm);
 	if (ret)
-- 
1.9.1

