Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbYHVBqA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 21:46:00 -0400
Subject: [PATCH 3/3] libertas: convert adhoc operations to direct commands
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1219355467.13058.8.camel@localhost.localdomain>
References: <1219173335.23157.13.camel@localhost.localdomain>
	 <1219355178.13058.4.camel@localhost.localdomain>
	 <1219355467.13058.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 21:46:59 -0400
Message-Id: <1219369619.6080.10.camel@localhost.localdomain> (sfid-20080822_034607_604995_5CFC3579)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with fixes for v9 and later firmware too.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index d47e4d5..4ddf44b 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -8,6 +8,7 @@
 #include "scan.h"
 #include "cmd.h"
 
+static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp);
 
 static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
 	{ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -20,6 +21,82 @@ static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
 #define CAPINFO_MASK	(~(0xda00))
 
 
+/**
+ *  @brief This function finds common rates between rates and card rates.
+ *
+ * It will fill common rates in rates as output if found.
+ *
+ * NOTE: Setting the MSB of the basic rates need to be taken
+ *   care, either before or after calling this function
+ *
+ *  @param priv     A pointer to struct lbs_private structure
+ *  @param rates       the buffer which keeps input and output
+ *  @param rates_size  the size of rate1 buffer; new size of buffer on return
+ *
+ *  @return            0 on success, or -1 on error
+ */
+static int get_common_rates(struct lbs_private *priv,
+	u8 *rates,
+	u16 *rates_size)
+{
+	u8 *card_rates = lbs_bg_rates;
+	size_t num_card_rates = sizeof(lbs_bg_rates);
+	int ret = 0, i, j;
+	u8 tmp[30];
+	size_t tmp_size = 0;
+
+	/* For each rate in card_rates that exists in rate1, copy to tmp */
+	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
+		for (j = 0; rates[j] && (j < *rates_size); j++) {
+			if (rates[j] == card_rates[i])
+				tmp[tmp_size++] = card_rates[i];
+		}
+	}
+
+	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
+	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
+	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
+	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
+
+	if (!priv->enablehwauto) {
+		for (i = 0; i < tmp_size; i++) {
+			if (tmp[i] == priv->cur_rate)
+				goto done;
+		}
+		lbs_pr_alert("Previously set fixed data rate %#x isn't "
+		       "compatible with the network.\n", priv->cur_rate);
+		ret = -1;
+		goto done;
+	}
+	ret = 0;
+
+done:
+	memset(rates, 0, *rates_size);
+	*rates_size = min_t(int, tmp_size, *rates_size);
+	memcpy(rates, tmp, *rates_size);
+	return ret;
+}
+
+
+/**
+ *  @brief Sets the MSB on basic rates as the firmware requires
+ *
+ * Scan through an array and set the MSB for basic data rates.
+ *
+ *  @param rates     buffer of data rates
+ *  @param len       size of buffer
+ */
+static void lbs_set_basic_rate_flags(u8 *rates, size_t len)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		if (rates[i] == 0x02 || rates[i] == 0x04 ||
+		    rates[i] == 0x0b || rates[i] == 0x16)
+			rates[i] |= 0x80;
+	}
+}
+
 
 /**
  *  @brief Associate to a specific BSS discovered in a scan
@@ -66,14 +143,17 @@ out:
  *  @param priv         A pointer to struct lbs_private structure
  *  @param assoc_req    The association request describing the BSS to join
  *
- *  @return             0--success, -1--fail
+ *  @return             0 on success, error on failure
  */
