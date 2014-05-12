Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8584 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaELIrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/14] brcmfmac: determine chanspec from struct cfg80211_chan_def info
Date: Mon, 12 May 2014 10:47:39 +0200
Message-ID: <1399884459-5048-15-git-send-email-arend@broadcom.com> (sfid-20140512_104801_982468_DB041AE2)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct cfg80211_chan_def contains additional info to derive the
bandwidth and side-band information of the chanspec. This patch adds
chandef_to_chanspec() function used in IBSS join and starting AP
operation.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   60 +++++++++++++++++++-
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 290fc09..23cfd04 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -341,6 +341,60 @@ static u8 brcmf_mw_to_qdbm(u16 mw)
 	return qdbm;
 }
 
+u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
+			struct cfg80211_chan_def *ch)
+{
+	struct brcmu_chan ch_inf;
+	s32 primary_offset;
+
+	brcmf_dbg(TRACE, "chandef: control %d center %d width %d\n",
+		  ch->chan->center_freq, ch->center_freq1, ch->width);
+	ch_inf.chnum = ieee80211_frequency_to_channel(ch->center_freq1);
+	primary_offset = ch->center_freq1 - ch->chan->center_freq;
+	switch (ch->width) {
+	case NL80211_CHAN_WIDTH_20:
+		ch_inf.bw = BRCMU_CHAN_BW_20;
+		WARN_ON(primary_offset != 0);
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		ch_inf.bw = BRCMU_CHAN_BW_40;
+		if (primary_offset < 0)
+			ch_inf.sb = BRCMU_CHAN_SB_U;
+		else
+			ch_inf.sb = BRCMU_CHAN_SB_L;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		ch_inf.bw = BRCMU_CHAN_BW_80;
+		if (primary_offset < 0) {
+			if (primary_offset < -CH_10MHZ_APART)
+				ch_inf.sb = BRCMU_CHAN_SB_UU;
+			else
+				ch_inf.sb = BRCMU_CHAN_SB_UL;
+		} else {
+			if (primary_offset > CH_10MHZ_APART)
+				ch_inf.sb = BRCMU_CHAN_SB_LL;
+			else
+				ch_inf.sb = BRCMU_CHAN_SB_LU;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+	switch (ch->chan->band) {
+	case IEEE80211_BAND_2GHZ:
+		ch_inf.band = BRCMU_CHAN_BAND_2G;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		ch_inf.band = BRCMU_CHAN_BAND_5G;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+	d11inf->encchspec(&ch_inf);
+
+	return ch_inf.chspec;
+}
+
 u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
 			struct ieee80211_channel *ch)
 {
@@ -1236,8 +1290,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 				params->chandef.chan->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
-			chanspec = channel_to_chanspec(&cfg->d11inf,
-						       params->chandef.chan);
+			chanspec = chandef_to_chanspec(&cfg->d11inf,
+						       &params->chandef);
 			join_params.params_le.chanspec_list[0] =
 				cpu_to_le16(chanspec);
 			join_params.params_le.chanspec_num = cpu_to_le32(1);
@@ -3810,7 +3864,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 
-	chanspec = channel_to_chanspec(&cfg->d11inf, settings->chandef.chan);
+	chanspec = chandef_to_chanspec(&cfg->d11inf, &settings->chandef);
 	err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 	if (err < 0) {
 		brcmf_err("Set Channel failed: chspec=%d, %d\n", chanspec, err);
-- 
1.7.9.5

