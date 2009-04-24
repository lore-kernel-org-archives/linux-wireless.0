Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53461 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbZDXTlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 15:41:31 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ar9170: uncomment powermgt case handle
Date: Fri, 24 Apr 2009 21:41:18 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904242141.19266.chunkeey@web.de> (sfid-20090424_214151_442826_5B6EE961)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uncomment a few lines that survived the RFCs.
However, there is not much to worry about, since AP mode is
not officially advertised and supported.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 4ee3223..f28a4c2 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -268,9 +268,9 @@ int ar9170_set_operating_mode(struct ar9170 *ar)
 		case NL80211_IFTYPE_ADHOC:
 			pm_mode |= AR9170_MAC_REG_POWERMGT_IBSS;
 			break;
-/*		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_AP:
 			pm_mode |= AR9170_MAC_REG_POWERMGT_AP;
-			break;*/
+			break;
 		case NL80211_IFTYPE_WDS:
 			pm_mode |= AR9170_MAC_REG_POWERMGT_AP_WDS;
 			break;
