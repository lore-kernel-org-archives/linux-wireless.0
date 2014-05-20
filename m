Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58314 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaETH13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:27:29 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so216227eek.21
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:27:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: xmit: set 5 GHz bit depending on current band
Date: Tue, 20 May 2014 09:27:18 +0200
Message-Id: <1400570838-27060-1-git-send-email-zajec5@gmail.com> (sfid-20140520_092732_748273_265B2DDF)
In-Reply-To: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
References: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PHYs other than A may also work in 5 GHz mode.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Update comment about "gmode" in phy_common.h
    Thanks Antonio.
---
 drivers/net/wireless/b43/phy_common.h | 2 +-
 drivers/net/wireless/b43/xmit.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 4c80b09..47b5585 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -231,7 +231,7 @@ struct b43_phy {
 	/* HT info */
 	bool is_40mhz;
 
-	/* GMODE bit enabled? */
+	/* Is GMODE (2 GHz mode) bit enabled? */
 	bool gmode;
 
 	/* Analog Type */
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 31adb8c..4f38f19 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -408,7 +408,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
-	if (phy->type == B43_PHYTYPE_A)
+	if (!phy->gmode)
 		mac_ctl |= B43_TXH_MAC_5GHZ;
 
 	/* Overwrite rates[0].count to make the retry calculation
-- 
1.8.4.5

