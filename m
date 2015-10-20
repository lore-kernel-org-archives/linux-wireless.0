Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:34298 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbJTGqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:20 -0400
Received: by lfaz124 with SMTP id z124so718542lfa.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:19 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 04/16] rtl8xxxu: Skip disabled efuse words early
Date: Tue, 20 Oct 2015 08:45:34 +0200
Message-Id: <1445323546-12807-5-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084625_407058_60EC16EF)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid a negative conditional and an extra level of indentation in the
bigger part of the loop body.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 28 +++++++++++-------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 79efdc2..cfb18db 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2010,22 +2010,20 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
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
2.1.0

