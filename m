Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1145 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab3E0TKT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 6/7] brcmfmac: Add multi channel support for
 P2P.
Date: Mon, 27 May 2013 21:09:58 +0200
Message-ID: <1369681799-3163-7-git-send-email-arend@broadcom.com> (sfid-20130527_211033_144018_F1EEF8FE)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Multi channel support was disabled. This patch will enable it and
configure the P2P GO on the correct frequency when multi channel
is used.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   26 +++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 656ce87..6a87178 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3672,10 +3672,28 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 }
 
 static s32
+brcmf_cfg80211_set_channel(struct brcmf_cfg80211_info *cfg,
+			   struct brcmf_if *ifp,
+			   struct ieee80211_channel *channel)
+{
+	u16 chanspec;
+	s32 err;
+
+	brcmf_dbg(TRACE, "band=%d, center_freq=%d\n", channel->band,
+		  channel->center_freq);
+
+	chanspec = channel_to_chanspec(&cfg->d11inf, channel);
+	err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
+
+	return err;
+}
+
+static s32
 brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
 {
 	s32 ie_offset;
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_tlv *ssid_ie;
 	struct brcmf_ssid_le ssid_le;
@@ -3746,6 +3764,12 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 
+	err = brcmf_cfg80211_set_channel(cfg, ifp, settings->chandef.chan);
+	if (err < 0) {
+		brcmf_err("Set Channel failed, %d\n", err);
+		goto exit;
+	}
+
 	if (settings->beacon_interval) {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 					    settings->beacon_interval);
@@ -4184,7 +4208,7 @@ static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
 static const struct ieee80211_iface_combination brcmf_iface_combos[] = {
 	{
 		 .max_interfaces = BRCMF_IFACE_MAX_CNT,
-		 .num_different_channels = 1, /* no multi-channel for now */
+		 .num_different_channels = 2,
 		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
 		 .limits = brcmf_iface_limits
 	}
-- 
1.7.10.4


