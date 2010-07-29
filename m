Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55185 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0G2SaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:30:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] b43: update hw/fw version info in wiphy struct
Date: Thu, 29 Jul 2010 14:28:50 -0400
Message-Id: <1280428130-29999-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <4C51C2C4.7050207@bu3sch.de>
References: <4C51C2C4.7050207@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 -> use coreid for hw_version

 drivers/net/wireless/b43/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 20631ae..294b688 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2280,6 +2280,7 @@ out:
 
 static int b43_upload_microcode(struct b43_wldev *dev)
 {
+	struct wiphy *wiphy = dev->wl->hw->wiphy;
 	const size_t hdr_len = sizeof(struct b43_fw_header);
 	const __be32 *data;
 	unsigned int i, len;
@@ -2405,6 +2406,10 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 		}
 	}
 
+	snprintf(wiphy->fw_version, sizeof(wiphy->fw_version), "%u.%u",
+			dev->fw.rev, dev->fw.patch);
+	wiphy->hw_version = dev->dev->id.coreid;
+
 	if (b43_is_old_txhdr_format(dev)) {
 		/* We're over the deadline, but we keep support for old fw
 		 * until it turns out to be in major conflict with something new. */
-- 
1.7.1.1

