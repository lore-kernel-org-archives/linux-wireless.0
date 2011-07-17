Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57455 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1GQHwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 03:52:05 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so4861845fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 00:52:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: HT-PHY: find channel entry with regs data
Date: Sun, 17 Jul 2011 10:30:33 +0200
Message-Id: <1310891434-3537-3-git-send-email-zajec5@gmail.com> (sfid-20110717_095209_938404_3CE70183)
In-Reply-To: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
References: <1310891434-3537-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/radio_2059.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2059.c b/drivers/net/wireless/b43/radio_2059.c
index 23dea4b..f029f6e 100644
--- a/drivers/net/wireless/b43/radio_2059.c
+++ b/drivers/net/wireless/b43/radio_2059.c
@@ -161,5 +161,14 @@ static const struct b43_phy_ht_channeltab_e_radio2059 b43_phy_ht_channeltab_radi
 const struct b43_phy_ht_channeltab_e_radio2059
 *b43_phy_ht_get_channeltab_e_r2059(struct b43_wldev *dev, u16 freq)
 {
+	const struct b43_phy_ht_channeltab_e_radio2059 *e;
+	unsigned int i;
+
+	e = b43_phy_ht_channeltab_radio2059;
+	for (i = 0; i < ARRAY_SIZE(b43_phy_ht_channeltab_radio2059); i++, e++) {
+		if (e->freq == freq)
+			return e;
+	}
+
 	return NULL;
 }
-- 
1.7.3.4

