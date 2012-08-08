Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56640 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030495Ab2HHRUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:20:16 -0400
Received: by obbuo13 with SMTP id uo13so1392370obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:20:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Aug 2012 19:20:15 +0200
Message-ID: <CAA2SeNLv9pE_3_-99Df_s0gF+56O6TFjfDfV-QuVxsOc6_Z5TQ@mail.gmail.com> (sfid-20120808_192021_322290_F28420AF)
Subject: [PATCH 1/1] ath9k: decrypt_error flag issue
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1780,7 +1780,6 @@
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_hdr *hdr;
 	int retval;
-	bool decrypt_error = false;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
@@ -1802,6 +1801,7 @@
 	tsf_lower = tsf & 0xffffffff;

 	do {
+		bool decrypt_error = false;
 		/* If handling rx interrupt and flush is in progress => exit */
 		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
 			break;
