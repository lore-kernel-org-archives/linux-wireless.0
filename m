Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63148 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbbCTMkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:40:37 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 05/18] ath9k: add multi_read to be compatible with ath9k_htc
Date: Fri, 20 Mar 2015 13:38:45 +0100
Message-Id: <1426855138-6121-6-git-send-email-linux@rempel-privat.de> (sfid-20150320_134040_822493_510D61C0)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/init.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6c6e884..041decc 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -141,6 +141,16 @@ static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 	return val;
 }
 
+static void ath9k_multi_ioread32(void *hw_priv, u32 *addr,
+                                u32 *val, u16 count)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		val[i] = ath9k_ioread32(hw_priv, addr[i]);
+}
+
+
 static unsigned int __ath9k_reg_rmw(struct ath_softc *sc, u32 reg_offset,
 				    u32 set, u32 clr)
 {
@@ -530,6 +540,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ah->hw = sc->hw;
 	ah->hw_version.devid = devid;
 	ah->reg_ops.read = ath9k_ioread32;
+	ah->reg_ops.multi_read = ath9k_multi_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
 	ah->reg_ops.rmw = ath9k_reg_rmw;
 	pCap = &ah->caps;
-- 
1.9.1

