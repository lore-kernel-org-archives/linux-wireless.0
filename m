Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7573 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXGCPXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:00 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:54 +0200
Subject: [PATCH] libertas: remove adapter->{data,bcn}_avg_factor
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.54290.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those two variables were initialized with some default values, but there
is no code that would ever change them. So we could use as well the defaults
directly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/cmd.c  |    2 +-
 drivers/net/wireless/libertas/dev.h  |    2 --
 drivers/net/wireless/libertas/main.c |    3 ---
 drivers/net/wireless/libertas/rx.c   |    4 ++--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 0da013f..72e76e4 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -671,7 +671,7 @@ static int wlan_cmd_802_11_rssi(wlan_private * priv,
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) + S_DS_GEN);
-	cmd->params.rssi.N = cpu_to_le16(priv->adapter->bcn_avg_factor);
+	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
 
 	/* reset Beacon SNR/NF/RSSI values */
 	adapter->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index fced9fa..d324eeb 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -334,8 +334,6 @@ struct _wlan_adapter {
 	u8 wpa_ie_len;
 
 	/** Requested Signal Strength*/
-	u16 bcn_avg_factor;
-	u16 data_avg_factor;
 	u16 SNR[MAX_TYPE_B][MAX_TYPE_AVG];
 	u16 NF[MAX_TYPE_B][MAX_TYPE_AVG];
 	u8 RSSI[MAX_TYPE_B][MAX_TYPE_AVG];
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 070e5da..2e56801 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -992,9 +992,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	wlan_adapter *adapter = priv->adapter;
 	int i;
 
-	adapter->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
-	adapter->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
-
 	/* ATIM params */
 	adapter->atimwindow = 0;
 
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 255da74..f0b04d2 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -84,12 +84,12 @@ static u8 wlan_getavgnf(wlan_private * priv)
 static void wlan_save_rawSNRNF(wlan_private * priv, struct rxpd *p_rx_pd)
 {
 	wlan_adapter *adapter = priv->adapter;
-	if (adapter->numSNRNF < adapter->data_avg_factor)
+	if (adapter->numSNRNF < DEFAULT_DATA_AVG_FACTOR)
 		adapter->numSNRNF++;
 	adapter->rawSNR[adapter->nextSNRNF] = p_rx_pd->snr;
 	adapter->rawNF[adapter->nextSNRNF] = p_rx_pd->nf;
 	adapter->nextSNRNF++;
-	if (adapter->nextSNRNF >= adapter->data_avg_factor)
+	if (adapter->nextSNRNF >= DEFAULT_DATA_AVG_FACTOR)
 		adapter->nextSNRNF = 0;
 	return;
 }
-- 
1.5.2.1

