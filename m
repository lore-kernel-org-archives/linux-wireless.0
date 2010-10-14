Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0JNRdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:33:50 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so3690881ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 10:33:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4 resend] b43: N-PHY: fix typo: read table when caching IQ LO calibration (do not write)
Date: Thu, 14 Oct 2010 19:33:35 +0200
Message-Id: <1287077617-11319-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287077617-11319-1-git-send-email-zajec5@gmail.com>
References: <1287077617-11319-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this patch was included in 3-patches-set that was not commited yet. Third
patch from that set was canceled, but this one is OK.
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 13d7e3b..715277e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2538,7 +2538,7 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 	}
 	iqcal_chanspec->center_freq = dev->phy.channel_freq;
 	iqcal_chanspec->channel_type = dev->phy.channel_type;
-	b43_ntab_write_bulk(dev, B43_NTAB16(15, 80), 8, table);
+	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 8, table);
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 0);
-- 
1.7.1

