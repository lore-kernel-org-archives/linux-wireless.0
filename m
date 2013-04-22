Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42278 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3DVUe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 16:34:57 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH-RESEND] ath9k: apply coverage class on slottime too
Date: Mon, 22 Apr 2013 22:34:41 +0200
Message-Id: <1366662881-11249-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130422_223502_624300_E6C9C6CD)
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
resent after further testing and concensus (original patch from
Oct 2012, no changes made)
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 10eb6ba..7f25da8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1100,7 +1100,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	}
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	acktimeout = slottime + sifstime + 3 * ah->coverage_class + ack_offset;
+	slottime += 3 * ah->coverage_class;
+	acktimeout = slottime + sifstime + ack_offset;
 	ctstimeout = acktimeout;
 
 	/*
-- 
1.7.10.4

