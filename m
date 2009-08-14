Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38423 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZHNCBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 22:01:34 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 19:01:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Subject: [RFT] ar9170: downgrade BUG_ON() on unexpected mdpu
Date: Thu, 13 Aug 2009 19:01:35 -0700
Message-ID: <1250215295-11253-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If someone pulls the harware out while RX'ing a lot of traffic
I would funky data may be passed, BUG_ON() seems pretty extreme
so lets just drop the frame as we do when the length does not
meet our criteria for processing.

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This one depends on my previous patch.

 drivers/net/wireless/ath/ar9170/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 75c317d..0bbbc36 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1068,8 +1068,11 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 		break;
 
 	default:
-		BUG_ON(1);
-		break;
+		if (ar9170_nag_limiter(ar))
+			printk(KERN_ERR "%s: rx'd unexpected "
+			       "type of MPDU.\n",
+			       wiphy_name(ar->hw->wiphy));
+		return;
 	}
 
 	if (unlikely(mpdu_len < FCS_LEN))
-- 
1.6.3.3

