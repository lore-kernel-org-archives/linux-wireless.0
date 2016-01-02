Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30537 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbcABIl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 2/7] brcmfmac: Add get_station support for IBSS
Date: Sat, 2 Jan 2016 09:41:37 +0100
Message-ID: <1451724102-21911-3-git-send-email-arend@broadcom.com> (sfid-20160102_094237_422110_06CF3C61)
In-Reply-To: <1451724102-21911-1-git-send-email-arend@broadcom.com>
References: <1451724102-21911-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When get_station is requested for IBSS then an error will be
printed and no information will be returned. This patch adds
IBSS specific get station information function.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 51 ++++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |  1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 17 ++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 17658b3..6b9339b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2429,6 +2429,54 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 }
 
 static s32
+brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
+				struct station_info *sinfo)
+{
+	struct brcmf_scb_val_le scbval;
+	struct brcmf_pktcnt_le pktcnt;
+	s32 err;
+	u32 rate;
+	u32 rssi;
+
+	/* Get the current tx rate */
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
+	if (err < 0) {
+		brcmf_err("BRCMF_C_GET_RATE error (%d)\n", err);
+		return err;
+	}
+	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+	sinfo->txrate.legacy = rate * 5;
+
+	memset(&scbval, 0, sizeof(scbval));
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI, &scbval,
+				     sizeof(scbval));
+	if (err) {
+		brcmf_err("BRCMF_C_GET_RSSI error (%d)\n", err);
+		return err;
+	}
+	rssi = le32_to_cpu(scbval.val);
+	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->signal = rssi;
+
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_GET_PKTCNTS, &pktcnt,
+				     sizeof(pktcnt));
+	if (err) {
+		brcmf_err("BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
+		return err;
+	}
+	sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS) |
+			 BIT(NL80211_STA_INFO_RX_DROP_MISC) |
+			 BIT(NL80211_STA_INFO_TX_PACKETS) |
+			 BIT(NL80211_STA_INFO_TX_FAILED);
+	sinfo->rx_packets = le32_to_cpu(pktcnt.rx_good_pkt);
+	sinfo->rx_dropped_misc = le32_to_cpu(pktcnt.rx_bad_pkt);
+	sinfo->tx_packets = le32_to_cpu(pktcnt.tx_good_pkt);
+	sinfo->tx_failed  = le32_to_cpu(pktcnt.tx_bad_pkt);
+
+	return 0;
+}
+
+static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   const u8 *mac, struct station_info *sinfo)
 {
@@ -2445,6 +2493,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
+	if (brcmf_is_ibssmode(ifp->vif))
+		return brcmf_cfg80211_get_station_ibss(ifp, sinfo);
+
 	memset(&sta_info_le, 0, sizeof(sta_info_le));
 	memcpy(&sta_info_le, mac, ETH_ALEN);
 	err = brcmf_fil_iovar_data_get(ifp, "tdls_sta_info",
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
index b20fc0f..6b72df1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h
@@ -70,6 +70,7 @@
 #define BRCMF_C_SET_WSEC			134
 #define BRCMF_C_GET_PHY_NOISE			135
 #define BRCMF_C_GET_BSS_INFO			136
+#define BRCMF_C_GET_GET_PKTCNTS			137
 #define BRCMF_C_GET_BANDLIST			140
 #define BRCMF_C_SET_SCB_TIMEOUT			158
 #define BRCMF_C_GET_ASSOCLIST			159
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 94d34ad..0b1e46d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -751,4 +751,21 @@ struct brcmf_pno_scanresults_le {
 	__le32 count;
 };
 
+/**
+ * struct brcmf_pktcnt_le - packet counters.
+ *
+ * @rx_good_pkt: packets (MSDUs & MMPDUs) received from this station
+ * @rx_bad_pkt: failed rx packets
+ * @tx_good_pkt: packets (MSDUs & MMPDUs) transmitted to this station
+ * @tx_bad_pkt: failed tx packets
+ * @rx_ocast_good_pkt: unicast packets destined for others
+ */
+struct brcmf_pktcnt_le {
+	__le32 rx_good_pkt;
+	__le32 rx_bad_pkt;
+	__le32 tx_good_pkt;
+	__le32 tx_bad_pkt;
+	__le32 rx_ocast_good_pkt;
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1

