Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbcKBOMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:30 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/10] rt2800: correct AUTO_RSP_CFG
Date: Wed,  2 Nov 2016 15:11:01 +0100
Message-Id: <1478095865-8651-7-git-send-email-sgruszka@redhat.com> (sfid-20161102_151234_126764_1BDCCCCF)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize AUTO_RSP_CFG register to similar value as vendor driver does.

Do not set BAC_ACK_POLICY based on short preamble setting, those are
unrelated.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 9ecdc4c..ff4a7c3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1691,8 +1691,6 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp,
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
-		rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY,
-				   !!erp->short_preamble);
 		rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE,
 				   !!erp->short_preamble);
 		rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
@@ -4735,9 +4733,9 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY, 1);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 1);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE, 1);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
 	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
-- 
1.7.1
