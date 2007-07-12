Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbXGLIKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 04:10:14 -0400
Date: Thu, 12 Jul 2007 16:09:32 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Fix ipw2200 set wrong power parameter causing firmware error
Message-ID: <20070712080932.GA28315@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power mode can only be set 0~5 to firmware. Otherwise there will be a
firmware error generated. This patch fixed the invalid power mode requested
by driver.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/ipw2200.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 7cb2052..bd0a8ff 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -2506,7 +2506,7 @@ static int ipw_send_power_mode(struct ipw_priv *priv, u32 mode)
 		break;
 	}
 
-	param = cpu_to_le32(mode);
+	param = cpu_to_le32(param);
 	return ipw_send_cmd_pdu(priv, IPW_CMD_POWER_MODE, sizeof(param),
 				&param);
 }
@@ -9567,6 +9567,7 @@ static int ipw_wx_set_power(struct net_device *dev,
 		priv->power_mode = IPW_POWER_ENABLED | IPW_POWER_BATTERY;
 	else
 		priv->power_mode = IPW_POWER_ENABLED | priv->power_mode;
+
 	err = ipw_send_power_mode(priv, IPW_POWER_LEVEL(priv->power_mode));
 	if (err) {
 		IPW_DEBUG_WX("failed setting power mode.\n");
@@ -9603,22 +9604,19 @@ static int ipw_wx_set_powermode(struct net_device *dev,
 	struct ipw_priv *priv = ieee80211_priv(dev);
 	int mode = *(int *)extra;
 	int err;
+
 	mutex_lock(&priv->mutex);
-	if ((mode < 1) || (mode > IPW_POWER_LIMIT)) {
+	if ((mode < 1) || (mode > IPW_POWER_LIMIT))
 		mode = IPW_POWER_AC;
-		priv->power_mode = mode;
-	} else {
-		priv->power_mode = IPW_POWER_ENABLED | mode;
-	}
 
-	if (priv->power_mode != mode) {
+	if (IPW_POWER_LEVEL(priv->power_mode) != mode) {
 		err = ipw_send_power_mode(priv, mode);
-
 		if (err) {
 			IPW_DEBUG_WX("failed setting power mode.\n");
 			mutex_unlock(&priv->mutex);
 			return err;
 		}
+		priv->power_mode = IPW_POWER_ENABLED | mode;
 	}
 	mutex_unlock(&priv->mutex);
 	return 0;
-- 
1.5.2
