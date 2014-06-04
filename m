Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbaFDNUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:20:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [RFC/RFT 5/5] rt2x00: do not initialize BCN_OFFSET registers
Date: Wed,  4 Jun 2014 15:19:15 +0200
Message-Id: <1401887955-11361-5-git-send-email-sgruszka@redhat.com> (sfid-20140604_152049_606805_6E09D94B)
In-Reply-To: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
References: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We setup BCN_OFFSET{0,1} registers dinamicly, don't have to
initialize them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a9cdddd..893c9d5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4562,28 +4562,6 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	if (ret)
 		return ret;
 
-	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0,
-			   rt2800_get_beacon_offset(rt2x00dev, 0));
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1,
-			   rt2800_get_beacon_offset(rt2x00dev, 1));
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2,
-			   rt2800_get_beacon_offset(rt2x00dev, 2));
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3,
-			   rt2800_get_beacon_offset(rt2x00dev, 3));
-	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
-
-	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4,
-			   rt2800_get_beacon_offset(rt2x00dev, 4));
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5,
-			   rt2800_get_beacon_offset(rt2x00dev, 5));
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6,
-			   rt2800_get_beacon_offset(rt2x00dev, 6));
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7,
-			   rt2800_get_beacon_offset(rt2x00dev, 7));
-	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
-
 	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
 	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
 
-- 
1.8.3.1

