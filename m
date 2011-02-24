Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:53590 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1BXKZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 05:25:46 -0500
Subject: [PATCH 2.6.38] rndis_wlan: use power save only for BCM4320b
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Feb 2011 12:25:42 +0200
Message-ID: <20110224102542.8302.21738.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCM4320a breaks when enabling power save (bug 29732). So disable power save
for anything but BCM4320b that is known to work.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 848cc2c..518542b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2597,6 +2597,9 @@ static int rndis_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	__le32 mode;
 	int ret;
 
+	if (priv->device_type != RNDIS_BCM4320B)
+		return -ENOTSUPP;
+
 	netdev_dbg(usbdev->net, "%s(): %s, %d\n", __func__,
 				enabled ? "enabled" : "disabled",
 				timeout);

