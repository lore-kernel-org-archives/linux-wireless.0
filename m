Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:37253 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdAMV0d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:26:33 -0500
Date: Fri, 13 Jan 2017 22:25:34 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 15/40] rt2x00: rt2800soc: fix rt2800soc_disable_radio for
 RT3883
Message-ID: <20170113212529.GA3472@makrotopia.org> (sfid-20170113_222739_975203_F1FE9765)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index 871d9d331046..85575004a784 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -51,9 +51,16 @@ static bool rt2800soc_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800soc_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
+	u32 reg;
+
 	rt2800_disable_radio(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, 0);
+
+	reg = 0;
+	if (rt2x00_rt(rt2x00dev, RT3883))
+		rt2x00_set_field32(&reg, TX_PIN_CFG_RFTR_EN, 1);
+
+	rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, reg);
 }
 
 static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
-- 
2.11.0
