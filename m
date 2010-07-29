Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44290 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab0G2SAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:00:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: update fw version info in wiphy struct
Date: Thu, 29 Jul 2010 13:51:39 -0400
Message-Id: <1280425899-20943-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index b818a43..f0e1eb7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -63,6 +63,9 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 
 	INFO(rt2x00dev, "Firmware detected - version: %d.%d.\n",
 	     fw->data[fw->size - 4], fw->data[fw->size - 3]);
+	snprintf(rt2x00dev->hw->wiphy->fw_version,
+			sizeof(rt2x00dev->hw->wiphy->fw_version), "%d.%d",
+			fw->data[fw->size - 4], fw->data[fw->size - 3]);
 
 	retval = rt2x00dev->ops->lib->check_firmware(rt2x00dev, fw->data, fw->size);
 	switch (retval) {
-- 
1.7.1.1

