Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:59614 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbXL0BQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 20:16:05 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/2] rtl8180: remove calibration error message for rtl8225z2
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 26 Dec 2007 20:16:37 -0500
Message-ID: <20071227011637.10445.99776.stgit@tetra.sourmilk.net> (sfid-20071227_011608_454639_A97414BE)
In-Reply-To: <20071227011637.10445.89261.stgit@tetra.sourmilk.net>
References: <20071227011637.10445.89261.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The radio seems to work fine despite this message. Remove it for now.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_rtl8225.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
index 9dab126..ef3832b 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl8180_rtl8225.c
@@ -578,9 +578,8 @@ static void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 		msleep(200);
 		rtl8225_write(dev, 0x02, 0x044D);
 		msleep(100);
-		if (!(rtl8225_read(dev, 6) & (1 << 7)))
-			printk(KERN_WARNING "%s: RF Calibration Failed! %x\n",
-			       wiphy_name(dev->wiphy), rtl8225_read(dev, 6));
+		/* TODO: readd calibration failure message when the calibration
+		   check works */
 	}
 
 	rtl8225_write(dev, 0x0, 0x1B7);


