Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15785 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbXLSGRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:17:16 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 6/6] rtl8180: don't corrupt BRSR register on rtl8180 cards
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 19 Dec 2007 01:17:36 -0500
Message-ID: <20071219061736.4885.56426.stgit@tetra.sourmilk.net> (sfid-20071219_061725_675389_A508DF06)
In-Reply-To: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
References: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

BRSR register is set to the (different) right value for both rtl8180 and
rtl8185. However rtl8225 rf init corrupts that register and we incorrectly
write it again after radio init with rtl8185 value.
As rf init for rtl8180's radios does not corrupt BRSR, we fix the problem by
simply avoiding the write for rtl8180 cards.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 3ab4922..c36c420 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -375,7 +375,8 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	}
 
 	priv->rf_init(dev);
-	rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
+	if (priv->r8185)
+		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
 	return 0;
 }
 


