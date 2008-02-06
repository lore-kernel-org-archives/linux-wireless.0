Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:52806 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762777AbYBFNhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 08:37:11 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: enable stall workaround by link quality instead
	of link speed
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Feb 2008 15:36:10 +0200
Message-ID: <20080206133609.12743.17426.stgit@fate.lan> (sfid-20080206_133715_363817_FA1AF47F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable workaround for poor link stalls by link quality instead of link
speed. Using link speed caused workaround be active always on 802.11b
networks which reduced performance and not even catch all stalls.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d3ecf89..8ce2ddf 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2300,7 +2300,7 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 	struct usbnet *usbdev = priv->usbdev;
 	struct iw_statistics iwstats;
 	__le32 rssi, tmp;
-	int len, ret, bitrate, j;
+	int len, ret, j;
 	unsigned long flags;
 	int update_jiffies = STATS_UPDATE_JIFFIES;
 	void *buf;
@@ -2352,14 +2352,10 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 	if (ret == 0)
 		iwstats.discard.misc += le32_to_cpu(tmp);
 
-	/* Workaround transfer stalls on poor quality links. */
-	len = sizeof(tmp);
-	ret = rndis_query_oid(usbdev, OID_GEN_LINK_SPEED, &tmp, &len);
-	if (ret == 0) {
-		bitrate = le32_to_cpu(tmp) * 100;
-		if (bitrate > 11000000)
-			goto end;
-
+	/* Workaround transfer stalls on poor quality links.
+	 * TODO: find right way to fix these stalls (as stalls do not happen
+	 * with ndiswrapper/windows driver). */
+	if (iwstats.qual.qual <= 25) {
 		/* Decrease stats worker interval to catch stalls.
 		 * faster. Faster than 400-500ms causes packet loss,
 		 * Slower doesn't catch stalls fast enough.

