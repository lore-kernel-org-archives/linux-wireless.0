Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40952 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2H1Hdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 03:33:51 -0400
From: Dengke Qiu <dqiu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl:link speed is 0Mbps sometimes
Date: Tue, 28 Aug 2012 15:33:42 +0800
Message-ID: <1346139222-3102-1-git-send-email-dqiu@qca.qualcomm.com> (sfid-20120828_093356_253164_EBBAA562)
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MSB of rate index from FW is used for sgi. But the ath6kl_wmi_get_rate
doesn't handle it. The access to wmi_rate_tbl array may be out of range
if sgi is 1. This may cause the return value of ath6kl_wmi_get_rate()
function is incorrect link rate. We add sgi adjustment to avoid such case.

Signed-off-by: Dengke Qiu <dqiu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   13 ++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h |    3 +++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 0950b92..a67c57a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3120,10 +3120,21 @@ int ath6kl_wmi_sta_bmiss_enhance_cmd(struct wmi *wmi, u8 if_idx, bool enhance)
 
 s32 ath6kl_wmi_get_rate(s8 rate_index)
 {
+	u8 sgi = 0;
+
 	if (rate_index == RATE_AUTO)
 		return 0;
 
-	return wmi_rate_tbl[(u32) rate_index][0];
+	/* SGI is stored as the MSB of the rate_index */
+	if (rate_index & RATE_INDEX_MSB) {
+		rate_index &= RATE_INDEX_WITHOUT_SGI_MASK;
+		sgi = 1;
+	}
+
+	if (WARN_ON(rate_index > RATE_MCS_7_40))
+		rate_index = RATE_MCS_7_40;
+
+	return wmi_rate_tbl[(u32) rate_index][sgi];
 }
 
 static int ath6kl_wmi_get_pmkid_list_event_rx(struct wmi *wmi, u8 *datap,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 49d0177..cad135b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1730,6 +1730,9 @@ struct rx_stats {
 	a_sle32 ucast_rate;
 } __packed;
 
+#define RATE_INDEX_WITHOUT_SGI_MASK     0x7f
+#define RATE_INDEX_MSB     0x80
+
 struct tkip_ccmp_stats {
 	__le32 tkip_local_mic_fail;
 	__le32 tkip_cnter_measures_invoked;
-- 
1.7.1

