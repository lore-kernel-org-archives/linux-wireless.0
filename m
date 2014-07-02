Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49050 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbaGBRHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 13:07:51 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so9373736wib.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 10:07:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: always print info about radio (manuf, id, revision)
Date: Wed,  2 Jul 2014 19:07:43 +0200
Message-Id: <1404320863-13372-1-git-send-email-zajec5@gmail.com> (sfid-20140702_190754_821217_636996D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Type of radio has a major meaning for the driver. There is quite some
code that does initialization/calibration depending on the radio rev.
Knowing radio params is quite important to provide help to users, so
print it even with debugging disabled.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This increases amount of lines that are always printed by b43 from 3 to
4. Do you think it's still acceptable? I'd really like to know what
radio are using ppl reporting any problems.
---
 drivers/net/wireless/b43/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4d7b38c..1b02016 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4469,13 +4469,13 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		B43_WARN_ON(1);
 	}
 	if (unsupported) {
-		b43err(dev->wl, "FOUND UNSUPPORTED RADIO "
-		       "(Manuf 0x%X, Version 0x%X, Revision %u)\n",
+		b43err(dev->wl,
+		       "FOUND UNSUPPORTED RADIO (Manuf 0x%X, ID 0x%X, Revision %u)\n",
 		       radio_manuf, radio_ver, radio_rev);
 		return -EOPNOTSUPP;
 	}
-	b43dbg(dev->wl, "Found Radio: Manuf 0x%X, Version 0x%X, Revision %u\n",
-	       radio_manuf, radio_ver, radio_rev);
+	b43info(dev->wl, "Found Radio: Manuf 0x%X, ID 0x%X, Revision %u\n",
+		radio_manuf, radio_ver, radio_rev);
 
 	phy->radio_manuf = radio_manuf;
 	phy->radio_ver = radio_ver;
-- 
1.8.4.5

