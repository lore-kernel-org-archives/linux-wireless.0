Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932107AbeCJOPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:37 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 20/20] mt7601u: use request_firmware_cache() to address cache on reboot
Date: Sat, 10 Mar 2018 06:15:01 -0800
Message-Id: <20180310141501.2214-21-mcgrof@kernel.org> (sfid-20180310_151552_593498_681AB7E1)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

request_firmware_cache() will ensure the firmware is available on resume
from suspend if on reboot the device retains the firmware.

This optimization is in place given otherwise on reboot we have to
reload the firmware, the opmization saves us about max 1s, minimum 10ms.

Cantabile has reported back this fixes his woes with both suspend and
hibernation.

Reported-by: Cantabile <cantabile.desu@gmail.com>
Tested-by: Cantabile <cantabile.desu@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index 65a8004418ea..b90456a4b4d7 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
 					 MT_USB_DMA_CFG_TX_BULK_EN));
 
 	if (firmware_running(dev))
-		return 0;
+		return request_firmware_cache(dev->dev, MT7601U_FIRMWARE);
 
 	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
 	if (ret)
-- 
2.16.2
