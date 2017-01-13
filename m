Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:54298 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdAMV22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:28:28 -0500
Date: Fri, 13 Jan 2017 22:28:16 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 23/40] rt2x00: rt2800lib: hardcode txmixer gain values to
 zero for RT3883
Message-ID: <20170113212810.GA3528@makrotopia.org> (sfid-20170113_222836_637735_7A6FA58D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 797c60875ac6..e406885a5cc3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7514,7 +7514,8 @@ static u8 rt2800_get_txmixer_gain_24g(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 
-	if (rt2x00_rt(rt2x00dev, RT3593))
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883))
 		return 0;
 
 	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
@@ -7528,7 +7529,8 @@ static u8 rt2800_get_txmixer_gain_5g(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 
-	if (rt2x00_rt(rt2x00dev, RT3593))
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883))
 		return 0;
 
 	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
-- 
2.11.0
