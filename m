Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:45:43 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/7] rt2800: limit TX_PWR_CFG_ values to 0xc
Date: Fri,  5 Oct 2012 13:44:10 +0200
Message-Id: <1349437455-18754-2-git-send-email-sgruszka@redhat.com> (sfid-20121005_134547_415730_1332DE1B)
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on AsicAdjustTxPower function from vendor driver
(2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO)
limit per rate TX power values we program into TX_PWR_CFG_ registers.

Note that on some configurations (devices/rates) is allowed to use
bigger values than 0xc, but we use safe maximum value for now. Further
work need to be done to allow use bigger values than 0xc.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a849a39..f3060d3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2563,7 +2563,8 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 	} else
 		reg_limit = 0;
 
-	return txpower + delta - reg_limit;
+	txpower = max(0, txpower + delta - reg_limit);
+	return min_t(u8, txpower, 0xc);
 }
 
 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
-- 
1.7.1

