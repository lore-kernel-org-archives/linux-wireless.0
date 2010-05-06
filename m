Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42662 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0EFK3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 06:29:18 -0400
Received: by bwz19 with SMTP id 19so400099bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 03:29:17 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/3] rt2x00: rt2800: update initial SIFS values
Date: Thu, 6 May 2010 12:29:04 +0200
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005061229.04897.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the CCK and OFDM SIFS value is set to 32us. This value is neither
used by the Ralink driver nor specified in 802.11.

Instead of using 10us for CCK SIFS (as defined in 802.11) use 16us like in the
Ralink drivers. And indeed using a SIFS value of 10us breaks connectivity with
11g + CTS protected connections. Add a comment to the code why we don't use 10us
for CCK SIFS value.

The OFDM SIFS value is set to 16us (as defined in 802.11 and also used by the
Ralink drivers).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e37bbea..f786068 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1415,9 +1415,16 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
 
+	/*
+	 * Usually the CCK SIFS time should be set to 10 and the OFDM SIFS
+	 * time should be set to 16. However, the original Ralink driver uses
+	 * 16 for both and indeed using a value of 10 for CCK SIFS results in
+	 * connection problems with 11g + CTS protection. Hence, use the same
+	 * defaults as the Ralink driver: 16 for both, CCK and OFDM SIFS.
+	 */
 	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 32);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 32);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 16);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 16);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, 314);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
-- 
1.6.4.2

