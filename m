Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3969 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab2JJSNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] brcmfmac: use control channel in roamed status
 reporting
Date: Wed, 10 Oct 2012 11:13:09 -0700
Message-ID: <1349892792-4792-5-git-send-email-frankyl@broadcom.com> (sfid-20121010_201326_251109_9CDA15BF)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel reported in scan results passed to cfg80211 is control
channel. But chanspec is reported while notifying cfg80211 about
roamed update. Cfg80211 complains because it could not find the
bss in the list. Report control channel while calling
cfg80211_roamed.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   26 +++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9c3fe1a..a39925a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4605,12 +4605,13 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
-	struct brcmf_channel_info_le channel_le;
-	struct ieee80211_channel *notify_channel;
+	struct ieee80211_channel *notify_channel = NULL;
 	struct ieee80211_supported_band *band;
+	struct brcmf_bss_info_le *bi;
 	u32 freq;
 	s32 err = 0;
 	u32 target_channel;
+	u8 *buf;
 
 	WL_TRACE("Enter\n");
 
@@ -4618,11 +4619,22 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	memcpy(profile->bssid, e->addr, ETH_ALEN);
 	brcmf_update_bss_info(cfg);
 
-	brcmf_exec_dcmd(ndev, BRCMF_C_GET_CHANNEL, &channel_le,
-			sizeof(channel_le));
+	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+	if (buf == NULL) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	/* data sent to dongle has to be little endian */
+	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+
+	if (err)
+		goto done;
 
-	target_channel = le32_to_cpu(channel_le.target_channel);
-	WL_CONN("Roamed to channel %d\n", target_channel);
+	bi = (struct brcmf_bss_info_le *)(buf + 4);
+	target_channel = bi->ctl_ch ? bi->ctl_ch :
+				      CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
 
 	if (target_channel <= CH_MAX_2G_CHANNEL)
 		band = wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -4632,6 +4644,8 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	freq = ieee80211_channel_to_frequency(target_channel, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
+done:
+	kfree(buf);
 	cfg80211_roamed(ndev, notify_channel, (u8 *)profile->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
-- 
1.7.9.5


