Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35036 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756019AbcKWH7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 02:59:41 -0500
Received: by mail-pg0-f44.google.com with SMTP id p66so3369328pga.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 23:59:40 -0800 (PST)
From: Chris Chiu <chiu@endlessm.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: linux@endlessm.com, Chris Chiu <chiu@endlessm.com>
Subject: [PATCH] mac80211: fix Tx BA session stuck issue during sw scanning
Date: Wed, 23 Nov 2016 15:59:28 +0800
Message-Id: <1479887968-17473-1-git-send-email-chiu@endlessm.com> (sfid-20161123_085944_969709_7D7812D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_iface_work() will check if sw scanning is in progress
before handling block ack session. In our case, the RTL8821AE
operate in station mode, when tx session expired, DELBA packet
stuck during sw scanning and so do other data packets.

ieee80211_scan_state_decision() will take lots of time in
SCAN_SUSPEND/SCAN_RESUME state due to !tx_empty or bad_latency.
Then the sw scanning mostly take > 20 seconds to finish or even
worse in our case RTL8821AE have 37 channels for 2G+5G to scan
and tx stalls ~300 seconds. AP side still thinks the connection
is alive because it still receives the QoS NULL packet from STA.
So the link state will never change but actually no data tx/rx
during this long time.

This commit tries to send out packet in SCAN_SUSPEND state so the
sw scanning can complete more efficiently and less affect on Block
Ack session handling. Verified on RTL8821AE for > 30000 pings and
no Tx BA session stuck observed.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/iface.c       | 4 +++-
 net/mac80211/scan.c        | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f56d342..78c1a13 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1076,6 +1076,7 @@ enum {
 	SCAN_SW_SCANNING,
 	SCAN_HW_SCANNING,
 	SCAN_ONCHANNEL_SCANNING,
+	SCAN_SUSPEND_SCANNING,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
 	SCAN_HW_CANCELLED,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b123a9e..0a43997 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1215,8 +1215,10 @@ static void ieee80211_iface_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	if (test_bit(SCAN_SW_SCANNING, &local->scanning))
+	if (test_bit(SCAN_SW_SCANNING, &local->scanning) &&
+	    !test_bit(SCAN_SUSPEND_SCANNING, &local->scanning)) {
 		return;
+	}
 
 	if (!ieee80211_can_run_worker(local))
 		return;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 070b40f..ebd32a0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -800,6 +800,8 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 		break;
 	}
 
+	test_and_clear_bit(SCAN_SUSPEND_SCANNING, &local->scanning);
+
 	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
 		skip = 1;
 
@@ -844,6 +846,8 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 	/* disable PS */
 	ieee80211_offchannel_return(local);
 
+	__set_bit(SCAN_SUSPEND_SCANNING, &local->scanning);
+
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */
 	local->next_scan_state = SCAN_RESUME;
-- 
2.1.4
