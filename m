Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:51062 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3FEPLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:11:49 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCHv4 2/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
Date: Wed,  5 Jun 2013 17:09:47 +0200
Message-Id: <1370444989-2095-2-git-send-email-ordex@autistici.org> (sfid-20130605_171153_726096_8B7A2059)
In-Reply-To: <1370444989-2095-1-git-send-email-ordex@autistici.org>
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

cfg80211 passes a NULL channel to mgmt_tx if the frame has
to be sent on the one currently in use by the device.
Make the implementation of mgmt_tx correctly handle this
case

Cc: Arend van Spriel <arend@broadcom.com>
Cc: brcm80211-dev-list@broadcom.com
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

v3:
- read current freq from the firmware via BRCMF_C_GET_CHANNEL

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

