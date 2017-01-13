Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:38906 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVb4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:31:56 -0500
Date: Fri, 13 Jan 2017 22:31:48 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 33/40] rt2x00: rt2800lib: use high memory for beacons on
 RT3883
Message-ID: <20170113213143.GA3630@makrotopia.org> (sfid-20170113_223158_988740_9F45A797)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 55fc3ec4597b..51c9d5e8b888 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -97,7 +97,8 @@ static inline void rt2800_shared_mem_select(struct rt2x00_dev *rt2x00dev,
 
 static inline bool rt2800_beacon_uses_high_mem(struct rt2x00_dev *rt2x00dev)
 {
-	if (rt2x00_rt(rt2x00dev, RT3593))
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883))
 		return true;
 
 	return false;
-- 
2.11.0
