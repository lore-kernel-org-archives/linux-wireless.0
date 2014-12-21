Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34443 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaLULoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:03 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: enable 802.11d support in firmware
Date: Sun, 21 Dec 2014 12:43:53 +0100
Message-ID: <1419162233-19492-11-git-send-email-arend@broadcom.com> (sfid-20141221_124421_163555_5837B7DF)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver gets beacon info containing a country IE from user-space
upon .start_ap() callback, it will enable regulatory 802.11d support.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 26 ++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |  1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index c896fe2..1783c03 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -3966,6 +3966,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	const struct brcmf_tlv *ssid_ie;
+	const struct brcmf_tlv *country_ie;
 	struct brcmf_ssid_le ssid_le;
 	s32 err = -EPERM;
 	const struct brcmf_tlv *rsn_ie;
@@ -3975,6 +3976,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_fil_bss_enable_le bss_enable;
 	u16 chanspec;
 	bool mbss;
+	int is_11d;
 
 	brcmf_dbg(TRACE, "ctrlchn=%d, center=%d, bw=%d, beacon_interval=%d, dtim_period=%d,\n",
 		  settings->chandef.chan->hw_value,
@@ -3986,6 +3988,13 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	dev_role = ifp->vif->wdev.iftype;
 	mbss = ifp->vif->mbss;
 
+	/* store current 11d setting */
+	brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_REGULATORY, &ifp->vif->is_11d);
+	country_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
+				      settings->beacon.tail_len,
+				      WLAN_EID_COUNTRY);
+	is_11d = country_ie ? 1 : 0;
+
 	memset(&ssid_le, 0, sizeof(ssid_le));
 	if (settings->ssid == NULL || settings->ssid_len == 0) {
 		ie_offset = DOT11_MGMT_HDR_LEN + DOT11_BCN_PRB_FIXED_LEN;
@@ -4051,6 +4060,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			goto exit;
 		}
 
+		if (is_11d != ifp->vif->is_11d) {
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
+						    is_11d);
+			if (err < 0) {
+				brcmf_err("Regulatory Set Error, %d\n", err);
+				goto exit;
+			}
+		}
 		if (settings->beacon_interval) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 						    settings->beacon_interval);
@@ -4083,6 +4100,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("SET INFRA error %d\n", err);
 			goto exit;
 		}
+	} else if (WARN_ON(is_11d != ifp->vif->is_11d)) {
+		/* Multiple-BSS should use same 11d configuration */
+		err = -EINVAL;
+		goto exit;
 	}
 	if (dev_role == NL80211_IFTYPE_AP) {
 		if ((brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) && (!mbss))
@@ -4178,6 +4199,11 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			brcmf_err("setting INFRA mode failed %d\n", err);
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
+					    ifp->vif->is_11d);
+		if (err < 0)
+			brcmf_err("restoring REGULATORY setting failed %d\n",
+				  err);
 		/* Bring device back up so it can be used again */
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index a5242af..d9e6d01 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -200,6 +200,7 @@ struct brcmf_cfg80211_vif {
 	struct list_head list;
 	u16 mgmt_rx_reg;
 	bool mbss;
+	int is_11d;
 };
 
 /* association inform */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 3ede91d..37345e7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -43,6 +43,8 @@
 #define BRCMF_C_SET_RADIO			38
 #define BRCMF_C_GET_PHYTYPE			39
 #define BRCMF_C_SET_KEY				45
+#define BRCMF_C_GET_REGULATORY			46
+#define BRCMF_C_SET_REGULATORY			47
 #define BRCMF_C_SET_PASSIVE_SCAN		49
 #define BRCMF_C_SCAN				50
 #define BRCMF_C_SCAN_RESULTS			51
-- 
1.9.1

