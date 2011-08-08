Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2796 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1HHN7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:31 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Sukesh Srikakula" <sukeshs@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 30/82] staging: brcm80211: brcmfmac: Roamed channel
 info passed to cfg80211
Date: Mon, 8 Aug 2011 15:58:14 +0200
Message-ID: <1312811946-16713-31-git-send-email-arend@broadcom.com> (sfid-20110808_160117_580959_ED5DD302)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

With this patch, brcmfmac driver will pass roamed channel information to
cfg80211 via cfg80211_roamed() API.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index cf57087..440ae6d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2890,6 +2890,11 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 		       const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct brcmf_channel_info channel;
+	struct ieee80211_channel *notify_channel;
+	struct ieee80211_supported_band *band;
+	u32 freq;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -2898,7 +2903,21 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 	brcmf_update_prof(cfg_priv, NULL, &e->addr, WL_PROF_BSSID);
 	brcmf_update_bss_info(cfg_priv);
 
-	cfg80211_roamed(ndev, NULL,
+	brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel, sizeof(channel));
+
+	channel.target_channel = le32_to_cpu(channel.target_channel);
+	WL_CONN("Roamed to channel %d\n", channel.target_channel);
+
+	if (channel.target_channel <= CH_MAX_2G_CHANNEL)
+		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	else
+		band = wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	freq = ieee80211_channel_to_frequency(channel.target_channel,
+						band->band);
+	notify_channel = ieee80211_get_channel(wiphy, freq);
+
+	cfg80211_roamed(ndev, notify_channel,
 			(u8 *)brcmf_read_prof(cfg_priv, WL_PROF_BSSID),
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
-- 
1.7.4.1


