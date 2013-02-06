Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2448 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab3BFRlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:12 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/12] brcmfmac: Use single function for channel to
 chanspec.
Date: Wed, 6 Feb 2013 18:40:44 +0100
Message-ID: <1360172447-2424-10-git-send-email-arend@broadcom.com> (sfid-20130206_184122_485683_E6E88693)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Simplify code by using single function for converting channel to
chanspec. No need to set 40MHz flags, as they are not needed for
correct working in FW.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   63 +++++++-------------
 1 file changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 544257a5..153924e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -393,16 +393,9 @@ static u16 channel_to_chanspec(struct ieee80211_channel *ch)
 	else
 		chanspec |= WL_CHANSPEC_BAND_5G;
 
-	if (ch->flags & IEEE80211_CHAN_NO_HT40) {
-		chanspec |= WL_CHANSPEC_BW_20;
-		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
-	} else {
-		chanspec |= WL_CHANSPEC_BW_40;
-		if (ch->flags & IEEE80211_CHAN_NO_HT40PLUS)
-			chanspec |= WL_CHANSPEC_CTL_SB_LOWER;
-		else
-			chanspec |= WL_CHANSPEC_CTL_SB_UPPER;
-	}
+	chanspec |= WL_CHANSPEC_BW_20;
+	chanspec |= WL_CHANSPEC_CTL_SB_NONE;
+
 	return chanspec;
 }
 
@@ -933,31 +926,6 @@ static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof)
 	memset(prof, 0, sizeof(*prof));
 }
 
-static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
-	size_t *join_params_size)
-{
-	u16 chanspec = 0;
-
-	if (ch != 0) {
-		if (ch <= CH_MAX_2G_CHANNEL)
-			chanspec |= WL_CHANSPEC_BAND_2G;
-		else
-			chanspec |= WL_CHANSPEC_BAND_5G;
-
-		chanspec |= WL_CHANSPEC_BW_20;
-		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
-
-		*join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE +
-				     sizeof(u16);
-
-		chanspec |= (ch & WL_CHANSPEC_CHAN_MASK);
-		join_params->params_le.chanspec_list[0] = cpu_to_le16(chanspec);
-		join_params->params_le.chanspec_num = cpu_to_le32(1);
-
-		brcmf_dbg(CONN, "channel %d, chanspec %#X\n", ch, chanspec);
-	}
-}
-
 static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 {
 	s32 err = 0;
@@ -988,6 +956,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	s32 wsec = 0;
 	s32 bcnprd;
+	u16 chanspec;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
@@ -1091,8 +1060,11 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 				params->chandef.chan->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
-			brcmf_ch_to_chanspec(cfg->channel,
-				&join_params, &join_params_size);
+			chanspec = channel_to_chanspec(params->chandef.chan);
+			join_params.params_le.chanspec_list[0] =
+				cpu_to_le16(chanspec);
+			join_params.params_le.chanspec_num = cpu_to_le32(1);
+			join_params_size += sizeof(join_params.params_le);
 		}
 
 		/* set channel for starter */
@@ -1404,6 +1376,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
 	struct brcmf_ssid ssid;
+	u16 chanspec;
 
 	s32 err = 0;
 
@@ -1421,10 +1394,13 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	if (chan) {
 		cfg->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
-		brcmf_dbg(CONN, "channel (%d), center_req (%d)\n",
-			  cfg->channel, chan->center_freq);
-	} else
+		chanspec = channel_to_chanspec(chan);
+		brcmf_dbg(CONN, "channel=%d, center_req=%d, chanspec=0x%04x\n",
+			  cfg->channel, chan->center_freq, chanspec);
+	} else {
 		cfg->channel = 0;
+		chanspec = 0;
+	}
 
 	brcmf_dbg(INFO, "ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
@@ -1473,8 +1449,11 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "ssid \"%s\", len (%d)\n",
 			  ssid.SSID, ssid.SSID_len);
 
-	brcmf_ch_to_chanspec(cfg->channel,
-			     &join_params, &join_params_size);
+	if (cfg->channel) {
+		join_params.params_le.chanspec_list[0] = cpu_to_le16(chanspec);
+		join_params.params_le.chanspec_num = cpu_to_le32(1);
+		join_params_size += sizeof(join_params.params_le);
+	}
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
-- 
1.7.10.4


