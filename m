Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56555 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2HKLU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 07:20:26 -0400
In-Reply-To: <201208111257.26417.chunkeey@googlemail.com>
References: <201208111257.26417.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 11 Aug 2012 13:09:20 +0200
Subject: [PATCH] p54: fix powerpc gcc warnings
To: linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, fengguang.wu@intel.com,
	linville@tuxdriver.com
Message-Id: <E1T09jx-0003TA-6G@debian64.localnet> (sfid-20120811_132031_342267_5146756B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My commit "p54: parse output power table" introduced
the following compiler warnings for powerpc-allmodconfig

eeprom.c: In function 'p54_get_maxpower':
eeprom.c:291 warning: comparison of distinct pointer types lacks a cast
eeporm.c:292 warning: comparison of distinct pointer types lacks a cast
eeprom.c:293 warning: comparison of distinct pointer types lacks a cast
eeprom.c:294 warning: comparison of distinct pointer types lacks a cast

This patch fixes those by using max_t(u16
which forces a type cast.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/eeprom.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index d4d8610..1ef1bfe 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -288,10 +288,14 @@ static int p54_get_maxpower(struct p54_common *priv, void *data)
 		for (j = 0; j < ARRAY_SIZE(pda->point); j++) {
 			struct pda_channel_output_limit_point_longbow *point =
 				&pda->point[j];
-			rawpower = max(rawpower, le16_to_cpu(point->val_qpsk));
-			rawpower = max(rawpower, le16_to_cpu(point->val_bpsk));
-			rawpower = max(rawpower, le16_to_cpu(point->val_16qam));
-			rawpower = max(rawpower, le16_to_cpu(point->val_64qam));
+			rawpower = max_t(u16,
+				rawpower, le16_to_cpu(point->val_qpsk));
+			rawpower = max_t(u16,
+				rawpower, le16_to_cpu(point->val_bpsk));
+			rawpower = max_t(u16,
+				rawpower, le16_to_cpu(point->val_16qam));
+			rawpower = max_t(u16,
+				rawpower, le16_to_cpu(point->val_64qam));
 		}
 		/* longbow seems to use 1/16 dBm units */
 		return rawpower / 16;
-- 
1.7.10.4

