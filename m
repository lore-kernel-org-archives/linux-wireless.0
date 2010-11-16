Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59621 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0KPV7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:59:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rndis_wlan: avoid uninitialized var warning in rndis_wlan_craft_connected_bss
Date: Tue, 16 Nov 2010 16:49:08 -0500
Message-Id: <1289944148-10326-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/rndis_wlan.o
drivers/net/wireless/rndis_wlan.c: In function ‘rndis_wlan_craft_connected_bss’:
drivers/net/wireless/rndis_wlan.c:2542:2: warning: ‘ret’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rndis_wlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8a77ff6..ee08bca 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2536,7 +2536,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	/* Get signal quality, in case of error use rssi=0 and ignore error. */
 	len = sizeof(rssi);
 	rssi = 0;
-	rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
+	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
 	signal = level_to_qual(le32_to_cpu(rssi));
 
 	netdev_dbg(usbdev->net, "%s(): OID_802_11_RSSI -> %d, "
-- 
1.7.3.2

