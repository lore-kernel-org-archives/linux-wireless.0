Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jakub Sitnicki <jsitnicki@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 026/113] rtl8xxxu: Skip disabled efuse words early
Date: Mon, 29 Feb 2016 17:04:24 -0500
Message-Id: <1456783551-28315-27-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231111_519512_0FA40923)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Sitnicki <jsitnicki@gmail.com>

Avoid a negative conditional and an extra level of indentation in the
bigger part of the loop body.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 28 +++++++++++-------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index eb0203c..2b9664e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2454,22 +2454,20 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 		}
 		for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
 			/* Check word enable condition in the section */
-			if (!(word_mask & BIT(i))) {
-				ret = rtl8xxxu_read_efuse8(priv,
-							   efuse_addr++,
-							   &val8);
-				if (ret)
-					goto exit;
-				priv->efuse_wifi.raw[map_addr++] = val8;
-
-				ret = rtl8xxxu_read_efuse8(priv,
-							   efuse_addr++,
-							   &val8);
-				if (ret)
-					goto exit;
-				priv->efuse_wifi.raw[map_addr++] = val8;
-			} else
+			if (word_mask & BIT(i)) {
 				map_addr += 2;
+				continue;
+			}
+
+			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &val8);
+			if (ret)
+				goto exit;
+			priv->efuse_wifi.raw[map_addr++] = val8;
+
+			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &val8);
+			if (ret)
+				goto exit;
+			priv->efuse_wifi.raw[map_addr++] = val8;
 		}
 	}
 
-- 
2.5.0

