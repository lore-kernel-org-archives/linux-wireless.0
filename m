Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33255 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab1ERS0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 14:26:35 -0400
Received: by ewy4 with SMTP id 4so526998ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 11:26:34 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/7] rt2x00: Enable PA_PE bits in TX_PIN_CFG according to active band.
Date: Wed, 18 May 2011 20:25:05 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Message-Id: <201105182025.05979.IvDoorn@gmail.com> (sfid-20110518_202638_870830_9D728C37)
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

(split off from the earlier RT35xx patch submitted by Shiang)

There's no point in enabling the PA_PE bits for the bands that we are
not active on.

Signed-off-by: Shiang Tu <shiang_tu@ralinktech.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 93fb674..1cad89e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1795,8 +1795,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	/* Turn on unused PA or LNA when not using 1T or 1R */
 	if (rt2x00dev->default_ant.tx_chain_num == 2) {
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
+				   rf->channel > 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
+				   rf->channel <= 14);
 	}
 
 	/* Turn on unused PA or LNA when not using 1T or 1R */
-- 
1.7.2.3

