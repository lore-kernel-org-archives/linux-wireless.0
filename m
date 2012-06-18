Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3781 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2FRLBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:01:13 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <jouni@qca.qualcomm.com>, <johannes@sipsolutions.net>,
	<kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath6kl: Enable auto channel selection for AP mode
Date: Mon, 18 Jun 2012 16:30:42 +0530
Message-ID: <1340017242-6436-3-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120618_130128_900504_CCC8E9A2)
In-Reply-To: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also update the new channel information through ch_switch_notify.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f27e973..4a30bdc 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2762,7 +2762,16 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	p.ssid_len = vif->ssid_len;
 	memcpy(p.ssid, vif->ssid, vif->ssid_len);
 	p.dot11_auth_mode = vif->dot11_auth_mode;
-	p.ch = cpu_to_le16(info->channel->center_freq);
+
+	if (info->auto_channel_select)
+		ar->want_ch_switch |= 1 << vif->fw_vif_idx;
+
+	if (info->channel) {
+		p.ch = cpu_to_le16(info->channel->center_freq);
+		if (ath6kl_set_htcap(vif, info->channel->band,
+				     info->channel_type != NL80211_CHAN_NO_HT))
+			return -EIO;
+	}
 
 	/* Enable uAPSD support by default */
 	res = ath6kl_wmi_ap_set_apsd(ar->wmi, vif->fw_vif_idx, true);
@@ -2786,10 +2795,6 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 
-	if (ath6kl_set_htcap(vif, info->channel->band,
-			     info->channel_type != NL80211_CHAN_NO_HT))
-		return -EIO;
-
 	/*
 	 * Get the PTKSA replay counter in the RSN IE. Supplicant
 	 * will use the RSN IE in M3 message and firmware has to
@@ -3502,7 +3507,8 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
 			    WIPHY_FLAG_HAVE_AP_SME |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
+			    WIPHY_FLAG_SUPPORTS_ACS;
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN, ar->fw_capabilities))
 		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-- 
1.7.4.1

