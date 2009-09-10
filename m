Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZIJHKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:17 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mick@madwifi-project.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 7/7] atheros: use get_unaligned_le*() for bssid mask setting
Date: Thu, 10 Sep 2009 03:10:19 -0400
Message-Id: <1252566619-30390-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Historically some macro helpers have been users for this,
AR5K_LOW_ID() and AR5K_HIGH_ID(), use upstream unaligned
helpers instead. This applid to ath5k and ar9170. ath9k
already uses this.

Worth noting is ath5k uses an ah_sta_id but that is already
the MAC address combined with the associaiton ID, ah_sta_id
is really ETH_ALEN in size.

Cc: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>
Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/mac.c  |   10 ++++----
 drivers/net/wireless/ath/ath.h         |    1 +
 drivers/net/wireless/ath/ath5k/ath5k.h |    7 ------
 drivers/net/wireless/ath/ath5k/pcu.c   |   36 ++++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/reset.c |    6 +++-
 5 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index 614e321..0c6273a 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -35,6 +35,9 @@
  *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+
+#include <asm/unaligned.h>
+
 #include "ar9170.h"
 #include "cmd.h"
 
@@ -227,11 +230,8 @@ static int ar9170_set_mac_reg(struct ar9170 *ar, const u32 reg, const u8 *mac)
 
 	ar9170_regwrite_begin(ar);
 
-	ar9170_regwrite(reg,
-			(mac[3] << 24) | (mac[2] << 16) |
-			(mac[1] << 8) | mac[0]);
-
-	ar9170_regwrite(reg + 4, (mac[5] << 8) | mac[4]);
+	ar9170_regwrite(reg, get_unaligned_le32(mac));
+	ar9170_regwrite(reg + 4, get_unaligned_le16(mac + 4));
 
 	ar9170_regwrite_finish();
 
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 59072e3..44f885a 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -18,6 +18,7 @@
 #define ATH_H
 
 #include <linux/skbuff.h>
+#include <linux/if_ether.h>
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6cd5efc..93a9c1f 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -165,13 +165,6 @@
 #define AR5K_INI_VAL_XR			0
 #define AR5K_INI_VAL_MAX		5
 
-/* Used for BSSID etc manipulation */
-#define AR5K_LOW_ID(_a)(				\
-(_a)[0] | (_a)[1] << 8 | (_a)[2] << 16 | (_a)[3] << 24	\
-)
-
-#define AR5K_HIGH_ID(_a)	((_a)[4] | (_a)[5] << 8)
-
 /*
  * Some tuneable values (these should be changeable by the user)
  * TODO: Make use of them and add more options OR use debug/configfs
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 43aa358..7bbcfe4 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -24,6 +24,8 @@
 * Protocol Control Unit Functions *
 \*********************************/
 
+#include <asm/unaligned.h>
+
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
@@ -95,8 +97,8 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 	/*
 	 * Set PCU registers
 	 */
-	low_id = AR5K_LOW_ID(ah->ah_sta_id);
-	high_id = AR5K_HIGH_ID(ah->ah_sta_id);
+	low_id = get_unaligned_le32(ah->ah_sta_id);
+	high_id = get_unaligned_le16(ah->ah_sta_id + 4);
 	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
 	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
 
@@ -279,8 +281,8 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 
 	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
 
-	low_id = AR5K_LOW_ID(mac);
-	high_id = AR5K_HIGH_ID(mac);
+	low_id = get_unaligned_le32(mac);
+	high_id = get_unaligned_le16(mac + 4);
 
 	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
 	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
@@ -306,17 +308,18 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 * Set simple BSSID mask on 5212
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, AR5K_LOW_ID(ah->ah_bssid_mask),
+		ath5k_hw_reg_write(ah, get_unaligned_le32(ah->ah_bssid_mask),
 							AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, AR5K_HIGH_ID(ah->ah_bssid_mask),
-							AR5K_BSS_IDM1);
+		ath5k_hw_reg_write(ah,
+				   get_unaligned_le16(ah->ah_bssid_mask + 4),
+				   AR5K_BSS_IDM1);
 	}
 
 	/*
 	 * Set BSSID which triggers the "SME Join" operation
 	 */
-	low_id = AR5K_LOW_ID(bssid);
-	high_id = AR5K_HIGH_ID(bssid);
+	low_id = get_unaligned_le32(bssid);
+	high_id = get_unaligned_le16(bssid);
 	ath5k_hw_reg_write(ah, low_id, AR5K_BSS_ID0);
 	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
 				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
@@ -437,8 +440,8 @@ int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 	 * on reset */
 	memcpy(ah->ah_bssid_mask, mask, ETH_ALEN);
 	if (ah->ah_version == AR5K_AR5212) {
-		low_id = AR5K_LOW_ID(mask);
-		high_id = AR5K_HIGH_ID(mask);
+		low_id = get_unaligned_le32(mask);
+		high_id = get_unaligned_le16(mask + 4);
 
 		ath5k_hw_reg_write(ah, low_id, AR5K_BSS_IDM0);
 		ath5k_hw_reg_write(ah, high_id, AR5K_BSS_IDM1);
@@ -1157,14 +1160,17 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 	 /* Invalid entry (key table overflow) */
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
-	/* MAC may be NULL if it's a broadcast key. In this case no need to
-	 * to compute AR5K_LOW_ID and AR5K_HIGH_ID as we already know it. */
+	/*
+	 * MAC may be NULL if it's a broadcast key. In this case no need to
+	 * to compute get_unaligned_le32 and get_unaligned_le16 as we
+	 * already know it.
+	 */
 	if (!mac) {
 		low_id = 0xffffffff;
 		high_id = 0xffff | AR5K_KEYTABLE_VALID;
 	} else {
-		low_id = AR5K_LOW_ID(mac);
-		high_id = AR5K_HIGH_ID(mac) | AR5K_KEYTABLE_VALID;
+		low_id = get_unaligned_le32(mac);
+		high_id = get_unaligned_le16(mac + 4) | AR5K_KEYTABLE_VALID;
 	}
 
 	ath5k_hw_reg_write(ah, low_id, AR5K_KEYTABLE_MAC0(entry));
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 34e13c7..3454dac 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -25,6 +25,8 @@
   Reset functions and helpers
 \*****************************/
 
+#include <asm/unaligned.h>
+
 #include <linux/pci.h> 		/* To determine if a card is pci-e */
 #include <linux/log2.h>
 #include "ath5k.h"
@@ -1171,9 +1173,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	ath5k_hw_reg_write(ah, s_led[2], AR5K_GPIODO);
 
 	/* Restore sta_id flags and preserve our mac address*/
-	ath5k_hw_reg_write(ah, AR5K_LOW_ID(ah->ah_sta_id),
+	ath5k_hw_reg_write(ah, get_unaligned_le32(ah->ah_sta_id),
 						AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, staid1_flags | AR5K_HIGH_ID(ah->ah_sta_id),
+	ath5k_hw_reg_write(ah, staid1_flags | get_unaligned_le16(ah->ah_sta_id),
 						AR5K_STA_ID1);
 
 
-- 
1.6.3.3

