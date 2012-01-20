Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57785 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2ATNgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 08:36:55 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 3/8] ath6kl: Add a new func to config default WOW patterns for non AP mode
Date: Fri, 20 Jan 2012 19:05:39 +0530
Message-ID: <1327066544-23779-4-git-send-email-rmani@qca.qualcomm.com> (sfid-20120120_143659_322917_054F57FD)
In-Reply-To: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

ath6kl_non_ap_add_default_wow_patterns() is added to configure
the below default patterns when the system enters into WOW
suspend in non AP mode.

  * Unicast packet pattern
  * mDNS/SSDP/LLMNR pattern

This func will be called from ath6kl_wow_suspend().

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   40 ++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 88cce8f..9ab92c4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1802,6 +1802,46 @@ static int ath6kl_ap_add_default_wow_patterns(struct ath6kl *ar,
 	return 0;
 }
 
+static int ath6kl_non_ap_add_default_wow_patterns(struct ath6kl *ar,
+						     struct ath6kl_vif *vif)
+{
+	struct net_device *ndev = vif->ndev;
+	static const u8 discvr_pattern[] = { 0xe0, 0x00, 0x00, 0xf8 };
+	static const u8 discvr_mask[] = { 0xf0, 0x00, 0x00, 0xf8 };
+	u8 discvr_offset = 38;
+	u8 mac_mask[ETH_ALEN];
+	int ret;
+
+	/* Setup unicast pkt pattern */
+	memset(mac_mask, 0xff, ETH_ALEN);
+	ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+				vif->fw_vif_idx, WOW_LIST_ID,
+				ETH_ALEN, 0, ndev->dev_addr,
+				mac_mask);
+	if (ret) {
+		ath6kl_err("failed to add WOW unicast pattern\n");
+		return ret;
+	}
+
+	/*
+	 * Setup multicast pattern for mDNS 224.0.0.251,
+	 * SSDP 239.255.255.250 and LLMNR 224.0.0.252
+	 */
+	if ((ndev->flags & IFF_ALLMULTI) ||
+	    (ndev->flags & IFF_MULTICAST && netdev_mc_count(ndev) > 0)) {
+		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+				vif->fw_vif_idx, WOW_LIST_ID,
+				sizeof(discvr_pattern), discvr_offset,
+				discvr_pattern, discvr_mask);
+		if (ret) {
+			ath6kl_err("failed to add WOW mDNS/SSDP/LLMNR pattern\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 {
 	struct in_device *in_dev;
-- 
1.7.1

