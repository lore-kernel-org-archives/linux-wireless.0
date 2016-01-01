Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:64129 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbcAAUaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 15:30:24 -0500
Subject: [PATCH 1/3] net-iwlegacy: Refactoring for il_eeprom_init()
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686E13F.2010309@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5686E1D2.60107@users.sourceforge.net> (sfid-20160101_213047_415265_BEC970C8)
Date: Fri, 1 Jan 2016 21:30:10 +0100
MIME-Version: 1.0
In-Reply-To: <5686E13F.2010309@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Jan 2016 20:54:25 +0100

Return directly if a memory allocation failed at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
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
2.6.3

