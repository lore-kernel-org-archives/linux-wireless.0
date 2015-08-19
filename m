Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35766 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbbHSLIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:08:52 -0400
Received: by lbcbn3 with SMTP id bn3so755441lbc.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 04:08:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add missing mutex unlock on failpath
Date: Wed, 19 Aug 2015 13:08:53 +0200
Message-Id: <1439982533-26824-1-git-send-email-michal.kazior@tieto.com> (sfid-20150819_130855_394509_D9CED362)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel would complain about leaving a held lock
after going back to userspace and would
subsequently deadlock.

Fixes: e04cafbc38c7 ("ath10k: fix peer limit enforcement")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9bca37820848..64674c955d44 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4144,7 +4144,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (ar->num_peers >= ar->max_num_peers) {
 		ath10k_warn(ar, "refusing vdev creation due to insufficient peer entry resources in firmware\n");
-		return -ENOBUFS;
+		ret = -ENOBUFS;
+		goto err;
 	}
 
 	if (ar->free_vdev_map == 0) {
-- 
2.1.4

