Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61115 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3TC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:02:56 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH v2 11/22] ath6kl: Support channel set request for startscan command
Date: Tue, 30 Aug 2011 21:58:00 +0300
Message-ID: <1314730691-12089-12-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210259_680980_FB6F06D8)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Edward Lu <elu@qca.qualcomm.com>

Signed-off-by: Edward Lu <elu@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   22 +++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 +++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 56a60c7..78b1788 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -748,6 +748,8 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				struct cfg80211_scan_request *request)
 {
 	struct ath6kl *ar = (struct ath6kl *)ath6kl_priv(ndev);
+	s8 n_channels = 0;
+	u16 *channels = NULL;
 	int ret = 0;
 
 	if (!ath6kl_cfg80211_ready(ar))
@@ -786,14 +788,32 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 
+	if (request->n_channels > 0) {
+		u8 i;
+
+		n_channels = min(127U, request->n_channels);
+
+		channels = kzalloc(n_channels * sizeof(u16), GFP_KERNEL);
+		if (channels == NULL) {
+			ath6kl_warn("failed to set scan channels, "
+				    "scan all channels");
+			n_channels = 0;
+		}
+
+		for (i = 0; i < n_channels; i++)
+			channels[i] = request->channels[i]->center_freq;
+	}
+
 	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
-				     false, 0, 0, 0, NULL) != 0) {
+				     false, 0, 0, n_channels, channels) != 0) {
 		ath6kl_err("wmi_startscan_cmd failed\n");
 		ret = -EIO;
 	}
 
 	ar->scan_req = request;
 
+	kfree(channels);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 2d80bdb..bbe3e8d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1709,7 +1709,7 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, enum wmi_scan_type scan_type,
 	struct sk_buff *skb;
 	struct wmi_start_scan_cmd *sc;
 	s8 size;
-	int ret;
+	int i, ret;
 
 	size = sizeof(struct wmi_start_scan_cmd);
 
@@ -1734,8 +1734,8 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, enum wmi_scan_type scan_type,
 	sc->force_scan_intvl = cpu_to_le32(force_scan_interval);
 	sc->num_ch = num_chan;
 
-	if (num_chan)
-		memcpy(sc->ch_list, ch_list, num_chan * sizeof(u16));
+	for (i = 0; i < num_chan; i++)
+		sc->ch_list[i] = cpu_to_le16(ch_list[i]);
 
 	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_START_SCAN_CMDID,
 				  NO_SYNC_WMIFLAG);
-- 
1.7.4.1

