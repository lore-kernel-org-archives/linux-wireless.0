Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43109 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZIXDHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] ath9k: use common read/write ops on pci and debug code
Date: Wed, 23 Sep 2009 23:06:59 -0400
Message-Id: <1253761622-9530-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
References: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCI and debug code will not be shared between ath9k and
ath9k_htc, so make that code use the common read/write ops.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   21 +++++++++++++--------
 drivers/net/wireless/ath/ath9k/pci.c   |    4 ++--
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5dfc0e9..352914c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -18,6 +18,11 @@
 
 #include "ath9k.h"
 
+#define REG_WRITE_D(_ah, _reg, _val) \
+	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
+#define REG_READ_D(_ah, _reg) \
+	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
+
 static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 
@@ -82,7 +87,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 
 	ath9k_ps_wakeup(sc);
 
-	REG_WRITE(ah, AR_MACMISC,
+	REG_WRITE_D(ah, AR_MACMISC,
 		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
 		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
@@ -94,7 +99,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		if (i % 4 == 0)
 			len += snprintf(buf + len, sizeof(buf) - len, "\n");
 
-		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u32)));
+		val[i] = REG_READ_D(ah, AR_DMADBG_0 + (i * sizeof(u32)));
 		len += snprintf(buf + len, sizeof(buf) - len, "%d: %08x ",
 				i, val[i]);
 	}
@@ -144,9 +149,9 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
 	len += snprintf(buf + len, sizeof(buf) - len, "pcu observe: 0x%x \n",
-			REG_READ(ah, AR_OBS_BUS_1));
+			REG_READ_D(ah, AR_OBS_BUS_1));
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"AR_CR: 0x%x \n", REG_READ(ah, AR_CR));
+			"AR_CR: 0x%x \n", REG_READ_D(ah, AR_CR));
 
 	ath9k_ps_restore(sc);
 
@@ -363,12 +368,12 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 				aphy->chan_idx, aphy->chan_is_ht);
 	}
 
-	put_unaligned_le32(REG_READ(sc->sc_ah, AR_STA_ID0), addr);
-	put_unaligned_le16(REG_READ(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
+	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
+	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addr: %pM\n", addr);
-	put_unaligned_le32(REG_READ(sc->sc_ah, AR_BSSMSKL), addr);
-	put_unaligned_le16(REG_READ(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
+	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
+	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addrmask: %pM\n", addr);
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a1001ff..b2a45ce 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -65,7 +65,7 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath_hw *ah = (struct ath_hw *) common->ah;
 
-	(void)REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
+	common->ops->read(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
 
 	if (!ath9k_hw_wait(ah,
 			   AR_EEPROM_STATUS_DATA,
@@ -75,7 +75,7 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 		return false;
 	}
 
-	*data = MS(REG_READ(ah, AR_EEPROM_STATUS_DATA),
+	*data = MS(common->ops->read(ah, AR_EEPROM_STATUS_DATA),
 		   AR_EEPROM_STATUS_DATA_VAL);
 
 	return true;
-- 
1.6.3.3

