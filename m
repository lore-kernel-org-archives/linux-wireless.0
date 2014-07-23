Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53198 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaGWQy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 12:54:57 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so1464660wgh.34
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 09:54:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: N-PHY: don't calculate values for TSSI if we can't transmit
Date: Wed, 23 Jul 2014 18:54:48 +0200
Message-Id: <1406134490-6880-1-git-send-email-zajec5@gmail.com> (sfid-20140723_185500_816201_69672AA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This process requires sending some sample tone, so make sure we're
allowed to transmit first.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 44bb58b..d269fbb 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3957,7 +3957,8 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	u32 tmp;
 	s32 rssi[4] = { };
 
-	/* TODO: check if we can transmit */
+	if (phy->chandef->chan->flags & IEEE80211_CHAN_NO_IR)
+		return;
 
 	if (b43_nphy_ipa(dev))
 		b43_nphy_ipa_internal_tssi_setup(dev);
-- 
1.8.4.5

