Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33255 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab1ERS0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 14:26:38 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so526998ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 11:26:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Don't disable G0 PA_PE bit in case of BT coexistence.
Date: Wed, 18 May 2011 20:25:18 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201105182022.20341.IvDoorn@gmail.com>
In-Reply-To: <201105182022.20341.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <201105182025.19264.IvDoorn@gmail.com> (sfid-20110518_202641_461358_AA14F76D)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

(split off from the earlier RT35xx patch submitted by Shiang)

Signed-off-by: Shiang Tu <shiang_tu@ralinktech.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1cad89e..ce736e9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1811,7 +1811,11 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFTR_EN, 1);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_TRSW_EN, 1);
-	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, rf->channel <= 14);
+	if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags))
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
+	else
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN,
+				   rf->channel <= 14);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, rf->channel > 14);
 
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
-- 
1.7.2.3

