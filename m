Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61281 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1BCVxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 16:53:01 -0500
Received: by wyb28 with SMTP id 28so1628838wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 13:53:00 -0800 (PST)
Message-Id: <cb1597685120e228d2c66a7eafc07aed1466f7dd.1296769444.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 3 Feb 2011 22:22:55 +0100
Subject: [PATCH] carl9170: fix typo in PS code
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a off-by-one bug which bugged
the driver's PS-POLL capability.

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---

Note: Even with this patch, powersave is still "troublesome".
So the functionality remains disabled [by default].
---
 drivers/net/wireless/ath/carl9170/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 939a0e9..84866a4 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -564,7 +564,7 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 	cam = ieee80211_check_tim(tim_ie, tim_len, ar->common.curaid);
 
 	/* 2. Maybe the AP wants to send multicast/broadcast data? */
-	cam = !!(tim_ie->bitmap_ctrl & 0x01);
+	cam |= !!(tim_ie->bitmap_ctrl & 0x01);
 
 	if (!cam) {
 		/* back to low-power land. */
-- 
1.7.2.3

