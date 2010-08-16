Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0HPUjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 16:39:16 -0400
Received: by fxm13 with SMTP id 13so3130309fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 13:39:14 -0700 (PDT)
From: =?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
Subject: [PATCH 1/4] b43: N-PHY: Implement Host Flags write during device init
Date: Mon, 16 Aug 2010 22:39:14 +0200
Message-Id: <1281991157-1557-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 5a72570..cb815cc 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1098,7 +1098,8 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 
 		if (dev->phy.rev < 2) {
 			if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
-				; /*TODO: b43_mhf(dev, 2, 0x0010, 0x0010, 3);*/
+				b43_hf_write(dev, b43_hf_read(dev) |
+						B43_HF_MLADVW);
 		} else if (dev->phy.rev == 2) {
 			b43_phy_write(dev, B43_NPHY_CRSCHECK2, 0);
 			b43_phy_write(dev, B43_NPHY_CRSCHECK3, 0);
-- 
1.6.4.2

