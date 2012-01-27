Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57628 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2A0KDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 05:03:18 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so1071014wic.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2012 02:03:18 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 3/3] mac80211: Move num_sta_ps counter decrement after synchronize_rcu
Date: Fri, 27 Jan 2012 11:02:53 +0100
Message-Id: <1327658573-477-3-git-send-email-helmut.schaa@googlemail.com> (sfid-20120127_110321_349564_3E6ECF2B)
In-Reply-To: <1327658573-477-2-git-send-email-helmut.schaa@googlemail.com>
References: <1327658573-477-1-git-send-email-helmut.schaa@googlemail.com>
 <1327658573-477-2-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unted the assumption that the sta struct is still accessible before the
synchronize_rcu call we should move the num_sta_ps counter decrement
after synchronize_rcu to avoid incorrect decrements if num_sta_ps.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Not sure if this really triggers in reality but it looks a bit more correct to me.

 net/mac80211/sta_info.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 92b894c..3af737c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -750,15 +750,6 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	sta->dead = true;
 
-	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
-		BUG_ON(!sdata->bss);
-
-		clear_sta_flag(sta, WLAN_STA_PS_STA);
-
-		atomic_dec(&sdata->bss->num_sta_ps);
-		sta_info_recalc_tim(sta);
-	}
-
 	local->num_sta--;
 	local->sta_generation++;
 
@@ -785,6 +776,15 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	 */
 	synchronize_rcu();
 
+	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		BUG_ON(!sdata->bss);
+
+		clear_sta_flag(sta, WLAN_STA_PS_STA);
+
+		atomic_dec(&sdata->bss->num_sta_ps);
+		sta_info_recalc_tim(sta);
+	}
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
 		__skb_queue_purge(&sta->ps_tx_buf[ac]);
-- 
1.7.7

