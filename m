Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eng.riverbed.com ([208.70.196.45]:15628 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbcFPQ64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:58:56 -0400
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com
From: Eduardo Abinader <eduardo.abinader@riverbed.com>
Subject: [PATCH] ath9k: return false when reading wrong eeprom offset
Message-ID: <5762DAC7.8090904@riverbed.com> (sfid-20160616_185900_367769_0D82CA47)
Date: Thu, 16 Jun 2016 18:58:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just setting the proper return for reading beyond the eeprom data.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7cdaf40..aa04b13 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -794,6 +794,8 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 			ath_err(common,
 				"%s: eeprom read failed, offset %08x is out of range\n",
 				__func__, off);
+
+			return false;
 		}
 
 		*data = pdata->eeprom_data[off];
-- 
2.5.0
