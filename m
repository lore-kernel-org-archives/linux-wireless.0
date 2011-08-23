Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.202]:49354 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab1HWVPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 17:15:08 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] carl9170: Fix mismatch in carl9170_op_set_key mutex lock-unlock
Date: Wed, 24 Aug 2011 00:44:32 +0400
Message-Id: <1314132272-7357-1-git-send-email-khoroshilov@ispras.ru> (sfid-20110823_231512_532034_AF895B3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If is_main_vif(ar, vif) reports that we have to fall back
to software encryption, we goto err_softw; before locking ar->mutex.
As a result, we have unprotected call to carl9170_set_operating_mode
and unmatched mutex_unlock.

The patch fix the issue by adding mutex_lock before goto.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/carl9170/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 0122930..0474e663 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1066,8 +1066,10 @@ static int carl9170_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 * the high througput speed in 802.11n networks.
 	 */
 
-	if (!is_main_vif(ar, vif))
+	if (!is_main_vif(ar, vif)) {
+		mutex_lock(&ar->mutex);
 		goto err_softw;
+	}
 
 	/*
 	 * While the hardware supports *catch-all* key, for offloading
-- 
1.7.4.1

