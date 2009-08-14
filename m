Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37477 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbZHNTL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 15:11:59 -0400
Received: by bwz22 with SMTP id 22so1313426bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 12:11:59 -0700 (PDT)
Message-ID: <4A85B6FF.8070304@gmail.com>
Date: Fri, 14 Aug 2009 21:11:59 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Don't adjust gain table for rev2+ when setting
 channel
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rev2+ never needs to have gain tables adjusted according to the spec.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 76457f7..adfa7bf 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -2059,10 +2059,9 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
 		if (err)
 			return err;
 		lpphy_japan_filter(dev, new_channel);
+		lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
 	}
 
-	lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
-
 	return 0;
 }
 
-- 
1.6.2.4



