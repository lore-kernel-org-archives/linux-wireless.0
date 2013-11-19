Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51797 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSQNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 11:13:01 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so4264612wes.15
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 08:12:58 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: set hw initial idle state
Date: Tue, 19 Nov 2013 17:12:05 +0100
Message-Id: <1384877525-23221-1-git-send-email-karl.beldan@gmail.com> (sfid-20131119_171306_599800_A455B4F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM, the first call of ieee80211_do_open will configure the hw as
non-idle, even if the interface being brought up is not a monitor, and
this leads to inconsistent sequences like:

register_hw()
	do_open(sta)
		hw_config(non-idle)
(.. sta is non-idle ..)
scan(sta)
	hw_config(idle) (after scan finishes)
do_stop(sta)
do_open(sta)
(.. sta is idle ..)

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index bdb0b6c..3ef7fc3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -995,6 +995,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
 			    result);
 
+	local->hw.conf.flags = IEEE80211_CONF_IDLE;
+
 	ieee80211_led_init(local);
 
 	rtnl_lock();
-- 
1.8.2

