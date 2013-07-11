Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45860 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3GKNUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 09:20:51 -0400
Received: by mail-ie0-f175.google.com with SMTP id a11so10500954iee.6
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 06:20:51 -0700 (PDT)
Date: Thu, 11 Jul 2013 09:19:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, mickflemm@gmail.com
Subject: [PATCH] ath5k: fix extra set bit in multicast mask
Message-ID: <20130711131913.GA31660@localhost> (sfid-20130711_152055_355495_B69C43D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bit 32 was always set which looks to have been accidental,
according to git history.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Just found this while reading old code -- I could maybe see
bit 0 being special, but bit 32 seemed odd.  Then looked
back through the history and looks like it was accidentally
added when prepare_multicast() was introduced; prior both
were initialized to 0.

 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 06f86f4..f5f1bc7 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -325,7 +325,7 @@ ath5k_prepare_multicast(struct ieee80211_hw *hw,
 	struct netdev_hw_addr *ha;
 
 	mfilt[0] = 0;
-	mfilt[1] = 1;
+	mfilt[1] = 0;
 
 	netdev_hw_addr_list_for_each(ha, mc_list) {
 		/* calculate XOR of eight 6-bit values */
-- 
1.7.10.4

-- 
Bob Copeland %% www.bobcopeland.com
