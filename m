Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7664 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaELIrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:45 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/14] brcmfmac: get rid of brcmf_cfg80211_set_channel() function
Date: Mon, 12 May 2014 10:47:37 +0200
Message-ID: <1399884459-5048-13-git-send-email-arend@broadcom.com> (sfid-20140512_104808_228690_76AAB429)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function does not provide any additional functionality and is
used only once so just get rid of it.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   28 +++++---------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f6693b3..2d7c77d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3734,23 +3734,6 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 }
 
 static s32
-brcmf_cfg80211_set_channel(struct brcmf_cfg80211_info *cfg,
-			   struct brcmf_if *ifp,
-			   struct ieee80211_channel *channel)
-{
-	u16 chanspec;
-	s32 err;
-
-	brcmf_dbg(TRACE, "band=%d, center_freq=%d\n", channel->band,
-		  channel->center_freq);
-
-	chanspec = channel_to_chanspec(&cfg->d11inf, channel);
-	err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
-
-	return err;
-}
-
-static s32
 brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
 {
@@ -3765,9 +3748,11 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_join_params join_params;
 	enum nl80211_iftype dev_role;
 	struct brcmf_fil_bss_enable_le bss_enable;
+	u16 chanspec;
 
-	brcmf_dbg(TRACE, "channel=%d, bw=%d, beacon_interval=%d, dtim_period=%d,\n",
-		  settings->chandef.chan->hw_value, settings->chandef.width,
+	brcmf_dbg(TRACE, "ctrlchn=%d, center=%d, bw=%d, beacon_interval=%d, dtim_period=%d,\n",
+		  settings->chandef.chan->hw_value,
+		  settings->chandef.center_freq1, settings->chandef.width,
 		  settings->beacon_interval, settings->dtim_period);
 	brcmf_dbg(TRACE, "ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
 		  settings->ssid, settings->ssid_len, settings->auth_type,
@@ -3825,9 +3810,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 
-	err = brcmf_cfg80211_set_channel(cfg, ifp, settings->chandef.chan);
+	chanspec = channel_to_chanspec(&cfg->d11inf, settings->chandef.chan);
+	err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 	if (err < 0) {
-		brcmf_err("Set Channel failed, %d\n", err);
+		brcmf_err("Set Channel failed: chspec=%d, %d\n", chanspec, err);
 		goto exit;
 	}
 
-- 
1.7.9.5

