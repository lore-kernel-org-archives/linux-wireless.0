Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15001 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbXGLIKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 04:10:06 -0400
Date: Thu, 12 Jul 2007 16:09:24 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ipw2100: Fix `iwpriv set_power` error
Message-ID: <20070712080924.GA28306@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwpriv <iface> set_power [0~6] can be used for ipw2100. '0' indicates
off and '6' indicates auto. 1~5 are the actual power levels.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/ipw2100.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index d51daf8..3d2a15a 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -7865,10 +7865,10 @@ static int ipw2100_wx_set_powermode(struct net_device *dev,
 		goto done;
 	}
 
-	if ((mode < 1) || (mode > POWER_MODES))
+	if ((mode < 0) || (mode > POWER_MODES))
 		mode = IPW_POWER_AUTO;
 
-	if (priv->power_mode != mode)
+	if (IPW_POWER_LEVEL(priv->power_mode) != mode)
 		err = ipw2100_set_power_mode(priv, mode);
       done:
 	mutex_unlock(&priv->action_mutex);
@@ -7899,7 +7899,7 @@ static int ipw2100_wx_get_powermode(struct net_device *dev,
 			break;
 		case IPW_POWER_AUTO:
 			snprintf(extra, MAX_POWER_STRING,
-				 "Power save level: %d (Auto)", 0);
+				 "Power save level: %d (Auto)", level);
 			break;
 		default:
 			timeout = timeout_duration[level - 1] / 1000;
-- 
1.5.2
