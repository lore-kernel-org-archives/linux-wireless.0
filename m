Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47120 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbZJLVUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/9] [compat-2.6] Remove temporary fix
Date: Mon, 12 Oct 2009 23:19:14 +0200
Message-Id: <1255382358-20760-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove temporary fix from 6dae19ce42f4f6424a37c25f9ec393c1b4bc5c32
it is now in John's tree

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/01-netdev.patch |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index a619a01..6ec1827 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -534,38 +534,3 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  	ether_setup(dev);
  	dev->tx_queue_len = 0;
-
-
-Remove this after John picks this up:
-
-From 8fe3f6159c61a7c88a2bd160e8281d62e3978bed Mon Sep 17 00:00:00 2001
-From: Luis R. Rodriguez <lrodriguez@atheros.com>
-Date: Thu, 8 Oct 2009 16:43:57 -0400
-Subject: [PATCH] libertas: remove double assignment of dev->netdev_ops
-
-This came in through the patch titled:
-    libertas: first stab at cfg80211 support
-
-I only noticed it because it breaks compat-wireless :)
-
-Cc: Holger Schurig <hs4233@mail.mn-solutions.de>
-Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
----
- drivers/net/wireless/libertas/main.c |    1 -
- 1 files changed, 0 insertions(+), 1 deletions(-)
-
-diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
-index e6da1df..87bfd17 100644
---- a/drivers/net/wireless/libertas/main.c
-+++ b/drivers/net/wireless/libertas/main.c
-@@ -1276,7 +1276,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
- 		goto err_adapter;
- 	}
- 
--	dev->netdev_ops = &lbs_netdev_ops;
- 	dev->ieee80211_ptr = wdev;
- 	dev->ml_priv = priv;
- 	SET_NETDEV_DEV(dev, dmdev);
--- 
-1.6.0.4
-
-- 
1.6.2.1

