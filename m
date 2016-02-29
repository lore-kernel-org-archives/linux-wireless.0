Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jakub Sitnicki <jsitnicki@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 025/113] rtl8xxxu: Don't check for illegal offset when reading from efuse
Date: Mon, 29 Feb 2016 17:04:23 -0500
Message-Id: <1456783551-28315-26-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231109_191273_9BBD1176)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Sitnicki <jsitnicki@gmail.com>

It is enough to check for either illegal offset or illegal map address
because map address is a value derived from an offset:

  map_addr = offset * 8
  EFUSE_MAP_LEN = EFUSE_MAX_SECTION_8723A * 8

Leave just the check for an illegal map address because its upper
bound (EFUSE_MAP_LEN) is used also in a couple other places.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 63 +++++++++++-------------
 1 file changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 2ff7430..eb0203c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2417,6 +2417,8 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
 	efuse_addr = 0;
 	while (efuse_addr < EFUSE_REAL_CONTENT_LEN_8723A) {
+		u16 map_addr;
+
 		ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &header);
 		if (ret || header == 0xff)
 			goto exit;
@@ -2439,45 +2441,36 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 			word_mask = header & 0x0f;
 		}
 
-		if (offset < EFUSE_MAX_SECTION_8723A) {
-			u16 map_addr;
-			/* Get word enable value from PG header */
+		/* Get word enable value from PG header */
 
-			/* We have 8 bits to indicate validity */
-			map_addr = offset * 8;
-			if (map_addr >= EFUSE_MAP_LEN) {
-				dev_warn(dev, "%s: Illegal map_addr (%04x), "
-					 "efuse corrupt!\n",
-					 __func__, map_addr);
-				ret = -EINVAL;
-				goto exit;
-			}
-			for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
-				/* Check word enable condition in the section */
-				if (!(word_mask & BIT(i))) {
-					ret = rtl8xxxu_read_efuse8(priv,
-								   efuse_addr++,
-								   &val8);
-					if (ret)
-						goto exit;
-					priv->efuse_wifi.raw[map_addr++] = val8;
-
-					ret = rtl8xxxu_read_efuse8(priv,
-								   efuse_addr++,
-								   &val8);
-					if (ret)
-						goto exit;
-					priv->efuse_wifi.raw[map_addr++] = val8;
-				} else
-					map_addr += 2;
-			}
-		} else {
-			dev_warn(dev,
-				 "%s: Illegal offset (%04x), efuse corrupt!\n",
-				 __func__, offset);
+		/* We have 8 bits to indicate validity */
+		map_addr = offset * 8;
+		if (map_addr >= EFUSE_MAP_LEN) {
+			dev_warn(dev, "%s: Illegal map_addr (%04x), "
+				 "efuse corrupt!\n",
+				 __func__, map_addr);
 			ret = -EINVAL;
 			goto exit;
 		}
+		for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
+			/* Check word enable condition in the section */
+			if (!(word_mask & BIT(i))) {
+				ret = rtl8xxxu_read_efuse8(priv,
+							   efuse_addr++,
+							   &val8);
+				if (ret)
+					goto exit;
+				priv->efuse_wifi.raw[map_addr++] = val8;
+
+				ret = rtl8xxxu_read_efuse8(priv,
+							   efuse_addr++,
+							   &val8);
+				if (ret)
+					goto exit;
+				priv->efuse_wifi.raw[map_addr++] = val8;
+			} else
+				map_addr += 2;
+		}
 	}
 
 exit:
-- 
2.5.0

