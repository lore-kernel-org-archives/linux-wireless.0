Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:58748 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaGQMyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 08:54:08 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so1636808wev.41
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 05:54:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: workaround qos nullfunc bug
Date: Thu, 17 Jul 2014 14:45:22 +0200
Message-Id: <1405601122-29726-2-git-send-email-michal.kazior@tieto.com> (sfid-20140717_145413_136361_09128A80)
In-Reply-To: <1405601122-29726-1-git-send-email-michal.kazior@tieto.com>
References: <1405601122-29726-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently fw/hw generates a corrupted QoS Control
Field in Qos NullFunc frames. The only way to
workaround this is to downgrade frames to
NullFunc. This should be okay since powersave is
done by fw/hw and these frames are only used for
CQM purposes (e.g. from hostapd to check if
station is still connected).

This doesn't fix any user visible bug that I know
of. It just prevents from sending out funky frames
on the air.

Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bbce3a0..3f9afaa 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1871,6 +1871,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
 static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
 	u8 *qos_ctl;
 
 	if (!ieee80211_is_data_qos(hdr->frame_control))
@@ -1880,6 +1881,16 @@ static void ath10k_tx_h_nwifi(struct ieee80211_hw *hw, struct sk_buff *skb)
 	memmove(skb->data + IEEE80211_QOS_CTL_LEN,
 		skb->data, (void *)qos_ctl - (void *)skb->data);
 	skb_pull(skb, IEEE80211_QOS_CTL_LEN);
+
+	/* Fw/Hw generates a corrupted QoS Control Field for QoS NullFunc
+	 * frames. Powersave is handled by the fw/hw so QoS NyllFunc frames are
+	 * used only for CQM purposes (e.g. hostapd station keepalive ping) so
+	 * it is safe to downgrade to NullFunc.
+	 */
+	if (ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+		cb->htt.tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
+	}
 }
 
 static void ath10k_tx_wep_key_work(struct work_struct *work)
-- 
1.8.5.3

