Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:40453 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725Ab3CNBgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 21:36:08 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: cleanup VHT cap
Date: Wed, 13 Mar 2013 18:32:47 -0700
Message-ID: <1363224767-26038-1-git-send-email-bzhao@marvell.com> (sfid-20130314_023618_765127_E2F554B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Firmware returned VHT cap has the same format that cfg80211
expects. There is no need to parse the vht cap from the firmware
and then set it to ieee80211_sta_vht_cap. Just copying is
sufficient.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   58 +------------------------------
 drivers/net/wireless/mwifiex/fw.h       |   28 ---------------
 2 files changed, 1 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c9bc5f5..dbf5b12 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1932,66 +1932,10 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
 				   struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 vht_cap = 0, cap = adapter->hw_dot_11ac_dev_cap;
 
 	vht_info->vht_supported = true;
 
-	switch (GET_VHTCAP_MAXMPDULEN(cap)) {
-	case 0x00:
-		vht_cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
-		break;
-	case 0x01:
-		vht_cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991;
-		break;
-	case 0x10:
-		vht_cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
-	    break;
-	default:
-	    dev_err(adapter->dev, "unsupported MAX MPDU len\n");
-	    break;
-	}
-
-	if (ISSUPP_11ACVHTHTCVHT(cap))
-		vht_cap |= IEEE80211_VHT_CAP_HTC_VHT;
-
-	if (ISSUPP_11ACVHTTXOPPS(cap))
-		vht_cap |= IEEE80211_VHT_CAP_VHT_TXOP_PS;
-
-	if (ISSUPP_11ACMURXBEAMFORMEE(cap))
-		vht_cap |= IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
-
-	if (ISSUPP_11ACMUTXBEAMFORMEE(cap))
-		vht_cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
-
-	if (ISSUPP_11ACSUBEAMFORMER(cap))
-		vht_cap |= IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
-
-	if (ISSUPP_11ACSUBEAMFORMEE(cap))
-		vht_cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
-
-	if (ISSUPP_11ACRXSTBC(cap))
-		vht_cap |= IEEE80211_VHT_CAP_RXSTBC_1;
-
-	if (ISSUPP_11ACTXSTBC(cap))
-		vht_cap |= IEEE80211_VHT_CAP_TXSTBC;
-
-	if (ISSUPP_11ACSGI160(cap))
-		vht_cap |= IEEE80211_VHT_CAP_SHORT_GI_160;
-
-	if (ISSUPP_11ACSGI80(cap))
-		vht_cap |= IEEE80211_VHT_CAP_SHORT_GI_80;
-
-	if (ISSUPP_11ACLDPC(cap))
-		vht_cap |= IEEE80211_VHT_CAP_RXLDPC;
-
-	if (ISSUPP_11ACBW8080(cap))
-		vht_cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
-
-	if (ISSUPP_11ACBW160(cap))
-		vht_cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
-
-	vht_info->cap = vht_cap;
-
+	vht_info->cap = adapter->hw_dot_11ac_dev_cap;
 	/* Update MCS support for VHT */
 	vht_info->vht_mcs.rx_mcs_map = cpu_to_le16(
 				adapter->hw_dot_11ac_mcs_support & 0xFFFF);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6d6e5ae..57c5def 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -230,40 +230,12 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(13)|BIT(14)))
 
-#define GET_VHTCAP_MAXMPDULEN(vht_cap_info) (vht_cap_info & 0x3)
 #define GET_VHTCAP_CHWDSET(vht_cap_info)    ((vht_cap_info >> 2) & 0x3)
 #define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)
 #define SET_VHTNSSMCS(mcs_mapset, nss, value) (mcs_mapset |= (value & 0x3) << \
 					      (2 * (nss - 1)))
 #define NO_NSS_SUPPORT		0x3
 
-/* HW_SPEC: HTC-VHT supported */
-#define ISSUPP_11ACVHTHTCVHT(Dot11acDevCap) (Dot11acDevCap & BIT(22))
-/* HW_SPEC: VHT TXOP PS support */
-#define ISSUPP_11ACVHTTXOPPS(Dot11acDevCap) (Dot11acDevCap & BIT(21))
-/* HW_SPEC: MU RX beamformee support */
-#define ISSUPP_11ACMURXBEAMFORMEE(Dot11acDevCap) (Dot11acDevCap & BIT(20))
-/* HW_SPEC: MU TX beamformee support */
-#define ISSUPP_11ACMUTXBEAMFORMEE(Dot11acDevCap) (Dot11acDevCap & BIT(19))
-/* HW_SPEC: SU Beamformee support */
-#define ISSUPP_11ACSUBEAMFORMEE(Dot11acDevCap) (Dot11acDevCap & BIT(10))
-/* HW_SPEC: SU Beamformer support */
-#define ISSUPP_11ACSUBEAMFORMER(Dot11acDevCap) (Dot11acDevCap & BIT(9))
-/* HW_SPEC: Rx STBC support */
-#define ISSUPP_11ACRXSTBC(Dot11acDevCap) (Dot11acDevCap & BIT(8))
-/* HW_SPEC: Tx STBC support */
-#define ISSUPP_11ACTXSTBC(Dot11acDevCap) (Dot11acDevCap & BIT(7))
-/* HW_SPEC: Short GI support for 160MHz BW */
-#define ISSUPP_11ACSGI160(Dot11acDevCap) (Dot11acDevCap & BIT(6))
-/* HW_SPEC: Short GI support for 80MHz BW */
-#define ISSUPP_11ACSGI80(Dot11acDevCap) (Dot11acDevCap & BIT(5))
-/* HW_SPEC: LDPC coding support */
-#define ISSUPP_11ACLDPC(Dot11acDevCap) (Dot11acDevCap & BIT(4))
-/* HW_SPEC: Channel BW 20/40/80/160/80+80 MHz support */
-#define ISSUPP_11ACBW8080(Dot11acDevCap) (Dot11acDevCap & BIT(3))
-/* HW_SPEC: Channel BW 20/40/80/160 MHz support */
-#define ISSUPP_11ACBW160(Dot11acDevCap) (Dot11acDevCap & BIT(2))
-
 #define GET_DEVTXMCSMAP(dev_mcs_map)      (dev_mcs_map >> 16)
 #define GET_DEVRXMCSMAP(dev_mcs_map)      (dev_mcs_map & 0xFFFF)
 
-- 
1.7.0.2

