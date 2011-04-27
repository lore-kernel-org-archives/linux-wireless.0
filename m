Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab1D0Lku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:40:50 -0400
Received: by pwi15 with SMTP id 15so609306pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 04:40:49 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19896.347.762620.660156@gargle.gargle.HOWL> (sfid-20110427_134052_543492_B28D4BC5)
Date: Wed, 27 Apr 2011 17:13:23 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 3/4] ath9k_htc: Add a new WMI command to set a rate mask
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This patch adds WMI_BITRATE_MASK_CMDID which can be
used by the set_bitrate_mask() handler.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    7 +++++++
 drivers/net/wireless/ath/ath9k/wmi.c |    2 ++
 drivers/net/wireless/ath/ath9k/wmi.h |    1 +
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 55f4bb3..6bb71e3 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -171,6 +171,13 @@ struct ath9k_htc_target_rate {
 	struct ath9k_htc_rate rates;
 };
 
+struct ath9k_htc_target_rate_mask {
+	u8 vif_index;
+	u8 band;
+	__be32 mask;
+	u16 pad;
+} __packed;
+
 struct ath9k_htc_target_int_stats {
 	__be32 rx;
 	__be32 rxorn;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 463b76a..f9b1eb4 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -79,6 +79,8 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_TX_STATS_CMDID";
 	case WMI_RX_STATS_CMDID:
 		return "WMI_RX_STATS_CMDID";
+	case WMI_BITRATE_MASK_CMDID:
+		return "WMI_BITRATE_MASK_CMDID";
 	}
 
 	return "Bogus";
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 5dfc213..6095eeb 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -111,6 +111,7 @@ enum wmi_cmd_id {
 	WMI_INT_STATS_CMDID,
 	WMI_TX_STATS_CMDID,
 	WMI_RX_STATS_CMDID,
+	WMI_BITRATE_MASK_CMDID,
 };
 
 enum wmi_event_id {
-- 
1.7.4.4

