Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57628 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2A0KDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 05:03:04 -0500
Received: by wics10 with SMTP id s10so1071014wic.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2012 02:03:02 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/3] mac80211: Fix incorrect num_sta_ps decrement in __sta_info_destroy
Date: Fri, 27 Jan 2012 11:02:51 +0100
Message-Id: <1327658573-477-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120127_110309_519457_58B39473)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When WLAN_STA_PS_DRIVER is set by ieee80211_sta_block_awake the
num_sta_ps counter is not incremented. Hence, we shouldn't decrement
it in __sta_info_destroy if only WLAN_STA_PS_DRIVER is set. This
could result in an incorrect num_sta_ps counter leading to strange side
effects with associated powersaving clients.

Fix this by only decrementing num_sta_ps when WLAN_STA_PS_STA was set
before.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/sta_info.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5b4ab21..70a0de3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -750,12 +750,10 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	sta->dead = true;
 
-	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-	    test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
+	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
 		BUG_ON(!sdata->bss);
 
 		clear_sta_flag(sta, WLAN_STA_PS_STA);
-		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 
 		atomic_dec(&sdata->bss->num_sta_ps);
 		sta_info_recalc_tim(sta);
-- 
1.7.7

