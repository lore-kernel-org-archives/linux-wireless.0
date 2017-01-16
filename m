Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:59512 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbdAPCzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 21:55:14 -0500
Date: Mon, 16 Jan 2017 03:55:01 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 01/14] rt2x00: rt2800lib: move rt2800_drv_data declaration
 into rt2800lib.h
Message-ID: <20170116025444.GA32156@makrotopia.org> (sfid-20170116_035516_550175_CCB4931C)
References: <874m114lwq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m114lwq.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

The rt2800_drv_data structure contains driver specific
information. Move the declaration into the rt2800lib.h
header which is a more logical place for it. Also fix
the comment style to avoid checkpatch warning.

The patch contains no functional changes, it is in
preparation for the next patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    | 16 ----------------
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index ec622a08a486..2371896c1e99 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2969,20 +2969,4 @@ enum rt2800_eeprom_word {
 #define WCID_END	222
 #define STA_IDS_SIZE	(WCID_END - WCID_START + 2)
 
-/*
- * RT2800 driver data structure
- */
-struct rt2800_drv_data {
-	u8 calibration_bw20;
-	u8 calibration_bw40;
-	u8 bbp25;
-	u8 bbp26;
-	u8 txmixer_gain_24g;
-	u8 txmixer_gain_5g;
-	u8 max_psdu;
-	unsigned int tbtt_tick;
-	unsigned int ampdu_factor_cnt[4];
-	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
-};
-
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 0a8b4df665fe..256928f0ea6a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -20,6 +20,22 @@
 #ifndef RT2800LIB_H
 #define RT2800LIB_H
 
+#include "rt2800.h"
+
+/* RT2800 driver data structure */
+struct rt2800_drv_data {
+	u8 calibration_bw20;
+	u8 calibration_bw40;
+	u8 bbp25;
+	u8 bbp26;
+	u8 txmixer_gain_24g;
+	u8 txmixer_gain_5g;
+	u8 max_psdu;
+	unsigned int tbtt_tick;
+	unsigned int ampdu_factor_cnt[4];
+	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
+};
+
 struct rt2800_ops {
 	void (*register_read)(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int offset, u32 *value);
-- 
2.11.0
