Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3461 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/19] staging: brcm80211: fixed sparse endianness
 warnings on fullmac assoc pars
Date: Fri, 16 Sep 2011 12:27:59 -0700
Message-ID: <1316201288-29635-11-git-send-email-frankyl@broadcom.com> (sfid-20110916_212834_729756_D23BABF3)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structures that are sent to the dongle have been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   10 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   63 ++++++++++------------
 2 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index e1d7c57..c34cc7b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -462,20 +462,20 @@ struct brcmf_scan_results {
 };
 
 /* used for association with a specific BSSID and chanspec list */
-struct brcmf_assoc_params {
+struct brcmf_assoc_params_le {
 	/* 00:00:00:00:00:00: broadcast scan */
 	u8 bssid[ETH_ALEN];
 	/* 0: all available channels, otherwise count of chanspecs in
 	 * chanspec_list */
-	s32 chanspec_num;
+	__le32 chanspec_num;
 	/* list of chanspecs */
-	u16 chanspec_list[1];
+	__le16 chanspec_list[1];
 };
 
 /* used for join with or without a specific bssid and channel list */
 struct brcmf_join_params {
-	struct brcmf_ssid ssid;
-	struct brcmf_assoc_params params;
+	struct brcmf_ssid_le ssid_le;
+	struct brcmf_assoc_params_le params_le;
 };
 
 /* size of brcmf_scan_results not including variable length array */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 2dced70..67955d3 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -34,7 +34,7 @@
 #include "wl_cfg80211.h"
 
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
-	(sizeof(struct brcmf_assoc_params) - sizeof(u16))
+	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
@@ -777,10 +777,7 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	u16 chanspec = 0;
 
 	if (ch != 0) {
-		join_params->params.chanspec_num = 1;
-		join_params->params.chanspec_list[0] = ch;
-
-		if (join_params->params.chanspec_list[0] <= CH_MAX_2G_CHANNEL)
+		if (ch <= CH_MAX_2G_CHANNEL)
 			chanspec |= WL_CHANSPEC_BAND_2G;
 		else
 			chanspec |= WL_CHANSPEC_BAND_5G;
@@ -789,19 +786,15 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
 
 		*join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE +
-			join_params->params.chanspec_num * sizeof(u16);
-
-		join_params->params.chanspec_list[0] &= WL_CHANSPEC_CHAN_MASK;
-		join_params->params.chanspec_list[0] |= chanspec;
-		join_params->params.chanspec_list[0] =
-		cpu_to_le16(join_params->params.chanspec_list[0]);
+				     sizeof(u16);
 
-		join_params->params.chanspec_num =
-			cpu_to_le32(join_params->params.chanspec_num);
+		chanspec |= (ch & WL_CHANSPEC_CHAN_MASK);
+		join_params->params_le.chanspec_list[0] = cpu_to_le16(chanspec);
+		join_params->params_le.chanspec_num = cpu_to_le32(1);
 
 		WL_CONN("join_params->params.chanspec_list[0]= %#X,"
 			"channel %d, chanspec %#X\n",
-		       join_params->params.chanspec_list[0], ch, chanspec);
+			chanspec, ch, chanspec);
 	}
 }
 
@@ -833,6 +826,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	s32 err = 0;
 	s32 wsec = 0;
 	s32 bcnprd;
+	struct brcmf_ssid ssid;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
@@ -910,24 +904,24 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	memset(&join_params, 0, sizeof(struct brcmf_join_params));
 
 	/* SSID */
-	join_params.ssid.SSID_len =
-			(params->ssid_len > 32) ? 32 : params->ssid_len;
-	memcpy(join_params.ssid.SSID, params->ssid, join_params.ssid.SSID_len);
-	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
-	join_params_size = sizeof(join_params.ssid);
-	brcmf_update_prof(cfg_priv, NULL, &join_params.ssid, WL_PROF_SSID);
+	ssid.SSID_len = min_t(u32, params->ssid_len, 32);
+	memcpy(ssid.SSID, params->ssid, ssid.SSID_len);
+	memcpy(join_params.ssid_le.SSID, params->ssid, ssid.SSID_len);
+	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
+	join_params_size = sizeof(join_params.ssid_le);
+	brcmf_update_prof(cfg_priv, NULL, &ssid, WL_PROF_SSID);
 
 	/* BSSID */
 	if (params->bssid) {
-		memcpy(join_params.params.bssid, params->bssid, ETH_ALEN);
-		join_params_size = sizeof(join_params.ssid) +
-					BRCMF_ASSOC_PARAMS_FIXED_SIZE;
+		memcpy(join_params.params_le.bssid, params->bssid, ETH_ALEN);
+		join_params_size = sizeof(join_params.ssid_le) +
+				   BRCMF_ASSOC_PARAMS_FIXED_SIZE;
 	} else {
-		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
+		memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
 	}
 
 	brcmf_update_prof(cfg_priv, NULL,
-			  &join_params.params.bssid, WL_PROF_BSSID);
+			  &join_params.params_le.bssid, WL_PROF_BSSID);
 
 	/* Channel */
 	if (params->channel) {
@@ -1244,6 +1238,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
+	struct brcmf_ssid ssid;
 
 	s32 err = 0;
 
@@ -1299,19 +1294,19 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	memset(&join_params, 0, sizeof(join_params));
-	join_params_size = sizeof(join_params.ssid);
+	join_params_size = sizeof(join_params.ssid_le);
 
-	join_params.ssid.SSID_len =
-		min(sizeof(join_params.ssid.SSID), sme->ssid_len);
-	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
-	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
-	brcmf_update_prof(cfg_priv, NULL, &join_params.ssid, WL_PROF_SSID);
+	ssid.SSID_len = min_t(u32, sizeof(ssid.SSID), sme->ssid_len);
+	memcpy(&join_params.ssid_le.SSID, sme->ssid, ssid.SSID_len);
+	memcpy(&ssid.SSID, sme->ssid, ssid.SSID_len);
+	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
+	brcmf_update_prof(cfg_priv, NULL, &ssid, WL_PROF_SSID);
 
-	memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
+	memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
 
-	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN)
+	if (ssid.SSID_len < IEEE80211_MAX_SSID_LEN)
 		WL_CONN("ssid \"%s\", len (%d)\n",
-		       join_params.ssid.SSID, join_params.ssid.SSID_len);
+		       ssid.SSID, ssid.SSID_len);
 
 	brcmf_ch_to_chanspec(cfg_priv->channel,
 			     &join_params, &join_params_size);
-- 
1.7.1


