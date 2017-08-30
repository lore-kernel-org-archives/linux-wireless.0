Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42658 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750757AbdH3TmV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:42:21 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: notify cfg80211 about scan abort
Date: Thu, 31 Aug 2017 01:08:35 +0530
Message-ID: <1504121915-2063-1-git-send-email-gbhat@marvell.com> (sfid-20170830_214224_403057_24A3401F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver sends a series of scan commands to firmware to serve a
user scan request. If an intermediate scan command fails, driver
aborts the scan but it is not being informed to cfg80211. This
will cause issues in applications performing periodic scans.
Fix this by informing scan abort.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 0fba5b1..1bd4e13 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -70,11 +70,7 @@
 		break;
 	case HostCmd_CMD_802_11_SCAN:
 	case HostCmd_CMD_802_11_SCAN_EXT:
-		mwifiex_cancel_pending_scan_cmd(adapter);
-
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->scan_processing = false;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		mwifiex_cancel_scan(adapter);
 		break;
 
 	case HostCmd_CMD_MAC_CONTROL:
-- 
1.9.1
