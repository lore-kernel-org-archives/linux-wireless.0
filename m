Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43593 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0JFFuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 01:50:08 -0400
Received: by mail-ey0-f174.google.com with SMTP id 6so2726728eyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 22:50:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: define B43_SHM_SH_CHAN_40MHZ
Date: Wed,  6 Oct 2010 07:50:07 +0200
Message-Id: <1286344208-32479-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1286344208-32479-1-git-send-email-zajec5@gmail.com>
References: <1286344208-32479-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h        |    3 ++-
 drivers/net/wireless/b43/phy_common.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 73376ff..29302ea 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -187,7 +187,8 @@ enum {
 #define B43_SHM_SH_PHYTXNOI		0x006E	/* PHY noise directly after TX (lower 8bit only) */
 #define B43_SHM_SH_RFRXSP1		0x0072	/* RF RX SP Register 1 */
 #define B43_SHM_SH_CHAN			0x00A0	/* Current channel (low 8bit only) */
-#define  B43_SHM_SH_CHAN_5GHZ		0x0100	/* Bit set, if 5Ghz channel */
+#define  B43_SHM_SH_CHAN_5GHZ		0x0100	/* Bit set, if 5 Ghz channel */
+#define  B43_SHM_SH_CHAN_40MHZ		0x0200	/* Bit set, if 40 Mhz channel width */
 #define B43_SHM_SH_BCMCFIFOID		0x0108	/* Last posted cookie to the bcast/mcast FIFO */
 /* TSSI information */
 #define B43_SHM_SH_TSSI_CCK		0x0058	/* TSSI for last 4 CCK frames (32bit) */
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 10b9e6f..44f0064 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -294,8 +294,10 @@ int b43_switch_channel(struct b43_wldev *dev, unsigned int new_channel)
 	 */
 	channelcookie = new_channel;
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
-		channelcookie |= 0x100;
-	//FIXME set 40Mhz flag if required
+		channelcookie |= B43_SHM_SH_CHAN_5GHZ;
+	/* FIXME: set 40Mhz flag if required */
+	if (0)
+		channelcookie |= B43_SHM_SH_CHAN_40MHZ;
 	savedcookie = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_CHAN);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_CHAN, channelcookie);
 
-- 
1.7.1

