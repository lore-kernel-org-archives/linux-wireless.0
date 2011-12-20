Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35859 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1LTVEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 16:04:48 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so6950267eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 13:04:48 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: fix success condition of running samples
Date: Tue, 20 Dec 2011 22:45:48 +0100
Message-Id: <1324417549-5545-2-git-send-email-zajec5@gmail.com> (sfid-20111220_220451_688574_55A6E68E)
In-Reply-To: <1324417549-5545-1-git-send-email-zajec5@gmail.com>
References: <1324417549-5545-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 52503c6..da6fa03 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -956,7 +956,7 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 			b43_phy_write(dev, B43_NPHY_SAMP_CMD, 1);
 	}
 	for (i = 0; i < 100; i++) {
-		if (b43_phy_read(dev, B43_NPHY_RFSEQST) & 1) {
+		if (!(b43_phy_read(dev, B43_NPHY_RFSEQST) & 1)) {
 			i = 0;
 			break;
 		}
-- 
1.7.3.4

