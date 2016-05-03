Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33421 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbcECNDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:03:51 -0400
Received: by mail-wm0-f65.google.com with SMTP id r12so3739044wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2016 06:03:50 -0700 (PDT)
From: meijjaa <jjmeijer88@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: meijjaa <jjmeijer88@gmail.com>
Subject: [PATCH] Fix regression in Android due to rework .get_station() callback
Date: Tue,  3 May 2016 15:03:40 +0200
Message-Id: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com> (sfid-20160503_150358_825024_6CFFEDD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After f654d13 Android is not able to get station signal strength.
To much was removed, this patch brings back the needed functionality.

Signed-off-by: meijjaa <jjmeijer88@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index deb5f78..0275474 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2428,6 +2428,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
+	struct brcmf_scb_val_le scb_val;
+	int rssi;
 	struct brcmf_sta_info_le sta_info_le;
 	u32 sta_flags;
 	u32 is_tdls_peer;
@@ -2506,6 +2508,21 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 				count_rssi++;
 			}
 		}
+		if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
+			     &ifp->vif->sme_state)) {
+			memset(&scb_val, 0, sizeof(scb_val));
+			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
+						     &scb_val, sizeof(scb_val));
+			if (err) {
+				brcmf_err("Could not get rssi (%d)\n", err);
+				goto done;
+			} else {
+				rssi = le32_to_cpu(scb_val.val);
+				sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+				sinfo->signal = rssi;
+				brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
+			}
+		}
 		if (count_rssi) {
 			sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
 			sinfo->chains = count_rssi;
-- 
1.9.1

