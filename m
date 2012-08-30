Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1100 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab2H3IF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 04:05:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/4] brcmfmac: fix get rssi by clearing getvar struct.
Date: Thu, 30 Aug 2012 10:05:37 +0200
Message-ID: <1346313937-3605-5-git-send-email-arend@broadcom.com> (sfid-20120830_100603_356512_7D7B0D18)
In-Reply-To: <1346313937-3605-1-git-send-email-arend@broadcom.com>
References: <1346313937-3605-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The function brcmf_cfg80211_get_station requests the RSSI from
the device. The complete structure used needs to be cleared
before sending the request to firmware. Otherwise the request
fails filling the logs with "Could not get rssi (-2)" messages.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 28c5fbb..c36e923 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1876,16 +1876,17 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
-		scb_val.val = cpu_to_le32(0);
+		memset(&scb_val, 0, sizeof(scb_val));
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_RSSI, &scb_val,
 				      sizeof(struct brcmf_scb_val_le));
-		if (err)
+		if (err) {
 			WL_ERR("Could not get rssi (%d)\n", err);
-
-		rssi = le32_to_cpu(scb_val.val);
-		sinfo->filled |= STATION_INFO_SIGNAL;
-		sinfo->signal = rssi;
-		WL_CONN("RSSI %d dBm\n", rssi);
+		} else {
+			rssi = le32_to_cpu(scb_val.val);
+			sinfo->filled |= STATION_INFO_SIGNAL;
+			sinfo->signal = rssi;
+			WL_CONN("RSSI %d dBm\n", rssi);
+		}
 	}
 
 done:
-- 
1.7.9.5


