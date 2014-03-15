Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31634 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbaCOQSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 12:18:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: Improve scanning settings for connect.
Date: Sat, 15 Mar 2014 17:18:19 +0100
Message-ID: <1394900301-15417-4-git-send-email-arend@broadcom.com> (sfid-20140315_171831_494776_BF8B6C4F)
In-Reply-To: <1394900301-15417-1-git-send-email-arend@broadcom.com>
References: <1394900301-15417-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When connecting without specifying the channel it can take quite
some time to connect. This is because not all parameters for the
scan operation are set to optimized values. This patch changes
these parameters resulting in a much faster connect in certain
situations.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   34 ++++++++++++--------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 00bd1e1..adbd5b7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1682,22 +1682,9 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	ext_join_params->ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
 	memcpy(&ext_join_params->ssid_le.SSID, sme->ssid,
 	       profile->ssid.SSID_len);
-	/*increase dwell time to receive probe response or detect Beacon
-	 * from target AP at a noisy air only during connect command
-	 */
-	ext_join_params->scan_le.active_time =
-		cpu_to_le32(BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS);
-	ext_join_params->scan_le.passive_time =
-		cpu_to_le32(BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS);
+
 	/* Set up join scan parameters */
 	ext_join_params->scan_le.scan_type = -1;
-	/* to sync with presence period of VSDB GO.
-	 * Send probe request more frequently. Probe request will be stopped
-	 * when it gets probe response from target AP/GO.
-	 */
-	ext_join_params->scan_le.nprobes =
-		cpu_to_le32(BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS /
-			    BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS);
 	ext_join_params->scan_le.home_time = cpu_to_le32(-1);
 
 	if (sme->bssid)
@@ -1710,6 +1697,25 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 		ext_join_params->assoc_le.chanspec_list[0] =
 			cpu_to_le16(chanspec);
+		/* Increase dwell time to receive probe response or detect
+		 * beacon from target AP at a noisy air only during connect
+		 * command.
+		 */
+		ext_join_params->scan_le.active_time =
+			cpu_to_le32(BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS);
+		ext_join_params->scan_le.passive_time =
+			cpu_to_le32(BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS);
+		/* To sync with presence period of VSDB GO send probe request
+		 * more frequently. Probe request will be stopped when it gets
+		 * probe response from target AP/GO.
+		 */
+		ext_join_params->scan_le.nprobes =
+			cpu_to_le32(BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS /
+				    BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS);
+	} else {
+		ext_join_params->scan_le.active_time = cpu_to_le32(-1);
+		ext_join_params->scan_le.passive_time = cpu_to_le32(-1);
+		ext_join_params->scan_le.nprobes = cpu_to_le32(-1);
 	}
 
 	err  = brcmf_fil_bsscfg_data_set(ifp, "join", ext_join_params,
-- 
1.7.9.5

