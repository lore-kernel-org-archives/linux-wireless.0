Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7560 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbXGCPWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:22:52 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:47 +0200
Subject: [PATCH] libertas: remove adapter->rxpd_rate
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.47102.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No code uses the contents of this variable, so it can go.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmdresp.c |    1 -
 drivers/net/wireless/libertas/dev.h     |    1 -
 drivers/net/wireless/libertas/rx.c      |    2 --
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 02ef04d..0c2f5e9 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -60,7 +60,6 @@ void libertas_mac_event_disconnected(wlan_private * priv)
 	memset(adapter->rawNF, 0x00, sizeof(adapter->rawNF));
 	adapter->nextSNRNF = 0;
 	adapter->numSNRNF = 0;
-	adapter->rxpd_rate = 0;
 	lbs_deb_cmd("current SSID '%s', length %u\n",
 	            escape_essid(adapter->curbssparams.ssid,
 	                         adapter->curbssparams.ssid_len),
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index fcfb2d3..fced9fa 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -343,7 +343,6 @@ struct _wlan_adapter {
 	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
 	u16 nextSNRNF;
 	u16 numSNRNF;
-	u16 rxpd_rate;
 
 	u8 radioon;
 	u32 preamble;
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index bce4ccd..255da74 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -116,8 +116,6 @@ static void wlan_compute_rssi(wlan_private * priv, struct rxpd *p_rx_pd)
 	adapter->NF[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->nf;
 	wlan_save_rawSNRNF(priv, p_rx_pd);
 
-	adapter->rxpd_rate = p_rx_pd->rx_rate;
-
 	adapter->SNR[TYPE_RXPD][TYPE_AVG] = wlan_getavgsnr(priv) * AVG_SCALE;
 	adapter->NF[TYPE_RXPD][TYPE_AVG] = wlan_getavgnf(priv) * AVG_SCALE;
 	lbs_deb_rx("after computing SNR: SNR-avg = %d, NF-avg = %d\n",
-- 
1.5.2.1

