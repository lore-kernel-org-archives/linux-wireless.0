Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44288 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab0G2SAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:00:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] p54: update fw version info in wiphy struct
Date: Thu, 29 Jul 2010 13:45:58 -0400
Message-Id: <1280425558-19585-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/p54/fwio.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 47006bc..6f027ab 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -123,10 +123,14 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		bootrec = (struct bootrec *)&bootrec->data[len];
 	}
 
-	if (fw_version)
+	if (fw_version) {
 		wiphy_info(priv->hw->wiphy,
 			   "fw rev %s - softmac protocol %x.%x\n",
 			   fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
+		snprintf(dev->wiphy->fw_version, sizeof(dev->wiphy->fw_version),
+				"%s - %x.%x", fw_version,
+				priv->fw_var >> 8, priv->fw_var & 0xff);
+	}
 
 	if (priv->fw_var < 0x500)
 		wiphy_info(priv->hw->wiphy,
-- 
1.7.1.1

