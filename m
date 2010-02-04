Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:5026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab0BDU6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 15:58:08 -0500
Received: by fg-out-1718.google.com with SMTP id e21so118675fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 12:58:05 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: LP-PHY: always adjust gain table on channel switch
Date: Thu,  4 Feb 2010 21:57:45 +0100
Message-Id: <1265317065-2922-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
Gábor: I think you missed specs here. Could you check whole routine just for
sure, please? I don't understand whole radio and chanspec magic yet.
---
 drivers/net/wireless/b43/phy_lp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 185219e..61009ee 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -2655,8 +2655,8 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
 		if (err)
 			return err;
 		lpphy_set_analog_filter(dev, new_channel);
-		lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
 	}
+	lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
 
 	lpphy->channel = new_channel;
 	b43_write16(dev, B43_MMIO_CHANNEL, new_channel);
-- 
1.6.4.2

