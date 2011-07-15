Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61532 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1GOXGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:06:35 -0400
Subject: [PATCH 2/4] ath9k: use get_unaligned_{b16, le16,
 le32} where possible
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 15 Jul 2011 19:06:33 -0400
Message-ID: <20110715230633.4461.24010.stgit@mj.roinet.com> (sfid-20110716_010639_008147_8B749349)
In-Reply-To: <20110715230627.4461.85730.stgit@mj.roinet.com>
References: <20110715230627.4461.85730.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |   12 +++++-------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   12 +++++-------
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   12 +++++-------
 drivers/net/wireless/ath/ath9k/hif_usb.c       |    5 +++--
 5 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1d09f22..33a1600 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/unaligned.h>
 #include "hw.h"
 #include "ar9003_phy.h"
 #include "ar9003_eeprom.h"
@@ -3006,11 +3007,11 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 
 	switch (param) {
 	case EEP_MAC_LSW:
-		return eep->macAddr[0] << 8 | eep->macAddr[1];
+		return get_unaligned_be16(eep->macAddr);
 	case EEP_MAC_MID:
-		return eep->macAddr[2] << 8 | eep->macAddr[3];
+		return get_unaligned_be16(eep->macAddr + 2);
 	case EEP_MAC_MSW:
-		return eep->macAddr[4] << 8 | eep->macAddr[5];
+		return get_unaligned_be16(eep->macAddr + 4);
 	case EEP_REG_0:
 		return le16_to_cpu(pBase->regDmn[0]);
 	case EEP_REG_1:
@@ -3380,8 +3381,7 @@ found:
 		osize = length;
 		read(ah, cptr, word, COMP_HDR_LEN + osize + COMP_CKSUM_LEN);
 		checksum = ar9300_comp_cksum(&word[COMP_HDR_LEN], length);
-		mchecksum = word[COMP_HDR_LEN + osize] |
-		    (word[COMP_HDR_LEN + osize + 1] << 8);
+		mchecksum = get_unaligned_le16(&word[COMP_HDR_LEN + osize]);
 		ath_dbg(common, ATH_DBG_EEPROM,
 			"checksum %x %x\n", checksum, mchecksum);
 		if (checksum == mchecksum) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 5b1e894..47cc950 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/unaligned.h>
 #include "hw.h"
 #include "ar9002_phy.h"
 
@@ -203,11 +204,11 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	case EEP_NFTHRESH_2:
 		return pModal->noiseFloorThreshCh[0];
 	case EEP_MAC_LSW:
-		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
+		return get_unaligned_be16(pBase->macAddr);
 	case EEP_MAC_MID:
-		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
+		return get_unaligned_be16(pBase->macAddr + 2);
 	case EEP_MAC_MSW:
-		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
+		return get_unaligned_be16(pBase->macAddr + 4);
 	case EEP_REG_0:
 		return pBase->regDmn[0];
 	case EEP_REG_1:
@@ -331,10 +332,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 
 			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
 			for (j = 0; j < 32; j++) {
-				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
-					((pdadcValues[4 * j + 1] & 0xFF) << 8) |
-					((pdadcValues[4 * j + 2] & 0xFF) << 16)|
-					((pdadcValues[4 * j + 3] & 0xFF) << 24);
+				reg32 = get_unaligned_le32(&pdadcValues[4 * j]);
 				REG_WRITE(ah, regOffset, reg32);
 
 				ath_dbg(common, ATH_DBG_EEPROM,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 343fc9f..d6f6b19 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/unaligned.h>
 #include "hw.h"
 #include "ar9002_phy.h"
 
@@ -195,11 +196,11 @@ static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 	case EEP_NFTHRESH_2:
 		return pModal->noiseFloorThreshCh[0];
 	case EEP_MAC_LSW:
-		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
+		return get_unaligned_be16(pBase->macAddr);
 	case EEP_MAC_MID:
-		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
+		return get_unaligned_be16(pBase->macAddr + 2);
 	case EEP_MAC_MSW:
-		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
+		return get_unaligned_be16(pBase->macAddr + 4);
 	case EEP_REG_0:
 		return pBase->regDmn[0];
 	case EEP_REG_1:
@@ -434,10 +435,7 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 					(672 << 2) + regChainOffset;
 
 				for (j = 0; j < 32; j++) {
-					reg32 = ((pdadcValues[4*j + 0] & 0xFF) << 0)
-						| ((pdadcValues[4*j + 1] & 0xFF) << 8)
-						| ((pdadcValues[4*j + 2] & 0xFF) << 16)
-						| ((pdadcValues[4*j + 3] & 0xFF) << 24);
+					reg32 = get_unaligned_le32(&pdadcValues[4 * j]);
 
 					REG_WRITE(ah, regOffset, reg32);
 					regOffset += 4;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 17f0a68..b9540a9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/unaligned.h>
 #include "hw.h"
 #include "ar9002_phy.h"
 
@@ -276,11 +277,11 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 	case EEP_NFTHRESH_2:
 		return pModal[1].noiseFloorThreshCh[0];
 	case EEP_MAC_LSW:
-		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
+		return get_unaligned_be16(pBase->macAddr);
 	case EEP_MAC_MID:
-		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
+		return get_unaligned_be16(pBase->macAddr + 2);
 	case EEP_MAC_MSW:
-		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
+		return get_unaligned_be16(pBase->macAddr + 4);
 	case EEP_REG_0:
 		return pBase->regDmn[0];
 	case EEP_REG_1:
@@ -831,10 +832,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 
 			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
 			for (j = 0; j < 32; j++) {
-				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
-					((pdadcValues[4 * j + 1] & 0xFF) << 8) |
-					((pdadcValues[4 * j + 2] & 0xFF) << 16)|
-					((pdadcValues[4 * j + 3] & 0xFF) << 24);
+				reg32 = get_unaligned_le32(&pdadcValues[4 * j]);
 				REG_WRITE(ah, regOffset, reg32);
 
 				ath_dbg(common, ATH_DBG_EEPROM,
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8028fe9..1d11ae1 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/unaligned.h>
 #include "htc.h"
 
 /* identify firmware images */
@@ -557,8 +558,8 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 		ptr = (u8 *) skb->data;
 
-		pkt_len = ptr[index] + (ptr[index+1] << 8);
-		pkt_tag = ptr[index+2] + (ptr[index+3] << 8);
+		pkt_len = get_unaligned_le16(ptr + index);
+		pkt_tag = get_unaligned_le16(ptr + index + 2);
 
 		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
 			RX_STAT_INC(skb_dropped);
