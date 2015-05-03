Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34463 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbECKmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 06:42:35 -0400
Date: Sun, 3 May 2015 11:42:31 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: adm8211: fix checkpatch error for trailing
 statements on next line
Message-ID: <20150503104231.GA3607@bytefire-computer> (sfid-20150503_124241_164280_18583C3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl error:

ERROR: trailing statements should be on next line

More specifically, the fix has been applied to the four occurances of the error listed below.

ERROR: trailing statements should be on next line
#1101: FILE: drivers/net/wireless/adm8211.c:1101:
+               case  0x8: reg |= (0x1 << 14);

ERROR: trailing statements should be on next line
#1103: FILE: drivers/net/wireless/adm8211.c:1103:
+               case 0x16: reg |= (0x2 << 14);

ERROR: trailing statements should be on next line
#1105: FILE: drivers/net/wireless/adm8211.c:1105:
+               case 0x32: reg |= (0x3 << 14);

ERROR: trailing statements should be on next line
#1107: FILE: drivers/net/wireless/adm8211.c:1107:
+                 default: reg |= (0x0 << 14);

Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>
---
 drivers/net/wireless/adm8211.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f07a618..79e4e5f 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1098,14 +1098,18 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 		pci_read_config_byte(priv->pdev, PCI_CACHE_LINE_SIZE, &cline);
 
 		switch (cline) {
-		case  0x8: reg |= (0x1 << 14);
-			   break;
-		case 0x16: reg |= (0x2 << 14);
-			   break;
-		case 0x32: reg |= (0x3 << 14);
-			   break;
-		  default: reg |= (0x0 << 14);
-			   break;
+		case  0x8:
+			reg |= (0x1 << 14);
+			break;
+		case 0x16:
+			reg |= (0x2 << 14);
+			break;
+		case 0x32:
+			reg |= (0x3 << 14);
+			break;
+		  default:
+			reg |= (0x0 << 14);
+			break;
 		}
 	}
 
-- 
1.9.1
