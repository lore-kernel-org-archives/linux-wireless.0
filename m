Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46009 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0G2RpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 13:45:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: update hw/fw version info in wiphy struct
Date: Thu, 29 Jul 2010 13:34:50 -0400
Message-Id: <1280424890-18995-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43legacy/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1713f5f..0b8a3b5 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1623,6 +1623,7 @@ error:
 
 static int b43legacy_upload_microcode(struct b43legacy_wldev *dev)
 {
+	struct wiphy *wiphy = dev->wl->hw->wiphy;
 	const size_t hdr_len = sizeof(struct b43legacy_fw_header);
 	const __be32 *data;
 	unsigned int i;
@@ -1732,6 +1733,10 @@ static int b43legacy_upload_microcode(struct b43legacy_wldev *dev)
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
 
+	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version), "%u.%u",
+			dev->fw.rev, dev->fw.patch);
+	wiphy->hw_version = dev->dev->bus->chip_id;
+
 	return 0;
 
 error:
-- 
1.7.1.1

