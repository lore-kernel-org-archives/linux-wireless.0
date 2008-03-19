Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19754 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbYCSTxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH, take 2] libertas: convert RSSI to a direct command
Date: Wed, 19 Mar 2008 17:40:30 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803181342.42704.hs4233@mail.mn-solutions.de> <1205937089.26119.20.camel@localhost.localdomain>
In-Reply-To: <1205937089.26119.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803191740.30313.hs4233@mail.mn-solutions.de> (sfid-20080319_195444_612168_E51C4A53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Besided the direct conversion of the CMD_802_11_RSSI command, this
patch also changes the following things:

* calls CMD_802_11_RSSI either asynchronosly (in the background)
  when main.c thinks the firmware is hosed and just want's to
  get a command through
* calls CMD_802_11_RSSI synchronously when called to get wireless
  statistics.
* don't do in-driver averaging anymore, this and the previous point
  eliminates the need for any "struct lbs_private" values
* use a 100% quality in a  special ADHOC case

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

John, the current series for the acked patches is:

1. [PATCH] libertas: make a handy lbs_cmd_async() command
2. [PATCH] libertas: fix scheduling while atomic bug in CMD_MAC_CONTROL
3. [PATCH, take 2] libertas: convert GET_LOG to a direct command
4. [PATCH] libertas: misc power saving adjusts
5. [PATCH] libertas: remove lots of unused stuff
6. [PATCH] libertas: fix spinlock recursion bug

If this patch get's acked, it applies on top of those 6.

Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-19 16:30:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-19 16:32:39.000000000 +0100
@@ -692,6 +692,44 @@ static int lbs_cmd_802_11_rate_adapt_rat
 	return 0;
 }
 
