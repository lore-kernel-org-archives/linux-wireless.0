Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41870 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0LIT4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 14:56:16 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so2643172wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 11:56:16 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: N-PHY: one more fix for order of tables initialization
Date: Thu,  9 Dec 2010 20:55:59 +0100
Message-Id: <1291924561-21630-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
References: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I missed that part in previous reordering.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index df61c16..dc8ef09 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -1835,12 +1835,12 @@ void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev)
 	/* Volatile tables */
 	ntab_upload(dev, B43_NTAB_BDI, b43_ntab_bdi);
 	ntab_upload(dev, B43_NTAB_PILOTLT, b43_ntab_pilotlt);
+	ntab_upload(dev, B43_NTAB_C0_GAINCTL, b43_ntab_gainctl0);
+	ntab_upload(dev, B43_NTAB_C1_GAINCTL, b43_ntab_gainctl1);
 	ntab_upload(dev, B43_NTAB_C0_ESTPLT, b43_ntab_estimatepowerlt0);
 	ntab_upload(dev, B43_NTAB_C1_ESTPLT, b43_ntab_estimatepowerlt1);
 	ntab_upload(dev, B43_NTAB_C0_ADJPLT, b43_ntab_adjustpower0);
 	ntab_upload(dev, B43_NTAB_C1_ADJPLT, b43_ntab_adjustpower1);
-	ntab_upload(dev, B43_NTAB_C0_GAINCTL, b43_ntab_gainctl0);
-	ntab_upload(dev, B43_NTAB_C1_GAINCTL, b43_ntab_gainctl1);
 	ntab_upload(dev, B43_NTAB_C0_IQLT, b43_ntab_iqlt0);
 	ntab_upload(dev, B43_NTAB_C1_IQLT, b43_ntab_iqlt1);
 	ntab_upload(dev, B43_NTAB_C0_LOFEEDTH, b43_ntab_loftlt0);
-- 
1.6.3.3

