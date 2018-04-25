Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39704 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751022AbeDYFTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 01:19:40 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: fix nested rtnl locking on BG_SCAN_STOPPED
Date: Wed, 25 Apr 2018 10:49:31 +0530
Message-ID: <1524633572-5588-1-git-send-email-gbhat@marvell.com> (sfid-20180425_071944_247679_E4785207)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever sched_scan(BG_SCAN) is in progress and driver downloads
any command, firmware will send an event BG_SCAN_STOPPED. On
recieving this, driver calls cfg80211_sched_scan_stopped. This
function in turn will try to acquire rtnl_lock. But if the
rtnl_lock was already held(while sending the command above), this
will result in nested rtnl locking. To fix this driver must call
rtnl version of the API if rtnl_is_locked().

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 93dfb76..03ef625c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -848,7 +848,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_BG_SCAN_STOPPED:
 		dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
-		cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
+		if (rtnl_is_locked())
+			cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
+		else
+			cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
 		if (priv->sched_scanning)
 			priv->sched_scanning = false;
 		break;
-- 
1.9.1
