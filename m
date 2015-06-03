Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-outd.mail.t-online.hu ([195.228.240.69]:58575 "EHLO
	mail-outd.mail.t-online.hu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759199AbbFCMwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 08:52:18 -0400
From: Robert Hodaszi <robert.hodaszi@digi.com>
To: davem@davemloft.net
Cc: johannes.berg@intel.com, royujjal@gmail.com,
	linux-wireless@vger.kernel.org,
	Robert Hodaszi <robert.hodaszi@digi.com>
Subject: [PATCH] cfg80211: modify lower retry limit to 0
Date: Wed,  3 Jun 2015 14:46:00 +0200
Message-Id: <1433335560-17985-1-git-send-email-robert.hodaszi@digi.com> (sfid-20150603_145244_934464_B91AF765)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Robert Hodaszi <robert.hodaszi@digi.com>

To disable the transmit retries on RT28xx driver, the retry limit should
be set to 0. The current lower limit (1) prevents it.

Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index fff1bef..6e38320 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -370,7 +370,7 @@ static int cfg80211_wext_siwretry(struct net_device *dev,
 	u8 oshort = wdev->wiphy->retry_short;
 	int err;
 
-	if (retry->disabled || retry->value < 1 || retry->value > 255 ||
+	if (retry->disabled || retry->value < 0 || retry->value > 255 ||
 	    (retry->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
 		return -EINVAL;
 
