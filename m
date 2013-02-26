Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58968 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959Ab3BZJIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 04:08:05 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so2123158eek.23
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 01:08:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: define BCMA wireless specific PLLs
Date: Tue, 26 Feb 2013 10:07:57 +0100
Message-Id: <1361869677-29919-1-git-send-email-zajec5@gmail.com> (sfid-20130226_100811_242212_D606C997)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h  |    6 ++++++
 drivers/net/wireless/b43/main.c |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 10e288d..fe4a77e 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -473,6 +473,12 @@ enum {
 #define B43_MACCMD_CCA			0x00000008	/* Clear channel assessment */
 #define B43_MACCMD_BGNOISE		0x00000010	/* Background noise */
 
+/* See BCMA_CLKCTLST_EXTRESREQ and BCMA_CLKCTLST_EXTRESST */
+#define B43_BCMA_CLKCTLST_80211_PLL_REQ	0x00000100
+#define B43_BCMA_CLKCTLST_PHY_PLL_REQ	0x00000200
+#define B43_BCMA_CLKCTLST_80211_PLL_ST	0x01000000
+#define B43_BCMA_CLKCTLST_PHY_PLL_ST	0x02000000
+
 /* BCMA 802.11 core specific IO Control (BCMA_IOCTL) flags */
 #define B43_BCMA_IOCTL_PHY_CLKEN	0x00000004	/* PHY Clock Enable */
 #define B43_BCMA_IOCTL_PHY_RESET	0x00000008	/* PHY Reset */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 806e34c..c974cf5 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1189,10 +1189,15 @@ static void b43_bcma_phy_reset(struct b43_wldev *dev)
 
 static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 {
+	u32 req = B43_BCMA_CLKCTLST_80211_PLL_REQ |
+		  B43_BCMA_CLKCTLST_PHY_PLL_REQ;
+	u32 status = B43_BCMA_CLKCTLST_80211_PLL_ST |
+		     B43_BCMA_CLKCTLST_PHY_PLL_ST;
+
 	b43_device_enable(dev, B43_BCMA_IOCTL_PHY_CLKEN);
 	bcma_core_set_clockmode(dev->dev->bdev, BCMA_CLKMODE_FAST);
 	b43_bcma_phy_reset(dev);
-	bcma_core_pll_ctl(dev->dev->bdev, 0x300, 0x3000000, true);
+	bcma_core_pll_ctl(dev->dev->bdev, req, status, true);
 }
 #endif
 
-- 
1.7.10.4

