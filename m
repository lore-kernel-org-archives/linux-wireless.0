Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55177 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab0G2SaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:30:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] b43legacy: update hw/fw version info in wiphy struct
Date: Thu, 29 Jul 2010 14:29:53 -0400
Message-Id: <1280428193-30038-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1280424890-18995-1-git-send-email-linville@tuxdriver.com>
References: <1280424890-18995-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 -> use coreid for hw_version

 drivers/net/wireless/b43legacy/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1713f5f..67f18ec 100644
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
+	wiphy->hw_version = dev->dev->id.coreid;
+
 	return 0;
 
 error:
-- 
1.7.1.1

