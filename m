Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38327 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab2LKRZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 12:25:44 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: check pdata variable before dereferencing it
Date: Tue, 11 Dec 2012 18:25:40 +0100
Message-Id: <1355246740-12539-1-git-send-email-juhosg@openwrt.org> (sfid-20121211_182547_811809_06D21380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to my recent commit (ath9k: allow to load EEPROM
content via firmware API) smatch complains about that
the 'pdata' variable in 'ath9k_hw_init' can be NULL
and it is dereferenced before checking that. That is
absolutely correct.

Check the 'pdata' variable before using it to avoid
a NULL pointer dereference.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 27703a5..f69ef5d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -633,7 +633,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath_read_cachesize(common, &csz);
 	common->cachelsz = csz << 2; /* convert to bytes */
 
-	if (pdata->eeprom_name) {
+	if (pdata && pdata->eeprom_name) {
 		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
 		if (ret)
 			goto err_eeprom;
-- 
1.7.10

