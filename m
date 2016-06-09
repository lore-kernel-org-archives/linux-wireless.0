Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbcFISiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 14:38:52 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 3/4] rtl8xxxu: tuse %*ph to dump buffers
Date: Thu,  9 Jun 2016 14:38:49 -0400
Message-Id: <1465497530-18510-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160609_203901_949537_50771BC2)
In-Reply-To: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Use %*ph specifier to dump small buffers in hex format instead of doing this
byte-by-byte.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c | 9 ++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 9 ++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 9 ++-------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index 2c86b55..eefb7ca 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -413,13 +413,8 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 		dev_info(&priv->udev->dev,
 			 "%s: dumping efuse (0x%02zx bytes):\n",
 			 __func__, sizeof(struct rtl8192cu_efuse));
-		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i += 8) {
-			dev_info(&priv->udev->dev, "%02x: "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
-				 raw[i], raw[i + 1], raw[i + 2],
-				 raw[i + 3], raw[i + 4], raw[i + 5],
-				 raw[i + 6], raw[i + 7]);
-		}
+		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i += 8)
+			dev_info(&priv->udev->dev, "%02x: %8ph\n", i, &raw[i]);
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index fe19ace..65c079a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -622,13 +622,8 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 		dev_info(&priv->udev->dev,
 			 "%s: dumping efuse (0x%02zx bytes):\n",
 			 __func__, sizeof(struct rtl8192eu_efuse));
-		for (i = 0; i < sizeof(struct rtl8192eu_efuse); i += 8) {
-			dev_info(&priv->udev->dev, "%02x: "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
-				 raw[i], raw[i + 1], raw[i + 2],
-				 raw[i + 3], raw[i + 4], raw[i + 5],
-				 raw[i + 6], raw[i + 7]);
-		}
+		for (i = 0; i < sizeof(struct rtl8192eu_efuse); i += 8)
+			dev_info(&priv->udev->dev, "%02x: %8ph\n", i, &raw[i]);
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 4186e7c..9d45afb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -466,13 +466,8 @@ static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 		dev_info(&priv->udev->dev,
 			 "%s: dumping efuse (0x%02zx bytes):\n",
 			 __func__, sizeof(struct rtl8723bu_efuse));
-		for (i = 0; i < sizeof(struct rtl8723bu_efuse); i += 8) {
-			dev_info(&priv->udev->dev, "%02x: "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
-				 raw[i], raw[i + 1], raw[i + 2],
-				 raw[i + 3], raw[i + 4], raw[i + 5],
-				 raw[i + 6], raw[i + 7]);
-		}
+		for (i = 0; i < sizeof(struct rtl8723bu_efuse); i += 8)
+			dev_info(&priv->udev->dev, "%02x: %8ph\n", i, &raw[i]);
 	}
 
 	return 0;
-- 
2.5.5

