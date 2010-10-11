Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0JKPVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 11:21:15 -0400
Received: by fxm4 with SMTP id 4so482439fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 08:21:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: fix typo: read table when caching IQ LO calibration (do not write)
Date: Mon, 11 Oct 2010 17:20:34 +0200
Message-Id: <1286810435-10820-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1286810435-10820-1-git-send-email-zajec5@gmail.com>
References: <1286810435-10820-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
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

