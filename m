Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:54829 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZAPSqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 13:46:35 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: fix p54_set_key's return code
Date: Fri, 16 Jan 2009 19:46:28 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901161946.28459.chunkeey@web.de> (sfid-20090116_194638_718580_98D716E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54 doesn't support AES-128-CMAC offload.

This patch will fix the noisy mac80211 warnings, when 802.11w is enabled: 
mac80211-phy189: failed to set key (4, ff:ff:ff:ff:ff:ff) to hardware (-22)
mac80211-phy189: failed to set key (5, ff:ff:ff:ff:ff:ff) to hardware (-22)

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 635b423..d706480 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -2355,7 +2355,7 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 			algo = P54_CRYPTO_AESCCMP;
 			break;
 		default:
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 	}
 

