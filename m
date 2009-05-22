Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:30109 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZEVI6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 04:58:39 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: fix support for bcm4320a
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Fri, 22 May 2009 11:58:36 +0300
Message-ID: <20090522085836.16315.72233.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Old variant of bcm4320 doesn't handle setting configuration parameters
correctly. One symptom is that MAC gets partially overwritten when any
config parameters are set. This patch disables config-params for bcm4320a
(and generic rndis-wlan).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 52fc647..addd7a5 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2275,7 +2275,17 @@ end:
 }
 
 
-static int bcm4320_early_init(struct usbnet *usbdev)
+static int bcm4320a_early_init(struct usbnet *usbdev)
+{
+	/* bcm4320a doesn't handle configuration parameters well. Try
+	 * set any and you get partially zeroed mac and broken device.
+	 */
+
+	return 0;
+}
+
+
+static int bcm4320b_early_init(struct usbnet *usbdev)
 {
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 	char buf[8];
@@ -2515,7 +2525,7 @@ static const struct driver_info	bcm4320b_info = {
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wext_reset,
-	.early_init =	bcm4320_early_init,
+	.early_init =	bcm4320b_early_init,
 	.link_change =	rndis_wext_link_change,
 };
 
@@ -2528,7 +2538,7 @@ static const struct driver_info	bcm4320a_info = {
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wext_reset,
-	.early_init =	bcm4320_early_init,
+	.early_init =	bcm4320a_early_init,
 	.link_change =	rndis_wext_link_change,
 };
 
@@ -2541,7 +2551,7 @@ static const struct driver_info rndis_wext_info = {
 	.rx_fixup =	rndis_rx_fixup,
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wext_reset,
-	.early_init =	bcm4320_early_init,
+	.early_init =	bcm4320a_early_init,
 	.link_change =	rndis_wext_link_change,
 };
 

