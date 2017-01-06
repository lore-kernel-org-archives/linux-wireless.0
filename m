Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033943AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 5/9] rt2800: tune TX_RTS_CFG config
Date: Fri,  6 Jan 2017 14:05:14 +0100
Message-Id: <1483707918-31480-6-git-send-email-sgruszka@redhat.com> (sfid-20170106_141129_708333_CDD07453)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable RTS frame retry fall-back and limit number of RTS retries to 7
what is default number of retries for small frames. As RTS/CTS is used
for TXOP protection, those settings prevent posting lots of RTS
frames when remote station do not response with CTS at the moment. After
sending 7 RTS's the HW will start back-off mechanism and after it will
start posing RTS again to get access to the medium.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 4833ec6..1f4a120 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4902,10 +4902,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
 
 	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
+	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 7);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
 			   IEEE80211_MAX_RTS_THRESHOLD);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 0);
+	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 1);
 	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
 
 	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
-- 
2.7.4
