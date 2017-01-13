Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:41445 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751328AbdAMV3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:29:05 -0500
Date: Fri, 13 Jan 2017 22:28:56 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 25/40] rt2x00: rt2800lib: use correct beacon base for RT3883
Message-ID: <20170113212850.GA3542@makrotopia.org> (sfid-20170113_222907_239962_C560D167)
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
index 1933dc22f1c4..8f036090f320 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -983,7 +983,8 @@ EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
 					  unsigned int index)
 {
-	if (rt2x00_rt(rt2x00dev, RT3593))
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883))
 		return HW_BEACON_BASE_HIGH(index);
 
 	return HW_BEACON_BASE(index);
-- 
2.11.0
