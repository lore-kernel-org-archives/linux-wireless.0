Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51676 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2J3MHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 08:07:52 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, nbd@openwrt.org, sven@narfation.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] ath9k: apply coverage class on slottime too
Date: Tue, 30 Oct 2012 13:07:35 +0100
Message-Id: <1351598855-21427-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121030_130756_233071_EAE989B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

According to 802.11-2007 17.3.8.6 (slot time), the slot time should
be increased by 3 us * coverage class. The code only increased the
ack timeout, which is fixed by this patch.

We have noticed in our long shot scenario that we see less collisions
with this patch.

Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
[add standard reference and commit message]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 71cd9f0..1a3d483 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1114,7 +1114,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	}
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	acktimeout = slottime + sifstime + 3 * ah->coverage_class + ack_offset;
+	slottime += 3 * ah->coverage_class;
+	acktimeout = slottime + sifstime + ack_offset;
 	ctstimeout = acktimeout;
 
 	/*
-- 
1.7.10

