Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63729 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab3I0OgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 10:36:15 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: Fix bug in max. VHT A-MPDU size
Date: Fri, 27 Sep 2013 16:36:06 +0200
Message-ID: <1380292567-2363-2-git-send-email-michal.kazior@tieto.com> (sfid-20130927_163622_277633_45BFD2D4)
In-Reply-To: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
References: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For VHT peers, the maximum A-MPDU size has to be calculated
from the VHT capabilities element and not the HT-cap. The formula
is the same, but a higher value is used in VHT, allowing larger
aggregates to be transmitted.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8684e03..b55b680 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1033,14 +1033,19 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 				    struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	u8 ampdu_factor;
 
 	if (!vht_cap->vht_supported)
 		return;
 
 	arg->peer_flags |= WMI_PEER_VHT;
-
 	arg->peer_vht_caps = vht_cap->cap;
 
+	ampdu_factor =
+		(vht_cap->cap & IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK) >>
+		IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+	arg->peer_max_mpdu = (1 << (IEEE80211_HT_MAX_AMPDU_FACTOR + ampdu_factor)) - 1;
+
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->peer_flags |= WMI_PEER_80MHZ;
 
-- 
1.7.9.5

