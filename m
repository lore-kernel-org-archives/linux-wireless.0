Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37545 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab2LJOaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 09:30:55 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/4] ath9k: add EEPROM offset to debug message
Date: Mon, 10 Dec 2012 15:30:26 +0100
Message-Id: <1355149828-7394-2-git-send-email-juhosg@openwrt.org> (sfid-20121210_153058_081897_C0ECE88D)
In-Reply-To: <1355149828-7394-1-git-send-email-juhosg@openwrt.org>
References: <1355149828-7394-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Show the EEPROM offset of the failed read operation
in 'ath9k_hw_nvram_read'. The debug message is more
informative this way.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 4b6a935..bf52ae1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -119,7 +119,8 @@ bool ath9k_hw_nvram_read(struct ath_common *common, u32 off, u16 *data)
 
 	ret = common->bus_ops->eeprom_read(common, off, data);
 	if (!ret)
-		ath_dbg(common, EEPROM, "Unable to read eeprom region\n");
+		ath_dbg(common, EEPROM,
+			"unable to read eeprom region at offset %u\n", off);
 
 	return ret;
 }
-- 
1.7.10

