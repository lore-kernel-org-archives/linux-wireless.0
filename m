Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36738 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcDTQlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:41:49 -0400
Received: by mail-pf0-f176.google.com with SMTP id e128so19849113pfe.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2016 09:41:49 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	kvalo@qca.qualcomm.com, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] rt2800lib: enable MFP if hw crypt is disabled
Date: Thu, 21 Apr 2016 00:41:34 +0800
Message-Id: <1461170494-576-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20160420_184155_903565_AF5C2DE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
care of the crypto with software encryption/decryption
and thus, MFP can be used.

Tested for secured mesh using ath9k_htc and ath9k.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

v2: set MFP correctly (Stanislaw Gruszka)
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 7fa0128..716468a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7492,6 +7492,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_is_usb(rt2x00dev))
 		ieee80211_hw_set(rt2x00dev->hw, HOST_BROADCAST_PS_BUFFERING);
 
+	/* Set MFP if HW crypto is disabled. */
+	if (rt2800_hwcrypt_disabled(rt2x00dev))
+		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
+
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2800_eeprom_addr(rt2x00dev,
-- 
2.3.0

