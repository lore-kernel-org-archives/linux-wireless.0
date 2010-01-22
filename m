Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:58253 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0AVAx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:27 -0500
Received: by ey-out-2122.google.com with SMTP id d26so173602eyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 16:53:26 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: check band width
Date: Fri, 22 Jan 2010 01:53:12 +0100
Message-Id: <1264121596-9616-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       |    6 ++++++
 drivers/net/wireless/b43/phy_common.h |    3 +++
 drivers/net/wireless/b43/phy_n.c      |    2 +-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9c5c7c9..a826e68 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3571,6 +3571,12 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	dev = wl->current_dev;
 	phy = &dev->phy;
 
+	if (conf_is_ht(conf))
+		phy->is_40mhz =
+			(conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf));
+	else
+		phy->is_40mhz = false;
+
 	b43_mac_suspend(dev);
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 9edd4e8..f635f9e 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -212,6 +212,9 @@ struct b43_phy {
 	bool supports_2ghz;
 	bool supports_5ghz;
 
+	/* HT info */
+	bool is_40mhz;
+
 	/* GMODE bit enabled? */
 	bool gmode;
 
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e77f1f2..2cdf32e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1787,7 +1787,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 
 	b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
 
-	if (1 /* FIXME: the band width is 20 MHz */)
+	if (!dev->phy.is_40mhz)
 		freq = 2500;
 	else
 		freq = 5000;
-- 
1.6.4.2

