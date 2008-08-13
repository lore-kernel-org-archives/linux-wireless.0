Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:49674 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYHMViy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 17:38:54 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: move p54_vdcf_init to the right place.
Date: Wed, 13 Aug 2008 23:41:45 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	navilein@hotmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808132341.45874.chunkeey@web.de> (sfid-20080813_233858_533074_D0DAD000)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->tx_hdr_len is set by the driver _after_ it called p54_init_common.
While this isn't much a problem for any PCI or ISL3887 cards/sticks,
because they don't need any extra header and therefore tx_hdr_len is
zero for them...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---

Larry, do you have any comments?
Because this series will eventually go to stable@kernel.org too... 

---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-13 20:50:03.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-13 20:55:42.000000000 +0200
@@ -834,10 +834,21 @@ static int p54_start(struct ieee80211_hw
 	struct p54_common *priv = dev->priv;
 	int err;
 
+	if (!priv->cached_vdcf) {
+		priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf)+
+			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
+			GFP_KERNEL);
+
+		if (!priv->cached_vdcf)
+			return -ENOMEM;
+	}
+
 	err = priv->open(dev);
 	if (!err)
 		priv->mode = IEEE80211_IF_TYPE_MNTR;
 
+	p54_init_vdcf(dev);
+
 	return err;
 }
 
@@ -1017,15 +1028,6 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
-        priv->cached_vdcf = kzalloc(sizeof(struct p54_tx_control_vdcf) +
-              priv->tx_hdr_len + sizeof(struct p54_control_hdr), GFP_KERNEL);
-
-	if (!priv->cached_vdcf) {
-		ieee80211_free_hw(dev);
-		return NULL;
-	}
-
-	p54_init_vdcf(dev);
 	mutex_init(&priv->conf_mutex);
 
 	return dev;

