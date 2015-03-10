Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38528 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbbCJN3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 09:29:16 -0400
Received: by lbiz12 with SMTP id z12so1688623lbi.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 06:29:14 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: fix PMG by using AES-CMAC/IGTK software crypto
Date: Tue, 10 Mar 2015 14:29:05 +0100
Message-Id: <1425994145-15574-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20150310_142929_982633_63023FC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While testing with older supplicant, .drv_set_key() was failing due to
higher than ath10k firmware could handle key_index (WMI_MAX_KEY_INDEX == 3).

--
wpa_driver_nl80211_set_key: ifindex=15 alg=4 addr=0x7f02b129fbe3 key_idx=4 set_tx=0 seq_len=6 key_len=16
    broadcast key
nl80211: set_key failed; err=-22 Invalid argument)
wlan0: WPA: Failed to configure IGTK to the driver
wlan0: RSN: Failed to configure IGTK
--

In order to fix this case (PMF: AES-CMAC/IGTK) force the AES_CMAC cipher to
be handled by software.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f8923f..2264c06361b1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -66,8 +66,8 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		arg.key_cipher = WMI_CIPHER_WEP;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		/* this one needs to be done in software */
-		return 1;
+		WARN_ON(1)
+		return -EINVAL;
 	default:
 		ath10k_warn(ar, "cipher %d is not supported\n", key->cipher);
 		return -EOPNOTSUPP;
@@ -3995,6 +3995,10 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	int ret = 0;
 	u32 flags = 0;
 
+	/* this one needs to be done in software */
+	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+		return 1;
+
 	if (key->keyidx > WMI_MAX_KEY_INDEX)
 		return -ENOSPC;
 
-- 
2.1.2

