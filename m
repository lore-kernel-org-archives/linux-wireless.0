Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbbBOMDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:10 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 7/9] wil6210: rename 'secure_pcp' to 'privacy'
Date: Sun, 15 Feb 2015 14:02:36 +0200
Message-Id: <1424001758-29529-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130320_395941_6E264159)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make this field to track privacy attribute for all interface types

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 2 +-
 drivers/net/wireless/ath/wil6210/debugfs.c  | 2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c      | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 2d5ea21..38bd294 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -769,7 +769,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, bcon->assocresp_ies_len,
 		   bcon->assocresp_ies);
 
-	wil->secure_pcp = info->privacy;
+	wil->privacy = info->privacy;
 
 	netif_carrier_on(ndev);
 
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index fd59751..fbe27a3 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1400,7 +1400,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 
 /* fields in struct wil6210_priv */
 static const struct dbg_off dbg_wil_off[] = {
-	WIL_FIELD(secure_pcp,	S_IRUGO | S_IWUSR,	doff_u32),
+	WIL_FIELD(privacy,	S_IRUGO,		doff_u32),
 	WIL_FIELD(status[0],	S_IRUGO | S_IWUSR,	doff_ulong),
 	WIL_FIELD(fw_version,	S_IRUGO,		doff_u32),
 	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4afb8e4..b6e65c3 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -540,7 +540,7 @@ struct wil6210_priv {
 	wait_queue_head_t wq; /* for all wait_event() use */
 	/* profile */
 	u32 monitor_flags;
-	u32 secure_pcp; /* create secure PCP? */
+	u32 privacy; /* secure connection? */
 	int sinfo_gen;
 	/* interrupt moderation */
 	u32 tx_max_burst_duration;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index e60186c..0213135 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -874,7 +874,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 		struct wmi_pcp_started_event evt;
 	} __packed reply;
 
-	if (!wil->secure_pcp)
+	if (!wil->privacy)
 		cmd.disable_sec = 1;
 
 	if ((cmd.pcp_max_assoc_sta > WIL6210_MAX_CID) ||
-- 
2.1.0

