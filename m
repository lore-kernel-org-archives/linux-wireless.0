Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35893 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbCXMkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:40:52 -0400
Received: by labe2 with SMTP id e2so82893026lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:40:50 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix survey reporting
Date: Tue, 24 Mar 2015 12:38:11 +0000
Message-Id: <1427200691-7109-1-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134055_853922_B1B553CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Number of channels is stored in a separate macro
in a header file and channel list is constructed
independently. The macro is used to define survey
array.

This fixes a recent regression introduced after
adding support for 144 channel. The regression
would lead to a warning and incomplete survey data
on channel 165:

  chan info: invalid frequency 5825 (idx 38 out of bounds)

Also make sure to enforce the sizes and avoid this
kind of problem in the future.

Fixes: 4a7898fed5f3 ("ath10k: enable channel 144 on 5GHz band")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    (based on pending branch)

 drivers/net/wireless/ath/ath10k/core.h | 2 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d50408822f39..7fa171fa55e3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -45,7 +45,7 @@
 #define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
 #define ATH10K_CONNECTION_LOSS_HZ (3*HZ)
-#define ATH10K_NUM_CHANS 38
+#define ATH10K_NUM_CHANS 39
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5f9705deb430..75cc304d32d4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6014,6 +6014,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	ht_cap = ath10k_get_ht_cap(ar);
 	vht_cap = ath10k_create_vht_cap(ar);
 
+	BUILD_BUG_ON((ARRAY_SIZE(ath10k_2ghz_channels) +
+		      ARRAY_SIZE(ath10k_5ghz_channels)) !=
+		     ATH10K_NUM_CHANS);
+
 	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
 		channels = kmemdup(ath10k_2ghz_channels,
 				   sizeof(ath10k_2ghz_channels),
-- 
2.1.4

