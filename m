Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17481 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdCXH6g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 03:58:36 -0400
From: <c_vnaral@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix station nss computation
Date: Fri, 24 Mar 2017 13:27:28 +0530
Message-ID: <1490342248-6213-1-git-send-email-c_vnaral@qti.qualcomm.com> (sfid-20170324_090425_912679_1FBF65CD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>

If station advertises diffferent NSS capabilities in Rx_mcs set
of HT and VHT IEs in assoc req, the current NSS computation
logic configures the NSS support only based on Rx_mcs set of
HT capabilities in the driver. This is configuring the station
NSS capabilities incorreclty in the target.

For example, if station advertise Rx_mcs set as 2 spatial streams
in HT capabilities and 1 spatial streams in VHT capabilities in
assoc request, as per current logic we are calculating nss from
HT capabilities and the driver sets peer_num_spatial_streams as
2 for the station which is configured in VHT 1*1.

This patchs fix this issue by calculating the nss from VHT cap if
station supports vht.

Signed-off-by: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 87a9b55..389f369 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2451,6 +2451,8 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	enum nl80211_band band;
 	const u16 *vht_mcs_mask;
 	u8 ampdu_factor;
+	u8 max_nss, vht_mcs;
+	int i;
 
 	if (WARN_ON(ath10k_mac_vif_chan(vif, &def)))
 		return;
@@ -2489,6 +2491,18 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_160)
 		arg->peer_flags |= ar->wmi.peer_flags->bw160;
 
+	/* Calculate peer NSS capability from VHT capabilities if STA
+	 * supports VHT.
+	 */
+	for (i = 0, max_nss = 0, vht_mcs = 0; i < NL80211_VHT_NSS_MAX; i++) {
+		vht_mcs = __le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map) >>
+			  (2 * i) & 3;
+
+		if ((vht_mcs != IEEE80211_VHT_MCS_NOT_SUPPORTED) &&
+		    vht_mcs_mask[i])
+			max_nss = i + 1;
+	}
+	arg->peer_num_spatial_streams = min(sta->rx_nss, max_nss);
 	arg->peer_vht_rates.rx_max_rate =
 		__le16_to_cpu(vht_cap->vht_mcs.rx_highest);
 	arg->peer_vht_rates.rx_mcs_set =
-- 
1.7.9.5
