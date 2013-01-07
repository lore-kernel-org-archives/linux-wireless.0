Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:10448 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3AGBoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2013 20:44:10 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/wireless/mwl8k.c: avoid use-after-free
Date: Sun,  6 Jan 2013 20:27:22 -0500
Message-Id: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu> (sfid-20130107_024413_719279_1BFE888B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not dereference p->station_id after kfree(cmd) because p
points into the cmd data structure.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/net/wireless/mwl8k.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f221b95..83564d3 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4250,9 +4250,11 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->amsdu_enabled = 0;
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
+	if (!rc)
+		rc = p->station_id;
 	kfree(cmd);
 
-	return rc ? rc : p->station_id;
+	return rc;
 }
 
 static int mwl8k_cmd_update_stadb_del(struct ieee80211_hw *hw,
-- 
1.7.10.4

