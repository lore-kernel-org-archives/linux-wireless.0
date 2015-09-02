Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35460 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbbIBLU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 07:20:57 -0400
Received: by lbpo4 with SMTP id o4so4003004lbp.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 04:20:55 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: fix beamformee VHT STS capability
Date: Wed,  2 Sep 2015 13:20:19 +0200
Message-Id: <1441192820-8403-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20150902_132102_541236_84BA9435)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The VHT STS CAP shall be reported by firmware to host, like in case of
QCA99x0. For QCA6174 hw family this isn't set for some reason.
So for this particular chips, let's assume it has the ability to
support VHT NDP in up to 4 STSs (which is true by the way).

Change the published beamformee STS cap accordingly to 3 or to what
the firmware reports.

Assumption so far, it suppose to be the num_rf_chains-1, was
completely wrong.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9bca37820848..25c20d18021a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4064,17 +4064,35 @@ static u32 get_nss_from_chainmask(u16 chain_mask)
 	return 1;
 }
 
+static int ath10k_mac_get_vht_cap_bf_sts(struct ath10k *ar)
+{
+	int nsts = ar->vht_cap_info;
+	nsts &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+
+	/* If firmware does not deliver to host number of space-time
+	 * streams supported, assume it support up to 4 BF STS and return
+	 * the value for VHT CAP: nsts-1)
+	 * */
+	if (nsts == 0)
+		return 3;
+
+	return nsts;
+}
+
 static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
 {
 	u32 value = 0;
 	struct ath10k *ar = arvif->ar;
+	int nsts;
 
 	if (ath10k_wmi_get_txbf_conf_scheme(ar) != WMI_TXBF_CONF_BEFORE_ASSOC)
 		return 0;
 
+	nsts = ath10k_mac_get_vht_cap_bf_sts(ar);
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE))
-		value |= SM((ar->num_rf_chains - 1), WMI_TXBF_STS_CAP_OFFSET);
+		value |= SM(nsts, WMI_TXBF_STS_CAP_OFFSET);
 
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE))
@@ -6803,7 +6821,7 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
-		val = ar->num_rf_chains - 1;
+		val = ath10k_mac_get_vht_cap_bf_sts(ar);
 		val <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
 		val &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 
-- 
2.1.2

