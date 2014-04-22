Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41379 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDVLy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 07:54:56 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so4550782eei.33
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 04:54:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: don't pre-set radio_on variable to true
Date: Tue, 22 Apr 2014 13:54:37 +0200
Message-Id: <1398167677-9207-3-git-send-email-zajec5@gmail.com> (sfid-20140422_135534_201817_751CA037)
In-Reply-To: <1398167677-9207-1-git-send-email-zajec5@gmail.com>
References: <1398167677-9207-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting it to true during init doesn't seem to be any workaround while
it can cause problems (not enabling radio due to belief it's enabled).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f0de7dd..32e08d3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5178,7 +5178,6 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	}
 
 	dev->phy.gmode = have_2ghz_phy;
-	dev->phy.radio_on = true;
 	b43_wireless_core_reset(dev, dev->phy.gmode);
 
 	err = b43_phy_versioning(dev);
-- 
1.8.4.5

