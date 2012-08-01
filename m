Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:60909 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab2HAVzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 17:55:48 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: dcbw@redhat.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix two memory leaks
Message-Id: <20120801203536.C81E39D401E@zog.reactivated.net> (sfid-20120801_235551_818880_30A35A53)
Date: Wed,  1 Aug 2012 21:35:36 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The if_sdio_card structure was never being freed, and neither
was the command structure used for association.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cfg.c     | 1 +
 drivers/net/wireless/libertas/if_sdio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index eb5de80..1c10b54 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1254,6 +1254,7 @@ static int lbs_associate(struct lbs_private *priv,
 			netif_tx_wake_all_queues(priv->dev);
 	}
 
+	kfree(cmd);
 done:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 76caeba..e970897 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1314,6 +1314,7 @@ static void if_sdio_remove(struct sdio_func *func)
 		kfree(packet);
 	}
 
+	kfree(card);
 	lbs_deb_leave(LBS_DEB_SDIO);
 }
 
-- 
1.7.11.2

