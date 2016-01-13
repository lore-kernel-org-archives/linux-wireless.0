Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65167 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbcAMPrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:47:21 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 2/7] ath10k: Fix naming Peer stats rssi_changed field in 10.2.4
Date: Wed, 13 Jan 2016 21:16:29 +0530
Message-ID: <1452699994-5078-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164725_999218_A00290AD)
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Fix naming of peer stats rssi_changed field in 10.2.4 to make it
more readable. As of now this field is not used, but necessary to
pull in fw_stats with appropriate length.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e1bb02b..187f495 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4233,7 +4233,7 @@ struct wmi_10_2_peer_stats {
 
 struct wmi_10_2_4_peer_stats {
 	struct wmi_10_2_peer_stats common;
-	__le32 unknown_value; /* FIXME: what is this word? */
+	__le32 peer_rssi_changed;
 } __packed;
 
 struct wmi_10_2_4_ext_peer_stats {
-- 
1.7.9.5

