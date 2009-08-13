Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbZHMUbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/13] iwlwifi: prevent read outside array bounds
Date: Thu, 13 Aug 2009 13:30:50 -0700
Message-Id: <1250195462-15811-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

With EDCA and HCCA we have 16 potential tid values. This is accommodated by
mac80211, but iwlwifi only supports EDCA. With this implementation it is
thus possible for mac80211 to request a tid that will cause iwlwifi to read
outside array bounds. A similar problem exists if traffic is received in an
unsupported category.

We add error checking to catch these situations.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    3 +++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    5 +++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 2133155..1bd7cd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -332,6 +332,9 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 	} else
 		return MAX_TID_COUNT;
 
+	if (unlikely(tid >= TID_MAX_LOAD_COUNT))
+		return MAX_TID_COUNT;
+
 	tl = &lq_data->load[tid];
 
 	curr_time -= curr_time % TID_ROUND_VALUE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9b76bd4..7686fc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -745,6 +745,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		if (unlikely(tid >= MAX_TID_COUNT))
+			goto drop_unlock;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = hdr->seq_ctrl &
@@ -1238,6 +1240,9 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 		return -EINVAL;
 	}
 
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
+
 	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
 		tx_fifo_id = default_tid_to_tx_fifo[tid];
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e617411..f339c5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -544,6 +544,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		if (unlikely(tid >= MAX_TID_COUNT))
+			goto drop;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
-- 
1.5.6.3

