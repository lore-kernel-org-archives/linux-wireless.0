Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34704 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaHDIWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:41 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 10/14] wil6210: fix false "scan timeout"
Date: Mon, 4 Aug 2014 11:20:50 +0300
Message-ID: <1407140454-31639-11-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102907_509772_49EE7B16)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

When sending scan request, if hardware is not ready, scan timer was started
and scan timeout mis-reported.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ee8a0e5..a00f318 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -311,8 +311,10 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	rc = wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
 			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
 
-	if (rc)
+	if (rc) {
+		del_timer_sync(&wil->scan_timer);
 		wil->scan_request = NULL;
+	}
 
 	return rc;
 }
-- 
1.8.5.2

