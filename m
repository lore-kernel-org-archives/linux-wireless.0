Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57455 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1GQHwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 03:52:10 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so4861845fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 00:52:09 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: HT-PHY: fix typo in 0x2059 radio init
Date: Sun, 17 Jul 2011 10:30:34 +0200
Message-Id: <1310891434-3537-4-git-send-email-zajec5@gmail.com> (sfid-20110717_095214_620378_B908AE52)
In-Reply-To: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
References: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following operation was incorrectly translated:
 radio_read(0x0011) -> 0xffff
radio_write(0x0011) <- 0xfff7

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index f903498..2105f9c 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -148,7 +148,7 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
 		b43_radio_mask(dev, 0x17F, ~0x1);
 	}
 
-	b43_radio_mask(dev, 0x11, 0x0008);
+	b43_radio_mask(dev, 0x11, ~0x0008);
 }
 
 /**************************************************
-- 
1.7.3.4

