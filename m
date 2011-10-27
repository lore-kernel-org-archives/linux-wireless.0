Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65450 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1J0NAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 09:00:18 -0400
Date: Thu, 27 Oct 2011 16:00:13 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Report unique remain-on-channel cookie values
Message-ID: <20111027130013.GA32096@jouni.qca.qualcomm.com> (sfid-20111027_150022_503865_56D03B98)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though only a single concurrent remain-on-channel operation is
supported, there may be two pending remain-on-channel events (one to
indicate end of a canceled operation and another to indicate start of a
new operation). User space won't be able to distinguish these events
unless unique cookies are used.

The previous behavior resulted in wpa_supplicant getting quite
confused about the driver's offchannel state in various sequences
and this made the P2P state machine behave incorrectly. Use of
more than a single remain-on-channel cookie value fixes this.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   11 +++++++++--
 drivers/net/wireless/ath/ath6kl/core.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   13 +++++++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0b044aa..adb3c3f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1932,10 +1932,16 @@ static int ath6kl_remain_on_channel(struct wiphy *wiphy,
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
+	u32 id;
 
 	/* TODO: if already pending or ongoing remain-on-channel,
 	 * return -EBUSY */
-	*cookie = 1; /* only a single pending request is supported */
+	id = ++vif->last_roc_id;
+	if (id == 0) {
+		/* Do not use 0 as the cookie value */
+		id = ++vif->last_roc_id;
+	}
+	*cookie = id;
 
 	return ath6kl_wmi_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx,
 					     chan->center_freq, duration);
@@ -1948,8 +1954,9 @@ static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	if (cookie != 1)
+	if (cookie != vif->last_roc_id)
 		return -ENOENT;
+	vif->last_cancel_roc_id = cookie;
 
 	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 97d7f11..5ac415e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -427,6 +427,8 @@ struct ath6kl_vif {
 	struct cfg80211_scan_request *scan_req;
 	enum sme_state sme_state;
 	int reconnect_flag;
+	u32 last_roc_id;
+	u32 last_cancel_roc_id;
 	u32 send_action_id;
 	bool probe_req_report;
 	u16 next_chan;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index e6b0960..ddefc8e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -443,6 +443,7 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 	u32 dur;
 	struct ieee80211_channel *chan;
 	struct ath6kl *ar = wmi->parent_dev;
+	u32 id;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -458,7 +459,8 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 			   "(freq=%u)\n", freq);
 		return -EINVAL;
 	}
-	cfg80211_ready_on_channel(vif->ndev, 1, chan, NL80211_CHAN_NO_HT,
+	id = vif->last_roc_id;
+	cfg80211_ready_on_channel(vif->ndev, id, chan, NL80211_CHAN_NO_HT,
 				  dur, GFP_ATOMIC);
 
 	return 0;
@@ -473,6 +475,7 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 	u32 dur;
 	struct ieee80211_channel *chan;
 	struct ath6kl *ar = wmi->parent_dev;
+	u32 id;
 
 	if (len < sizeof(*ev))
 		return -EINVAL;
@@ -488,7 +491,13 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 			   "channel (freq=%u)\n", freq);
 		return -EINVAL;
 	}
-	cfg80211_remain_on_channel_expired(vif->ndev, 1, chan,
+	if (vif->last_cancel_roc_id &&
+	    vif->last_cancel_roc_id + 1 == vif->last_roc_id)
+		id = vif->last_cancel_roc_id; /* event for cancel command */
+	else
+		id = vif->last_roc_id; /* timeout on uncanceled r-o-c */
+	vif->last_cancel_roc_id = 0;
+	cfg80211_remain_on_channel_expired(vif->ndev, id, chan,
 					   NL80211_CHAN_NO_HT, GFP_ATOMIC);
 
 	return 0;
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