+int lbs_get_rssi(struct lbs_private *priv, u16 *snr, u16 *nf)
+{
+	struct cmd_ds_802_11_rssi cmd;
+	struct cmd_ds_802_11_rssi_rsp rsp;
+	int ret;
+	u16 _snr, _nf;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.avg_factor = cpu_to_le16(1);
+	rsp.hdr.size = cpu_to_le16(sizeof(rsp));
+
+	/* main.c might have called us just to un-break a hanging firmware */
+	if (!snr && !nf) {
+		lbs_cmd_async(priv, CMD_802_11_RSSI, &cmd.hdr, sizeof(cmd));
+		return 0;
+	}
+
+	ret = lbs_cmd(priv, CMD_802_11_RSSI,
+		&cmd, lbs_cmd_copyback, (unsigned long) &rsp);
+
+	if (!ret) {
+		_snr = le16_to_cpu(rsp.SNR);
+		_nf  = le16_to_cpu(rsp.NF);
+	} else {
+		_snr = 0;
+		_nf  = abs(MRVDRV_NF_DEFAULT_SCAN_VALUE);
+	}
+
+	if (*snr) *snr = _snr;
+	if (*nf)  *nf  = _nf;
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+
+	return ret;
+}
+
 /**
  *  @brief Get the current data rate
  *
@@ -858,27 +896,6 @@ out:
 	return ret;
 }
 
-static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *cmd)
-{
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) + S_DS_GEN);
-	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
-
-	/* reset Beacon SNR/NF/RSSI values */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = 0;
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->NF[TYPE_BEACON][TYPE_AVG] = 0;
-	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
-	priv->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
 			       u8 cmd_action, void *pdata_buf)
 {
@@ -1427,10 +1444,6 @@ int lbs_prepare_and_send_command(struct 
 		ret = lbs_cmd_80211_ad_hoc_join(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_RSSI:
-		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
-		break;
-
 	case CMD_802_11_AD_HOC_STOP:
 		ret = lbs_cmd_80211_ad_hoc_stop(cmdptr);
 		break;
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 16:30:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 16:31:59.000000000 +0100
@@ -51,15 +51,6 @@ void lbs_mac_event_disconnected(struct l
 	kfree_skb(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
-
-	/* reset SNR/NF/RSSI values */
-	memset(priv->SNR, 0x00, sizeof(priv->SNR));
-	memset(priv->NF, 0x00, sizeof(priv->NF));
-	memset(priv->RSSI, 0x00, sizeof(priv->RSSI));
-	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
-	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
-	priv->nextSNRNF = 0;
-	priv->numSNRNF = 0;
 	priv->connect_status = LBS_DISCONNECTED;
 
 	/* Clear out associated SSID and BSSID since connection is
@@ -232,36 +223,6 @@ static int lbs_ret_802_11_rate_adapt_rat
 	return 0;
 }
 
-static int lbs_ret_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/* store the non average value */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->SNR);
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->noisefloor);
-
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgSNR);
-	priv->NF[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgnoisefloor);
-
-	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
-		     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-
-	priv->RSSI[TYPE_BEACON][TYPE_AVG] =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
-		     priv->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
-
-	lbs_deb_cmd("RSSI: beacon %d, avg %d\n",
-	       priv->RSSI[TYPE_BEACON][TYPE_NOAVG],
-	       priv->RSSI[TYPE_BEACON][TYPE_AVG]);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_eeprom_access(struct lbs_private *priv,
 				  struct cmd_ds_command *resp)
 {
@@ -364,10 +325,6 @@ static inline int handle_cmd_response(st
 		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_RSSI):
-		ret = lbs_ret_802_11_rssi(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_MAC_ADDRESS):
 		ret = lbs_ret_802_11_mac_address(priv, resp);
 		break;
Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-19 16:30:18.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-19 16:31:59.000000000 +0100
@@ -411,19 +411,21 @@ struct cmd_ds_802_11_rf_channel {
 };
 
 struct cmd_ds_802_11_rssi {
-	/* weighting factor */
-	__le16 N;
+	struct cmd_header hdr;
 
+	__le16 avg_factor;
 	__le16 reserved_0;
 	__le16 reserved_1;
 	__le16 reserved_2;
 };
 
 struct cmd_ds_802_11_rssi_rsp {
+	struct cmd_header hdr;
+
 	__le16 SNR;
-	__le16 noisefloor;
+	__le16 NF;
 	__le16 avgSNR;
-	__le16 avgnoisefloor;
+	__le16 avgNF;
 };
 
 struct cmd_ds_802_11_mac_address {
@@ -713,8 +715,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_rate_adapt_rateset rateset;
 		struct cmd_ds_mac_multicast_adr madr;
 		struct cmd_ds_802_11_ad_hoc_join adj;
-		struct cmd_ds_802_11_rssi rssi;
-		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_802_11_disassociate dassociate;
 		struct cmd_ds_802_11_mac_address macadd;
 		struct cmd_ds_mac_reg_access macreg;
Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-03-19 16:30:18.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-03-19 16:31:59.000000000 +0100
@@ -621,9 +621,6 @@ void lbs_association_worker(struct work_
 		if (success) {
 			lbs_deb_assoc("associated to %s\n",
 				print_mac(mac, priv->curbssparams.bssid));
-			lbs_prepare_and_send_command(priv,
-				CMD_802_11_RSSI,
-				0, CMD_OPTION_WAITFORRSP, 0, NULL);
 		} else {
 			ret = -1;
 		}
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-19 16:30:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-19 16:31:59.000000000 +0100
@@ -487,8 +487,7 @@ static void lbs_tx_timeout(struct net_de
 	   firmware has crapped itself -- rather than just a very
 	   busy medium. So send a harmless command, and if/when
 	   _that_ times out, we'll kick it in the head. */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				     0, 0, NULL);
+	lbs_get_rssi(priv, NULL, NULL);
 
 	lbs_deb_leave(LBS_DEB_TX);
 }
@@ -908,8 +907,7 @@ int lbs_resume(struct lbs_private *priv)
 
 	/* Firmware doesn't seem to give us RX packets any more
 	   until we send it some command. Might as well update */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				     0, 0, NULL);
+	lbs_get_rssi(priv, NULL, NULL);
 
 	netif_device_attach(priv->dev);
 	if (priv->mesh_dev)
Index: wireless-testing/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-03-19 16:28:26.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-03-19 16:33:37.000000000 +0100
@@ -1194,12 +1194,6 @@ static inline char *lbs_translate_scan(s
 	if (iwe.u.qual.qual > 100)
 		iwe.u.qual.qual = 100;
 
-	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
-		iwe.u.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
-	} else {
-		iwe.u.qual.noise = CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-	}
-
 	/* Locally created ad-hoc BSSs won't have beacons if this is the
 	 * only station in the adhoc network; so get signal strength
 	 * from receive statistics.
@@ -1208,11 +1202,9 @@ static inline char *lbs_translate_scan(s
 	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
 			     priv->curbssparams.ssid_len,
 			     bss->ssid, bss->ssid_len)) {
-		int snr, nf;
-		snr = priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		nf = priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		iwe.u.qual.level = CAL_RSSI(snr, nf);
+		iwe.u.qual.level = 100;
 	}
+	iwe.u.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
 	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_QUAL_LEN);
 
 	/* Add encryption capability */
@@ -1369,11 +1361,6 @@ int lbs_get_scan(struct net_device *dev,
 	if (priv->scan_channel)
 		return -EAGAIN;
 
-	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
-	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate)
-		lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-					     CMD_OPTION_WAITFORRSP, 0, NULL);
-
 	mutex_lock(&priv->lock);
 	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
 		char *next_ev;
Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-03-19 16:30:18.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-03-19 16:31:59.000000000 +0100
@@ -34,6 +34,8 @@ int lbs_update_hw_spec(struct lbs_privat
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 		    struct cmd_ds_mesh_access *cmd);
 
+int lbs_get_rssi(struct lbs_private *priv, u16 *snr, u16 *nf);
+
 int lbs_get_data_rate(struct lbs_private *priv);
 int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 
Index: wireless-testing/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-03-19 16:30:18.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-03-19 16:31:59.000000000 +0100
@@ -288,15 +288,6 @@ struct lbs_private {
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
 
-	/** Requested Signal Strength*/
-	u16 SNR[MAX_TYPE_B][MAX_TYPE_AVG];
-	u16 NF[MAX_TYPE_B][MAX_TYPE_AVG];
-	u8 RSSI[MAX_TYPE_B][MAX_TYPE_AVG];
-	u8 rawSNR[DEFAULT_DATA_AVG_FACTOR];
-	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
-	u16 nextSNRNF;
-	u16 numSNRNF;
-
 	u8 radioon;
 	u32 preamble;
 
Index: wireless-testing/drivers/net/wireless/libertas/join.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/join.c	2008-03-19 16:30:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/join.c	2008-03-19 16:31:59.000000000 +0100
@@ -751,14 +751,6 @@ int lbs_ret_80211_associate(struct lbs_p
 	priv->curbssparams.ssid_len = bss->ssid_len;
 	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
 
-	priv->SNR[TYPE_RXPD][TYPE_AVG] = 0;
-	priv->NF[TYPE_RXPD][TYPE_AVG] = 0;
-
-	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
-	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
-	priv->nextSNRNF = 0;
-	priv->numSNRNF = 0;
-
 	netif_carrier_on(priv->dev);
 	if (!priv->tx_pending_len)
 		netif_wake_queue(priv->dev);
Index: wireless-testing/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-03-19 16:30:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-03-19 16:31:59.000000000 +0100
@@ -811,6 +811,7 @@ static struct iw_statistics *lbs_get_wir
 	u8 rssi;
 	u32 tx_retries;
 	struct cmd_ds_802_11_get_log log;
+	u16 snr, nf;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -821,17 +822,11 @@ static struct iw_statistics *lbs_get_wir
 	    (priv->mesh_connect_status != LBS_CONNECTED))
 		goto out;
 
-	/* Quality by RSSI */
-	priv->wstats.qual.level =
-	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
-	     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
+	lbs_get_rssi(priv, &snr, &nf);
 
-	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
-		priv->wstats.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
-	} else {
-		priv->wstats.qual.noise =
-		    CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
-	}
+	/* Quality by RSSI */
+	priv->wstats.qual.level = CAL_RSSI(snr, nf);
+	priv->wstats.qual.noise = CAL_NF(nf);
 
 	lbs_deb_wext("signal level %#x\n", priv->wstats.qual.level);
 	lbs_deb_wext("noise %#x\n", priv->wstats.qual.noise);
@@ -883,9 +878,6 @@ static struct iw_statistics *lbs_get_wir
 	priv->wstats.qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 	stats_valid = 1;
 
-	/* update stats asynchronously for future calls */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-					0, 0, NULL);
 out:
 	if (!stats_valid) {
 		priv->wstats.miss.beacon = 0;
Index: wireless-testing/drivers/net/wireless/libertas/rx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/rx.c	2008-03-19 16:28:26.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/rx.c	2008-03-19 16:31:59.000000000 +0100
@@ -39,99 +39,6 @@ static int process_rxed_802_11_packet(st
 	struct sk_buff *skb);
 
 /**
- *  @brief This function computes the avgSNR .
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   avgSNR
- */
-static u8 lbs_getavgsnr(struct lbs_private *priv)
-{
-	u8 i;
-	u16 temp = 0;
-	if (priv->numSNRNF == 0)
-		return 0;
-	for (i = 0; i < priv->numSNRNF; i++)
-		temp += priv->rawSNR[i];
-	return (u8) (temp / priv->numSNRNF);
-
-}
-
-/**
- *  @brief This function computes the AvgNF
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   AvgNF
- */
-static u8 lbs_getavgnf(struct lbs_private *priv)
-{
-	u8 i;
-	u16 temp = 0;
-	if (priv->numSNRNF == 0)
-		return 0;
-	for (i = 0; i < priv->numSNRNF; i++)
-		temp += priv->rawNF[i];
-	return (u8) (temp / priv->numSNRNF);
-
-}
-
-/**
- *  @brief This function save the raw SNR/NF to our internel buffer
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @param prxpd   A pointer to rxpd structure of received packet
- *  @return 	   n/a
- */
-static void lbs_save_rawSNRNF(struct lbs_private *priv, struct rxpd *p_rx_pd)
-{
-	if (priv->numSNRNF < DEFAULT_DATA_AVG_FACTOR)
-		priv->numSNRNF++;
-	priv->rawSNR[priv->nextSNRNF] = p_rx_pd->snr;
-	priv->rawNF[priv->nextSNRNF] = p_rx_pd->nf;
-	priv->nextSNRNF++;
-	if (priv->nextSNRNF >= DEFAULT_DATA_AVG_FACTOR)
-		priv->nextSNRNF = 0;
-	return;
-}
-
-/**
- *  @brief This function computes the RSSI in received packet.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @param prxpd   A pointer to rxpd structure of received packet
- *  @return 	   n/a
- */
-static void lbs_compute_rssi(struct lbs_private *priv, struct rxpd *p_rx_pd)
-{
-
-	lbs_deb_enter(LBS_DEB_RX);
-
-	lbs_deb_rx("rxpd: SNR %d, NF %d\n", p_rx_pd->snr, p_rx_pd->nf);
-	lbs_deb_rx("before computing SNR: SNR-avg = %d, NF-avg = %d\n",
-	       priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-	       priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-
-	priv->SNR[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->snr;
-	priv->NF[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->nf;
-	lbs_save_rawSNRNF(priv, p_rx_pd);
-
-	priv->SNR[TYPE_RXPD][TYPE_AVG] = lbs_getavgsnr(priv) * AVG_SCALE;
-	priv->NF[TYPE_RXPD][TYPE_AVG] = lbs_getavgnf(priv) * AVG_SCALE;
-	lbs_deb_rx("after computing SNR: SNR-avg = %d, NF-avg = %d\n",
-	       priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-	       priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-
-	priv->RSSI[TYPE_RXPD][TYPE_NOAVG] =
-	    CAL_RSSI(priv->SNR[TYPE_RXPD][TYPE_NOAVG],
-		     priv->NF[TYPE_RXPD][TYPE_NOAVG]);
-
-	priv->RSSI[TYPE_RXPD][TYPE_AVG] =
-	    CAL_RSSI(priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-		     priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-
-	lbs_deb_leave(LBS_DEB_RX);
-}
-
-/**
  *  @brief This function processes received packet and forwards it
  *  to kernel/upper layer
  *
@@ -240,8 +147,6 @@ int lbs_process_rxed_packet(struct lbs_p
 	if (priv->auto_rate)
 		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
 
-	lbs_compute_rssi(priv, p_rx_pd);
-
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
@@ -359,7 +264,7 @@ static int process_rxed_802_11_packet(st
 	/* known values */
 	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
 	/* XXX must check no carryout */
-	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
+	radiotap_hdr.antsignal = CAL_RSSI(prxpd->snr, prxpd->nf);
 	radiotap_hdr.rx_flags = 0;
 	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
 		radiotap_hdr.rx_flags |= IEEE80211_RADIOTAP_F_RX_BADFCS;
@@ -386,8 +291,6 @@ static int process_rxed_802_11_packet(st
 	if (priv->auto_rate)
 		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
 
-	lbs_compute_rssi(priv, prxpd);
-
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
