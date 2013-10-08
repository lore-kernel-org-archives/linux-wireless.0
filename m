Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42719 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3JHCyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 22:54:20 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so7938431pbc.16
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 19:54:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/2] ath10k: Fix bug in max. VHT A-MPDU size
Date: Mon,  7 Oct 2013 19:51:57 -0700
Message-Id: <1381200718-16271-2-git-send-email-michal.kazior@tieto.com> (sfid-20131008_045424_311498_924D44C1)
In-Reply-To: <1381200718-16271-1-git-send-email-michal.kazior@tieto.com>
References: <1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
 <1381200718-16271-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For VHT peers, the maximum A-MPDU size has to be calculated
from the VHT capabilities element and not the HT-cap. The formula
is the same, but a higher value is used in VHT, allowing larger
aggregates to be transmitted.

The patch contains a workaround for some Netgear/Linksys APs that
report Rx A-MPDU factor incorrectly.

Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v3:
 * fix lines over 80 chars (Kalle)
 * fix max() cast warning (Kalle)
 * add Tested-by

 drivers/net/wireless/ath/ath10k/mac.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4b7c949..049eca2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1033,14 +1033,27 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 				    struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	u8 ampdu_factor;
 
 	if (!vht_cap->vht_supported)
 		return;
 
 	arg->peer_flags |= WMI_PEER_VHT;
-
 	arg->peer_vht_caps = vht_cap->cap;
 
+
+	ampdu_factor = (vht_cap->cap &
+			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK) >>
+		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+
+	/* Workaround: Some Netgear/Linksys 11ac APs set Rx A-MPDU factor to
+	 * zero in VHT IE. Using it would result in degraded throughput.
+	 * arg->peer_max_mpdu at this point contains HT max_mpdu so keep
+	 * it if VHT max_mpdu is smaller. */
+	arg->peer_max_mpdu = max(arg->peer_max_mpdu,
+				 (1U << (IEEE80211_HT_MAX_AMPDU_FACTOR +
+					ampdu_factor)) - 1);
+
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->peer_flags |= WMI_PEER_80MHZ;
 
-- 
1.8.4.rc3

