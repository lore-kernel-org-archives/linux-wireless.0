Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44364 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeAXHkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 02:40:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
Date: Wed, 24 Jan 2018 08:40:51 +0100
Message-Id: <20180124074051.19939-1-johannes@sipsolutions.net> (sfid-20180124_084058_197640_C09D6B74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're obviously not part of a memory reclaim path, so don't set the flag.

This also causes a warning in check_flush_dependency() since we end up
in a code path that flushes a non-reclaim workqueue, and we shouldn't do
that if we were really part of reclaim.

Reported-by: syzbot+41cdaf4232c50e658934@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1cf22e62e3dd..6e0af815f25e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3516,7 +3516,7 @@ static int __init init_mac80211_hwsim(void)
 
 	spin_lock_init(&hwsim_radio_lock);
 
-	hwsim_wq = alloc_workqueue("hwsim_wq",WQ_MEM_RECLAIM,0);
+	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
 	if (!hwsim_wq)
 		return -ENOMEM;
 	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
-- 
2.15.1
