Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37645 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0AQMEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 07:04:07 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so298468fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 04:04:06 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Jan 2010 13:04:08 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 7/7] b43: N-PHY: store seq mode for proper restoring (follow
 specs)
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6oeg6lf9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 34be98b..141d4ed 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -897,6 +897,7 @@ static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
  		[B43_RFSEQ_UPDATE_GAINU]	= B43_NPHY_RFSEQTR_UPGU,
  	};
  	int i;
+	u16 seq_mode = b43_phy_read(dev, B43_NPHY_RFSEQMODE);

  	B43_WARN_ON(seq >= ARRAY_SIZE(trigger));

@@ -910,8 +911,7 @@ static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
  	}
  	b43err(dev->wl, "RF sequence status timeout\n");
  ok:
-	b43_phy_mask(dev, B43_NPHY_RFSEQMODE,
-		     ~(B43_NPHY_RFSEQMODE_CAOVER | B43_NPHY_RFSEQMODE_TROVER));
+	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
  }

  static void b43_nphy_bphy_init(struct b43_wldev *dev)
-- 
1.6.4.2

