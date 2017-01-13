Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:57717 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdAMV0l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:26:41 -0500
Date: Fri, 13 Jan 2017 22:26:32 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 18/40] rt2x00: rt2800lib: use the extended EEPROM map for
 RT3883
Message-ID: <20170113212628.GA3494@makrotopia.org> (sfid-20170113_222643_875205_535EFCA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 870e2da20d47..e3b9a97b1fc2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -342,7 +342,8 @@ static unsigned int rt2800_eeprom_word_index(struct rt2x00_dev *rt2x00dev,
 		      wiphy_name(rt2x00dev->hw->wiphy), word))
 		return 0;
 
-	if (rt2x00_rt(rt2x00dev, RT3593))
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883))
 		map = rt2800_eeprom_map_ext;
 	else
 		map = rt2800_eeprom_map;
-- 
2.11.0
