Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39343 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0C1Wx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 18:53:28 -0400
Received: by mail-fx0-f223.google.com with SMTP id 23so424568fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 15:53:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: N-PHY: find table entry earlier for setting chanspec
Date: Mon, 29 Mar 2010 00:53:14 +0200
Message-Id: <1269816796-26820-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
References: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not want to partially change chanspec just to find out there is not
entry in table for given channel.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 052119b..d9e47ba 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3343,6 +3343,10 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 
 	if (dev->phy.rev >= 3) {
 		/* TODO */
+	} else {
+		tabent = b43_nphy_get_chantabent(dev, channel);
+		if (!tabent)
+			return -ESRCH;
 	}
 
 	nphy->radio_chanspec = chanspec;
@@ -3366,10 +3370,6 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 		/* TODO: PHY Radio2056 Setup (chan_info_ptr[i]) */
 		/* TODO: N PHY Chanspec Setup (chan_info_ptr[i]) */
 	} else {
-		tabent = b43_nphy_get_chantabent(dev, channel);
-		if (!tabent)
-			return -ESRCH;
-
 		tmp = (chanspec.b_freq == 1) ? 0x0020 : 0x0050;
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, tmp);
 		b43_radio_2055_setup(dev, tabent);
-- 
1.6.4.2