-static int lbs_join_adhoc_network(struct lbs_private *priv,
+static int lbs_adhoc_join(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
+	struct cmd_ds_802_11_ad_hoc_join cmd;
 	struct bss_descriptor *bss = &assoc_req->bss;
-	int ret = 0;
 	u8 preamble = RADIO_PREAMBLE_LONG;
+	DECLARE_MAC_BUF(mac);
+	u16 ratesize = 0;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
@@ -123,10 +203,88 @@ static int lbs_join_adhoc_network(struct lbs_private *priv,
 	lbs_deb_join("AdhocJoin: band = %c\n", assoc_req->band);
 
 	priv->adhoccreate = 0;
+	priv->curbssparams.channel = bss->channel;
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_AD_HOC_JOIN,
-				    0, CMD_OPTION_WAITFORRSP,
-				    OID_802_11_SSID, assoc_req);
+	/* Build the join command */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	cmd.bss.type = CMD_BSS_TYPE_IBSS;
+	cmd.bss.beaconperiod = cpu_to_le16(bss->beaconperiod);
+
+	memcpy(&cmd.bss.bssid, &bss->bssid, ETH_ALEN);
+	memcpy(&cmd.bss.ssid, &bss->ssid, bss->ssid_len);
+
+	memcpy(&cmd.bss.phyparamset, &bss->phyparamset,
+	       sizeof(union ieeetypes_phyparamset));
+
+	memcpy(&cmd.bss.ssparamset, &bss->ssparamset,
+	       sizeof(union IEEEtypes_ssparamset));
+
+	cmd.bss.capability = cpu_to_le16(bss->capability & CAPINFO_MASK);
+	lbs_deb_join("ADHOC_J_CMD: tmpcap=%4X CAPINFO_MASK=%4X\n",
+	       bss->capability, CAPINFO_MASK);
+
+	/* information on BSSID descriptor passed to FW */
+	lbs_deb_join("ADHOC_J_CMD: BSSID = %s, SSID = '%s'\n",
+			print_mac(mac, cmd.bss.bssid), cmd.bss.ssid);
+
+	/* Only v8 and below support setting these */
+	if (priv->fwrelease < 0x09000000) {
+		/* failtimeout */
+		cmd.failtimeout = cpu_to_le16(MRVDRV_ASSOCIATION_TIME_OUT);
+		/* probedelay */
+		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
+	}
+
+	/* Copy Data rates from the rates recorded in scan response */
+	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
+	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
+	memcpy(cmd.bss.rates, bss->rates, ratesize);
+	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
+		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
+		ret = -1;
+		goto out;
+	}
+
+	/* Copy the ad-hoc creation rates into Current BSS state structure */
+	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
+	memcpy(&priv->curbssparams.rates, cmd.bss.rates, ratesize);
+
+	/* Set MSB on basic rates as the firmware requires, but _after_
+	 * copying to current bss rates.
+	 */
+	lbs_set_basic_rate_flags(cmd.bss.rates, ratesize);
+
+	cmd.bss.ssparamset.ibssparamset.atimwindow = cpu_to_le16(bss->atimwindow);
+
+	if (assoc_req->secinfo.wep_enabled) {
+		u16 tmp = le16_to_cpu(cmd.bss.capability);
+		tmp |= WLAN_CAPABILITY_PRIVACY;
+		cmd.bss.capability = cpu_to_le16(tmp);
+	}
+
+	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
+		__le32 local_ps_mode = cpu_to_le32(LBS802_11POWERMODECAM);
+
+		/* wake up first */
+		ret = lbs_prepare_and_send_command(priv, CMD_802_11_PS_MODE,
+						   CMD_ACT_SET, 0, 0,
+						   &local_ps_mode);
+		if (ret) {
+			ret = -1;
+			goto out;
+		}
+	}
+
+	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
+		ret = -1;
+		goto out;
+	}
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_JOIN, &cmd);
+	if (ret == 0)
+		ret = lbs_adhoc_post(priv, (struct cmd_header *) &cmd);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -138,20 +296,22 @@ out:
  *
  *  @param priv         A pointer to struct lbs_private structure
  *  @param assoc_req    The association request describing the BSS to start
- *  @return             0--success, -1--fail
+ *
+ *  @return             0 on success, error on failure
  */
