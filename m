Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35714 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbbH0MrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 08:47:08 -0400
Received: by lbcbn3 with SMTP id bn3so10548315lbc.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 05:47:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: change beamformee VHT STS capability
Date: Thu, 27 Aug 2015 14:47:32 +0200
Message-Id: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com> (sfid-20150827_144714_708972_32842B02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartosz Markowski <bartosz.markowski@tieto.com>

All beamformee supporting chips have the ability to support
VHT NDP in up to 4 STSs. Change the published beamformee
STS cap accordingly to 3 as it should be Nsts-1.

This makes it possible to actually make full use
of. e.g. a 4SS MU-MIMO capable AP.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 64674c955d44..54ced30f5364 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4074,7 +4074,7 @@ static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
 
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE))
-		value |= SM((ar->num_rf_chains - 1), WMI_TXBF_STS_CAP_OFFSET);
+		value |= SM(3, WMI_TXBF_STS_CAP_OFFSET);
 
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE))
@@ -6804,7 +6804,7 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
-		val = ar->num_rf_chains - 1;
+		val = 3;
 		val <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
 		val &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 
-- 
2.1.4

