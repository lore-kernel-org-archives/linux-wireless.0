Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35089 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbbJTGqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:19 -0400
Received: by lbbes7 with SMTP id es7so7765874lbb.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:18 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 03/16] rtl8xxxu: Don't check for illegal offset when reading from efuse
Date: Tue, 20 Oct 2015 08:45:33 +0200
Message-Id: <1445323546-12807-4-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084623_459517_BAE23394)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is enough to check for either illegal offset or illegal map address
because map address is a value derived from an offset:

  map_addr = offset * 8
  EFUSE_MAP_LEN_8723A = EFUSE_MAX_SECTION_8723A * 8

Leave just the check for an illegal map address because its upper
bound (EFUSE_MAP_LEN_8723A) is used also in a couple other places.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 63 +++++++++++-------------
 1 file changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a8d7e0a..79efdc2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1973,6 +1973,8 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
 	efuse_addr = 0;
 	while (efuse_addr < EFUSE_REAL_CONTENT_LEN_8723A) {
+		u16 map_addr;
+
 		ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &header);
 		if (ret || header == 0xff)
 			goto exit;
@@ -1995,45 +1997,36 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 			word_mask = header & 0x0f;
 		}
 
-		if (offset < EFUSE_MAX_SECTION_8723A) {
-			u16 map_addr;
-			/* Get word enable value from PG header */
+		/* Get word enable value from PG header */
 
-			/* We have 8 bits to indicate validity */
-			map_addr = offset * 8;
-			if (map_addr >= EFUSE_MAP_LEN_8723A) {
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
+		if (map_addr >= EFUSE_MAP_LEN_8723A) {
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
2.1.0

