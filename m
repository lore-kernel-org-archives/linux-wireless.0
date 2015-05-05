Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36075 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965617AbbEEHRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 03:17:47 -0400
Date: Tue, 5 May 2015 08:17:41 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: joe@perchescom
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] adm8211: fix checkpatch error for trailing statements on
 next line
Message-ID: <20150505071741.GA2678@bytefire-computer> (sfid-20150505_091842_132542_77CFC42F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes these checkpatch.pl errors:

ERROR: trailing statements should be on next line
ERROR: switch and case should be at the same indent

More specifically, the fix has been applied to the five occurances of the errors listed below.

ERROR: trailing statements should be on next line
#1101: FILE: drivers/net/wireless/adm8211.c:1101:
+		case  0x8: reg |= (0x1 << 14);

ERROR: trailing statements should be on next line
#1103: FILE: drivers/net/wireless/adm8211.c:1103:
+		case 0x16: reg |= (0x2 << 14);

ERROR: trailing statements should be on next line
#1105: FILE: drivers/net/wireless/adm8211.c:1105:
+		case 0x32: reg |= (0x3 << 14);

ERROR: trailing statements should be on next line
#1107: FILE: drivers/net/wireless/adm8211.c:1107:
+		default: reg |= (0x0 << 14);

ERROR: switch and case should be at the same indent
#1100: FILE: adm8211.c:1100:
+		switch (cline) {
[...]
+		  default:


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
+		default:
+			reg |= (0x0 << 14);
+			break;
 		}
 	}
 
-- 
1.9.1

