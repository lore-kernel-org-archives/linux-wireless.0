Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35956 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0K1MAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 07:00:13 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so3434315wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 04:00:12 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: N-PHY: initialize perical variable, add missing call to CCA reset
Date: Sun, 28 Nov 2010 12:59:44 +0100
Message-Id: <1290945585-20864-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
References: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d5595b6..31bed83 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2212,6 +2212,9 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 
 	b43_nphy_classifier(dev, 7, class);
 	b43_nphy_write_clip_detection(dev, clip_state);
+	/* Specs don't say about reset here, but it makes wl and b43 dumps
+	   identical, it really seems wl performs this */
+	b43_nphy_reset_cca(dev);
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
@@ -3625,6 +3628,7 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 	nphy->gain_boost = true; /* this way we follow wl, assume it is true */
 	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
 	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
+	nphy->perical = 2; /* avoid additional rssi cal on init (like wl) */
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
-- 
1.6.3.3

