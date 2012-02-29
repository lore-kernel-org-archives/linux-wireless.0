Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:44308 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2B2OZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 09:25:04 -0500
Subject: [PATCH 2/3] rndis_wlan: use RNDIS_WLAN_NUM_KEYS for all key index
 checks
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 16:25:00 +0200
Message-ID: <20120229142500.9946.45929.stgit@localhost6.localdomain6> (sfid-20120229_152508_974083_5EA53D1C)
In-Reply-To: <20120229142454.9946.57205.stgit@localhost6.localdomain6>
References: <20120229142454.9946.57205.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use new RNDIS_WLAN_NUM_KEYS for checks in add_wep_key() and add_wpa_key().

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 6a6e729..3e0f058 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1387,13 +1387,15 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	netdev_dbg(usbdev->net, "%s(idx: %d, len: %d)\n",
 		   __func__, index, key_len);
 
-	if ((key_len != 5 && key_len != 13) || index < 0 || index > 3)
+	if (index < 0 || index >= RNDIS_WLAN_NUM_KEYS)
 		return -EINVAL;
 
 	if (key_len == 5)
 		cipher = WLAN_CIPHER_SUITE_WEP40;
-	else
+	else if (key_len == 13)
 		cipher = WLAN_CIPHER_SUITE_WEP104;
+	else
+		return -EINVAL;
 
 	memset(&ndis_key, 0, sizeof(ndis_key));
 
@@ -1436,7 +1438,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	bool is_addr_ok;
 	int ret;
 
-	if (index < 0 || index >= 4) {
+	if (index < 0 || index >= RNDIS_WLAN_NUM_KEYS) {
 		netdev_dbg(usbdev->net, "%s(): index out of range (%i)\n",
 			   __func__, index);
 		return -EINVAL;

