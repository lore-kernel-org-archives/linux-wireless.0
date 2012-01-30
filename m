Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35827 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2A3QBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 11:01:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: use WARN_ON_ONCE in ath_rc_get_highest_rix
Date: Mon, 30 Jan 2012 10:55:13 -0500
Message-Id: <1327938913-21007-1-git-send-email-linville@tuxdriver.com> (sfid-20120130_170134_997254_DDB3DDCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device seems to survive the issue, so no need to flood the logs
about it...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index b3c3798..635b592 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -694,7 +694,7 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 		return rate;
 
 	/* This should not happen */
-	WARN_ON(1);
+	WARN_ON_ONCE(1);
 
 	rate = ath_rc_priv->valid_rate_index[0];
 
-- 
1.7.4.4

