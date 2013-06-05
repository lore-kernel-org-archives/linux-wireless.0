Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:60861 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3FELzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:55:13 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCHv2 3/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
Date: Wed,  5 Jun 2013 13:53:06 +0200
Message-Id: <1370433187-1337-3-git-send-email-ordex@autistici.org> (sfid-20130605_135520_435407_B8D3BEF5)
In-Reply-To: <1370433187-1337-1-git-send-email-ordex@autistici.org>
References: <1370433187-1337-1-git-send-email-ordex@autistici.org>
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
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6d758f2..dcb0c00 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3917,6 +3917,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct brcmf_fil_af_params_le *af_params;
 	bool ack;
 	s32 chan_nr;
+	u32 freq;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3968,8 +3969,13 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		memcpy(&af_params->bssid[0], &mgmt->bssid[0], ETH_ALEN);
 		/* Add the length exepted for 802.11 header  */
 		action_frame->len = cpu_to_le16(len - DOT11_MGMT_HDR_LEN);
-		/* Add the channel */
-		chan_nr = ieee80211_frequency_to_channel(chan->center_freq);
+		/* Add the channel. Default to the current one, but use the one
+		 * specified as parameter if any
+		 */
+		freq = cfg->channel;
+		if (chan)
+			freq = chan->center_freq;
+		chan_nr = ieee80211_frequency_to_channel(freq);
 		af_params->channel = cpu_to_le32(chan_nr);
 
 		memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
-- 
1.8.1.5

