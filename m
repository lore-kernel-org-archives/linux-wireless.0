Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4240 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3ABOXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:03 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/18] brcmfmac: removed deprecated set_bitrate_mask
 support
Date: Wed, 2 Jan 2013 15:22:39 +0100
Message-ID: <1357136572-18273-7-git-send-email-arend@broadcom.com> (sfid-20130102_152309_533341_E89A3DC7)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Set bitrate_mask is not desired anymore. The firmware will
determine the correct rates to be used.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   62 --------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1261a9b..ee4eb44 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2011,67 +2011,6 @@ done:
 	return err;
 }
 
-static s32
-brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
-			     const u8 *addr,
-			     const struct cfg80211_bitrate_mask *mask)
-{
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcm_rateset_le rateset_le;
-	s32 rate;
-	s32 val;
-	s32 err_bg;
-	s32 err_a;
-	u32 legacy;
-	s32 err = 0;
-
-	brcmf_dbg(TRACE, "Enter\n");
-	if (!check_vif_up(ifp->vif))
-		return -EIO;
-
-	/* addr param is always NULL. ignore it */
-	/* Get current rateset */
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CURR_RATESET,
-				     &rateset_le, sizeof(rateset_le));
-	if (err) {
-		brcmf_err("could not get current rateset (%d)\n", err);
-		goto done;
-	}
-
-	legacy = ffs(mask->control[IEEE80211_BAND_2GHZ].legacy & 0xFFFF);
-	if (!legacy)
-		legacy = ffs(mask->control[IEEE80211_BAND_5GHZ].legacy &
-			     0xFFFF);
-
-	val = wl_g_rates[legacy - 1].bitrate * 100000;
-
-	if (val < le32_to_cpu(rateset_le.count))
-		/* Select rate by rateset index */
-		rate = rateset_le.rates[val] & 0x7f;
-	else
-		/* Specified rate in bps */
-		rate = val / 500000;
-
-	brcmf_dbg(CONN, "rate %d mbps\n", rate / 2);
-
-	/*
-	 *
-	 *      Set rate override,
-	 *      Since the is a/b/g-blind, both a/bg_rate are enforced.
-	 */
-	err_bg = brcmf_fil_iovar_int_set(ifp, "bg_rate", rate);
-	err_a = brcmf_fil_iovar_int_set(ifp, "a_rate", rate);
-	if (err_bg && err_a) {
-		brcmf_err("could not set fixed rate (%d) (%d)\n", err_bg,
-			  err_a);
-		err = err_bg | err_a;
-	}
-
-done:
-	brcmf_dbg(TRACE, "Exit\n");
-	return err;
-}
-
 static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 				   struct brcmf_bss_info_le *bi)
 {
@@ -3703,7 +3642,6 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.set_default_key = brcmf_cfg80211_config_default_key,
 	.set_default_mgmt_key = brcmf_cfg80211_config_default_mgmt_key,
 	.set_power_mgmt = brcmf_cfg80211_set_power_mgmt,
-	.set_bitrate_mask = brcmf_cfg80211_set_bitrate_mask,
 	.connect = brcmf_cfg80211_connect,
 	.disconnect = brcmf_cfg80211_disconnect,
 	.suspend = brcmf_cfg80211_suspend,
-- 
1.7.10.4


