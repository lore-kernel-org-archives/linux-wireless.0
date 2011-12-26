Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16602 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1LZFNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 00:13:37 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Marek Lindner <lindner_marek@yahoo.de>
Subject: [PATCH] mac80211: fix kernel panic in IBSS due to a regression
Date: Mon, 26 Dec 2011 10:43:29 +0530
Message-ID: <1324876409-2031-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111226_061340_939860_6E1100C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

kernel panic occurs when we create an IBSS mode and leave it for
sometime without any joiner and this is introduced by the
commit ec2b774e7c91094d8c00de579646f1162b87b01e where we don't
put proper braces for 'list_for_each_entry_safe' and we pass an
invalid 'sta' pointer to __sta_info_destroy

EIP is at __list_add+0xe/0xa0
EAX: f3b63db4 EBX: 00000000 ECX: eab88c1c EDX: 00000000
ESI: 00000000 EDI: 00000246 EBP: f3b63d80 ESP: f3b63d58
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/u:2 (pid: 198, ti=f3b62000 task=f3afbea0
task.ti=f3b62000)
Stack:
00000000 00000000 f9ef9821 00000000 00000000 eab88c30
f3b63d80 c017f623
eab88bf0 eab88bf0 f3b63dd0 c066f925 00000000 00000002
00000000 f9ef9821
f3b63da0 c0180a2b eab88c1c eab88c30 00000002 f3afbea0
eab88bf4 f3b63db4
 Call Trace:
[<f9ef9821>] ? __ieee80211_stop_tx_ba_session+0x31/0x60
[mac80211]
[<c017f623>] ? debug_mutex_add_waiter+0x23/0x60
[<c066f925>] __mutex_lock_common+0xd5/0x390
[<f9ef9821>] ? __ieee80211_stop_tx_ba_session+0x31/0x60
[mac80211]
[<c0180a2b>] ? trace_hardirqs_off+0xb/0x10
[<c066fd37>] mutex_lock_nested+0x47/0x60
[<f9ef9821>] ? __ieee80211_stop_tx_ba_session+0x31/0x60
[mac80211]
[<f9ef9821>] __ieee80211_stop_tx_ba_session+0x31/0x60
[mac80211]
[<f9ef8989>] ieee80211_sta_tear_down_BA_sessions+0x39/0x60 [mac80211]
[<f9ef1a67>] __sta_info_destroy+0x57/0x780 [mac80211]
[<f9ef2223>] ieee80211_sta_expire+0x93/0xb0 [mac80211]
[<f9efc8f6>] ieee80211_ibss_work+0x2d6/0x530 [mac80211]

Cc: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/sta_info.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f0d3b48..b197136 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -945,7 +945,8 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta, *tmp;
 
 	mutex_lock(&local->sta_mtx);
-	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
+
+	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (sdata != sta->sdata)
 			continue;
 
@@ -956,6 +957,8 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 #endif
 			WARN_ON(__sta_info_destroy(sta));
 		}
+	}
+
 	mutex_unlock(&local->sta_mtx);
 }
 
-- 
1.7.0.4

