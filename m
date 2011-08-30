Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5642 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3TEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:04:32 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 20/22] ath6kl: Include P2P IE(s) in GO Probe Response depending on request
Date: Tue, 30 Aug 2011 21:58:09 +0300
Message-ID: <1314730691-12089-21-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210435_234203_FC1F5CB7)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P2P has special rules on when to include P2P IE(s) in Probe Response
frame based on the Probe Request frame. Handle P2P IE(s) separately
to follow these rules.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   96 +++++++++++++++++++++++++++-
 1 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a3aa150..2136899 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1518,6 +1518,48 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static bool ath6kl_is_p2p_ie(const u8 *pos)
+{
+	return pos[0] == WLAN_EID_VENDOR_SPECIFIC && pos[1] >= 4 &&
+		pos[2] == 0x50 && pos[3] == 0x6f &&
+		pos[4] == 0x9a && pos[5] == 0x09;
+}
+
+static int ath6kl_set_ap_probe_resp_ies(struct ath6kl *ar, const u8 *ies,
+					size_t ies_len)
+{
+	const u8 *pos;
+	u8 *buf = NULL;
+	size_t len = 0;
+	int ret;
+
+	/*
+	 * Filter out P2P IE(s) since they will be included depending on
+	 * the Probe Request frame in ath6kl_send_go_probe_resp().
+	 */
+
+	if (ies && ies_len) {
+		buf = kmalloc(ies_len, GFP_KERNEL);
+		if (buf == NULL)
+			return -ENOMEM;
+		pos = ies;
+		while (pos + 1 < ies + ies_len) {
+			if (pos + 2 + pos[1] > ies + ies_len)
+				break;
+			if (!ath6kl_is_p2p_ie(pos)) {
+				memcpy(buf + len, pos, 2 + pos[1]);
+				len += 2 + pos[1];
+			}
+			pos += 2 + pos[1];
+		}
+	}
+
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_RESP,
+				       buf, len);
+	kfree(buf);
+	return ret;
+}
+
 static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 			    struct beacon_parameters *info, bool add)
 {
@@ -1545,9 +1587,8 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 	if (info->proberesp_ies) {
-		res = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_RESP,
-					       info->proberesp_ies,
-					       info->proberesp_ies_len);
+		res = ath6kl_set_ap_probe_resp_ies(ar, info->proberesp_ies,
+						   info->proberesp_ies_len);
 		if (res)
 			return res;
 	}
@@ -1735,6 +1776,41 @@ static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi);
 }
 
+static int ath6kl_send_go_probe_resp(struct ath6kl *ar, const u8 *buf,
+				     size_t len, unsigned int freq)
+{
+	const u8 *pos;
+	u8 *p2p;
+	int p2p_len;
+	int ret;
+	const struct ieee80211_mgmt *mgmt;
+
+	mgmt = (const struct ieee80211_mgmt *) buf;
+
+	/* Include P2P IE(s) from the frame generated in user space. */
+
+	p2p = kmalloc(len, GFP_KERNEL);
+	if (p2p == NULL)
+		return -ENOMEM;
+	p2p_len = 0;
+
+	pos = mgmt->u.probe_resp.variable;
+	while (pos + 1 < buf + len) {
+		if (pos + 2 + pos[1] > buf + len)
+			break;
+		if (ath6kl_is_p2p_ie(pos)) {
+			memcpy(p2p + p2p_len, pos, 2 + pos[1]);
+			p2p_len += 2 + pos[1];
+		}
+		pos += 2 + pos[1];
+	}
+
+	ret = ath6kl_wmi_send_probe_response_cmd(ar->wmi, freq, mgmt->da,
+						 p2p, p2p_len);
+	kfree(p2p);
+	return ret;
+}
+
 static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
@@ -1743,6 +1819,20 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	u32 id;
+	const struct ieee80211_mgmt *mgmt;
+
+	mgmt = (const struct ieee80211_mgmt *) buf;
+	if (buf + len >= mgmt->u.probe_resp.variable &&
+	    ar->nw_type == AP_NETWORK && test_bit(CONNECTED, &ar->flag) &&
+	    ieee80211_is_probe_resp(mgmt->frame_control)) {
+		/*
+		 * Send Probe Response frame in AP mode using a separate WMI
+		 * command to allow the target to fill in the generic IEs.
+		 */
+		*cookie = 0; /* TX status not supported */
+		return ath6kl_send_go_probe_resp(ar, buf, len,
+						 chan->center_freq);
+	}
 
 	id = ar->send_action_id++;
 	if (id == 0) {
-- 
1.7.4.1

