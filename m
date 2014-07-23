Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59619 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaGWPyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 11:54:10 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCHv3 1/2] ath: Move spectral debugfs structs to shared header
Date: Wed, 23 Jul 2014 17:53:56 +0200
Message-Id: <1406130837-10353-2-git-send-email-sw@simonwunderlich.de> (sfid-20140723_175415_773823_75A16B70)
In-Reply-To: <1406130837-10353-1-git-send-email-sw@simonwunderlich.de>
References: <1406130837-10353-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sven Eckelmann <sven@narfation.org>

The ath9k and ath10k will share the definitions of the debugfs spectral
structures and enums. Having them in the same place helps to avoid conflicts.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/spectral.h  | 71 +-----------------------
 drivers/net/wireless/ath/spectral_common.h | 88 ++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 69 deletions(-)
 create mode 100644 drivers/net/wireless/ath/spectral_common.h

diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 137e2e6..0b9465e 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -17,6 +17,8 @@
 #ifndef SPECTRAL_H
 #define SPECTRAL_H
 
+#include "../spectral_common.h"
+
 /* enum spectral_mode:
  *
  * @SPECTRAL_DISABLED: spectral mode is disabled
@@ -54,8 +56,6 @@ struct ath_ht20_mag_info {
 	u8 max_exp;
 } __packed;
 
-#define SPECTRAL_HT20_NUM_BINS		56
-
 /* WARNING: don't actually use this struct! MAC may vary the amount of
  * data by -1/+2. This struct is for reference only.
  */
@@ -83,8 +83,6 @@ struct ath_ht20_40_mag_info {
 	u8 max_exp;
 } __packed;
 
-#define SPECTRAL_HT20_40_NUM_BINS		128
-
 /* WARNING: don't actually use this struct! MAC may vary the amount of
  * data. This struct is for reference only.
  */
@@ -125,71 +123,6 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 	return bins[0] & 0x3f;
 }
 
-/* FFT sample format given to userspace via debugfs.
- *
- * Please keep the type/length at the front position and change
- * other fields after adding another sample type
- *
- * TODO: this might need rework when switching to nl80211-based
- * interface.
- */
-enum ath_fft_sample_type {
-	ATH_FFT_SAMPLE_HT20 = 1,
-	ATH_FFT_SAMPLE_HT20_40,
-};
-
-struct fft_sample_tlv {
-	u8 type;	/* see ath_fft_sample */
-	__be16 length;
-	/* type dependent data follows */
-} __packed;
-
-struct fft_sample_ht20 {
-	struct fft_sample_tlv tlv;
-
-	u8 max_exp;
-
-	__be16 freq;
-	s8 rssi;
-	s8 noise;
-
-	__be16 max_magnitude;
-	u8 max_index;
-	u8 bitmap_weight;
-
-	__be64 tsf;
-
-	u8 data[SPECTRAL_HT20_NUM_BINS];
-} __packed;
-
-struct fft_sample_ht20_40 {
-	struct fft_sample_tlv tlv;
-
-	u8 channel_type;
-	__be16 freq;
-
-	s8 lower_rssi;
-	s8 upper_rssi;
-
-	__be64 tsf;
-
-	s8 lower_noise;
-	s8 upper_noise;
-
-	__be16 lower_max_magnitude;
-	__be16 upper_max_magnitude;
-
-	u8 lower_max_index;
-	u8 upper_max_index;
-
-	u8 lower_bitmap_weight;
-	u8 upper_bitmap_weight;
-
-	u8 max_exp;
-
-	u8 data[SPECTRAL_HT20_40_NUM_BINS];
-} __packed;
-
 void ath9k_spectral_init_debug(struct ath_softc *sc);
 void ath9k_spectral_deinit_debug(struct ath_softc *sc);
 
diff --git a/drivers/net/wireless/ath/spectral_common.h b/drivers/net/wireless/ath/spectral_common.h
new file mode 100644
index 0000000..b9ab722
--- /dev/null
+++ b/drivers/net/wireless/ath/spectral_common.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef SPECTRAL_COMMON_H
+#define SPECTRAL_COMMON_H
+
+#define SPECTRAL_HT20_NUM_BINS		56
+#define SPECTRAL_HT20_40_NUM_BINS		128
+
+/* FFT sample format given to userspace via debugfs.
+ *
+ * Please keep the type/length at the front position and change
+ * other fields after adding another sample type
+ *
+ * TODO: this might need rework when switching to nl80211-based
+ * interface.
+ */
+enum ath_fft_sample_type {
+	ATH_FFT_SAMPLE_HT20 = 1,
+	ATH_FFT_SAMPLE_HT20_40,
+};
+
+struct fft_sample_tlv {
+	u8 type;	/* see ath_fft_sample */
+	__be16 length;
+	/* type dependent data follows */
+} __packed;
+
+struct fft_sample_ht20 {
+	struct fft_sample_tlv tlv;
+
+	u8 max_exp;
+
+	__be16 freq;
+	s8 rssi;
+	s8 noise;
+
+	__be16 max_magnitude;
+	u8 max_index;
+	u8 bitmap_weight;
+
+	__be64 tsf;
+
+	u8 data[SPECTRAL_HT20_NUM_BINS];
+} __packed;
+
+struct fft_sample_ht20_40 {
+	struct fft_sample_tlv tlv;
+
+	u8 channel_type;
+	__be16 freq;
+
+	s8 lower_rssi;
+	s8 upper_rssi;
+
+	__be64 tsf;
+
+	s8 lower_noise;
+	s8 upper_noise;
+
+	__be16 lower_max_magnitude;
+	__be16 upper_max_magnitude;
+
+	u8 lower_max_index;
+	u8 upper_max_index;
+
+	u8 lower_bitmap_weight;
+	u8 upper_bitmap_weight;
+
+	u8 max_exp;
+
+	u8 data[SPECTRAL_HT20_40_NUM_BINS];
+} __packed;
+
+#endif /* SPECTRAL_COMMON_H */
-- 
1.9.1

