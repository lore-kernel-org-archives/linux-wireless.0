Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57455 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1GQHwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 03:52:01 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so4861845fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 00:52:01 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: HT-PHY: switch to channel after enabling radio
Date: Sun, 17 Jul 2011 10:30:32 +0200
Message-Id: <1310891434-3537-2-git-send-email-zajec5@gmail.com> (sfid-20110717_095206_616709_F8E31E83)
In-Reply-To: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
References: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also change the default channel to 11. This is the first channel closed
driver switches to.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 0cc293a..f903498 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -288,6 +288,8 @@ static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
 			b43_radio_2059_init(dev);
 		else
 			B43_WARN_ON(1);
+
+		b43_switch_channel(dev, dev->phy.channel);
 	}
 }
 
@@ -329,7 +331,7 @@ static int b43_phy_ht_op_switch_channel(struct b43_wldev *dev,
 static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-		return 1;
+		return 11;
 	return 36;
 }
 
-- 
1.7.3.4