-static int lbs_start_adhoc_network(struct lbs_private *priv,
+static int lbs_adhoc_start(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
-	int ret = 0;
+	struct cmd_ds_802_11_ad_hoc_start cmd;
 	u8 preamble = RADIO_PREAMBLE_LONG;
+	size_t ratesize = 0;
+	u16 tmpcap = 0;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	priv->adhoccreate = 1;
-
 	if (priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
-		lbs_deb_join("AdhocStart: Short preamble\n");
+		lbs_deb_join("ADHOC_START: Will use short preamble\n");
 		preamble = RADIO_PREAMBLE_SHORT;
 	}
 
@@ -159,21 +319,107 @@ static int lbs_start_adhoc_network(struct lbs_private *priv,
 	if (ret)
 		goto out;
 
-	lbs_deb_join("AdhocStart: channel = %d\n", assoc_req->channel);
-	lbs_deb_join("AdhocStart: band = %d\n", assoc_req->band);
+	/* Build the start command */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_AD_HOC_START,
-				    0, CMD_OPTION_WAITFORRSP, 0, assoc_req);
+	memcpy(cmd.ssid, assoc_req->ssid, assoc_req->ssid_len);
+
+	lbs_deb_join("ADHOC_START: SSID '%s', ssid length %u\n",
+		escape_essid(assoc_req->ssid, assoc_req->ssid_len),
+		assoc_req->ssid_len);
+
+	cmd.bsstype = CMD_BSS_TYPE_IBSS;
+
+	if (priv->beacon_period == 0)
+		priv->beacon_period = MRVDRV_BEACON_INTERVAL;
+	cmd.beaconperiod = cpu_to_le16(priv->beacon_period);
+
+	WARN_ON(!assoc_req->channel);
+
+	/* set Physical parameter set */
+	cmd.phyparamset.dsparamset.elementid = MFIE_TYPE_DS_SET;
+	cmd.phyparamset.dsparamset.len = 1;
+	cmd.phyparamset.dsparamset.currentchan = assoc_req->channel;
+
+	/* set IBSS parameter set */
+	cmd.ssparamset.ibssparamset.elementid = MFIE_TYPE_IBSS_SET;
+	cmd.ssparamset.ibssparamset.len = 2;
+	cmd.ssparamset.ibssparamset.atimwindow = 0;
+
+	/* set capability info */
+	tmpcap = WLAN_CAPABILITY_IBSS;
+	if (assoc_req->secinfo.wep_enabled) {
+		lbs_deb_join("ADHOC_START: WEP enabled, setting privacy on\n");
+		tmpcap |= WLAN_CAPABILITY_PRIVACY;
+	} else
+		lbs_deb_join("ADHOC_START: WEP disabled, setting privacy off\n");
+
+	cmd.capability = cpu_to_le16(tmpcap);
+
+	/* Only v8 and below support setting probe delay */
+	if (priv->fwrelease < 0x09000000)
+		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
+
+	ratesize = min(sizeof(cmd.rates), sizeof(lbs_bg_rates));
+	memcpy(cmd.rates, lbs_bg_rates, ratesize);
+
+	/* Copy the ad-hoc creating rates into Current BSS state structure */
+	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
+	memcpy(&priv->curbssparams.rates, &cmd.rates, ratesize);
+
+	/* Set MSB on basic rates as the firmware requires, but _after_
+	 * copying to current bss rates.
+	 */
+	lbs_set_basic_rate_flags(cmd.rates, ratesize);
+
+	lbs_deb_join("ADHOC_START: rates=%02x %02x %02x %02x\n",
+	       cmd.rates[0], cmd.rates[1], cmd.rates[2], cmd.rates[3]);
+
+	if (lbs_create_dnld_countryinfo_11d(priv)) {
+		lbs_deb_join("ADHOC_START: dnld_countryinfo_11d failed\n");
+		ret = -1;
+		goto out;
+	}
+
+	lbs_deb_join("ADHOC_START: Starting Ad-Hoc BSS on channel %d, band %d\n",
+		     assoc_req->channel, assoc_req->band);
+
+	priv->adhoccreate = 1;
+	priv->mode = IW_MODE_ADHOC;
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_START, &cmd);
+	if (ret == 0)
+		ret = lbs_adhoc_post(priv, (struct cmd_header *) &cmd);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
-int lbs_stop_adhoc_network(struct lbs_private *priv)
+/**
+ *  @brief Stop and Ad-Hoc network and exit Ad-Hoc mode
+ *
+ *  @param priv         A pointer to struct lbs_private structure
+ *  @return             0 on success, or an error
+ */
+int lbs_adhoc_stop(struct lbs_private *priv)
 {
-	return lbs_prepare_and_send_command(priv, CMD_802_11_AD_HOC_STOP,
-				     0, CMD_OPTION_WAITFORRSP, 0, NULL);
+	struct cmd_ds_802_11_ad_hoc_stop cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_JOIN);
+
+	memset(&cmd, 0, sizeof (cmd));
+	cmd.hdr.size = cpu_to_le16 (sizeof (cmd));
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_STOP, &cmd);
+
+	/* Clean up everything even if there was an error */
+	lbs_mac_event_disconnected(priv);
+
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
+	return ret;
 }
 
 static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
@@ -485,14 +731,14 @@ static int assoc_helper_essid(struct lbs_private *priv,
 		if (bss != NULL) {
 			lbs_deb_assoc("SSID found, will join\n");
 			memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
-			lbs_join_adhoc_network(priv, assoc_req);
+			lbs_adhoc_join(priv, assoc_req);
 		} else {
 			/* else send START command */
 			lbs_deb_assoc("SSID not found, creating adhoc network\n");
 			memcpy(&assoc_req->bss.ssid, &assoc_req->ssid,
 				IW_ESSID_MAX_SIZE);
 			assoc_req->bss.ssid_len = assoc_req->ssid_len;
-			lbs_start_adhoc_network(priv, assoc_req);
+			lbs_adhoc_start(priv, assoc_req);
 		}
 	}
 
