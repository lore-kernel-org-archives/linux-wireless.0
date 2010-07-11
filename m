Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61101 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0GKKcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:11 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so426234eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/17] rt2x00: Don't initialize beacon interval to 0 on rt2800 devices
Date: Sun, 11 Jul 2010 12:29:49 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111228.56050.IvDoorn@gmail.com> <201007111229.27800.IvDoorn@gmail.com>
In-Reply-To: <201007111229.27800.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111229.50936.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Activating the TBTT interrupt when a beacon interval of 0 is configured
results in an interrupt storm causing the machine to hang. Hence,
initialize the beacon interval to a reasonable default of 100TUs.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 64bfa6e..cfe199b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1419,7 +1419,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
 	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 0);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 1600);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-- 
1.7.1.1

