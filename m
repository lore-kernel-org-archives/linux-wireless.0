Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42204 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZHEUYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:24:24 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so285565ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:24:25 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 4/6] orinoco: move disassociation to hw.c
Date: Wed,  5 Aug 2009 21:23:30 +0100
Message-Id: <1249503812-16921-5-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
References: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the disassociation to be called via cfg80211.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |   24 ++++++++++++++++++++++++
 drivers/net/wireless/orinoco/hw.h   |    2 ++
 drivers/net/wireless/orinoco/wext.c |   17 ++++-------------
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 35516a9..3e9021c 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -1248,3 +1248,27 @@ int orinoco_hw_trigger_scan(struct orinoco_private *priv,
 
 	return err;
 }
+
+/* Disassociate from node with BSSID addr */
+int orinoco_hw_disassociate(struct orinoco_private *priv,
+			    u8 *addr, u16 reason_code)
+{
+	hermes_t *hw = &priv->hw;
+	int err;
+
+	struct {
+		u8 addr[ETH_ALEN];
+		__le16 reason_code;
+	} __attribute__ ((packed)) buf;
+
+	/* Currently only supported by WPA enabled Agere fw */
+	if (!priv->has_wpa)
+		return -EOPNOTSUPP;
+
+	memcpy(buf.addr, addr, ETH_ALEN);
+	buf.reason_code = cpu_to_le16(reason_code);
+	err = HERMES_WRITE_RECORD(hw, USER_BAP,
+				  HERMES_RID_CNFDISASSOCIATE,
+				  &buf);
+	return err;
+}
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 33a31fa..b096786 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -51,5 +51,7 @@ int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 			       int *numrates, s32 *rates, int max);
 int orinoco_hw_trigger_scan(struct orinoco_private *priv,
 			    const struct cfg80211_ssid *ssid);
+int orinoco_hw_disassociate(struct orinoco_private *priv,
+			    u8 *addr, u16 reason_code);
 
 #endif /* _ORINOCO_HW_H_ */
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 7e18bb4..f324bf9 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1136,7 +1136,6 @@ static int orinoco_ioctl_set_mlme(struct net_device *dev,
 				  union iwreq_data *wrqu, char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	unsigned long flags;
 	int ret = 0;
@@ -1150,19 +1149,11 @@ static int orinoco_ioctl_set_mlme(struct net_device *dev,
 		break;
 
 	case IW_MLME_DISASSOC:
-	{
-		struct {
-			u8 addr[ETH_ALEN];
-			__le16 reason_code;
-		} __attribute__ ((packed)) buf;
-
-		memcpy(buf.addr, mlme->addr.sa_data, ETH_ALEN);
-		buf.reason_code = cpu_to_le16(mlme->reason_code);
-		ret = HERMES_WRITE_RECORD(hw, USER_BAP,
-					  HERMES_RID_CNFDISASSOCIATE,
-					  &buf);
+
+		ret = orinoco_hw_disassociate(priv, mlme->addr.sa_data,
+					      mlme->reason_code);
 		break;
-	}
+
 	default:
 		ret = -EOPNOTSUPP;
 	}
-- 
1.6.3.3

