Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9245 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab2DWPHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 11:07:25 -0400
Message-ID: <4F956DD2.2020309@gmail.com> (sfid-20120423_170728_949845_710003F9)
Date: Mon, 23 Apr 2012 16:57:22 +0200
From: Vitaly Wool <vitalywool@gmail.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH/RFC] mac80211: wake queues if ieee80211_suspend failed
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sometimes I'm seeing that after a rejected suspend which was
rejected by the driver's suspend routine, the device can not
associate to any AP any more. Investigation shows that it's
due to the fact that the queues are left stopped with the
reason IEEE80211_QUEUE_STOP_REASON_SUSPEND.

With that known, it looks like we need to wake queues on an
unsuccessful suspend attempt explicitly.

---
  net/mac80211/pm.c           |    2 ++
  1 file changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 844cefb..fd57913 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -96,6 +96,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
  		int err = drv_suspend(local, wowlan);
  		if (err) {
  			local->quiescing = false;
+			ieee80211_wake_queues_by_reason(hw,
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
  			return err;
  		}
  		list_for_each_entry(sdata,&local->interfaces, list) {
-- 
1.7.5.4

-- 
Vitaly Wool<vitalywool@gmail.com>

