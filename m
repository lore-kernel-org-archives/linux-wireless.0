Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35300 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbcCRC3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:29:46 -0400
Received: by mail-pf0-f174.google.com with SMTP id n5so146128247pfn.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:29:46 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Nicolas Pitre <nico@linaro.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org
Subject: [PATCH CONTROVERSIAL 19/19] iwlegacy: Rename label in il_eeprom_init()
Date: Fri, 18 Mar 2016 13:29:39 +1100
Message-Id: <90fe6325e407d35a18fa8c8cb7eaa269968d6426.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032949_825118_EB834229)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

Rename a jump label according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
[Rewrote commit title]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

This was controversial when introduced, however the change is obvious and
harmless and is, in the worst case, just churn.

I'm only including this as it meets my criteria for sheparding pending
patches: it's sane, obviously correct or reviewable by me, and doesn't
require any work to apply.

This does meet those requirements, however given how controviersial it was
when introduced, I'm not expecting people to be enthusiastic about
applying it.

Thanks,

Julian Calaby
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 2cc3d42..a1b1360 100644
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
 
 err:
-- 
2.7.0

