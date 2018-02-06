Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56496 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbeBFXCN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 18:02:13 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath10k:  Support mgt frame per-chain rssi
Date: Tue,  6 Feb 2018 15:02:08 -0800
Message-Id: <1517958128-12147-1-git-send-email-greearb@candelatech.com> (sfid-20180207_000233_036515_241D7BFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This provides per-chain rssi for management frames received
over wmi.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Fix 'rssh' typo in commit message.

 drivers/net/wireless/ath/ath10k/wmi.c | 21 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 905af93..ff37274 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2287,6 +2287,7 @@ static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
 	u32 msdu_len;
 	struct wmi_mgmt_rx_ext_info *ext_info;
 	u32 len;
+	int i;
 
 	ev = (struct wmi_10_4_mgmt_rx_event *)skb->data;
 	ev_hdr = &ev->hdr;
@@ -2302,6 +2303,8 @@ static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
 	arg->snr = ev_hdr->snr;
 	arg->phy_mode = ev_hdr->phy_mode;
 	arg->rate = ev_hdr->rate;
+	for (i = 0; i<4; i++)
+		arg->rssi_ctl[i] = ev_hdr->rssi_ctl[i];
 
 	msdu_len = __le32_to_cpu(arg->buf_len);
 	if (skb->len < msdu_len)
@@ -2357,6 +2360,13 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	u32 buf_len;
 	u16 fc;
 	int ret;
+	int i;
+
+	/* Initialize the rssi to 'ignore-me' value, stock wave-1
+	 * firmware doesn't support it.
+	 */
+	for (i = 0; i<4; i++)
+		arg.rssi_ctl[i] = 0x80;
 
 	ret = ath10k_wmi_pull_mgmt_rx(ar, skb, &arg);
 	if (ret) {
@@ -2416,6 +2426,12 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	status->freq = ieee80211_channel_to_frequency(channel, status->band);
 	status->signal = snr + ATH10K_DEFAULT_NOISE_FLOOR;
+	for (i = 0; i<4; i++) {
+		if (arg.rssi_ctl[i] != 0x80) {
+			status->chains |= BIT(i);
+			status->chain_signal[i] = ATH10K_DEFAULT_NOISE_FLOOR + arg.rssi_ctl[i];
+		}
+	}
 	status->rate_idx = ath10k_mac_bitrate_to_idx(sband, rate / 100);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -2451,8 +2467,11 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   fc & IEEE80211_FCTL_FTYPE, fc & IEEE80211_FCTL_STYPE);
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
-		   "event mgmt rx freq %d band %d snr %d, rate_idx %d\n",
+		   "event mgmt rx freq %d band %d snr %d chains: 0x%x(%d %d %d %d), rate_idx %d\n",
 		   status->freq, status->band, status->signal,
+		   status->chains,
+		   status->chain_signal[0], status->chain_signal[1],
+		   status->chain_signal[2], status->chain_signal[3],
 		   status->rate_idx);
 
 	ieee80211_rx(ar->hw, skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a3ba191..d198772 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6490,6 +6490,7 @@ struct wmi_scan_ev_arg {
 struct wmi_mgmt_rx_ev_arg {
 	__le32 channel;
 	__le32 snr;
+	u8 rssi_ctl[4];
 	__le32 rate;
 	__le32 phy_mode;
 	__le32 buf_len;
-- 
2.4.11
