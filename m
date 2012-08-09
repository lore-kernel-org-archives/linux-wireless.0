Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35290 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030969Ab2HIPrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 11:47:48 -0400
Received: by ghrr11 with SMTP id r11so582686ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 08:47:47 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Aug 2012 17:47:47 +0200
Message-ID: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com> (sfid-20120809_174752_209600_635FF81F)
Subject: [PATCH v2] ath9k: decrypt_error flag issue
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

After the hw reports a decryption error, the flag decrypt_error is set to
true in ath9k_rx_accept.
Since this flag is initialized to false just outside ath_rx_tasklet while cycle,
all subsequent frames are marked as corrupted until ath_rx_tasklet ends.
Fix the issue initializing decrypt_error flag at the begging of the cycle.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1044,7 +1044,6 @@
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_hdr *hdr;
 	int retval;
-	bool decrypt_error = false;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
@@ -1066,6 +1065,7 @@
 	tsf_lower = tsf & 0xffffffff;

 	do {
+		bool decrypt_error = false;
 		/* If handling rx interrupt and flush is in progress => exit */
 		if (test_bit(SC_OP_RXFLUSH, &sc->sc_flags) && (flush == 0))
 			break;
