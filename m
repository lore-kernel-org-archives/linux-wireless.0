Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56179 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3FIGNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:11 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/6] wil6210: fix timeout for start_pcp
Date: Sun, 9 Jun 2013 09:12:50 +0300
Message-ID: <1370758375-16867-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081315_031348_4ED37D32)
In-Reply-To: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It may take up to 3500ms for the FW to start AP/PCP. Increase accordingly,
adding some safety margin.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 527ffb5..aeb64f2 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -739,8 +739,12 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 	if (!wil->secure_pcp)
 		cmd.disable_sec = 1;
 
+	/*
+	 * Processing time may be huge, in case of secure AP it takes about
+	 * 3500ms for FW to start AP
+	 */
 	rc = wmi_call(wil, WMI_PCP_START_CMDID, &cmd, sizeof(cmd),
-		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 100);
+		      WMI_PCP_STARTED_EVENTID, &reply, sizeof(reply), 5000);
 	if (rc)
 		return rc;
 
-- 
1.8.1.2

