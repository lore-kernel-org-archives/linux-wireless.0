Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:52837 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3FKMWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:22:05 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCHv5 2/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
Date: Tue, 11 Jun 2013 14:20:01 +0200
Message-Id: <1370953203-4086-2-git-send-email-ordex@autistici.org> (sfid-20130611_142210_111527_8F795BDC)
In-Reply-To: <1370953203-4086-1-git-send-email-ordex@autistici.org>
References: <1370953203-4086-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

cfg80211 passes a NULL channel to mgmt_tx if the frame has
to be sent on the one currently in use by the device.
Make the implementation of mgmt_tx correctly handle this
case

Cc: brcm80211-dev-list@broadcom.com
Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6d758f2..8bd256b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3917,6 +3917,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct brcmf_fil_af_params_le *af_params;
 	bool ack;
 	s32 chan_nr;
+	u32 freq;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3929,6 +3930,8 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return -EPERM;
 	}
 
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		/* Right now the only reason to get a probe response */
 		/* is for p2p listen response or for p2p GO from     */
@@ -3944,7 +3947,6 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		ie_offset =  DOT11_MGMT_HDR_LEN +
 			     DOT11_BCN_PRB_FIXED_LEN;
 		ie_len = len - ie_offset;
-		vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 		if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif)
 			vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 		err = brcmf_vif_set_mgmt_ie(vif,
@@ -3968,8 +3970,15 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		memcpy(&af_params->bssid[0], &mgmt->bssid[0], ETH_ALEN);
 		/* Add the length exepted for 802.11 header  */
 		action_frame->len = cpu_to_le16(len - DOT11_MGMT_HDR_LEN);
-		/* Add the channel */
-		chan_nr = ieee80211_frequency_to_channel(chan->center_freq);
+		/* Add the channel. Use the one specified as parameter if any or
+		 * the current one (got from the firmware) otherwise
+		 */
+		if (chan)
+			freq = chan->center_freq;
+		else
+			brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL,
+					      &freq);
+		chan_nr = ieee80211_frequency_to_channel(freq);
 		af_params->channel = cpu_to_le32(chan_nr);
 
 		memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
-- 
1.8.1.5

