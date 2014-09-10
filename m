Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41327 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaIJNfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:45 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 18/22] wil6210: specify max. IE length
Date: Wed, 10 Sep 2014 16:34:47 +0300
Message-ID: <1410356091-19219-19-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153551_139631_2FEA46F4)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expose firmware limit for the max_scan_ie_len;
also do actually set IE's for the probe request

max_scan_ie_len used to be 0, this blocks scan requests with non-zero IE's

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 61eaf20..6119ecb 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -309,9 +309,23 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 			     request->channels[i]->center_freq);
 	}
 
+	if (request->ie_len)
+		print_hex_dump_bytes("Scan IE ", DUMP_PREFIX_OFFSET,
+				     request->ie, request->ie_len);
+	else
+		wil_dbg_misc(wil, "Scan has no IE's\n");
+
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_REQ, request->ie_len,
+			request->ie);
+	if (rc) {
+		wil_err(wil, "Aborting scan, set_ie failed: %d\n", rc);
+		goto out;
+	}
+
 	rc = wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
 			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
 
+out:
 	if (rc) {
 		del_timer_sync(&wil->scan_timer);
 		wil->scan_request = NULL;
@@ -813,6 +827,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 {
 	/* TODO: set real value */
 	wiphy->max_scan_ssids = 10;
+	wiphy->max_scan_ie_len = WMI_MAX_IE_LEN;
 	wiphy->max_num_pmkids = 0 /* TODO: */;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_AP) |
-- 
1.9.1