@@ -525,7 +771,7 @@ static int assoc_helper_bssid(struct lbs_private *priv,
 		ret = lbs_associate(priv, assoc_req);
 		lbs_deb_assoc("ASSOC: lbs_associate(bssid) returned %d\n", ret);
 	} else if (assoc_req->mode == IW_MODE_ADHOC) {
-		lbs_join_adhoc_network(priv, assoc_req);
+		lbs_adhoc_join(priv, assoc_req);
 	}
 
 out:
@@ -1045,7 +1291,7 @@ void lbs_association_worker(struct work_struct *work)
 		}
 	} else if (priv->mode == IW_MODE_ADHOC) {
 		if (should_stop_adhoc(priv, assoc_req)) {
-			ret = lbs_stop_adhoc_network(priv);
+			ret = lbs_adhoc_stop(priv);
 			if (ret) {
 				lbs_deb_assoc("Teardown of AdHoc network due to "
 					"new configuration request failed: %d\n",
@@ -1221,82 +1467,6 @@ struct assoc_request *lbs_get_association_request(struct lbs_private *priv)
 
 
 /**
- *  @brief This function finds common rates between rate1 and card rates.
- *
- * It will fill common rates in rate1 as output if found.
- *
- * NOTE: Setting the MSB of the basic rates need to be taken
- *   care, either before or after calling this function
- *
- *  @param priv     A pointer to struct lbs_private structure
- *  @param rate1       the buffer which keeps input and output
- *  @param rate1_size  the size of rate1 buffer; new size of buffer on return
- *
- *  @return            0 or -1
- */
-static int get_common_rates(struct lbs_private *priv,
-	u8 *rates,
-	u16 *rates_size)
-{
-	u8 *card_rates = lbs_bg_rates;
-	size_t num_card_rates = sizeof(lbs_bg_rates);
-	int ret = 0, i, j;
-	u8 tmp[30];
-	size_t tmp_size = 0;
-
-	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
-		for (j = 0; rates[j] && (j < *rates_size); j++) {
-			if (rates[j] == card_rates[i])
-				tmp[tmp_size++] = card_rates[i];
-		}
-	}
-
-	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
-	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
-	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
-
-	if (!priv->enablehwauto) {
-		for (i = 0; i < tmp_size; i++) {
-			if (tmp[i] == priv->cur_rate)
-				goto done;
-		}
-		lbs_pr_alert("Previously set fixed data rate %#x isn't "
-		       "compatible with the network.\n", priv->cur_rate);
-		ret = -1;
-		goto done;
-	}
-	ret = 0;
-
-done:
-	memset(rates, 0, *rates_size);
-	*rates_size = min_t(int, tmp_size, *rates_size);
-	memcpy(rates, tmp, *rates_size);
-	return ret;
-}
-
-
-/**
- *  @brief Sets the MSB on basic rates as the firmware requires
- *
- * Scan through an array and set the MSB for basic data rates.
- *
- *  @param rates     buffer of data rates
- *  @param len       size of buffer
- */
-static void lbs_set_basic_rate_flags(u8 *rates, size_t len)
-{
-	int i;
-
-	for (i = 0; i < len; i++) {
-		if (rates[i] == 0x02 || rates[i] == 0x04 ||
-		    rates[i] == 0x0b || rates[i] == 0x16)
-			rates[i] |= 0x80;
-	}
-}
-
-/**
  *  @brief This function prepares command of authenticate.
  *
  *  @param priv      A pointer to struct lbs_private structure
@@ -1495,231 +1665,6 @@ done:
 	return ret;
 }
 
-int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
-				 struct cmd_ds_command *cmd, void *pdata_buf)
-{
-	struct cmd_ds_802_11_ad_hoc_start *adhs = &cmd->params.ads;
-	int ret = 0;
-	int cmdappendsize = 0;
-	struct assoc_request *assoc_req = pdata_buf;
-	u16 tmpcap = 0;
-	size_t ratesize = 0;
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	if (!priv) {
-		ret = -1;
-		goto done;
-	}
-
-	cmd->command = cpu_to_le16(CMD_802_11_AD_HOC_START);
-
-	/*
-	 * Fill in the parameters for 2 data structures:
-	 *   1. cmd_ds_802_11_ad_hoc_start command
-	 *   2. priv->scantable[i]
-	 *
-	 * Driver will fill up SSID, bsstype,IBSS param, Physical Param,
-	 *   probe delay, and cap info.
-	 *
-	 * Firmware will fill up beacon period, DTIM, Basic rates
-	 *   and operational rates.
-	 */
-
-	memset(adhs->ssid, 0, IW_ESSID_MAX_SIZE);
-	memcpy(adhs->ssid, assoc_req->ssid, assoc_req->ssid_len);
-
-	lbs_deb_join("ADHOC_S_CMD: SSID '%s', ssid length %u\n",
-		escape_essid(assoc_req->ssid, assoc_req->ssid_len),
-		assoc_req->ssid_len);
-
-	/* set the BSS type */
-	adhs->bsstype = CMD_BSS_TYPE_IBSS;
-	priv->mode = IW_MODE_ADHOC;
-	if (priv->beacon_period == 0)
-		priv->beacon_period = MRVDRV_BEACON_INTERVAL;
-	adhs->beaconperiod = cpu_to_le16(priv->beacon_period);
-
-	/* set Physical param set */
-#define DS_PARA_IE_ID   3
-#define DS_PARA_IE_LEN  1
-
-	adhs->phyparamset.dsparamset.elementid = DS_PARA_IE_ID;
-	adhs->phyparamset.dsparamset.len = DS_PARA_IE_LEN;
-
-	WARN_ON(!assoc_req->channel);
-
-	lbs_deb_join("ADHOC_S_CMD: Creating ADHOC on channel %d\n",
-		     assoc_req->channel);
-
-	adhs->phyparamset.dsparamset.currentchan = assoc_req->channel;
-
-	/* set IBSS param set */
-#define IBSS_PARA_IE_ID   6
-#define IBSS_PARA_IE_LEN  2
-
-	adhs->ssparamset.ibssparamset.elementid = IBSS_PARA_IE_ID;
-	adhs->ssparamset.ibssparamset.len = IBSS_PARA_IE_LEN;
-	adhs->ssparamset.ibssparamset.atimwindow = 0;
-
-	/* set capability info */
-	tmpcap = WLAN_CAPABILITY_IBSS;
-	if (assoc_req->secinfo.wep_enabled) {
-		lbs_deb_join("ADHOC_S_CMD: WEP enabled, "
-			"setting privacy on\n");
-		tmpcap |= WLAN_CAPABILITY_PRIVACY;
-	} else {
-		lbs_deb_join("ADHOC_S_CMD: WEP disabled, "
-			"setting privacy off\n");
-	}
-	adhs->capability = cpu_to_le16(tmpcap);
-
-	/* probedelay */
-	adhs->probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
-
-	memset(adhs->rates, 0, sizeof(adhs->rates));
-	ratesize = min(sizeof(adhs->rates), sizeof(lbs_bg_rates));
-	memcpy(adhs->rates, lbs_bg_rates, ratesize);
-
-	/* Copy the ad-hoc creating rates into Current BSS state structure */
-	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
-	memcpy(&priv->curbssparams.rates, &adhs->rates, ratesize);
-
-	/* Set MSB on basic rates as the firmware requires, but _after_
-	 * copying to current bss rates.
-	 */
-	lbs_set_basic_rate_flags(adhs->rates, ratesize);
-
-	lbs_deb_join("ADHOC_S_CMD: rates=%02x %02x %02x %02x \n",
-	       adhs->rates[0], adhs->rates[1], adhs->rates[2], adhs->rates[3]);
-
-	lbs_deb_join("ADHOC_S_CMD: AD HOC Start command is ready\n");
-
-	if (lbs_create_dnld_countryinfo_11d(priv)) {
-		lbs_deb_join("ADHOC_S_CMD: dnld_countryinfo_11d failed\n");
-		ret = -1;
-		goto done;
-	}
-
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_ad_hoc_start) +
-				S_DS_GEN + cmdappendsize);
-
-	ret = 0;
-done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
-	return ret;
-}
-
-int lbs_cmd_80211_ad_hoc_stop(struct cmd_ds_command *cmd)
-{
-	cmd->command = cpu_to_le16(CMD_802_11_AD_HOC_STOP);
-	cmd->size = cpu_to_le16(S_DS_GEN);
-
-	return 0;
-}
-
-int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
-				struct cmd_ds_command *cmd, void *pdata_buf)
-{
-	struct cmd_ds_802_11_ad_hoc_join *join_cmd = &cmd->params.adj;
-	struct assoc_request *assoc_req = pdata_buf;
-	struct bss_descriptor *bss = &assoc_req->bss;
-	int cmdappendsize = 0;
-	int ret = 0;
-	u16 ratesize = 0;
-	DECLARE_MAC_BUF(mac);
-
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	cmd->command = cpu_to_le16(CMD_802_11_AD_HOC_JOIN);
-
-	join_cmd->bss.type = CMD_BSS_TYPE_IBSS;
-	join_cmd->bss.beaconperiod = cpu_to_le16(bss->beaconperiod);
-
-	memcpy(&join_cmd->bss.bssid, &bss->bssid, ETH_ALEN);
-	memcpy(&join_cmd->bss.ssid, &bss->ssid, bss->ssid_len);
-
-	memcpy(&join_cmd->bss.phyparamset, &bss->phyparamset,
-	       sizeof(union ieeetypes_phyparamset));
-
-	memcpy(&join_cmd->bss.ssparamset, &bss->ssparamset,
-	       sizeof(union IEEEtypes_ssparamset));
-
-	join_cmd->bss.capability = cpu_to_le16(bss->capability & CAPINFO_MASK);
-	lbs_deb_join("ADHOC_J_CMD: tmpcap=%4X CAPINFO_MASK=%4X\n",
-	       bss->capability, CAPINFO_MASK);
-
-	/* information on BSSID descriptor passed to FW */
-	lbs_deb_join(
-	       "ADHOC_J_CMD: BSSID = %s, SSID = '%s'\n",
-	       print_mac(mac, join_cmd->bss.bssid),
-	       join_cmd->bss.ssid);
-
-	/* failtimeout */
-	join_cmd->failtimeout = cpu_to_le16(MRVDRV_ASSOCIATION_TIME_OUT);
-
-	/* probedelay */
-	join_cmd->probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
-
-	priv->curbssparams.channel = bss->channel;
-
-	/* Copy Data rates from the rates recorded in scan response */
-	memset(join_cmd->bss.rates, 0, sizeof(join_cmd->bss.rates));
-	ratesize = min_t(u16, sizeof(join_cmd->bss.rates), MAX_RATES);
-	memcpy(join_cmd->bss.rates, bss->rates, ratesize);
-	if (get_common_rates(priv, join_cmd->bss.rates, &ratesize)) {
-		lbs_deb_join("ADHOC_J_CMD: get_common_rates returns error.\n");
-		ret = -1;
-		goto done;
-	}
-
-	/* Copy the ad-hoc creating rates into Current BSS state structure */
-	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
-	memcpy(&priv->curbssparams.rates, join_cmd->bss.rates, ratesize);
-
-	/* Set MSB on basic rates as the firmware requires, but _after_
-	 * copying to current bss rates.
-	 */
-	lbs_set_basic_rate_flags(join_cmd->bss.rates, ratesize);
-
-	join_cmd->bss.ssparamset.ibssparamset.atimwindow =
-	    cpu_to_le16(bss->atimwindow);
-
-	if (assoc_req->secinfo.wep_enabled) {
-		u16 tmp = le16_to_cpu(join_cmd->bss.capability);
-		tmp |= WLAN_CAPABILITY_PRIVACY;
-		join_cmd->bss.capability = cpu_to_le16(tmp);
-	}
-
-	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
-		/* wake up first */
-		__le32 Localpsmode;
-
-		Localpsmode = cpu_to_le32(LBS802_11POWERMODECAM);
-		ret = lbs_prepare_and_send_command(priv,
-					    CMD_802_11_PS_MODE,
-					    CMD_ACT_SET,
-					    0, 0, &Localpsmode);
-
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
-	}
-
-	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
-		ret = -1;
-		goto done;
-	}
-
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_ad_hoc_join) +
-				S_DS_GEN + cmdappendsize);
-
-done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
-	return ret;
-}
-
 int lbs_ret_80211_associate(struct lbs_private *priv,
 			      struct cmd_ds_command *resp)
 {
@@ -1821,24 +1766,19 @@ done:
 	return ret;
 }
 
