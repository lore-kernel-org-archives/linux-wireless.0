Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2610 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbYCZTuc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 15:50:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] prism54: correct thinko in "prism54: Convert stats_sem in a mutex"
Date: Wed, 26 Mar 2008 15:21:33 -0400
Message-Id: <1206559293-8546-1-git-send-email-linville@tuxdriver.com> (sfid-20080326_195043_401396_538E20C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mutex_trylock has different return code semantics than down_trylock...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Problem reported by user here:

	https://bugzilla.redhat.com/show_bug.cgi?id=438912

 drivers/net/wireless/prism54/isl_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 2d91a56..2e25e19 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -218,7 +218,7 @@ prism54_get_wireless_stats(struct net_device *ndev)
 	islpci_private *priv = netdev_priv(ndev);
 
 	/* If the stats are being updated return old data */
-	if (mutex_trylock(&priv->stats_lock) == 0) {
+	if (mutex_trylock(&priv->stats_lock)) {
 		memcpy(&priv->iwstatistics, &priv->local_iwstatistics,
 		       sizeof (struct iw_statistics));
 		/* They won't be marked updated for the next time */
-- 
1.5.3.3

