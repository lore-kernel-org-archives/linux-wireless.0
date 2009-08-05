Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42204 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZHEUY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:24:27 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so285565ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:24:28 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 5/6] orinoco: add function to retrieve current bssid
Date: Wed,  5 Aug 2009 21:23:31 +0100
Message-Id: <1249503812-16921-6-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
References: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will need this from the cfg80211 disassociate call.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |   12 ++++++++++++
 drivers/net/wireless/orinoco/hw.h   |    2 ++
 drivers/net/wireless/orinoco/wext.c |    4 +---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 3e9021c..5b12654 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -1272,3 +1272,15 @@ int orinoco_hw_disassociate(struct orinoco_private *priv,
 				  &buf);
 	return err;
 }
+
+int orinoco_hw_get_current_bssid(struct orinoco_private *priv,
+				 u8 *addr)
+{
+	hermes_t *hw = &priv->hw;
+	int err;
+
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
+			      ETH_ALEN, NULL, addr);
+
+	return err;
+}
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index b096786..8df6e87 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -53,5 +53,7 @@ int orinoco_hw_trigger_scan(struct orinoco_private *priv,
 			    const struct cfg80211_ssid *ssid);
 int orinoco_hw_disassociate(struct orinoco_private *priv,
 			    u8 *addr, u16 reason_code);
+int orinoco_hw_get_current_bssid(struct orinoco_private *priv,
+				 u8 *addr);
 
 #endif /* _ORINOCO_HW_H_ */
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index f324bf9..f68bbe3 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -156,7 +156,6 @@ static int orinoco_ioctl_getwap(struct net_device *dev,
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 
-	hermes_t *hw = &priv->hw;
 	int err = 0;
 	unsigned long flags;
 
@@ -164,8 +163,7 @@ static int orinoco_ioctl_getwap(struct net_device *dev,
 		return -EBUSY;
 
 	ap_addr->sa_family = ARPHRD_ETHER;
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
-			      ETH_ALEN, NULL, ap_addr->sa_data);
+	err = orinoco_hw_get_current_bssid(priv, ap_addr->sa_data);
 
 	orinoco_unlock(priv, &flags);
 
-- 
1.6.3.3