-int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
-				 struct cmd_ds_command *resp)
+static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp)
 {
 	int ret = 0;
 	u16 command = le16_to_cpu(resp->command);
 	u16 result = le16_to_cpu(resp->result);
-	struct cmd_ds_802_11_ad_hoc_result *padhocresult;
+	struct cmd_ds_802_11_ad_hoc_result *adhoc_resp;
 	union iwreq_data wrqu;
 	struct bss_descriptor *bss;
 	DECLARE_MAC_BUF(mac);
 
 	lbs_deb_enter(LBS_DEB_JOIN);
 
-	padhocresult = &resp->params.result;
-
-	lbs_deb_join("ADHOC_RESP: size = %d\n", le16_to_cpu(resp->size));
-	lbs_deb_join("ADHOC_RESP: command = %x\n", command);
-	lbs_deb_join("ADHOC_RESP: result = %x\n", result);
+	adhoc_resp = (struct cmd_ds_802_11_ad_hoc_result *) resp;
 
 	if (!priv->in_progress_assoc_req) {
 		lbs_deb_join("ADHOC_RESP: no in-progress association "
@@ -1852,26 +1792,19 @@ int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 	 * Join result code 0 --> SUCCESS
 	 */
 	if (result) {
-		lbs_deb_join("ADHOC_RESP: failed\n");
+		lbs_deb_join("ADHOC_RESP: failed (result 0x%X)\n", result);
 		if (priv->connect_status == LBS_CONNECTED)
 			lbs_mac_event_disconnected(priv);
 		ret = -1;
 		goto done;
 	}
 
-	/*
-	 * Now the join cmd should be successful
-	 * If BSSID has changed use SSID to compare instead of BSSID
-	 */
-	lbs_deb_join("ADHOC_RESP: associated to '%s'\n",
-		escape_essid(bss->ssid, bss->ssid_len));
-
 	/* Send a Media Connected event, according to the Spec */
 	priv->connect_status = LBS_CONNECTED;
 
 	if (command == CMD_RET(CMD_802_11_AD_HOC_START)) {
 		/* Update the created network descriptor with the new BSSID */
-		memcpy(bss->bssid, padhocresult->bssid, ETH_ALEN);
+		memcpy(bss->bssid, adhoc_resp->bssid, ETH_ALEN);
 	}
 
 	/* Set the BSSID from the joined/started descriptor */
@@ -1890,22 +1823,13 @@ int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
-	lbs_deb_join("ADHOC_RESP: - Joined/Started Ad Hoc\n");
-	lbs_deb_join("ADHOC_RESP: channel = %d\n", priv->curbssparams.channel);
-	lbs_deb_join("ADHOC_RESP: BSSID = %s\n",
-		     print_mac(mac, padhocresult->bssid));
+	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %s, channel %d\n",
+		     escape_essid(bss->ssid, bss->ssid_len),
+		     print_mac(mac, priv->curbssparams.bssid),
+		     priv->curbssparams.channel);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
 	return ret;
 }
 
-int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_JOIN);
-
-	lbs_mac_event_disconnected(priv);
-
-	lbs_deb_leave(LBS_DEB_JOIN);
-	return 0;
-}
diff --git a/drivers/net/wireless/libertas/assoc.h b/drivers/net/wireless/libertas/assoc.h
index 92ba2c2..8b7336d 100644
--- a/drivers/net/wireless/libertas/assoc.h
+++ b/drivers/net/wireless/libertas/assoc.h
@@ -12,13 +12,9 @@ struct cmd_ds_command;
 int lbs_cmd_80211_authenticate(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					void *pdata_buf);
