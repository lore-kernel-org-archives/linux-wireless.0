Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42886 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaGWQzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 12:55:01 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so1482633wgh.30
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 09:55:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: enable 5 GHz support for N-PHY devices
Date: Wed, 23 Jul 2014 18:54:50 +0200
Message-Id: <1406134490-6880-3-git-send-email-zajec5@gmail.com> (sfid-20140723_185510_566973_3238E411)
In-Reply-To: <1406134490-6880-1-git-send-email-zajec5@gmail.com>
References: <1406134490-6880-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has been tested on 14e4:4328 (BCM4321), 14e4:432b (BCM4322),
14e4:4353 (BCM43224) and 14e4:4359 (BCM43228) which is an almost
complete list of 5 GHz capable device (only BCM43222 is missing).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3b4b192..d7055fe 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5338,7 +5338,6 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		switch (dev->phy.type) {
 		case B43_PHYTYPE_A:
 		case B43_PHYTYPE_G:
-		case B43_PHYTYPE_N:
 		case B43_PHYTYPE_LP:
 		case B43_PHYTYPE_HT:
 			b43warn(wl, "5 GHz band is unsupported on this PHY\n");
-- 
1.8.4.5

