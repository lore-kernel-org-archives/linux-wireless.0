Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36105 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0G2SPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:15:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] zd1211rw: update fw version info in wiphy struct
Date: Thu, 29 Jul 2010 14:00:15 -0400
Message-Id: <1280426415-22014-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index b2af3c5..87a95bc 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -973,6 +973,7 @@ static void dump_fw_registers(struct zd_chip *chip)
 
 static int print_fw_version(struct zd_chip *chip)
 {
+	struct wiphy *wiphy = zd_chip_to_mac(chip)->hw->wiphy;
 	int r;
 	u16 version;
 
@@ -982,6 +983,10 @@ static int print_fw_version(struct zd_chip *chip)
 		return r;
 
 	dev_info(zd_chip_dev(chip),"firmware version %04hx\n", version);
+
+	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version),
+			"%04hx", version);
+
 	return 0;
 }
 
-- 
1.7.1.1

