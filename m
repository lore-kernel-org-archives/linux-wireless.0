Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45505 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0LIT4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 14:56:25 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so2856888wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 11:56:24 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: rename TMS defines, drop useless condition from core reset
Date: Thu,  9 Dec 2010 20:56:01 +0100
Message-Id: <1291924561-21630-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
References: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As discussed we do not know band width at core reset time and it is not a good
idea to reset whole just to change band. So just set unconditionally 20 MHz
band width as default during core reset.

As for defines PHY clock changed to band width in specs and it makes much more
sens to call defines by band width which is self-explainable. Updated specs do
not mention 0 value, but comparing to old ones you can notice lineral relation
between PHY clock speed and band width. So it makes sense for 0x0 value to be
10 MHz band width.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h  |    8 ++++----
 drivers/net/wireless/b43/main.c |    8 ++------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 9aad2ca..bd4cb75 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -416,10 +416,10 @@ enum {
 
 /* 802.11 core specific TM State Low (SSB_TMSLOW) flags */
 #define B43_TMSLOW_GMODE		0x20000000	/* G Mode Enable */
-#define B43_TMSLOW_PHYCLKSPEED		0x00C00000	/* PHY clock speed mask (N-PHY only) */
-#define  B43_TMSLOW_PHYCLKSPEED_40MHZ	0x00000000	/* 40 MHz PHY */
-#define  B43_TMSLOW_PHYCLKSPEED_80MHZ	0x00400000	/* 80 MHz PHY */
-#define  B43_TMSLOW_PHYCLKSPEED_160MHZ	0x00800000	/* 160 MHz PHY */
+#define B43_TMSLOW_PHY_BANDWIDTH	0x00C00000	/* PHY band width and clock speed mask (N-PHY only) */
+#define  B43_TMSLOW_PHY_BANDWIDTH_10MHZ	0x00000000	/* 10 MHz bandwidth, 40 MHz PHY */
+#define  B43_TMSLOW_PHY_BANDWIDTH_20MHZ	0x00400000	/* 20 MHz bandwidth, 80 MHz PHY */
+#define  B43_TMSLOW_PHY_BANDWIDTH_40MHZ	0x00800000	/* 40 MHz bandwidth, 160 MHz PHY */
 #define B43_TMSLOW_PLLREFSEL		0x00200000	/* PLL Frequency Reference Select (rev >= 5) */
 #define B43_TMSLOW_MACPHYCLKEN		0x00100000	/* MAC PHY Clock Control Enable (rev >= 5) */
 #define B43_TMSLOW_PHYRESET		0x00080000	/* PHY Reset */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9ae3f61..1aec160 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1150,12 +1150,8 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 
 	flags |= B43_TMSLOW_PHYCLKEN;
 	flags |= B43_TMSLOW_PHYRESET;
-	if (dev->phy.type == B43_PHYTYPE_N) {
-		if (b43_channel_type_is_40mhz(dev->phy.channel_type))
-			flags |= B43_TMSLOW_PHYCLKSPEED_160MHZ;
-		else
-			flags |= B43_TMSLOW_PHYCLKSPEED_80MHZ;
-	}
+	if (dev->phy.type == B43_PHYTYPE_N)
+		flags |= B43_TMSLOW_PHY_BANDWIDTH_20MHZ; /* Make 20 MHz def */
 	ssb_device_enable(dev->dev, flags);
 	msleep(2);		/* Wait for the PLL to turn on. */
 
-- 
1.6.3.3

