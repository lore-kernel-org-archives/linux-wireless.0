Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44952 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1F0WIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 18:08:04 -0400
Received: by fxd18 with SMTP id 18so2183704fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 15:08:02 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: HT-PHY: replace radio routing magic numbers
Date: Tue, 28 Jun 2011 00:08:52 +0200
Message-Id: <1309212533-4473-1-git-send-email-zajec5@gmail.com> (sfid-20110628_001012_371730_77910CFD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c     |    2 +-
 drivers/net/wireless/b43/radio_2059.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index f09bb6e..8df92e1 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -57,7 +57,7 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 	b43_radio_write(dev, 0x98, e->radio_syn98);
 
 	for (i = 0; i < 2; i++) {
-		routing = i ? 0x800 : 0x400;
+		routing = i ? R2059_RXRX1 : R2059_TXRX0;
 		b43_radio_write(dev, routing | 0x4a, e->radio_rxtx4a);
 		b43_radio_write(dev, routing | 0x58, e->radio_rxtx58);
 		b43_radio_write(dev, routing | 0x5a, e->radio_rxtx5a);
diff --git a/drivers/net/wireless/b43/radio_2059.h b/drivers/net/wireless/b43/radio_2059.h
index c2874b1..e4d69e5 100644
--- a/drivers/net/wireless/b43/radio_2059.h
+++ b/drivers/net/wireless/b43/radio_2059.h
@@ -5,6 +5,11 @@
 
 #include "phy_ht.h"
 
+#define R2059_SYN			0x000
+#define R2059_TXRX0			0x400
+#define R2059_RXRX1			0x800
+#define R2059_ALL			0xC00
+
 /* Values for various registers uploaded on channel switching */
 struct b43_phy_ht_channeltab_e_radio2059 {
 	/* The channel frequency in MHz */
-- 
1.7.1

