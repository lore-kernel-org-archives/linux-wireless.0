Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33906 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbEELhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 07:37:37 -0400
Date: Tue, 5 May 2015 12:37:31 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] adm8211: fix checkpatch errors for indentation and new line
 around switch-case
Message-ID: <20150505113731.GA2885@bytefire-computer> (sfid-20150505_133800_631238_45933537)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes these checkpatch.pl errors around a single switch-case block:

ERROR: switch and case should be at the same indent
ERROR: trailing statements should be on next line

More specifically, the fix has been applied to the five occurances of the errors listed below.

ERROR: switch and case should be at the same indent
#1100: FILE: adm8211.c:1100:
+		switch (cline) {
[...]
+		  default: reg |= (0x0 << 14);

ERROR: trailing statements should be on next line
#1101: FILE: adm8211.c:1101:
+		case  0x8: reg |= (0x1 << 14);

ERROR: trailing statements should be on next line
#1103: FILE: adm8211.c:1103:
+		case 0x16: reg |= (0x2 << 14);

ERROR: trailing statements should be on next line
#1105: FILE: adm8211.c:1105:
+		case 0x32: reg |= (0x3 << 14);

ERROR: trailing statements should be on next line
#1107: FILE: adm8211.c:1107:
+		  default: reg |= (0x0 << 14);

Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>
---
 drivers/net/wireless/adm8211.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f07a618..058fb4b 100644
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

