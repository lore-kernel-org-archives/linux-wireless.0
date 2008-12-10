Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4882 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYLJEFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 23:05:43 -0500
Date: Tue, 9 Dec 2008 23:05:38 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: fix endianness of bitwise ops when installing mic
Message-ID: <20081210040538.GA11810@hash.localnet> (sfid-20081210_050605_521920_6011A98E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix these bugs found by sparse:

    ath5k/pcu.c:1102:21: warning: restricted __le32 degrades to integer
    ath5k/pcu.c:1102:13: warning: incorrect type in assignment (different base types)
    ath5k/pcu.c:1102:13:    expected restricted __le32 <noident>
    ath5k/pcu.c:1102:13:    got unsigned int
    ath5k/pcu.c:1104:20: warning: restricted __le32 degrades to integer
    ath5k/pcu.c:1104:13: warning: incorrect type in assignment (different base types)
    ath5k/pcu.c:1104:13:    expected restricted __le32 <noident>
    ath5k/pcu.c:1104:13:    got unsigned int

Changes-licensed-under: ISC

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/pcu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index dabe422..0cac05c 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -1099,9 +1099,9 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 
 		if (ah->ah_combined_mic) {
 			key_v[0] = rxmic[0];
-			key_v[1] = (txmic[0] >> 16) & 0xffff;
+			key_v[1] = cpu_to_le32(le32_to_cpu(txmic[0]) >> 16);
 			key_v[2] = rxmic[1];
-			key_v[3] = txmic[0] & 0xffff;
+			key_v[3] = cpu_to_le32(le32_to_cpu(txmic[0]) & 0xffff);
 			key_v[4] = txmic[1];
 		} else {
 			key_v[0] = rxmic[0];
-- 
1.6.0.4

-- 
Bob Copeland %% www.bobcopeland.com

