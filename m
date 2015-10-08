Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:23091 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbbJHSd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/11] brcmfmac: Fix station info rate information.
Date: Thu, 8 Oct 2015 20:33:16 +0200
Message-ID: <1444329201-3696-7-git-send-email-arend@broadcom.com> (sfid-20151008_203334_578981_BCD5082B)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Txrate and rxrate in get_station got assigned first with value
in kbps and then divided by 100 to get it in 100kbps unit. The
problem with that is that type of rate is u16 which resulted
in incorrect values for high data rate values.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 2ee57c0..73eddad 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2478,13 +2478,13 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		sinfo->rx_packets += le32_to_cpu(sta_info_le.rx_mcast_pkts);
 		if (sinfo->tx_packets) {
 			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
-			sinfo->txrate.legacy = le32_to_cpu(sta_info_le.tx_rate);
-			sinfo->txrate.legacy /= 100;
+			sinfo->txrate.legacy =
+				le32_to_cpu(sta_info_le.tx_rate) / 100;
 		}
 		if (sinfo->rx_packets) {
 			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
-			sinfo->rxrate.legacy = le32_to_cpu(sta_info_le.rx_rate);
-			sinfo->rxrate.legacy /= 100;
+			sinfo->rxrate.legacy =
+				le32_to_cpu(sta_info_le.rx_rate) / 100;
 		}
 		if (le16_to_cpu(sta_info_le.ver) >= 4) {
 			sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES);
-- 
1.9.1