-int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
-				       struct cmd_ds_command *cmd,
-				       void *pdata_buf);
-int lbs_cmd_80211_ad_hoc_stop(struct cmd_ds_command *cmd);
-int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
-					struct cmd_ds_command *cmd,
-					void *pdata_buf);
+
+int lbs_adhoc_stop(struct lbs_private *priv);
+
 int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 				 u8 bssid[ETH_ALEN], u16 reason);
 int lbs_cmd_80211_associate(struct lbs_private *priv,
@@ -27,10 +23,7 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 
 int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 					struct cmd_ds_command *resp);
-int lbs_ret_80211_ad_hoc_stop(struct lbs_private *priv);
 int lbs_ret_80211_associate(struct lbs_private *priv,
 				     struct cmd_ds_command *resp);
 
-int lbs_stop_adhoc_network(struct lbs_private *priv);
-
 #endif /* _LBS_ASSOC_H */
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index f3073a5..802547e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1419,10 +1419,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_80211_associate(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_AD_HOC_START:
-		ret = lbs_cmd_80211_ad_hoc_start(priv, cmdptr, pdata_buf);
-		break;
-
 	case CMD_802_11_RESET:
 		ret = lbs_cmd_802_11_reset(cmdptr, cmd_action);
 		break;
@@ -1447,18 +1443,10 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 				          cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_AD_HOC_JOIN:
-		ret = lbs_cmd_80211_ad_hoc_join(priv, cmdptr, pdata_buf);
-		break;
-
 	case CMD_802_11_RSSI:
 		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
 		break;
 
-	case CMD_802_11_AD_HOC_STOP:
-		ret = lbs_cmd_80211_ad_hoc_stop(cmdptr);
-		break;
-
 	case CMD_802_11_SET_AFC:
 	case CMD_802_11_GET_AFC:
 
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index c94604c..0371c83 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -258,11 +258,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_80211_associate(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_AD_HOC_START):
-	case CMD_RET(CMD_802_11_AD_HOC_JOIN):
-		ret = lbs_ret_80211_ad_hoc_start(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_SNMP_MIB):
 		ret = lbs_ret_802_11_snmp_mib(priv, resp);
 		break;
@@ -285,10 +280,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_802_11_rssi(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_AD_HOC_STOP):
-		ret = lbs_ret_80211_ad_hoc_stop(priv);
-		break;
-
 	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
 		ret = lbs_ret_802_11d_domain_info(resp);
 		break;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 342c2e3..1367380 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -257,11 +257,6 @@ struct cmd_ds_802_11_associate_rsp {
 	struct ieeetypes_assocrsp assocRsp;
 };
 
-struct cmd_ds_802_11_ad_hoc_result {
-	u8 pad[3];
-	u8 bssid[ETH_ALEN];
-};
-
 struct cmd_ds_802_11_set_wep {
 	struct cmd_header hdr;
 
@@ -508,10 +503,12 @@ struct cmd_ds_802_11_rate_adapt_rateset {
 };
 
 struct cmd_ds_802_11_ad_hoc_start {
+	struct cmd_header hdr;
+
 	u8 ssid[IW_ESSID_MAX_SIZE];
 	u8 bsstype;
 	__le16 beaconperiod;
-	u8 dtimperiod;
+	u8 dtimperiod;   /* Reserved on v9 and later */
 	union IEEEtypes_ssparamset ssparamset;
 	union ieeetypes_phyparamset phyparamset;
 	__le16 probedelay;
@@ -520,9 +517,16 @@ struct cmd_ds_802_11_ad_hoc_start {
 	u8 tlv_memory_size_pad[100];
 } __attribute__ ((packed));
 
+struct cmd_ds_802_11_ad_hoc_result {
+	struct cmd_header hdr;
+	
+	u8 pad[3];
+	u8 bssid[ETH_ALEN];
+};
+
 struct adhoc_bssdesc {
-	u8 bssid[6];
-	u8 ssid[32];
+	u8 bssid[ETH_ALEN];
+	u8 ssid[IW_ESSID_MAX_SIZE];
 	u8 type;
 	__le16 beaconperiod;
 	u8 dtimperiod;
@@ -540,10 +544,15 @@ struct adhoc_bssdesc {
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_ad_hoc_join {
+	struct cmd_header hdr;
+
 	struct adhoc_bssdesc bss;
-	__le16 failtimeout;
-	__le16 probedelay;
+	__le16 failtimeout;   /* Reserved on v9 and later */
+	__le16 probedelay;    /* Reserved on v9 and later */
+} __attribute__ ((packed));
 
+struct cmd_ds_802_11_ad_hoc_stop {
+	struct cmd_header hdr;
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_enable_rsn {
@@ -694,16 +703,13 @@ struct cmd_ds_command {
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
 		struct cmd_ds_802_11_associate associate;
-		struct cmd_ds_802_11_ad_hoc_start ads;
 		struct cmd_ds_802_11_reset reset;
-		struct cmd_ds_802_11_ad_hoc_result result;
 		struct cmd_ds_802_11_authenticate auth;
 		struct cmd_ds_802_11_get_stat gstat;
 		struct cmd_ds_802_3_get_stat gstat_8023;
 		struct cmd_ds_802_11_snmp_mib smib;
 		struct cmd_ds_802_11_rf_antenna rant;
 		struct cmd_ds_802_11_monitor_mode monitor;
-		struct cmd_ds_802_11_ad_hoc_join adj;
 		struct cmd_ds_802_11_rssi rssi;
 		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_mac_reg_access macreg;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index dafe62e..2436634 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -295,7 +295,7 @@ static ssize_t lbs_rtap_set(struct device *dev,
 							     priv->curbssparams.bssid,
 							     WLAN_REASON_DEAUTH_LEAVING);
 			else if (priv->mode == IW_MODE_ADHOC)
-				lbs_stop_adhoc_network(priv);
+				lbs_adhoc_stop(priv);
 			lbs_add_rtap(priv);
 		}
 		priv->monitormode = monitor_mode;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 4307090..426f1fe 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -966,7 +966,7 @@ static int lbs_mesh_set_freq(struct net_device *dev,
 						     priv->curbssparams.bssid,
 						     WLAN_REASON_DEAUTH_LEAVING);
 		else if (priv->mode == IW_MODE_ADHOC)
-			lbs_stop_adhoc_network(priv);
+			lbs_adhoc_stop(priv);
 	}
 	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, fwrq->m);
 	lbs_update_channel(priv);


