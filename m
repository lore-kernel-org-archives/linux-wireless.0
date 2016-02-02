Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33085 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbcBBHvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 02:51:23 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2] mac80211: fix memory leak
Date: Tue,  2 Feb 2016 13:21:14 +0530
Message-Id: <1454399474-11350-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160202_085139_412988_C015FFF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sudip Mukherjee <sudip@vectorindia.org>

On error we jumped to the error label and returned the error code but we
missed releasing sinfo.

Fixes: 5fe74014172d ("mac80211: avoid excessive stack usage in sta_info")
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v2: added Fixes tag, Reviewed-by and From:.

 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6c198e6..36e75c4 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -561,6 +561,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	__cleanup_single_sta(sta);
  out_err:
 	mutex_unlock(&local->sta_mtx);
+	kfree(sinfo);
 	rcu_read_lock();
 	return err;
 }
-- 
1.9.1

