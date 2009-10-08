Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZJHUqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 16:46:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: [PATCH] libertas: remove double assignment of dev->netdev_ops
Date: Thu,  8 Oct 2009 16:46:09 -0400
Message-Id: <1255034769-18882-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This came in through the patch titled:
    libertas: first stab at cfg80211 support

I only noticed it because it breaks compat-wireless :)

Cc: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/libertas/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index e6da1df..87bfd17 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1276,7 +1276,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 		goto err_adapter;
 	}
 
-	dev->netdev_ops = &lbs_netdev_ops;
 	dev->ieee80211_ptr = wdev;
 	dev->ml_priv = priv;
 	SET_NETDEV_DEV(dev, dmdev);
-- 
1.6.0.4

