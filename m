Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:35167 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbZHTSAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 14:00:34 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: fix broken logic in add_wep_key()
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Aug 2009 21:00:34 +0300
Message-ID: <20090820180034.14750.50307.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add_wep_key() tries to check if key length is not 5 AND not 13
but uses (key_len != 5 || key_len != 13) instead. Fix this.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d42692d..c5b921b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1214,7 +1214,7 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 	struct ndis_80211_wep_key ndis_key;
 	int cipher, ret;
 
-	if ((key_len != 5 || key_len != 13) || index < 0 || index > 3)
+	if ((key_len != 5 && key_len != 13) || index < 0 || index > 3)
 		return -EINVAL;
 
 	if (key_len == 5)

