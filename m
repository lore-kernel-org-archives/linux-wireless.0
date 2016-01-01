Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:50802 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbcAAUcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 15:32:43 -0500
Subject: [PATCH 3/3] net-iwlegacy: Another refactoring for il_eeprom_init()
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686E13F.2010309@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5686E263.1020901@users.sourceforge.net> (sfid-20160101_213259_230671_4A358EB6)
Date: Fri, 1 Jan 2016 21:32:35 +0100
MIME-Version: 1.0
In-Reply-To: <5686E13F.2010309@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Jan 2016 21:16:01 +0100

Rename a jump label according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index ae45fd3..660ab2b 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -759,7 +759,7 @@ il_eeprom_init(struct il_priv *il)
 				 IL_EEPROM_ACCESS_TIMEOUT);
 		if (ret < 0) {
 			IL_ERR("Time out reading EEPROM[%d]\n", addr);
-			goto done;
+			goto release_semaphore;
 		}
 		r = _il_rd(il, CSR_EEPROM_REG);
 		e[addr / 2] = cpu_to_le16(r >> 16);
@@ -769,7 +769,7 @@ il_eeprom_init(struct il_priv *il)
 		 il_eeprom_query16(il, EEPROM_VERSION));
 
 	ret = 0;
-done:
+release_semaphore:
 	il->ops->eeprom_release_semaphore(il);
 
 	if (ret) {
-- 
2.6.3

