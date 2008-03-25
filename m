Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbYCYXdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/6] mac80211: fix wrong Rx A-MPDU control via debugfs
Date: Tue, 25 Mar 2008 16:33:39 -0700
Message-Id: <1206488021-4193-5-git-send-email-reinette.chatre@intel.com> (sfid-20080325_233413_275879_3F0B3910)
In-Reply-To: <1206488021-4193-4-git-send-email-reinette.chatre@intel.com>
References: <1206488021-4193-1-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-2-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-3-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch eliminate the use of buf_size as a trigger in favor of a new
flag to control Rx A-MPDU sessions through debugfs

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/debugfs_sta.c |    6 ++++--
 net/mac80211/sta_info.h    |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index fc2c1a1..62354de 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -230,11 +230,13 @@ static ssize_t sta_agg_status_write(struct file *file,
 			strcpy(state, "off ");
 			ieee80211_sta_stop_rx_ba_session(dev, da, tid_num, 0,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
-			sta->ampdu_mlme.tid_rx[tid_num].buf_size = 0xFF;
+			sta->ampdu_mlme.tid_rx[tid_num].state |=
+					HT_AGG_STATE_DEBUGFS_CTL;
 			tid_static_rx[tid_num] = 0;
 		} else {
 			strcpy(state, "on ");
-			sta->ampdu_mlme.tid_rx[tid_num].buf_size = 0x00;
+			sta->ampdu_mlme.tid_rx[tid_num].state &=
+					~HT_AGG_STATE_DEBUGFS_CTL;
 			tid_static_rx[tid_num] = 1;
 		}
 		printk(KERN_DEBUG "debugfs - try switching tid %u %s\n",
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f166c80..5d6b436 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -63,6 +63,7 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_OPERATIONAL	(HT_ADDBA_REQUESTED_MSK |	\
 					 HT_ADDBA_DRV_READY_MSK |	\
 					 HT_ADDBA_RECEIVED_MSK)
+#define HT_AGG_STATE_DEBUGFS_CTL	BIT(7)
 
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
-- 
1.5.3.4

