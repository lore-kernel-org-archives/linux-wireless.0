Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59265 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab2APPml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 10:42:41 -0500
Received: by werb14 with SMTP id b14so400238wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 07:42:39 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [RFC] mac80211: Fix possible race between sta_unblock and network softirq
Date: Mon, 16 Jan 2012 16:42:22 +0100
Message-Id: <1326728542-31697-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120116_164245_809189_979F347A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

I'm currently writing some code for rt2800 that requires the driver
to stop sending to a specific station for a short period of time
(until all AMPDUs are finished to work around a hw issue that affects
rate sampling with minstrel_ht). I decided to give
ieee80211_sta_block_awake a try, however, the machine sometimes locked
up while running some performance tests but due to a hw watchdog I
wasn't able to get any sort of backtrace :(

So, while doing some review of the ieee80211_sta_block_awake I came
across this and wondered if softirqs should be disabled when delivering
the buffered frames in sta_unblock.

Using this patch I cannot reproduce the lockup anymore.

So, is there any special reason this single code path in sta_unblock
doesn't disable softirqs?

Thanks,
Helmut

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

