Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55670 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2CCUYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 15:24:47 -0500
Received: by eaaq12 with SMTP id q12so970782eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 12:24:46 -0800 (PST)
Subject: [PATCH 1/2] p54: pass interface setup errors back to mac80211
Cc: linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 3 Mar 2012 21:24:43 +0100
To: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201203032124.43228.chunkeey@googlemail.com> (sfid-20120303_212451_068194_EB0850F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 9c2d3d1..765e098 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -227,6 +227,7 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 			     struct ieee80211_vif *vif)
 {
 	struct p54_common *priv = dev->priv;
+	int err;
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 
@@ -251,9 +252,9 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 	}
 
 	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
-	p54_setup_mac(priv);
+	err = p54_setup_mac(priv);
 	mutex_unlock(&priv->conf_mutex);
-	return 0;
+	return err;
 }
 
 static void p54_remove_interface(struct ieee80211_hw *dev,
-- 
1.7.9.1

