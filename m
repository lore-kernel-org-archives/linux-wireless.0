Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:57213 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZH1J7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:59:19 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 7/8] rndis_wlan: set ieee80211_ptr->iftype in
	rndis_change_virtual_intf
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:59:21 +0300
Message-ID: <20090828095921.10554.51249.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c28fde5..d117620 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1526,7 +1526,8 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy,
 					enum nl80211_iftype type, u32 *flags,
 					struct vif_params *params)
 {
-	struct usbnet *usbdev = netdev_priv(dev);
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
 	int mode;
 
 	switch (type) {
@@ -1540,6 +1541,8 @@ static int rndis_change_virtual_intf(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
+	priv->wdev.iftype = type;
+
 	return set_infra_mode(usbdev, mode);
 }
 

