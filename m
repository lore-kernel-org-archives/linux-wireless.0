Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYFLBti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/29] iwlwifi: fix allow iwlwifi to aggregate according to tid load
Date: Thu, 12 Jun 2008 09:46:58 +0800
Message-Id: <1213235239-2954-9-git-send-email-yi.zhu@intel.com> (sfid-20080612_034944_502615_8B528212)
In-Reply-To: <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This fix opens back the aggregation decision path for iwlwifi.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index a928741..77884e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -273,8 +273,8 @@ static void rs_tl_rm_old_stats(struct iwl4965_traffic_load *tl, u32 curr_time)
  *	increment traffic load value for tid and also remove
  *	any old values if passed the certain time period
  */
-static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
-			     struct ieee80211_hdr *hdr)
+static u8 rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
+			   struct ieee80211_hdr *hdr)
 {
 	u32 curr_time = jiffies_to_msecs(jiffies);
 	u32 time_diff;
@@ -287,7 +287,7 @@ static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
 		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
 		tid = qc[0] & 0xf;
 	} else
-		return;
+		return MAX_TID_COUNT;
 
 	tl = &lq_data->load[tid];
 
@@ -300,7 +300,7 @@ static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
 		tl->queue_count = 1;
 		tl->head = 0;
 		tl->packet_count[0] = 1;
-		return;
+		return MAX_TID_COUNT;
 	}
 
 	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
@@ -317,6 +317,8 @@ static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
 
 	if ((index + 1) > tl->queue_count)
 		tl->queue_count = index + 1;
+
+	return tid;
 }
 
 /*
@@ -1680,7 +1682,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	}
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
-	rs_tl_add_packet(lq_sta, hdr);
+	tid = rs_tl_add_packet(lq_sta, hdr);
+
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
 	 * the rest of this function:  "search" if searching for better
-- 
1.5.3.6

