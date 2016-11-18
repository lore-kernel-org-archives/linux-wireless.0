Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752758AbcKRJsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 04:48:23 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 8/9] rt2800: tune *_PROT_CFG parameters
Date: Fri, 18 Nov 2016 10:44:00 +0100
Message-Id: <1479462241-9299-9-git-send-email-sgruszka@redhat.com> (sfid-20161118_104828_692161_5A9CF999)
In-Reply-To: <1479462241-9299-1-git-send-email-sgruszka@redhat.com>
References: <1479462241-9299-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use RTS/CTS protection for TXOP on all rates modes as default and
disable CCK rates (this cause performance problems).

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 57bfec4..8d35b2e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4771,9 +4771,9 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV_SHORT, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 0);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
@@ -4784,9 +4784,9 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV_SHORT, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 0);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
@@ -4797,9 +4797,9 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV_SHORT, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_CCK, 0);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
@@ -4810,9 +4810,9 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV_SHORT, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_CCK, 0);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-- 
1.8.3.1
