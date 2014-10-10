Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35744 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaJJLAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 07:00:16 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so3636974wgh.16
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 04:00:15 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: simplify computation of mgmt rx band
Date: Fri, 10 Oct 2014 12:49:08 +0200
Message-Id: <1412938148-6659-1-git-send-email-michal.kazior@tieto.com> (sfid-20141010_130021_817822_D4FCE536)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using global channel won't work with chanctx. Try
to determine the channel from the information
provided in the wmi event itself alone. This
should be sufficient.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 829fccf..ae746ce 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1114,7 +1114,6 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	struct wmi_mgmt_rx_event_v2 *ev_v2;
 	struct wmi_mgmt_rx_hdr_v1 *ev_hdr;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_channel *ch;
 	struct ieee80211_hdr *hdr;
 	u32 rx_status;
 	u32 channel;
@@ -1167,25 +1166,26 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (rx_status & WMI_RX_STATUS_ERR_MIC)
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
-	/* HW can Rx CCK rates on 5GHz. In that case phy_mode is set to
+	/* Hardware can Rx CCK rates on 5GHz. In that case phy_mode is set to
 	 * MODE_11B. This means phy_mode is not a reliable source for the band
-	 * of mgmt rx. */
-
-	ch = ar->scan_channel;
-	if (!ch)
-		ch = ar->rx_channel;
-
-	if (ch) {
-		status->band = ch->band;
-
-		if (phy_mode == MODE_11B &&
-		    status->band == IEEE80211_BAND_5GHZ)
-			ath10k_dbg(ar, ATH10K_DBG_MGMT, "wmi mgmt rx 11b (CCK) on 5GHz\n");
+	 * of mgmt rx.
+	 */
+	if (channel >= 1 && channel <= 14) {
+		status->band = IEEE80211_BAND_2GHZ;
+	} else if (channel >= 36 && channel <= 165) {
+		status->band = IEEE80211_BAND_5GHZ;
 	} else {
-		ath10k_warn(ar, "using (unreliable) phy_mode to extract band for mgmt rx\n");
-		status->band = phy_mode_to_band(phy_mode);
+		/* Shouldn't happen unless list of advertised channels to
+		 * mac80211 has been changed.
+		 */
+		WARN_ON_ONCE(1);
+		dev_kfree_skb(skb);
+		return 0;
 	}
 
+	if (phy_mode == MODE_11B && status->band == IEEE80211_BAND_5GHZ)
+		ath10k_dbg(ar, ATH10K_DBG_MGMT, "wmi mgmt rx 11b (CCK) on 5GHz\n");
+
 	status->freq = ieee80211_channel_to_frequency(channel, status->band);
 	status->signal = snr + ATH10K_DEFAULT_NOISE_FLOOR;
 	status->rate_idx = get_rate_idx(rate, status->band);
-- 
1.8.5.3

