Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53620 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2A0KDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 05:03:17 -0500
Received: by werb13 with SMTP id b13so1081688wer.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2012 02:03:16 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/3] mac80211: Fix incorrect num_sta_ps decrement in ap_sta_ps_end
Date: Fri, 27 Jan 2012 11:02:52 +0100
Message-Id: <1327658573-477-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20120127_110319_764965_2DA5BA01)
In-Reply-To: <1327658573-477-1-git-send-email-helmut.schaa@googlemail.com>
References: <1327658573-477-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver blocked this specific STA with the help of
ieee80211_sta_block_awake we won't clear WLAN_STA_PS_STA later but
still decrement num_sta_ps. Hence, the next data frame from this
STA will trigger ap_sta_ps_end again and also decrement num_sta_ps
again leading to an incorrect num_sta_ps counter.

This can result in problems with powersaving clients not waking up
from PS because the TIM calculation might be skipped due to the
incorrect num_sta_ps counter.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rx.c       |    1 -
 net/mac80211/sta_info.c |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3567586..f89617a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1147,7 +1147,6 @@ static void ap_sta_ps_end(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	atomic_dec(&sdata->bss->num_sta_ps);
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d exits power save mode\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 70a0de3..92b894c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1007,9 +1007,11 @@ EXPORT_SYMBOL(ieee80211_find_sta);
 static void clear_sta_ps_flags(void *_sta)
 {
 	struct sta_info *sta = _sta;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
-	clear_sta_flag(sta, WLAN_STA_PS_STA);
+	if (test_and_clear_sta_flag(sta, WLAN_STA_PS_STA))
+		atomic_dec(&sdata->bss->num_sta_ps);
 }
 
 /* powersave support code */
-- 
1.7.7

