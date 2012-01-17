Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64013 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2AQIXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 03:23:02 -0500
Received: by wibhm6 with SMTP id hm6so1165883wib.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 00:23:00 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Fix possible race between sta_unblock and network softirq
Date: Tue, 17 Jan 2012 09:22:49 +0100
Message-Id: <1326788569-7764-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120117_092306_958420_2151C1DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All other code paths in sta_unblock synchronize with the network
softirq by using local_bh_disable/enable. Do the same around
ieee80211_sta_ps_deliver_wakeup.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/sta_info.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 24d321f..5b4ab21 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -238,9 +238,11 @@ static void sta_unblock(struct work_struct *wk)
 	if (sta->dead)
 		return;
 
-	if (!test_sta_flag(sta, WLAN_STA_PS_STA))
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		local_bh_disable();
 		ieee80211_sta_ps_deliver_wakeup(sta);
-	else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL)) {
+		local_bh_enable();
+	} else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL)) {
 		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 
 		local_bh_disable();
-- 
1.7.7

