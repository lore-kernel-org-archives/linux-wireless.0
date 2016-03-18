Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34630 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:23:54 -0400
Received: by mail-pf0-f169.google.com with SMTP id x3so145843164pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:23:53 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 08/19] iwlegacy: Return directly if allocation fails in il_eeprom_init()
Date: Fri, 18 Mar 2016 13:23:46 +1100
Message-Id: <01ae52425e9dba9f82f8d107da02a0d2cd23f09d.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032357_198162_BE519733)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

Also remove an unused label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
[Rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index eb5cb60..c3afaf7 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -723,10 +723,9 @@ il_eeprom_init(struct il_priv *il)
 	sz = il->cfg->eeprom_size;
 	D_EEPROM("NVM size = %d\n", sz);
 	il->eeprom = kzalloc(sz, GFP_KERNEL);
-	if (!il->eeprom) {
-		ret = -ENOMEM;
-		goto alloc_err;
-	}
+	if (!il->eeprom)
+		return -ENOMEM;
+
 	e = (__le16 *) il->eeprom;
 
 	il->ops->apm_init(il);
@@ -778,7 +777,6 @@ err:
 		il_eeprom_free(il);
 	/* Reset chip to save power until we load uCode during "up". */
 	il_apm_stop(il);
-alloc_err:
 	return ret;
 }
 EXPORT_SYMBOL(il_eeprom_init);
-- 
2.7.0

