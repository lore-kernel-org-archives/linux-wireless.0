Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXLJRkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:40:08 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 29/48] libertas: kill struct lbs_adapter
Message-Id: <E1J1kpY-0006mS-Iq@shinybook.infradead.org> (sfid-20071210_174023_429070_AD543FB4)
Date: Mon, 10 Dec 2007 10:46:04 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 20:04:36 +0000

There seems to be no reason for a separate structure; move it all
into struct lbs_private.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/11d.c     |   68 +++---
 drivers/net/wireless/libertas/assoc.c   |  136 ++++++------
 drivers/net/wireless/libertas/assoc.h   |    2 +-
 drivers/net/wireless/libertas/cmd.c     |  278 +++++++++++------------
 drivers/net/wireless/libertas/cmdresp.c |  336 +++++++++++++---------------
 drivers/net/wireless/libertas/debugfs.c |   56 +++---
 drivers/net/wireless/libertas/decl.h    |    7 +-
 drivers/net/wireless/libertas/dev.h     |   97 ++++----
 drivers/net/wireless/libertas/ethtool.c |   19 +-
 drivers/net/wireless/libertas/if_cs.c   |   21 +-
 drivers/net/wireless/libertas/if_sdio.c |   20 +-
 drivers/net/wireless/libertas/if_usb.c  |   27 +--
 drivers/net/wireless/libertas/join.c    |  150 ++++++-------
 drivers/net/wireless/libertas/main.c    |  326 ++++++++++++---------------
 drivers/net/wireless/libertas/rx.c      |   78 +++----
 drivers/net/wireless/libertas/scan.c    |  188 ++++++++--------
 drivers/net/wireless/libertas/scan.h    |    6 +-
 drivers/net/wireless/libertas/tx.c      |   63 +++---
 drivers/net/wireless/libertas/wext.c    |  372 ++++++++++++++-----------------
 19 files changed, 1046 insertions(+), 1204 deletions(-)

diff --git a/drivers/net/wireless/libertas/11d.c b/drivers/net/wireless/libertas/11d.c
index 013965d..5e10ce0 100644
--- a/drivers/net/wireless/libertas/11d.c
+++ b/drivers/net/wireless/libertas/11d.c
@@ -432,8 +432,8 @@ u8 lbs_get_scan_type_11d(u8 chan,
 
 void lbs_init_11d(struct lbs_private *priv)
 {
-	priv->adapter->enable11d = 0;
-	memset(&(priv->adapter->parsed_region_chan), 0,
+	priv->enable11d = 0;
+	memset(&(priv->parsed_region_chan), 0,
 	       sizeof(struct parsed_region_chan_11d));
 	return;
 }
@@ -447,7 +447,7 @@ static int set_domain_info_11d(struct lbs_private *priv)
 {
 	int ret;
 
-	if (!priv->adapter->enable11d) {
+	if (!priv->enable11d) {
 		lbs_deb_11d("dnld domain Info with 11d disabled\n");
 		return 0;
 	}
@@ -469,22 +469,21 @@ static int set_domain_info_11d(struct lbs_private *priv)
 */
 int lbs_set_universaltable(struct lbs_private *priv, u8 band)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	u16 size = sizeof(struct chan_freq_power);
 	u16 i = 0;
 
-	memset(adapter->universal_channel, 0,
-	       sizeof(adapter->universal_channel));
+	memset(priv->universal_channel, 0,
+	       sizeof(priv->universal_channel));
 
-	adapter->universal_channel[i].nrcfp =
+	priv->universal_channel[i].nrcfp =
 	    sizeof(channel_freq_power_UN_BG) / size;
 	lbs_deb_11d("BG-band nrcfp %d\n",
-	       adapter->universal_channel[i].nrcfp);
+	       priv->universal_channel[i].nrcfp);
 
-	adapter->universal_channel[i].CFP = channel_freq_power_UN_BG;
-	adapter->universal_channel[i].valid = 1;
-	adapter->universal_channel[i].region = UNIVERSAL_REGION_CODE;
-	adapter->universal_channel[i].band = band;
+	priv->universal_channel[i].CFP = channel_freq_power_UN_BG;
+	priv->universal_channel[i].valid = 1;
+	priv->universal_channel[i].region = UNIVERSAL_REGION_CODE;
+	priv->universal_channel[i].band = band;
 	i++;
 
 	return 0;
@@ -505,8 +504,7 @@ int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 	struct cmd_ds_802_11d_domain_info *pdomaininfo =
 	    &cmd->params.domaininfo;
 	struct mrvlietypes_domainparamset *domain = &pdomaininfo->domain;
-	struct lbs_adapter *adapter = priv->adapter;
-	u8 nr_subband = adapter->domainreg.nr_subband;
+	u8 nr_subband = priv->domainreg.nr_subband;
 
 	lbs_deb_enter(LBS_DEB_11D);
 
@@ -523,7 +521,7 @@ int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 	}
 
 	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
-	memcpy(domain->countrycode, adapter->domainreg.countrycode,
+	memcpy(domain->countrycode, priv->domainreg.countrycode,
 	       sizeof(domain->countrycode));
 
 	domain->header.len =
@@ -531,7 +529,7 @@ int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 			     sizeof(domain->countrycode));
 
 	if (nr_subband) {
-		memcpy(domain->subband, adapter->domainreg.subband,
+		memcpy(domain->subband, priv->domainreg.subband,
 		       nr_subband * sizeof(struct ieeetypes_subbandset));
 
 		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
@@ -605,24 +603,23 @@ int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
                                         struct bss_descriptor * bss)
 {
 	int ret;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_11D);
-	if (priv->adapter->enable11d) {
-		memset(&adapter->parsed_region_chan, 0,
+	if (priv->enable11d) {
+		memset(&priv->parsed_region_chan, 0,
 		       sizeof(struct parsed_region_chan_11d));
 		ret = parse_domain_info_11d(&bss->countryinfo, 0,
-					       &adapter->parsed_region_chan);
+					       &priv->parsed_region_chan);
 
 		if (ret == -1) {
 			lbs_deb_11d("error parsing domain_info from AP\n");
 			goto done;
 		}
 
-		memset(&adapter->domainreg, 0,
+		memset(&priv->domainreg, 0,
 		       sizeof(struct lbs_802_11d_domain_reg));
-		generate_domain_info_11d(&adapter->parsed_region_chan,
-				      &adapter->domainreg);
+		generate_domain_info_11d(&priv->parsed_region_chan,
+				      &priv->domainreg);
 
 		ret = set_domain_info_11d(priv);
 
@@ -646,18 +643,17 @@ done:
 int lbs_create_dnld_countryinfo_11d(struct lbs_private *priv)
 {
 	int ret;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct region_channel *region_chan;
 	u8 j;
 
 	lbs_deb_enter(LBS_DEB_11D);
-	lbs_deb_11d("curbssparams.band %d\n", adapter->curbssparams.band);
+	lbs_deb_11d("curbssparams.band %d\n", priv->curbssparams.band);
 
-	if (priv->adapter->enable11d) {
+	if (priv->enable11d) {
 		/* update parsed_region_chan_11; dnld domaininf to FW */
 
-		for (j = 0; j < ARRAY_SIZE(adapter->region_channel); j++) {
-			region_chan = &adapter->region_channel[j];
+		for (j = 0; j < ARRAY_SIZE(priv->region_channel); j++) {
+			region_chan = &priv->region_channel[j];
 
 			lbs_deb_11d("%d region_chan->band %d\n", j,
 			       region_chan->band);
@@ -665,28 +661,28 @@ int lbs_create_dnld_countryinfo_11d(struct lbs_private *priv)
 			if (!region_chan || !region_chan->valid
 			    || !region_chan->CFP)
 				continue;
-			if (region_chan->band != adapter->curbssparams.band)
+			if (region_chan->band != priv->curbssparams.band)
 				continue;
 			break;
 		}
 
-		if (j >= ARRAY_SIZE(adapter->region_channel)) {
+		if (j >= ARRAY_SIZE(priv->region_channel)) {
 			lbs_deb_11d("region_chan not found, band %d\n",
-			       adapter->curbssparams.band);
+			       priv->curbssparams.band);
 			ret = -1;
 			goto done;
 		}
 
-		memset(&adapter->parsed_region_chan, 0,
+		memset(&priv->parsed_region_chan, 0,
 		       sizeof(struct parsed_region_chan_11d));
 		lbs_generate_parsed_region_chan_11d(region_chan,
-						     &adapter->
+						     &priv->
 						     parsed_region_chan);
 
-		memset(&adapter->domainreg, 0,
+		memset(&priv->domainreg, 0,
 		       sizeof(struct lbs_802_11d_domain_reg));
-		generate_domain_info_11d(&adapter->parsed_region_chan,
-					 &adapter->domainreg);
+		generate_domain_info_11d(&priv->parsed_region_chan,
+					 &priv->domainreg);
 
 		ret = set_domain_info_11d(priv);
 
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 88da68e..63bd692 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -18,7 +18,6 @@ static const u8 bssid_off[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 static int assoc_helper_essid(struct lbs_private *priv,
                               struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct bss_descriptor * bss;
 	int channel = -1;
@@ -38,7 +37,7 @@ static int assoc_helper_essid(struct lbs_private *priv,
 		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
 			assoc_req->ssid_len, 0);
 
-		bss = lbs_find_ssid_in_list(adapter, assoc_req->ssid,
+		bss = lbs_find_ssid_in_list(priv, assoc_req->ssid,
 				assoc_req->ssid_len, NULL, IW_MODE_INFRA, channel);
 		if (bss != NULL) {
 			memcpy(&assoc_req->bss, bss, sizeof(struct bss_descriptor));
@@ -54,7 +53,7 @@ static int assoc_helper_essid(struct lbs_private *priv,
 			assoc_req->ssid_len, 1);
 
 		/* Search for the requested SSID in the scan table */
-		bss = lbs_find_ssid_in_list(adapter, assoc_req->ssid,
+		bss = lbs_find_ssid_in_list(priv, assoc_req->ssid,
 				assoc_req->ssid_len, NULL, IW_MODE_ADHOC, channel);
 		if (bss != NULL) {
 			lbs_deb_assoc("SSID found, will join\n");
@@ -78,7 +77,6 @@ static int assoc_helper_essid(struct lbs_private *priv,
 static int assoc_helper_bssid(struct lbs_private *priv,
                               struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct bss_descriptor * bss;
 	DECLARE_MAC_BUF(mac);
@@ -87,7 +85,7 @@ static int assoc_helper_bssid(struct lbs_private *priv,
 		print_mac(mac, assoc_req->bssid));
 
 	/* Search for index position in list for requested MAC */
-	bss = lbs_find_bssid_in_list(adapter, assoc_req->bssid,
+	bss = lbs_find_bssid_in_list(priv, assoc_req->bssid,
 			    assoc_req->mode);
 	if (bss == NULL) {
 		lbs_deb_assoc("ASSOC: WAP: BSSID %s not found, "
@@ -138,21 +136,20 @@ static int assoc_helper_associate(struct lbs_private *priv,
 static int assoc_helper_mode(struct lbs_private *priv,
                              struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	if (assoc_req->mode == adapter->mode)
+	if (assoc_req->mode == priv->mode)
 		goto done;
 
 	if (assoc_req->mode == IW_MODE_INFRA) {
-		if (adapter->psstate != PS_STATE_FULL_POWER)
+		if (priv->psstate != PS_STATE_FULL_POWER)
 			lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
-		adapter->psmode = LBS802_11POWERMODECAM;
+		priv->psmode = LBS802_11POWERMODECAM;
 	}
 
-	adapter->mode = assoc_req->mode;
+	priv->mode = assoc_req->mode;
 	ret = lbs_prepare_and_send_command(priv,
 				    CMD_802_11_SNMP_MIB,
 				    0, CMD_OPTION_WAITFORRSP,
@@ -191,7 +188,6 @@ void lbs_sync_channel(struct work_struct *work)
 static int assoc_helper_channel(struct lbs_private *priv,
                                 struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -201,11 +197,11 @@ static int assoc_helper_channel(struct lbs_private *priv,
 		lbs_deb_assoc("ASSOC: channel: error getting channel.");
 	}
 
-	if (assoc_req->channel == adapter->curbssparams.channel)
+	if (assoc_req->channel == priv->curbssparams.channel)
 		goto done;
 
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
-	       adapter->curbssparams.channel, assoc_req->channel);
+	       priv->curbssparams.channel, assoc_req->channel);
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_RF_CHANNEL,
 				CMD_OPT_802_11_RF_CHANNEL_SET,
@@ -219,7 +215,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 		lbs_deb_assoc("ASSOC: channel: error getting channel.");
 	}
 
-	if (assoc_req->channel != adapter->curbssparams.channel) {
+	if (assoc_req->channel != priv->curbssparams.channel) {
 		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d",
 		              assoc_req->channel);
 		goto done;
@@ -246,7 +242,6 @@ done:
 static int assoc_helper_wep_keys(struct lbs_private *priv,
                                  struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int i;
 	int ret = 0;
 
@@ -275,23 +270,23 @@ static int assoc_helper_wep_keys(struct lbs_private *priv,
 
 	/* enable/disable the MAC's WEP packet filter */
 	if (assoc_req->secinfo.wep_enabled)
-		adapter->currentpacketfilter |= CMD_ACT_MAC_WEP_ENABLE;
+		priv->currentpacketfilter |= CMD_ACT_MAC_WEP_ENABLE;
 	else
-		adapter->currentpacketfilter &= ~CMD_ACT_MAC_WEP_ENABLE;
+		priv->currentpacketfilter &= ~CMD_ACT_MAC_WEP_ENABLE;
 	ret = lbs_set_mac_packet_filter(priv);
 	if (ret)
 		goto out;
 
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 
-	/* Copy WEP keys into adapter wep key fields */
+	/* Copy WEP keys into priv wep key fields */
 	for (i = 0; i < 4; i++) {
-		memcpy(&adapter->wep_keys[i], &assoc_req->wep_keys[i],
+		memcpy(&priv->wep_keys[i], &assoc_req->wep_keys[i],
 			sizeof(struct enc_key));
 	}
-	adapter->wep_tx_keyidx = assoc_req->wep_tx_keyidx;
+	priv->wep_tx_keyidx = assoc_req->wep_tx_keyidx;
 
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -301,14 +296,13 @@ out:
 static int assoc_helper_secinfo(struct lbs_private *priv,
                                 struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u32 do_wpa;
 	u32 rsn = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	memcpy(&adapter->secinfo, &assoc_req->secinfo,
+	memcpy(&priv->secinfo, &assoc_req->secinfo,
 		sizeof(struct lbs_802_11_security));
 
 	ret = lbs_set_mac_packet_filter(priv);
@@ -396,17 +390,16 @@ out:
 static int assoc_helper_wpa_ie(struct lbs_private *priv,
                                struct assoc_request * assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	if (assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled) {
-		memcpy(&adapter->wpa_ie, &assoc_req->wpa_ie, assoc_req->wpa_ie_len);
-		adapter->wpa_ie_len = assoc_req->wpa_ie_len;
+		memcpy(&priv->wpa_ie, &assoc_req->wpa_ie, assoc_req->wpa_ie_len);
+		priv->wpa_ie_len = assoc_req->wpa_ie_len;
 	} else {
-		memset(&adapter->wpa_ie, 0, MAX_WPA_IE_LEN);
-		adapter->wpa_ie_len = 0;
+		memset(&priv->wpa_ie, 0, MAX_WPA_IE_LEN);
+		priv->wpa_ie_len = 0;
 	}
 
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -414,14 +407,14 @@ static int assoc_helper_wpa_ie(struct lbs_private *priv,
 }
 
 
-static int should_deauth_infrastructure(struct lbs_adapter *adapter,
+static int should_deauth_infrastructure(struct lbs_private *priv,
                                         struct assoc_request * assoc_req)
 {
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	if (adapter->connect_status != LBS_CONNECTED)
+	if (priv->connect_status != LBS_CONNECTED)
 		return 0;
 
 	if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
@@ -431,7 +424,7 @@ static int should_deauth_infrastructure(struct lbs_adapter *adapter,
 	}
 
 	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
-		if (adapter->secinfo.auth_mode != assoc_req->secinfo.auth_mode) {
+		if (priv->secinfo.auth_mode != assoc_req->secinfo.auth_mode) {
 			lbs_deb_assoc("Deauthenticating due to new security\n");
 			ret = 1;
 			goto out;
@@ -466,16 +459,16 @@ out:
 }
 
 
-static int should_stop_adhoc(struct lbs_adapter *adapter,
+static int should_stop_adhoc(struct lbs_private *priv,
                              struct assoc_request * assoc_req)
 {
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	if (adapter->connect_status != LBS_CONNECTED)
+	if (priv->connect_status != LBS_CONNECTED)
 		return 0;
 
-	if (lbs_ssid_cmp(adapter->curbssparams.ssid,
-	                      adapter->curbssparams.ssid_len,
+	if (lbs_ssid_cmp(priv->curbssparams.ssid,
+	                      priv->curbssparams.ssid_len,
 	                      assoc_req->ssid, assoc_req->ssid_len) != 0)
 		return 1;
 
@@ -486,7 +479,7 @@ static int should_stop_adhoc(struct lbs_adapter *adapter,
 	}
 
 	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
-		if (assoc_req->channel != adapter->curbssparams.channel)
+		if (assoc_req->channel != priv->curbssparams.channel)
 			return 1;
 	}
 
@@ -499,7 +492,6 @@ void lbs_association_worker(struct work_struct *work)
 {
 	struct lbs_private *priv = container_of(work, struct lbs_private,
 		assoc_work.work);
-	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req = NULL;
 	int ret = 0;
 	int find_any_ssid = 0;
@@ -507,11 +499,11 @@ void lbs_association_worker(struct work_struct *work)
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	mutex_lock(&adapter->lock);
-	assoc_req = adapter->pending_assoc_req;
-	adapter->pending_assoc_req = NULL;
-	adapter->in_progress_assoc_req = assoc_req;
-	mutex_unlock(&adapter->lock);
+	mutex_lock(&priv->lock);
+	assoc_req = priv->pending_assoc_req;
+	priv->pending_assoc_req = NULL;
+	priv->in_progress_assoc_req = assoc_req;
+	mutex_unlock(&priv->lock);
 
 	if (!assoc_req)
 		goto done;
@@ -569,8 +561,8 @@ void lbs_association_worker(struct work_struct *work)
 	 * Check if the attributes being changing require deauthentication
 	 * from the currently associated infrastructure access point.
 	 */
-	if (adapter->mode == IW_MODE_INFRA) {
-		if (should_deauth_infrastructure(adapter, assoc_req)) {
+	if (priv->mode == IW_MODE_INFRA) {
+		if (should_deauth_infrastructure(priv, assoc_req)) {
 			ret = lbs_send_deauthentication(priv);
 			if (ret) {
 				lbs_deb_assoc("Deauthentication due to new "
@@ -578,8 +570,8 @@ void lbs_association_worker(struct work_struct *work)
 					ret);
 			}
 		}
-	} else if (adapter->mode == IW_MODE_ADHOC) {
-		if (should_stop_adhoc(adapter, assoc_req)) {
+	} else if (priv->mode == IW_MODE_ADHOC) {
+		if (should_stop_adhoc(priv, assoc_req)) {
 			ret = lbs_stop_adhoc_network(priv);
 			if (ret) {
 				lbs_deb_assoc("Teardown of AdHoc network due to "
@@ -643,7 +635,7 @@ void lbs_association_worker(struct work_struct *work)
 			success = 0;
 		}
 
-		if (adapter->connect_status != LBS_CONNECTED) {
+		if (priv->connect_status != LBS_CONNECTED) {
 			lbs_deb_assoc("ASSOC: association unsuccessful, "
 				"not connected\n");
 			success = 0;
@@ -651,9 +643,9 @@ void lbs_association_worker(struct work_struct *work)
 
 		if (success) {
 			lbs_deb_assoc("ASSOC: associated to '%s', %s\n",
-				escape_essid(adapter->curbssparams.ssid,
-				             adapter->curbssparams.ssid_len),
-				print_mac(mac, adapter->curbssparams.bssid));
+				escape_essid(priv->curbssparams.ssid,
+				             priv->curbssparams.ssid_len),
+				print_mac(mac, priv->curbssparams.bssid));
 			lbs_prepare_and_send_command(priv,
 				CMD_802_11_RSSI,
 				0, CMD_OPTION_WAITFORRSP, 0, NULL);
@@ -672,9 +664,9 @@ out:
 			ret);
 	}
 
-	mutex_lock(&adapter->lock);
-	adapter->in_progress_assoc_req = NULL;
-	mutex_unlock(&adapter->lock);
+	mutex_lock(&priv->lock);
+	priv->in_progress_assoc_req = NULL;
+	mutex_unlock(&priv->lock);
 	kfree(assoc_req);
 
 done:
@@ -685,15 +677,15 @@ done:
 /*
  * Caller MUST hold any necessary locks
  */
-struct assoc_request *lbs_get_association_request(struct lbs_adapter *adapter)
+struct assoc_request *lbs_get_association_request(struct lbs_private *priv)
 {
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
-	if (!adapter->pending_assoc_req) {
-		adapter->pending_assoc_req = kzalloc(sizeof(struct assoc_request),
+	if (!priv->pending_assoc_req) {
+		priv->pending_assoc_req = kzalloc(sizeof(struct assoc_request),
 		                                     GFP_KERNEL);
-		if (!adapter->pending_assoc_req) {
+		if (!priv->pending_assoc_req) {
 			lbs_pr_info("Not enough memory to allocate association"
 				" request!\n");
 			return NULL;
@@ -703,57 +695,57 @@ struct assoc_request *lbs_get_association_request(struct lbs_adapter *adapter)
 	/* Copy current configuration attributes to the association request,
 	 * but don't overwrite any that are already set.
 	 */
-	assoc_req = adapter->pending_assoc_req;
+	assoc_req = priv->pending_assoc_req;
 	if (!test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
-		memcpy(&assoc_req->ssid, &adapter->curbssparams.ssid,
+		memcpy(&assoc_req->ssid, &priv->curbssparams.ssid,
 		       IW_ESSID_MAX_SIZE);
-		assoc_req->ssid_len = adapter->curbssparams.ssid_len;
+		assoc_req->ssid_len = priv->curbssparams.ssid_len;
 	}
 
 	if (!test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags))
-		assoc_req->channel = adapter->curbssparams.channel;
+		assoc_req->channel = priv->curbssparams.channel;
 
 	if (!test_bit(ASSOC_FLAG_BAND, &assoc_req->flags))
-		assoc_req->band = adapter->curbssparams.band;
+		assoc_req->band = priv->curbssparams.band;
 
 	if (!test_bit(ASSOC_FLAG_MODE, &assoc_req->flags))
-		assoc_req->mode = adapter->mode;
+		assoc_req->mode = priv->mode;
 
 	if (!test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
-		memcpy(&assoc_req->bssid, adapter->curbssparams.bssid,
+		memcpy(&assoc_req->bssid, priv->curbssparams.bssid,
 			ETH_ALEN);
 	}
 
 	if (!test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)) {
 		int i;
 		for (i = 0; i < 4; i++) {
-			memcpy(&assoc_req->wep_keys[i], &adapter->wep_keys[i],
+			memcpy(&assoc_req->wep_keys[i], &priv->wep_keys[i],
 				sizeof(struct enc_key));
 		}
 	}
 
 	if (!test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags))
-		assoc_req->wep_tx_keyidx = adapter->wep_tx_keyidx;
+		assoc_req->wep_tx_keyidx = priv->wep_tx_keyidx;
 
 	if (!test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
-		memcpy(&assoc_req->wpa_mcast_key, &adapter->wpa_mcast_key,
+		memcpy(&assoc_req->wpa_mcast_key, &priv->wpa_mcast_key,
 			sizeof(struct enc_key));
 	}
 
 	if (!test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
-		memcpy(&assoc_req->wpa_unicast_key, &adapter->wpa_unicast_key,
+		memcpy(&assoc_req->wpa_unicast_key, &priv->wpa_unicast_key,
 			sizeof(struct enc_key));
 	}
 
 	if (!test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
-		memcpy(&assoc_req->secinfo, &adapter->secinfo,
+		memcpy(&assoc_req->secinfo, &priv->secinfo,
 			sizeof(struct lbs_802_11_security));
 	}
 
 	if (!test_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags)) {
-		memcpy(&assoc_req->wpa_ie, &adapter->wpa_ie,
+		memcpy(&assoc_req->wpa_ie, &priv->wpa_ie,
 			MAX_WPA_IE_LEN);
-		assoc_req->wpa_ie_len = adapter->wpa_ie_len;
+		assoc_req->wpa_ie_len = priv->wpa_ie_len;
 	}
 
 	lbs_deb_leave(LBS_DEB_ASSOC);
diff --git a/drivers/net/wireless/libertas/assoc.h b/drivers/net/wireless/libertas/assoc.h
index fad00ae..08372bb 100644
--- a/drivers/net/wireless/libertas/assoc.h
+++ b/drivers/net/wireless/libertas/assoc.h
@@ -6,7 +6,7 @@
 #include "dev.h"
 
 void lbs_association_worker(struct work_struct *work);
-struct assoc_request *lbs_get_association_request(struct lbs_adapter *adapter);
+struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
 void lbs_sync_channel(struct work_struct *work);
 
 #endif /* _LBS_ASSOC_H */
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6838c9c..49a9aee 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -50,7 +50,7 @@ static int lbs_cmd_hw_spec(struct lbs_private *priv, struct cmd_ds_command *cmd)
 
 	cmd->command = cpu_to_le16(CMD_GET_HW_SPEC);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_get_hw_spec) + S_DS_GEN);
-	memcpy(hwspec->permanentaddr, priv->adapter->current_addr, ETH_ALEN);
+	memcpy(hwspec->permanentaddr, priv->current_addr, ETH_ALEN);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -123,7 +123,6 @@ static int lbs_cmd_802_11_sleep_params(struct lbs_private *priv,
 					struct cmd_ds_command *cmd,
 					u16 cmd_action)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_sleep_params *sp = &cmd->params.sleep_params;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -133,17 +132,17 @@ static int lbs_cmd_802_11_sleep_params(struct lbs_private *priv,
 	cmd->command = cpu_to_le16(CMD_802_11_SLEEP_PARAMS);
 
 	if (cmd_action == CMD_ACT_GET) {
-		memset(&adapter->sp, 0, sizeof(struct sleep_params));
+		memset(&priv->sp, 0, sizeof(struct sleep_params));
 		memset(sp, 0, sizeof(struct cmd_ds_802_11_sleep_params));
 		sp->action = cpu_to_le16(cmd_action);
 	} else if (cmd_action == CMD_ACT_SET) {
 		sp->action = cpu_to_le16(cmd_action);
-		sp->error = cpu_to_le16(adapter->sp.sp_error);
-		sp->offset = cpu_to_le16(adapter->sp.sp_offset);
-		sp->stabletime = cpu_to_le16(adapter->sp.sp_stabletime);
-		sp->calcontrol = (u8) adapter->sp.sp_calcontrol;
-		sp->externalsleepclk = (u8) adapter->sp.sp_extsleepclk;
-		sp->reserved = cpu_to_le16(adapter->sp.sp_reserved);
+		sp->error = cpu_to_le16(priv->sp.sp_error);
+		sp->offset = cpu_to_le16(priv->sp.sp_offset);
+		sp->stabletime = cpu_to_le16(priv->sp.sp_stabletime);
+		sp->calcontrol = (u8) priv->sp.sp_calcontrol;
+		sp->externalsleepclk = (u8) priv->sp.sp_extsleepclk;
+		sp->reserved = cpu_to_le16(priv->sp.sp_reserved);
 	}
 
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -156,7 +155,6 @@ static int lbs_cmd_802_11_set_wep(struct lbs_private *priv,
                                    void * pdata_buf)
 {
 	struct cmd_ds_802_11_set_wep *wep = &cmd->params.wep;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct assoc_request * assoc_req = pdata_buf;
 
@@ -212,9 +210,9 @@ static int lbs_cmd_802_11_set_wep(struct lbs_private *priv,
 		wep->action = cpu_to_le16(CMD_ACT_REMOVE);
 
 		/* default tx key index */
-		wep->keyindex = cpu_to_le16((u16)(adapter->wep_tx_keyidx &
+		wep->keyindex = cpu_to_le16((u16)(priv->wep_tx_keyidx &
 						  (u32)CMD_WEP_KEY_INDEX_MASK));
-		lbs_deb_cmd("SET_WEP: remove key %d\n", adapter->wep_tx_keyidx);
+		lbs_deb_cmd("SET_WEP: remove key %d\n", priv->wep_tx_keyidx);
 	}
 
 	ret = 0;
@@ -415,7 +413,6 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				    int cmd_oid, void *pdata_buf)
 {
 	struct cmd_ds_802_11_snmp_mib *pSNMPMIB = &cmd->params.smib;
-	struct lbs_adapter *adapter = priv->adapter;
 	u8 ucTemp;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -507,7 +504,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 			pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 			pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
 			*((__le16 *)(pSNMPMIB->value)) =
-			    cpu_to_le16((u16) adapter->txretrycount);
+			    cpu_to_le16((u16) priv->txretrycount);
 		}
 
 		break;
@@ -534,7 +531,6 @@ static int lbs_cmd_802_11_radio_control(struct lbs_private *priv,
 					 struct cmd_ds_command *cmd,
 					 int cmd_action)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_radio_control *pradiocontrol = &cmd->params.radio;
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -546,7 +542,7 @@ static int lbs_cmd_802_11_radio_control(struct lbs_private *priv,
 
 	pradiocontrol->action = cpu_to_le16(cmd_action);
 
-	switch (adapter->preamble) {
+	switch (priv->preamble) {
 	case CMD_TYPE_SHORT_PREAMBLE:
 		pradiocontrol->control = cpu_to_le16(SET_SHORT_PREAMBLE);
 		break;
@@ -561,7 +557,7 @@ static int lbs_cmd_802_11_radio_control(struct lbs_private *priv,
 		break;
 	}
 
-	if (adapter->radioon)
+	if (priv->radioon)
 		pradiocontrol->control |= cpu_to_le16(TURN_ON_RF);
 	else
 		pradiocontrol->control &= cpu_to_le16(~TURN_ON_RF);
@@ -640,7 +636,6 @@ static int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
 {
 	struct cmd_ds_802_11_rate_adapt_rateset
 	*rateadapt = &cmd->params.rateset;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->size =
@@ -649,8 +644,8 @@ static int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
 	cmd->command = cpu_to_le16(CMD_802_11_RATE_ADAPT_RATESET);
 
 	rateadapt->action = cpu_to_le16(cmd_action);
-	rateadapt->enablehwauto = cpu_to_le16(adapter->enablehwauto);
-	rateadapt->bitmap = cpu_to_le16(adapter->ratebitmap);
+	rateadapt->enablehwauto = cpu_to_le16(priv->enablehwauto);
+	rateadapt->bitmap = cpu_to_le16(priv->ratebitmap);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -661,7 +656,6 @@ static int lbs_cmd_802_11_data_rate(struct lbs_private *priv,
 				     u16 cmd_action)
 {
 	struct cmd_ds_802_11_data_rate *pdatarate = &cmd->params.drate;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -672,9 +666,9 @@ static int lbs_cmd_802_11_data_rate(struct lbs_private *priv,
 	pdatarate->action = cpu_to_le16(cmd_action);
 
 	if (cmd_action == CMD_ACT_SET_TX_FIX_RATE) {
-		pdatarate->rates[0] = lbs_data_rate_to_fw_index(adapter->cur_rate);
+		pdatarate->rates[0] = lbs_data_rate_to_fw_index(priv->cur_rate);
 		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n",
-		       adapter->cur_rate);
+		       priv->cur_rate);
 	} else if (cmd_action == CMD_ACT_SET_TX_AUTO) {
 		lbs_deb_cmd("DATA_RATE: setting auto\n");
 	}
@@ -688,7 +682,6 @@ static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
 				      u16 cmd_action)
 {
 	struct cmd_ds_mac_multicast_adr *pMCastAdr = &cmd->params.madr;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_multicast_adr) +
@@ -698,9 +691,9 @@ static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
 	lbs_deb_cmd("MULTICAST_ADR: setting %d addresses\n", pMCastAdr->nr_of_adrs);
 	pMCastAdr->action = cpu_to_le16(cmd_action);
 	pMCastAdr->nr_of_adrs =
-	    cpu_to_le16((u16) adapter->nr_of_multicastmacaddr);
-	memcpy(pMCastAdr->maclist, adapter->multicastlist,
-	       adapter->nr_of_multicastmacaddr * ETH_ALEN);
+	    cpu_to_le16((u16) priv->nr_of_multicastmacaddr);
+	memcpy(pMCastAdr->maclist, priv->multicastlist,
+	       priv->nr_of_multicastmacaddr * ETH_ALEN);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -730,7 +723,6 @@ static int lbs_cmd_802_11_rf_channel(struct lbs_private *priv,
 static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *cmd)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
@@ -738,12 +730,12 @@ static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
 	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
 
 	/* reset Beacon SNR/NF/RSSI values */
-	adapter->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
-	adapter->SNR[TYPE_BEACON][TYPE_AVG] = 0;
-	adapter->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
-	adapter->NF[TYPE_BEACON][TYPE_AVG] = 0;
-	adapter->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
-	adapter->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->SNR[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->NF[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->NF[TYPE_BEACON][TYPE_AVG] = 0;
+	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] = 0;
+	priv->RSSI[TYPE_BEACON][TYPE_AVG] = 0;
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -828,7 +820,6 @@ static int lbs_cmd_802_11_mac_address(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd,
 				       u16 cmd_action)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->command = cpu_to_le16(CMD_802_11_MAC_ADDRESS);
@@ -840,8 +831,8 @@ static int lbs_cmd_802_11_mac_address(struct lbs_private *priv,
 
 	if (cmd_action == CMD_ACT_SET) {
 		memcpy(cmd->params.macadd.macadd,
-		       adapter->current_addr, ETH_ALEN);
-		lbs_deb_hex(LBS_DEB_CMD, "SET_CMD: MAC addr", adapter->current_addr, 6);
+		       priv->current_addr, ETH_ALEN);
+		lbs_deb_hex(LBS_DEB_CMD, "SET_CMD: MAC addr", priv->current_addr, 6);
 	}
 
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -958,7 +949,6 @@ static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
 {
 	struct cmd_ds_802_11_beacon_control
 		*bcn_ctrl = &cmd->params.bcn_ctrl;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->size =
@@ -967,8 +957,8 @@ static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
 	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
 
 	bcn_ctrl->action = cpu_to_le16(cmd_action);
-	bcn_ctrl->beacon_enable = cpu_to_le16(adapter->beacon_enable);
-	bcn_ctrl->beacon_period = cpu_to_le16(adapter->beacon_period);
+	bcn_ctrl->beacon_enable = cpu_to_le16(priv->beacon_enable);
+	bcn_ctrl->beacon_period = cpu_to_le16(priv->beacon_period);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -978,7 +968,7 @@ static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
  * Note: NEVER use lbs_queue_cmd() with addtail==0 other than for
  * the command timer, because it does not account for queued commands.
  */
-void lbs_queue_cmd(struct lbs_adapter *adapter,
+void lbs_queue_cmd(struct lbs_private *priv,
 	struct cmd_ctrl_node *cmdnode,
 	u8 addtail)
 {
@@ -1002,19 +992,19 @@ void lbs_queue_cmd(struct lbs_adapter *adapter,
 	if (le16_to_cpu(cmdptr->command) == CMD_802_11_PS_MODE) {
 		struct cmd_ds_802_11_ps_mode *psm = &cmdptr->params.psmode;
 		if (psm->action == cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
-			if (adapter->psstate != PS_STATE_FULL_POWER)
+			if (priv->psstate != PS_STATE_FULL_POWER)
 				addtail = 0;
 		}
 	}
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (addtail)
-		list_add_tail(&cmdnode->list, &adapter->cmdpendingq);
+		list_add_tail(&cmdnode->list, &priv->cmdpendingq);
 	else
-		list_add(&cmdnode->list, &adapter->cmdpendingq);
+		list_add(&cmdnode->list, &priv->cmdpendingq);
 
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	lbs_deb_host("QUEUE_CMD: inserted command 0x%04x into cmdpendingq\n",
 	       le16_to_cpu(((struct cmd_ds_gen*)cmdnode->bufvirtualaddr)->command));
@@ -1035,31 +1025,30 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 {
 	unsigned long flags;
 	struct cmd_ds_command *cmdptr;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = -1;
 	u16 cmdsize;
 	u16 command;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!adapter || !cmdnode) {
-		lbs_deb_host("DNLD_CMD: adapter or cmdmode is NULL\n");
+	if (!priv || !cmdnode) {
+		lbs_deb_host("DNLD_CMD: priv or cmdmode is NULL\n");
 		goto done;
 	}
 
 	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 	if (!cmdptr || !cmdptr->size) {
 		lbs_deb_host("DNLD_CMD: cmdptr is NULL or zero\n");
 		__lbs_cleanup_and_insert_cmd(priv, cmdnode);
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		goto done;
 	}
 
-	adapter->cur_cmd = cmdnode;
-	adapter->cur_cmd_retcode = 0;
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	priv->cur_cmd = cmdnode;
+	priv->cur_cmd_retcode = 0;
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	cmdsize = le16_to_cpu(cmdptr->size);
 	command = le16_to_cpu(cmdptr->command);
@@ -1074,11 +1063,11 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 
 	if (ret != 0) {
 		lbs_deb_host("DNLD_CMD: hw_host_to_card failed\n");
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		adapter->cur_cmd_retcode = ret;
-		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->cur_cmd = NULL;
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		priv->cur_cmd_retcode = ret;
+		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
+		priv->cur_cmd = NULL;
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		goto done;
 	}
 
@@ -1087,9 +1076,9 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 	/* Setup the timer after transmit command */
 	if (command == CMD_802_11_SCAN || command == CMD_802_11_AUTHENTICATE
 	    || command == CMD_802_11_ASSOCIATE)
-		mod_timer(&adapter->command_timer, jiffies + (10*HZ));
+		mod_timer(&priv->command_timer, jiffies + (10*HZ));
 	else
-		mod_timer(&adapter->command_timer, jiffies + (5*HZ));
+		mod_timer(&priv->command_timer, jiffies + (5*HZ));
 
 	ret = 0;
 
@@ -1107,7 +1096,7 @@ static int lbs_cmd_mac_control(struct lbs_private *priv,
 
 	cmd->command = cpu_to_le16(CMD_MAC_CONTROL);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_control) + S_DS_GEN);
-	mac->action = cpu_to_le16(priv->adapter->currentpacketfilter);
+	mac->action = cpu_to_le16(priv->currentpacketfilter);
 
 	lbs_deb_cmd("MAC_CONTROL: action 0x%x, size %d\n",
 		    le16_to_cpu(mac->action), le16_to_cpu(cmd->size));
@@ -1118,18 +1107,17 @@ static int lbs_cmd_mac_control(struct lbs_private *priv,
 
 /**
  *  This function inserts command node to cmdfreeq
- *  after cleans it. Requires adapter->driver_lock held.
+ *  after cleans it. Requires priv->driver_lock held.
  */
 void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 	struct cmd_ctrl_node *ptempcmd)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 
 	if (!ptempcmd)
 		return;
 
 	cleanup_cmdnode(ptempcmd);
-	list_add_tail(&ptempcmd->list, &adapter->cmdfreeq);
+	list_add_tail(&ptempcmd->list, &priv->cmdfreeq);
 }
 
 static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
@@ -1137,9 +1125,9 @@ static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 	__lbs_cleanup_and_insert_cmd(priv, ptempcmd);
-	spin_unlock_irqrestore(&priv->adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 
 int lbs_set_radio_control(struct lbs_private *priv)
@@ -1154,7 +1142,7 @@ int lbs_set_radio_control(struct lbs_private *priv)
 				    CMD_OPTION_WAITFORRSP, 0, NULL);
 
 	lbs_deb_cmd("RADIO_SET: radio %d, preamble %d\n",
-	       priv->adapter->radioon, priv->adapter->preamble);
+	       priv->radioon, priv->preamble);
 
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
@@ -1191,20 +1179,19 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 			  u16 wait_option, u32 cmd_oid, void *pdata_buf)
 {
 	int ret = 0;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode;
 	struct cmd_ds_command *cmdptr;
 	unsigned long flags;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!adapter) {
-		lbs_deb_host("PREP_CMD: adapter is NULL\n");
+	if (!priv) {
+		lbs_deb_host("PREP_CMD: priv is NULL\n");
 		ret = -1;
 		goto done;
 	}
 
-	if (adapter->surpriseremoved) {
+	if (priv->surpriseremoved) {
 		lbs_deb_host("PREP_CMD: card removed\n");
 		ret = -1;
 		goto done;
@@ -1235,8 +1222,8 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	}
 
 	/* Set sequence number, command and INT option */
-	adapter->seqnum++;
-	cmdptr->seqnum = cpu_to_le16(adapter->seqnum);
+	priv->seqnum++;
+	cmdptr->seqnum = cpu_to_le16(priv->seqnum);
 
 	cmdptr->command = cpu_to_le16(cmd_no);
 	cmdptr->result = 0;
@@ -1482,7 +1469,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 	cmdnode->cmdwaitqwoken = 0;
 
-	lbs_queue_cmd(adapter, cmdnode, 1);
+	lbs_queue_cmd(priv, cmdnode, 1);
 	wake_up_interruptible(&priv->waitq);
 
 	if (wait_option & CMD_OPTION_WAITFORRSP) {
@@ -1492,14 +1479,14 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 					 cmdnode->cmdwaitqwoken);
 	}
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
-	if (adapter->cur_cmd_retcode) {
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	if (priv->cur_cmd_retcode) {
 		lbs_deb_host("PREP_CMD: command failed with return code %d\n",
-		       adapter->cur_cmd_retcode);
-		adapter->cur_cmd_retcode = 0;
+		       priv->cur_cmd_retcode);
+		priv->cur_cmd_retcode = 0;
 		ret = -1;
 	}
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
@@ -1521,7 +1508,6 @@ int lbs_allocate_cmd_buffer(struct lbs_private *priv)
 	u32 i;
 	struct cmd_ctrl_node *tempcmd_array;
 	u8 *ptempvirtualaddr;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -1533,7 +1519,7 @@ int lbs_allocate_cmd_buffer(struct lbs_private *priv)
 		ret = -1;
 		goto done;
 	}
-	adapter->cmd_array = tempcmd_array;
+	priv->cmd_array = tempcmd_array;
 
 	/* Allocate and initialize command buffers */
 	ulbufsize = MRVDRV_SIZE_OF_CMD_BUFFER;
@@ -1571,17 +1557,16 @@ int lbs_free_cmd_buffer(struct lbs_private *priv)
 	u32 ulbufsize; /* Someone needs to die for this. Slowly and painfully */
 	unsigned int i;
 	struct cmd_ctrl_node *tempcmd_array;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
 	/* need to check if cmd array is allocated or not */
-	if (adapter->cmd_array == NULL) {
+	if (priv->cmd_array == NULL) {
 		lbs_deb_host("FREE_CMD_BUF: cmd_array is NULL\n");
 		goto done;
 	}
 
-	tempcmd_array = adapter->cmd_array;
+	tempcmd_array = priv->cmd_array;
 
 	/* Release shared memory buffers */
 	ulbufsize = MRVDRV_SIZE_OF_CMD_BUFFER;
@@ -1593,9 +1578,9 @@ int lbs_free_cmd_buffer(struct lbs_private *priv)
 	}
 
 	/* Release cmd_ctrl_node */
-	if (adapter->cmd_array) {
-		kfree(adapter->cmd_array);
-		adapter->cmd_array = NULL;
+	if (priv->cmd_array) {
+		kfree(priv->cmd_array);
+		priv->cmd_array = NULL;
 	}
 
 done:
@@ -1613,18 +1598,17 @@ done:
 struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 {
 	struct cmd_ctrl_node *tempnode;
-	struct lbs_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!adapter)
+	if (!priv)
 		return NULL;
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	if (!list_empty(&adapter->cmdfreeq)) {
-		tempnode = list_first_entry(&adapter->cmdfreeq,
+	if (!list_empty(&priv->cmdfreeq)) {
+		tempnode = list_first_entry(&priv->cmdfreeq,
 					    struct cmd_ctrl_node, list);
 		list_del(&tempnode->list);
 	} else {
@@ -1632,7 +1616,7 @@ struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 		tempnode = NULL;
 	}
 
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (tempnode)
 		cleanup_cmdnode(tempnode);
@@ -1700,7 +1684,6 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
  */
 int lbs_execute_next_command(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode = NULL;
 	struct cmd_ds_command *cmdptr;
 	unsigned long flags;
@@ -1711,40 +1694,40 @@ int lbs_execute_next_command(struct lbs_private *priv)
 	// data packet is received
 	lbs_deb_enter(LBS_DEB_THREAD);
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	if (adapter->cur_cmd) {
+	if (priv->cur_cmd) {
 		lbs_pr_alert( "EXEC_NEXT_CMD: already processing command!\n");
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		ret = -1;
 		goto done;
 	}
 
-	if (!list_empty(&adapter->cmdpendingq)) {
-		cmdnode = list_first_entry(&adapter->cmdpendingq,
+	if (!list_empty(&priv->cmdpendingq)) {
+		cmdnode = list_first_entry(&priv->cmdpendingq,
 					   struct cmd_ctrl_node, list);
 	}
 
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (cmdnode) {
 		cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
 
 		if (is_command_allowed_in_ps(cmdptr->command)) {
-			if ((adapter->psstate == PS_STATE_SLEEP) ||
-			    (adapter->psstate == PS_STATE_PRE_SLEEP)) {
+			if ((priv->psstate == PS_STATE_SLEEP) ||
+			    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 				lbs_deb_host(
 				       "EXEC_NEXT_CMD: cannot send cmd 0x%04x in psstate %d\n",
 				       le16_to_cpu(cmdptr->command),
-				       adapter->psstate);
+				       priv->psstate);
 				ret = -1;
 				goto done;
 			}
 			lbs_deb_host("EXEC_NEXT_CMD: OK to send command "
 			       "0x%04x in psstate %d\n",
 				    le16_to_cpu(cmdptr->command),
-				    adapter->psstate);
-		} else if (adapter->psstate != PS_STATE_FULL_POWER) {
+				    priv->psstate);
+		} else if (priv->psstate != PS_STATE_FULL_POWER) {
 			/*
 			 * 1. Non-PS command:
 			 * Queue it. set needtowakeup to TRUE if current state
@@ -1760,12 +1743,12 @@ int lbs_execute_next_command(struct lbs_private *priv)
 			    cpu_to_le16(CMD_802_11_PS_MODE)) {
 				/*  Prepare to send Exit PS,
 				 *  this non PS command will be sent later */
-				if ((adapter->psstate == PS_STATE_SLEEP)
-				    || (adapter->psstate == PS_STATE_PRE_SLEEP)
+				if ((priv->psstate == PS_STATE_SLEEP)
+				    || (priv->psstate == PS_STATE_PRE_SLEEP)
 				    ) {
 					/* w/ new scheme, it will not reach here.
 					   since it is blocked in main_thread. */
-					adapter->needtowakeup = 1;
+					priv->needtowakeup = 1;
 				} else
 					lbs_ps_wakeup(priv, 0);
 
@@ -1793,13 +1776,13 @@ int lbs_execute_next_command(struct lbs_private *priv)
 					goto done;
 				}
 
-				if ((adapter->psstate == PS_STATE_SLEEP) ||
-				    (adapter->psstate == PS_STATE_PRE_SLEEP)) {
+				if ((priv->psstate == PS_STATE_SLEEP) ||
+				    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
 					list_del(&cmdnode->list);
 					lbs_cleanup_and_insert_cmd(priv, cmdnode);
-					adapter->needtowakeup = 1;
+					priv->needtowakeup = 1;
 
 					ret = 0;
 					goto done;
@@ -1818,15 +1801,15 @@ int lbs_execute_next_command(struct lbs_private *priv)
 		 * check if in power save mode, if yes, put the device back
 		 * to PS mode
 		 */
-		if ((adapter->psmode != LBS802_11POWERMODECAM) &&
-		    (adapter->psstate == PS_STATE_FULL_POWER) &&
-		    ((adapter->connect_status == LBS_CONNECTED) ||
-		    (adapter->mesh_connect_status == LBS_CONNECTED))) {
-			if (adapter->secinfo.WPAenabled ||
-			    adapter->secinfo.WPA2enabled) {
+		if ((priv->psmode != LBS802_11POWERMODECAM) &&
+		    (priv->psstate == PS_STATE_FULL_POWER) &&
+		    ((priv->connect_status == LBS_CONNECTED) ||
+		    (priv->mesh_connect_status == LBS_CONNECTED))) {
+			if (priv->secinfo.WPAenabled ||
+			    priv->secinfo.WPA2enabled) {
 				/* check for valid WPA group keys */
-				if (adapter->wpa_mcast_key.len ||
-				    adapter->wpa_unicast_key.len) {
+				if (priv->wpa_mcast_key.len ||
+				    priv->wpa_unicast_key.len) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: WPA enabled and GTK_SET"
 					       " go back to PS_SLEEP");
@@ -1874,7 +1857,6 @@ void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
 static int sendconfirmsleep(struct lbs_private *priv, u8 *cmdptr, u16 size)
 {
 	unsigned long flags;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_HOST);
@@ -1887,24 +1869,24 @@ static int sendconfirmsleep(struct lbs_private *priv, u8 *cmdptr, u16 size)
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, cmdptr, size);
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
-	if (adapter->intcounter || adapter->currenttxskb)
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	if (priv->intcounter || priv->currenttxskb)
 		lbs_deb_host("SEND_SLEEPC_CMD: intcounter %d, currenttxskb %p\n",
-		       adapter->intcounter, adapter->currenttxskb);
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		       priv->intcounter, priv->currenttxskb);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (ret) {
 		lbs_pr_alert(
 		       "SEND_SLEEPC_CMD: Host to Card failed for Confirm Sleep\n");
 	} else {
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		if (!adapter->intcounter) {
-			adapter->psstate = PS_STATE_SLEEP;
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		if (!priv->intcounter) {
+			priv->psstate = PS_STATE_SLEEP;
 		} else {
 			lbs_deb_host("SEND_SLEEPC_CMD: after sent, intcounter %d\n",
-			       adapter->intcounter);
+			       priv->intcounter);
 		}
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		lbs_deb_host("SEND_SLEEPC_CMD: sent confirm sleep\n");
 	}
@@ -1961,7 +1943,6 @@ void lbs_ps_wakeup(struct lbs_private *priv, int wait_option)
 void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 {
 	unsigned long flags =0;
-	struct lbs_adapter *adapter = priv->adapter;
 	u8 allowed = 1;
 
 	lbs_deb_enter(LBS_DEB_HOST);
@@ -1971,20 +1952,20 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 		lbs_deb_host("dnld_sent was set");
 	}
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
-	if (adapter->cur_cmd) {
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	if (priv->cur_cmd) {
 		allowed = 0;
 		lbs_deb_host("cur_cmd was set");
 	}
-	if (adapter->intcounter > 0) {
+	if (priv->intcounter > 0) {
 		allowed = 0;
-		lbs_deb_host("intcounter %d", adapter->intcounter);
+		lbs_deb_host("intcounter %d", priv->intcounter);
 	}
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (allowed) {
 		lbs_deb_host("sending lbs_ps_confirm_sleep\n");
-		sendconfirmsleep(priv, (u8 *) & adapter->lbs_ps_confirm_sleep,
+		sendconfirmsleep(priv, (u8 *) & priv->lbs_ps_confirm_sleep,
 				 sizeof(struct PS_CMD_ConfirmSleep));
 	} else {
 		lbs_deb_host("sleep confirm has been delayed\n");
@@ -2014,7 +1995,6 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
 int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
 	    int (*callback)(uint16_t, struct cmd_ds_command *, struct lbs_private *))
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmdnode;
 	struct cmd_ds_gen *cmdptr;
 	unsigned long flags;
@@ -2022,13 +2002,13 @@ int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
-	if (!adapter) {
-		lbs_deb_host("PREP_CMD: adapter is NULL\n");
+	if (!priv) {
+		lbs_deb_host("PREP_CMD: priv is NULL\n");
 		ret = -1;
 		goto done;
 	}
 
-	if (adapter->surpriseremoved) {
+	if (priv->surpriseremoved) {
 		lbs_deb_host("PREP_CMD: card removed\n");
 		ret = -1;
 		goto done;
@@ -2050,10 +2030,10 @@ int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
 	cmdnode->callback = callback;
 
 	/* Set sequence number, clean result, move to buffer */
-	adapter->seqnum++;
+	priv->seqnum++;
 	cmdptr->command = cpu_to_le16(command);
 	cmdptr->size    = cpu_to_le16(cmd_size + S_DS_GEN);
-	cmdptr->seqnum = cpu_to_le16(adapter->seqnum);
+	cmdptr->seqnum = cpu_to_le16(priv->seqnum);
 	cmdptr->result = 0;
 	memcpy(cmdptr->cmdresp, cmd, cmd_size);
 
@@ -2063,20 +2043,20 @@ int lbs_cmd(struct lbs_private *priv, uint16_t command, void *cmd, int cmd_size,
 	 * because the caller of lbs_cmd() sets up all of *cmd for us. */
 
 	cmdnode->cmdwaitqwoken = 0;
-	lbs_queue_cmd(adapter, cmdnode, 1);
+	lbs_queue_cmd(priv, cmdnode, 1);
 	wake_up_interruptible(&priv->waitq);
 
 	might_sleep();
 	wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
-	if (adapter->cur_cmd_retcode) {
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	if (priv->cur_cmd_retcode) {
 		lbs_deb_host("PREP_CMD: command failed with return code %d\n",
-		       adapter->cur_cmd_retcode);
-		adapter->cur_cmd_retcode = 0;
+		       priv->cur_cmd_retcode);
+		priv->cur_cmd_retcode = 0;
 		ret = -1;
 	}
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 44865bf..ab6e729 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -25,10 +25,9 @@
  */
 void lbs_mac_event_disconnected(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	union iwreq_data wrqu;
 
-	if (adapter->connect_status != LBS_CONNECTED)
+	if (priv->connect_status != LBS_CONNECTED)
 		return;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -45,31 +44,31 @@ void lbs_mac_event_disconnected(struct lbs_private *priv)
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
 	/* Free Tx and Rx packets */
-	kfree_skb(priv->adapter->currenttxskb);
-	priv->adapter->currenttxskb = NULL;
+	kfree_skb(priv->currenttxskb);
+	priv->currenttxskb = NULL;
 
 	/* report disconnect to upper layer */
 	netif_stop_queue(priv->dev);
 	netif_carrier_off(priv->dev);
 
 	/* reset SNR/NF/RSSI values */
-	memset(adapter->SNR, 0x00, sizeof(adapter->SNR));
-	memset(adapter->NF, 0x00, sizeof(adapter->NF));
-	memset(adapter->RSSI, 0x00, sizeof(adapter->RSSI));
-	memset(adapter->rawSNR, 0x00, sizeof(adapter->rawSNR));
-	memset(adapter->rawNF, 0x00, sizeof(adapter->rawNF));
-	adapter->nextSNRNF = 0;
-	adapter->numSNRNF = 0;
-	adapter->connect_status = LBS_DISCONNECTED;
+	memset(priv->SNR, 0x00, sizeof(priv->SNR));
+	memset(priv->NF, 0x00, sizeof(priv->NF));
+	memset(priv->RSSI, 0x00, sizeof(priv->RSSI));
+	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
+	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
+	priv->nextSNRNF = 0;
+	priv->numSNRNF = 0;
+	priv->connect_status = LBS_DISCONNECTED;
 
 	/* Clear out associated SSID and BSSID since connection is
 	 * no longer valid.
 	 */
-	memset(&adapter->curbssparams.bssid, 0, ETH_ALEN);
-	memset(&adapter->curbssparams.ssid, 0, IW_ESSID_MAX_SIZE);
-	adapter->curbssparams.ssid_len = 0;
+	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
+	memset(&priv->curbssparams.ssid, 0, IW_ESSID_MAX_SIZE);
+	priv->curbssparams.ssid_len = 0;
 
-	if (adapter->psstate != PS_STATE_FULL_POWER) {
+	if (priv->psstate != PS_STATE_FULL_POWER) {
 		/* make firmware to exit PS mode */
 		lbs_deb_cmd("disconnected, so exit PS mode\n");
 		lbs_ps_wakeup(priv, 0);
@@ -107,7 +106,6 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 			       u16 type, struct cmd_ds_command *resp)
 {
 	int ret = 0;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -116,8 +114,8 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 		{
 			struct cmd_ds_mac_reg_access *reg = &resp->params.macreg;
 
-			adapter->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
-			adapter->offsetvalue.value = le32_to_cpu(reg->value);
+			priv->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
+			priv->offsetvalue.value = le32_to_cpu(reg->value);
 			break;
 		}
 
@@ -125,8 +123,8 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 		{
 			struct cmd_ds_bbp_reg_access *reg = &resp->params.bbpreg;
 
-			adapter->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
-			adapter->offsetvalue.value = reg->value;
+			priv->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
+			priv->offsetvalue.value = reg->value;
 			break;
 		}
 
@@ -134,8 +132,8 @@ static int lbs_ret_reg_access(struct lbs_private *priv,
 		{
 			struct cmd_ds_rf_reg_access *reg = &resp->params.rfreg;
 
-			adapter->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
-			adapter->offsetvalue.value = reg->value;
+			priv->offsetvalue.offset = (u32)le16_to_cpu(reg->offset);
+			priv->offsetvalue.value = reg->value;
 			break;
 		}
 
@@ -152,19 +150,18 @@ static int lbs_ret_get_hw_spec(struct lbs_private *priv,
 {
 	u32 i;
 	struct cmd_ds_get_hw_spec *hwspec = &resp->params.hwspec;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	DECLARE_MAC_BUF(mac);
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	adapter->fwcapinfo = le32_to_cpu(hwspec->fwcapinfo);
+	priv->fwcapinfo = le32_to_cpu(hwspec->fwcapinfo);
 
-	memcpy(adapter->fwreleasenumber, hwspec->fwreleasenumber, 4);
+	memcpy(priv->fwreleasenumber, hwspec->fwreleasenumber, 4);
 
 	lbs_deb_cmd("GET_HW_SPEC: firmware release %u.%u.%up%u\n",
-		    adapter->fwreleasenumber[2], adapter->fwreleasenumber[1],
-		    adapter->fwreleasenumber[0], adapter->fwreleasenumber[3]);
+		    priv->fwreleasenumber[2], priv->fwreleasenumber[1],
+		    priv->fwreleasenumber[0], priv->fwreleasenumber[3]);
 	lbs_deb_cmd("GET_HW_SPEC: MAC addr %s\n",
 		    print_mac(mac, hwspec->permanentaddr));
 	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%04x\n",
@@ -174,29 +171,29 @@ static int lbs_ret_get_hw_spec(struct lbs_private *priv,
 	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
 	 * returns non-zero high 8 bits here.
 	 */
-	adapter->regioncode = le16_to_cpu(hwspec->regioncode) & 0xFF;
+	priv->regioncode = le16_to_cpu(hwspec->regioncode) & 0xFF;
 
 	for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
 		/* use the region code to search for the index */
-		if (adapter->regioncode == lbs_region_code_to_index[i]) {
+		if (priv->regioncode == lbs_region_code_to_index[i]) {
 			break;
 		}
 	}
 
 	/* if it's unidentified region code, use the default (USA) */
 	if (i >= MRVDRV_MAX_REGION_CODE) {
-		adapter->regioncode = 0x10;
+		priv->regioncode = 0x10;
 		lbs_pr_info("unidentified region code; using the default (USA)\n");
 	}
 
-	if (adapter->current_addr[0] == 0xff)
-		memmove(adapter->current_addr, hwspec->permanentaddr, ETH_ALEN);
+	if (priv->current_addr[0] == 0xff)
+		memmove(priv->current_addr, hwspec->permanentaddr, ETH_ALEN);
 
-	memcpy(priv->dev->dev_addr, adapter->current_addr, ETH_ALEN);
+	memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
 	if (priv->mesh_dev)
-		memcpy(priv->mesh_dev->dev_addr, adapter->current_addr, ETH_ALEN);
+		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
-	if (lbs_set_regiontable(priv, adapter->regioncode, 0)) {
+	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
 		ret = -1;
 		goto done;
 	}
@@ -215,7 +212,6 @@ static int lbs_ret_802_11_sleep_params(struct lbs_private *priv,
 					struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_sleep_params *sp = &resp->params.sleep_params;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -224,12 +220,12 @@ static int lbs_ret_802_11_sleep_params(struct lbs_private *priv,
 		    le16_to_cpu(sp->offset), le16_to_cpu(sp->stabletime),
 		    sp->calcontrol, sp->externalsleepclk);
 
-	adapter->sp.sp_error = le16_to_cpu(sp->error);
-	adapter->sp.sp_offset = le16_to_cpu(sp->offset);
-	adapter->sp.sp_stabletime = le16_to_cpu(sp->stabletime);
-	adapter->sp.sp_calcontrol = sp->calcontrol;
-	adapter->sp.sp_extsleepclk = sp->externalsleepclk;
-	adapter->sp.sp_reserved = le16_to_cpu(sp->reserved);
+	priv->sp.sp_error = le16_to_cpu(sp->error);
+	priv->sp.sp_offset = le16_to_cpu(sp->offset);
+	priv->sp.sp_stabletime = le16_to_cpu(sp->stabletime);
+	priv->sp.sp_calcontrol = sp->calcontrol;
+	priv->sp.sp_extsleepclk = sp->externalsleepclk;
+	priv->sp.sp_reserved = le16_to_cpu(sp->reserved);
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	return 0;
@@ -239,13 +235,12 @@ static int lbs_ret_802_11_stat(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
 	lbs_deb_enter(LBS_DEB_CMD);
-/*	currently adapter->wlan802_11Stat is unused
+/*	currently priv->wlan802_11Stat is unused
 
 	struct cmd_ds_802_11_get_stat *p11Stat = &resp->params.gstat;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	// TODO Convert it to Big endian befor copy
-	memcpy(&adapter->wlan802_11Stat,
+	memcpy(&priv->wlan802_11Stat,
 	       p11Stat, sizeof(struct cmd_ds_802_11_get_stat));
 */
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -268,22 +263,22 @@ static int lbs_ret_802_11_snmp_mib(struct lbs_private *priv,
 	if (querytype == CMD_ACT_GET) {
 		switch (oid) {
 		case FRAGTHRESH_I:
-			priv->adapter->fragthsd =
+			priv->fragthsd =
 				le16_to_cpu(*((__le16 *)(smib->value)));
 			lbs_deb_cmd("SNMP_RESP: frag threshold %u\n",
-				    priv->adapter->fragthsd);
+				    priv->fragthsd);
 			break;
 		case RTSTHRESH_I:
-			priv->adapter->rtsthsd =
+			priv->rtsthsd =
 				le16_to_cpu(*((__le16 *)(smib->value)));
 			lbs_deb_cmd("SNMP_RESP: rts threshold %u\n",
-				    priv->adapter->rtsthsd);
+				    priv->rtsthsd);
 			break;
 		case SHORT_RETRYLIM_I:
-			priv->adapter->txretrycount =
+			priv->txretrycount =
 				le16_to_cpu(*((__le16 *)(smib->value)));
 			lbs_deb_cmd("SNMP_RESP: tx retry count %u\n",
-				    priv->adapter->rtsthsd);
+				    priv->rtsthsd);
 			break;
 		default:
 			break;
@@ -299,7 +294,6 @@ static int lbs_ret_802_11_key_material(struct lbs_private *priv,
 {
 	struct cmd_ds_802_11_key_material *pkeymaterial =
 	    &resp->params.keymaterial;
-	struct lbs_adapter *adapter = priv->adapter;
 	u16 action = le16_to_cpu(pkeymaterial->action);
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -327,9 +321,9 @@ static int lbs_ret_802_11_key_material(struct lbs_private *priv,
 				break;
 
 			if (key_flags & KEY_INFO_WPA_UNICAST)
-				pkey = &adapter->wpa_unicast_key;
+				pkey = &priv->wpa_unicast_key;
 			else if (key_flags & KEY_INFO_WPA_MCAST)
-				pkey = &adapter->wpa_mcast_key;
+				pkey = &priv->wpa_mcast_key;
 			else
 				break;
 
@@ -354,11 +348,10 @@ static int lbs_ret_802_11_mac_address(struct lbs_private *priv,
 				       struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_mac_address *macadd = &resp->params.macadd;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	memcpy(adapter->current_addr, macadd->macadd, ETH_ALEN);
+	memcpy(priv->current_addr, macadd->macadd, ETH_ALEN);
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	return 0;
@@ -368,13 +361,12 @@ static int lbs_ret_802_11_rf_tx_power(struct lbs_private *priv,
 				       struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rf_tx_power *rtp = &resp->params.txp;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	adapter->txpowerlevel = le16_to_cpu(rtp->currentlevel);
+	priv->txpowerlevel = le16_to_cpu(rtp->currentlevel);
 
-	lbs_deb_cmd("TX power currently %d\n", adapter->txpowerlevel);
+	lbs_deb_cmd("TX power currently %d\n", priv->txpowerlevel);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -384,13 +376,12 @@ static int lbs_ret_802_11_rate_adapt_rateset(struct lbs_private *priv,
 					      struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rate_adapt_rateset *rates = &resp->params.rateset;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	if (rates->action == CMD_ACT_GET) {
-		adapter->enablehwauto = le16_to_cpu(rates->enablehwauto);
-		adapter->ratebitmap = le16_to_cpu(rates->bitmap);
+		priv->enablehwauto = le16_to_cpu(rates->enablehwauto);
+		priv->ratebitmap = le16_to_cpu(rates->bitmap);
 	}
 
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -401,7 +392,6 @@ static int lbs_ret_802_11_data_rate(struct lbs_private *priv,
 				     struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_data_rate *pdatarate = &resp->params.drate;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -411,8 +401,8 @@ static int lbs_ret_802_11_data_rate(struct lbs_private *priv,
 	/* FIXME: get actual rates FW can do if this command actually returns
 	 * all data rates supported.
 	 */
-	adapter->cur_rate = lbs_fw_index_to_data_rate(pdatarate->rates[0]);
-	lbs_deb_cmd("DATA_RATE: current rate 0x%02x\n", adapter->cur_rate);
+	priv->cur_rate = lbs_fw_index_to_data_rate(pdatarate->rates[0]);
+	lbs_deb_cmd("DATA_RATE: current rate 0x%02x\n", priv->cur_rate);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -422,19 +412,18 @@ static int lbs_ret_802_11_rf_channel(struct lbs_private *priv,
 				      struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rf_channel *rfchannel = &resp->params.rfchannel;
-	struct lbs_adapter *adapter = priv->adapter;
 	u16 action = le16_to_cpu(rfchannel->action);
 	u16 newchannel = le16_to_cpu(rfchannel->currentchannel);
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	if (action == CMD_OPT_802_11_RF_CHANNEL_GET
-	    && adapter->curbssparams.channel != newchannel) {
+	    && priv->curbssparams.channel != newchannel) {
 		lbs_deb_cmd("channel switch from %d to %d\n",
-		       adapter->curbssparams.channel, newchannel);
+		       priv->curbssparams.channel, newchannel);
 
 		/* Update the channel again */
-		adapter->curbssparams.channel = newchannel;
+		priv->curbssparams.channel = newchannel;
 	}
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -445,28 +434,27 @@ static int lbs_ret_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	/* store the non average value */
-	adapter->SNR[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->SNR);
-	adapter->NF[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->noisefloor);
+	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->SNR);
+	priv->NF[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->noisefloor);
 
-	adapter->SNR[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgSNR);
-	adapter->NF[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgnoisefloor);
+	priv->SNR[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgSNR);
+	priv->NF[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgnoisefloor);
 
-	adapter->RSSI[TYPE_BEACON][TYPE_NOAVG] =
-	    CAL_RSSI(adapter->SNR[TYPE_BEACON][TYPE_NOAVG],
-		     adapter->NF[TYPE_BEACON][TYPE_NOAVG]);
+	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] =
+	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
+		     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
 
-	adapter->RSSI[TYPE_BEACON][TYPE_AVG] =
-	    CAL_RSSI(adapter->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
-		     adapter->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
+	priv->RSSI[TYPE_BEACON][TYPE_AVG] =
+	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_AVG] / AVG_SCALE,
+		     priv->NF[TYPE_BEACON][TYPE_AVG] / AVG_SCALE);
 
 	lbs_deb_cmd("RSSI: beacon %d, avg %d\n",
-	       adapter->RSSI[TYPE_BEACON][TYPE_NOAVG],
-	       adapter->RSSI[TYPE_BEACON][TYPE_AVG]);
+	       priv->RSSI[TYPE_BEACON][TYPE_NOAVG],
+	       priv->RSSI[TYPE_BEACON][TYPE_AVG]);
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -475,9 +463,8 @@ static int lbs_ret_802_11_rssi(struct lbs_private *priv,
 static int lbs_ret_802_11_eeprom_access(struct lbs_private *priv,
 				  struct cmd_ds_command *resp)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_ioctl_regrdwr *pbuf;
-	pbuf = (struct lbs_ioctl_regrdwr *) adapter->prdeeprom;
+	pbuf = (struct lbs_ioctl_regrdwr *) priv->prdeeprom;
 
 	lbs_deb_enter_args(LBS_DEB_CMD, "len %d",
 	       le16_to_cpu(resp->params.rdeeprom.bytecount));
@@ -502,12 +489,11 @@ static int lbs_ret_get_log(struct lbs_private *priv,
 			    struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_get_log *logmessage = &resp->params.glog;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	/* Stored little-endian */
-	memcpy(&adapter->logmsg, logmessage, sizeof(struct cmd_ds_802_11_get_log));
+	memcpy(&priv->logmsg, logmessage, sizeof(struct cmd_ds_802_11_get_log));
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
@@ -517,8 +503,7 @@ static int lbs_ret_802_11_enable_rsn(struct lbs_private *priv,
                                           struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_enable_rsn *enable_rsn = &resp->params.enbrsn;
-	struct lbs_adapter *adapter = priv->adapter;
-	u32 * pdata_buf = adapter->cur_cmd->pdata_buf;
+	u32 * pdata_buf = priv->cur_cmd->pdata_buf;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -536,13 +521,12 @@ static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
 {
 	struct cmd_ds_802_11_beacon_control *bcn_ctrl =
 	    &resp->params.bcn_ctrl;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	if (bcn_ctrl->action == CMD_ACT_GET) {
-		adapter->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
-		adapter->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
+		priv->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
+		priv->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
 	}
 
 	lbs_deb_enter(LBS_DEB_CMD);
@@ -552,11 +536,10 @@ static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
 static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
 	struct cmd_ds_command *resp)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_subscribe_event *cmd_event =
 		&resp->params.subscribe_event;
 	struct cmd_ds_802_11_subscribe_event *dst_event =
-		adapter->cur_cmd->pdata_buf;
+		priv->cur_cmd->pdata_buf;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -575,7 +558,6 @@ static inline int handle_cmd_response(u16 respcmd,
 {
 	int ret = 0;
 	unsigned long flags;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
@@ -628,10 +610,10 @@ static inline int handle_cmd_response(u16 respcmd,
 
 	case CMD_RET(CMD_802_11_SET_AFC):
 	case CMD_RET(CMD_802_11_GET_AFC):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		memmove(adapter->cur_cmd->pdata_buf, &resp->params.afc,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		memmove(priv->cur_cmd->pdata_buf, &resp->params.afc,
 			sizeof(struct cmd_ds_802_11_afc));
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		break;
 
@@ -686,59 +668,59 @@ static inline int handle_cmd_response(u16 respcmd,
 		ret = lbs_ret_802_11_sleep_params(priv, resp);
 		break;
 	case CMD_RET(CMD_802_11_INACTIVITY_TIMEOUT):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		*((u16 *) adapter->cur_cmd->pdata_buf) =
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		*((u16 *) priv->cur_cmd->pdata_buf) =
 		    le16_to_cpu(resp->params.inactivity_timeout.timeout);
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 
 	case CMD_RET(CMD_802_11_TPC_CFG):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		memmove(adapter->cur_cmd->pdata_buf, &resp->params.tpccfg,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		memmove(priv->cur_cmd->pdata_buf, &resp->params.tpccfg,
 			sizeof(struct cmd_ds_802_11_tpc_cfg));
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_802_11_LED_GPIO_CTRL):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		memmove(adapter->cur_cmd->pdata_buf, &resp->params.ledgpio,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		memmove(priv->cur_cmd->pdata_buf, &resp->params.ledgpio,
 			sizeof(struct cmd_ds_802_11_led_ctrl));
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_802_11_SUBSCRIBE_EVENT):
 		ret = lbs_ret_802_11_subscribe_event(priv, resp);
 		break;
 
 	case CMD_RET(CMD_802_11_PWR_CFG):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		memmove(adapter->cur_cmd->pdata_buf, &resp->params.pwrcfg,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		memmove(priv->cur_cmd->pdata_buf, &resp->params.pwrcfg,
 			sizeof(struct cmd_ds_802_11_pwr_cfg));
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		break;
 
 	case CMD_RET(CMD_GET_TSF):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		memcpy(priv->adapter->cur_cmd->pdata_buf,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		memcpy(priv->cur_cmd->pdata_buf,
 		       &resp->params.gettsf.tsfvalue, sizeof(u64));
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_BT_ACCESS):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		if (adapter->cur_cmd->pdata_buf)
-			memcpy(adapter->cur_cmd->pdata_buf,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		if (priv->cur_cmd->pdata_buf)
+			memcpy(priv->cur_cmd->pdata_buf,
 			       &resp->params.bt.addr1, 2 * ETH_ALEN);
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_FWT_ACCESS):
-		spin_lock_irqsave(&adapter->driver_lock, flags);
-		if (adapter->cur_cmd->pdata_buf)
-			memcpy(adapter->cur_cmd->pdata_buf, &resp->params.fwt,
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		if (priv->cur_cmd->pdata_buf)
+			memcpy(priv->cur_cmd->pdata_buf, &resp->params.fwt,
 			       sizeof(resp->params.fwt));
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_MESH_ACCESS):
-		if (adapter->cur_cmd->pdata_buf)
-			memcpy(adapter->cur_cmd->pdata_buf, &resp->params.mesh,
+		if (priv->cur_cmd->pdata_buf)
+			memcpy(priv->cur_cmd->pdata_buf, &resp->params.mesh,
 			       sizeof(resp->params.mesh));
 		break;
 	case CMD_RET(CMD_802_11_BEACON_CTRL):
@@ -758,7 +740,6 @@ int lbs_process_rx_command(struct lbs_private *priv)
 {
 	u16 respcmd;
 	struct cmd_ds_command *resp;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	ulong flags;
 	u16 result;
@@ -766,39 +747,39 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	lbs_deb_enter(LBS_DEB_HOST);
 
 	/* Now we got response from FW, cancel the command timer */
-	del_timer(&adapter->command_timer);
+	del_timer(&priv->command_timer);
 
-	mutex_lock(&adapter->lock);
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	mutex_lock(&priv->lock);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	if (!adapter->cur_cmd) {
+	if (!priv->cur_cmd) {
 		lbs_deb_host("CMD_RESP: cur_cmd is NULL\n");
 		ret = -1;
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		goto done;
 	}
-	resp = (struct cmd_ds_command *)(adapter->cur_cmd->bufvirtualaddr);
+	resp = (struct cmd_ds_command *)(priv->cur_cmd->bufvirtualaddr);
 
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
 	lbs_deb_host("CMD_RESP: response 0x%04x, size %d, jiffies %lu\n",
 		respcmd, priv->upld_len, jiffies);
-	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", adapter->cur_cmd->bufvirtualaddr,
+	lbs_deb_hex(LBS_DEB_HOST, "CMD_RESP", priv->cur_cmd->bufvirtualaddr,
 		    priv->upld_len);
 
 	if (!(respcmd & 0x8000)) {
 		lbs_deb_host("invalid response!\n");
-		adapter->cur_cmd_retcode = -1;
-		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->cur_cmd = NULL;
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		priv->cur_cmd_retcode = -1;
+		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
+		priv->cur_cmd = NULL;
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		ret = -1;
 		goto done;
 	}
 
 	/* Store the response code to cur_cmd_retcode. */
-	adapter->cur_cmd_retcode = result;
+	priv->cur_cmd_retcode = result;
 
 	if (respcmd == CMD_RET(CMD_802_11_PS_MODE)) {
 		struct cmd_ds_802_11_ps_mode *psmode = &resp->params.psmode;
@@ -816,15 +797,15 @@ int lbs_process_rx_command(struct lbs_private *priv)
 			 * ad-hoc mode. It takes place in
 			 * lbs_execute_next_command().
 			 */
-			if (adapter->mode == IW_MODE_ADHOC &&
+			if (priv->mode == IW_MODE_ADHOC &&
 			    action == CMD_SUBCMD_ENTER_PS)
-				adapter->psmode = LBS802_11POWERMODECAM;
+				priv->psmode = LBS802_11POWERMODECAM;
 		} else if (action == CMD_SUBCMD_ENTER_PS) {
-			adapter->needtowakeup = 0;
-			adapter->psstate = PS_STATE_AWAKE;
+			priv->needtowakeup = 0;
+			priv->psstate = PS_STATE_AWAKE;
 
 			lbs_deb_host("CMD_RESP: ENTER_PS command response\n");
-			if (adapter->connect_status != LBS_CONNECTED) {
+			if (priv->connect_status != LBS_CONNECTED) {
 				/*
 				 * When Deauth Event received before Enter_PS command
 				 * response, We need to wake up the firmware.
@@ -832,23 +813,23 @@ int lbs_process_rx_command(struct lbs_private *priv)
 				lbs_deb_host(
 				       "disconnected, invoking lbs_ps_wakeup\n");
 
-				spin_unlock_irqrestore(&adapter->driver_lock, flags);
-				mutex_unlock(&adapter->lock);
+				spin_unlock_irqrestore(&priv->driver_lock, flags);
+				mutex_unlock(&priv->lock);
 				lbs_ps_wakeup(priv, 0);
-				mutex_lock(&adapter->lock);
-				spin_lock_irqsave(&adapter->driver_lock, flags);
+				mutex_lock(&priv->lock);
+				spin_lock_irqsave(&priv->driver_lock, flags);
 			}
 		} else if (action == CMD_SUBCMD_EXIT_PS) {
-			adapter->needtowakeup = 0;
-			adapter->psstate = PS_STATE_FULL_POWER;
+			priv->needtowakeup = 0;
+			priv->psstate = PS_STATE_FULL_POWER;
 			lbs_deb_host("CMD_RESP: EXIT_PS command response\n");
 		} else {
 			lbs_deb_host("CMD_RESP: PS action 0x%X\n", action);
 		}
 
-		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->cur_cmd = NULL;
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
+		priv->cur_cmd = NULL;
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		ret = 0;
 		goto done;
@@ -869,32 +850,32 @@ int lbs_process_rx_command(struct lbs_private *priv)
 
 		}
 
-		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->cur_cmd = NULL;
-		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
+		priv->cur_cmd = NULL;
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 		ret = -1;
 		goto done;
 	}
 
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
-	if (adapter->cur_cmd && adapter->cur_cmd->callback)
-		ret = adapter->cur_cmd->callback(respcmd, resp, priv);
+	if (priv->cur_cmd && priv->cur_cmd->callback)
+		ret = priv->cur_cmd->callback(respcmd, resp, priv);
 	else
 		ret = handle_cmd_response(respcmd, resp, priv);
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	if (adapter->cur_cmd) {
+	if (priv->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
-		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->cur_cmd = NULL;
+		__lbs_cleanup_and_insert_cmd(priv, priv->cur_cmd);
+		priv->cur_cmd = NULL;
 	}
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 done:
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
 	return ret;
 }
@@ -902,14 +883,13 @@ done:
 int lbs_process_event(struct lbs_private *priv)
 {
 	int ret = 0;
-	struct lbs_adapter *adapter = priv->adapter;
 	u32 eventcause;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	spin_lock_irq(&adapter->driver_lock);
-	eventcause = adapter->eventcause >> SBI_EVENT_CAUSE_SHIFT;
-	spin_unlock_irq(&adapter->driver_lock);
+	spin_lock_irq(&priv->driver_lock);
+	eventcause = priv->eventcause >> SBI_EVENT_CAUSE_SHIFT;
+	spin_unlock_irq(&priv->driver_lock);
 
 	lbs_deb_cmd("event cause %d\n", eventcause);
 
@@ -937,14 +917,14 @@ int lbs_process_event(struct lbs_private *priv)
 		lbs_deb_cmd("EVENT: sleep\n");
 
 		/* handle unexpected PS SLEEP event */
-		if (adapter->psstate == PS_STATE_FULL_POWER) {
+		if (priv->psstate == PS_STATE_FULL_POWER) {
 			lbs_deb_cmd(
 			       "EVENT: in FULL POWER mode, ignoreing PS_SLEEP\n");
 			break;
 		}
-		adapter->psstate = PS_STATE_PRE_SLEEP;
+		priv->psstate = PS_STATE_PRE_SLEEP;
 
-		lbs_ps_confirm_sleep(priv, (u16) adapter->psmode);
+		lbs_ps_confirm_sleep(priv, (u16) priv->psmode);
 
 		break;
 
@@ -952,19 +932,19 @@ int lbs_process_event(struct lbs_private *priv)
 		lbs_deb_cmd("EVENT: awake\n");
 
 		/* handle unexpected PS AWAKE event */
-		if (adapter->psstate == PS_STATE_FULL_POWER) {
+		if (priv->psstate == PS_STATE_FULL_POWER) {
 			lbs_deb_cmd(
 			       "EVENT: In FULL POWER mode - ignore PS AWAKE\n");
 			break;
 		}
 
-		adapter->psstate = PS_STATE_AWAKE;
+		priv->psstate = PS_STATE_AWAKE;
 
-		if (adapter->needtowakeup) {
+		if (priv->needtowakeup) {
 			/*
 			 * wait for the command processing to finish
 			 * before resuming sending
-			 * adapter->needtowakeup will be set to FALSE
+			 * priv->needtowakeup will be set to FALSE
 			 * in lbs_ps_wakeup()
 			 */
 			lbs_deb_cmd("waking up ...\n");
@@ -1012,12 +992,12 @@ int lbs_process_event(struct lbs_private *priv)
 			break;
 		}
 		lbs_pr_info("EVENT: MESH_AUTO_STARTED\n");
-		adapter->mesh_connect_status = LBS_CONNECTED;
+		priv->mesh_connect_status = LBS_CONNECTED;
 		if (priv->mesh_open == 1) {
 			netif_wake_queue(priv->mesh_dev);
 			netif_carrier_on(priv->mesh_dev);
 		}
-		adapter->mode = IW_MODE_ADHOC;
+		priv->mode = IW_MODE_ADHOC;
 		schedule_work(&priv->sync_channel);
 		break;
 
@@ -1026,9 +1006,9 @@ int lbs_process_event(struct lbs_private *priv)
 		break;
 	}
 
-	spin_lock_irq(&adapter->driver_lock);
-	adapter->eventcause = 0;
-	spin_unlock_irq(&adapter->driver_lock);
+	spin_lock_irq(&priv->driver_lock);
+	priv->eventcause = 0;
+	spin_unlock_irq(&priv->driver_lock);
 
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 341ef67..9917a18 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -45,9 +45,9 @@ static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 	ssize_t res;
 
 	pos += snprintf(buf+pos, len-pos, "state = %s\n",
-				szStates[priv->adapter->connect_status]);
+				szStates[priv->connect_status]);
 	pos += snprintf(buf+pos, len-pos, "region_code = %02x\n",
-				(u32) priv->adapter->regioncode);
+				(u32) priv->regioncode);
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
@@ -70,8 +70,8 @@ static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 	pos += snprintf(buf+pos, len-pos,
 		"# | ch  | rssi |       bssid       |   cap    | Qual | SSID \n");
 
-	mutex_lock(&priv->adapter->lock);
-	list_for_each_entry (iter_bss, &priv->adapter->network_list, list) {
+	mutex_lock(&priv->lock);
+	list_for_each_entry (iter_bss, &priv->network_list, list) {
 		u16 ibss = (iter_bss->capability & WLAN_CAPABILITY_IBSS);
 		u16 privacy = (iter_bss->capability & WLAN_CAPABILITY_PRIVACY);
 		u16 spectrum_mgmt = (iter_bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT);
@@ -90,7 +90,7 @@ static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 
 		numscansdone++;
 	}
-	mutex_unlock(&priv->adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
@@ -118,12 +118,12 @@ static ssize_t lbs_sleepparams_write(struct file *file,
 		res = -EFAULT;
 		goto out_unlock;
 	}
-	priv->adapter->sp.sp_error = p1;
-	priv->adapter->sp.sp_offset = p2;
-	priv->adapter->sp.sp_stabletime = p3;
-	priv->adapter->sp.sp_calcontrol = p4;
-	priv->adapter->sp.sp_extsleepclk = p5;
-	priv->adapter->sp.sp_reserved = p6;
+	priv->sp.sp_error = p1;
+	priv->sp.sp_offset = p2;
+	priv->sp.sp_stabletime = p3;
+	priv->sp.sp_calcontrol = p4;
+	priv->sp.sp_extsleepclk = p5;
+	priv->sp.sp_reserved = p6;
 
 	res = lbs_prepare_and_send_command(priv,
 				CMD_802_11_SLEEP_PARAMS,
@@ -144,7 +144,6 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
 	ssize_t res;
 	size_t pos = 0;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
@@ -159,10 +158,10 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 		goto out_unlock;
 	}
 
-	pos += snprintf(buf, len, "%d %d %d %d %d %d\n", adapter->sp.sp_error,
-			adapter->sp.sp_offset, adapter->sp.sp_stabletime,
-			adapter->sp.sp_calcontrol, adapter->sp.sp_extsleepclk,
-			adapter->sp.sp_reserved);
+	pos += snprintf(buf, len, "%d %d %d %d %d %d\n", priv->sp.sp_error,
+			priv->sp.sp_offset, priv->sp.sp_stabletime,
+			priv->sp.sp_calcontrol, priv->sp.sp_extsleepclk,
+			priv->sp.sp_reserved);
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
@@ -320,11 +319,11 @@ static ssize_t lbs_setuserscan(struct file *file,
 	lbs_parse_type(buf, count, scan_cfg);
 
 	lbs_scan_networks(priv, scan_cfg, 1);
-	wait_event_interruptible(priv->adapter->cmd_pending,
-				 priv->adapter->surpriseremoved || 
-				 (!priv->adapter->cur_cmd && list_empty(&priv->adapter->cmdpendingq)));
+	wait_event_interruptible(priv->cmd_pending,
+				 priv->surpriseremoved || 
+				 (!priv->cur_cmd && list_empty(&priv->cmdpendingq)));
 
-	if (priv->adapter->surpriseremoved)
+	if (priv->surpriseremoved)
 		goto out_scan_cfg;
 
 	memset(&wrqu, 0x00, sizeof(union iwreq_data));
@@ -619,7 +618,6 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
@@ -634,7 +632,7 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
 	pos += snprintf(buf+pos, len-pos, "MAC[0x%x] = 0x%08x\n",
-				priv->mac_offset, adapter->offsetvalue.value);
+				priv->mac_offset, priv->offsetvalue.value);
 
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	free_page(addr);
@@ -702,7 +700,6 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
@@ -717,7 +714,7 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
 	pos += snprintf(buf+pos, len-pos, "BBP[0x%x] = 0x%08x\n",
-				priv->bbp_offset, adapter->offsetvalue.value);
+				priv->bbp_offset, priv->offsetvalue.value);
 
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	free_page(addr);
@@ -786,7 +783,6 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
 	struct lbs_private *priv = file->private_data;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_offset_value offval;
 	ssize_t pos = 0;
 	int ret;
@@ -801,7 +797,7 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
 	pos += snprintf(buf+pos, len-pos, "RF[0x%x] = 0x%08x\n",
-				priv->rf_offset, adapter->offsetvalue.value);
+				priv->rf_offset, priv->offsetvalue.value);
 
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	free_page(addr);
@@ -1008,8 +1004,8 @@ void lbs_debugfs_remove_one(struct lbs_private *priv)
 
 #ifdef PROC_DEBUG
 
-#define item_size(n)	(FIELD_SIZEOF(struct lbs_adapter, n))
-#define item_addr(n)	(offsetof(struct lbs_adapter, n))
+#define item_size(n)	(FIELD_SIZEOF(struct lbs_private, n))
+#define item_addr(n)	(offsetof(struct lbs_private, n))
 
 
 struct debug_data {
@@ -1018,7 +1014,7 @@ struct debug_data {
 	size_t addr;
 };
 
-/* To debug any member of struct lbs_adapter, simply add one line here.
+/* To debug any member of struct lbs_private, simply add one line here.
  */
 static struct debug_data items[] = {
 	{"intcounter", item_size(intcounter), item_addr(intcounter)},
@@ -1157,7 +1153,7 @@ static void lbs_debug_init(struct lbs_private *priv, struct net_device *dev)
 		return;
 
 	for (i = 0; i < num_of_items; i++)
-		items[i].addr += (size_t) priv->adapter;
+		items[i].addr += (size_t) priv;
 
 	priv->debugfs_debug = debugfs_create_file("debug", 0644,
 						  priv->debugfs_dir, &items[0],
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 1a8fdaa..e255b19 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -12,7 +12,6 @@
 
 /** Function Prototype Declaration */
 struct lbs_private;
-struct lbs_adapter;
 struct sk_buff;
 struct net_device;
 struct cmd_ctrl_node;
@@ -32,7 +31,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_action,
 	u16 wait_option, u32 cmd_oid, void *pdata_buf);
 
-void lbs_queue_cmd(struct lbs_adapter *adapter,
+void lbs_queue_cmd(struct lbs_private *priv,
 	struct cmd_ctrl_node *cmdnode,
 	u8 addtail);
 
@@ -43,7 +42,7 @@ void lbs_interrupt(struct net_device *);
 int lbs_set_radio_control(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
-void lbs_get_fwversion(struct lbs_adapter *adapter,
+void lbs_get_fwversion(struct lbs_private *priv,
 	char *fwversion,
 	int maxlen);
 
@@ -66,7 +65,7 @@ void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
 void lbs_tx_runqueue(struct lbs_private *priv);
 
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_adapter *adapter,
+	struct lbs_private *priv,
 	u8 band,
 	u16 channel);
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index eaa45d4..21b0d38 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -1,7 +1,7 @@
 /**
   * This file contains definitions and data structures specific
   * to Marvell 802.11 NIC. It contains the Device Information
-  * structure struct lbs_adapter.
+  * structure struct lbs_private..
   */
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
@@ -109,7 +109,6 @@ struct lbs_private {
 	char name[DEV_NAME_LEN];
 
 	void *card;
-	struct lbs_adapter *adapter;
 	struct net_device *dev;
 
 	struct net_device_stats stats;
@@ -156,54 +155,10 @@ struct lbs_private {
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
 	int (*hw_get_int_status) (struct lbs_private *priv, u8 *);
 	int (*hw_read_event_cause) (struct lbs_private *);
-};
-
-/** Association request
- *
- * Encapsulates all the options that describe a specific assocation request
- * or configuration of the wireless card's radio, mode, and security settings.
- */
-struct assoc_request {
-#define ASSOC_FLAG_SSID			1
-#define ASSOC_FLAG_CHANNEL		2
-#define ASSOC_FLAG_BAND			3
-#define ASSOC_FLAG_MODE			4
-#define ASSOC_FLAG_BSSID		5
-#define ASSOC_FLAG_WEP_KEYS		6
-#define ASSOC_FLAG_WEP_TX_KEYIDX	7
-#define ASSOC_FLAG_WPA_MCAST_KEY	8
-#define ASSOC_FLAG_WPA_UCAST_KEY	9
-#define ASSOC_FLAG_SECINFO		10
-#define ASSOC_FLAG_WPA_IE		11
-	unsigned long flags;
-
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 ssid_len;
-	u8 channel;
-	u8 band;
-	u8 mode;
-	u8 bssid[ETH_ALEN];
-
-	/** WEP keys */
-	struct enc_key wep_keys[4];
-	u16 wep_tx_keyidx;
-
-	/** WPA keys */
-	struct enc_key wpa_mcast_key;
-	struct enc_key wpa_unicast_key;
-
-	struct lbs_802_11_security secinfo;
 
-	/** WPA Information Elements*/
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
-
-	/* BSS to associate with for infrastructure of Ad-Hoc join */
-	struct bss_descriptor bss;
-};
+	/* was struct lbs_adapter from here... */
 
-/** Wlan adapter data structure*/
-struct lbs_adapter {
+	/** Wlan adapter data structure*/
 	/** STATUS variables */
 	u8 fwreleasenumber[4];
 	u32 fwcapinfo;
@@ -229,7 +184,7 @@ struct lbs_adapter {
 	struct list_head cmdpendingq;
 
 	wait_queue_head_t cmd_pending;
-	/* command related variables protected by adapter->driver_lock */
+	/* command related variables protected by priv->driver_lock */
 
 	/** Async and Sync Event variables */
 	u32 intcounter;
@@ -366,4 +321,48 @@ struct lbs_adapter {
 	u8 fw_ready;
 };
 
+/** Association request
+ *
+ * Encapsulates all the options that describe a specific assocation request
+ * or configuration of the wireless card's radio, mode, and security settings.
+ */
+struct assoc_request {
+#define ASSOC_FLAG_SSID			1
+#define ASSOC_FLAG_CHANNEL		2
+#define ASSOC_FLAG_BAND			3
+#define ASSOC_FLAG_MODE			4
+#define ASSOC_FLAG_BSSID		5
+#define ASSOC_FLAG_WEP_KEYS		6
+#define ASSOC_FLAG_WEP_TX_KEYIDX	7
+#define ASSOC_FLAG_WPA_MCAST_KEY	8
+#define ASSOC_FLAG_WPA_UCAST_KEY	9
+#define ASSOC_FLAG_SECINFO		10
+#define ASSOC_FLAG_WPA_IE		11
+	unsigned long flags;
+
+	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid_len;
+	u8 channel;
+	u8 band;
+	u8 mode;
+	u8 bssid[ETH_ALEN];
+
+	/** WEP keys */
+	struct enc_key wep_keys[4];
+	u16 wep_tx_keyidx;
+
+	/** WPA keys */
+	struct enc_key wpa_mcast_key;
+	struct enc_key wpa_unicast_key;
+
+	struct lbs_802_11_security secinfo;
+
+	/** WPA Information Elements*/
+	u8 wpa_ie[MAX_WPA_IE_LEN];
+	u8 wpa_ie_len;
+
+	/* BSS to associate with for infrastructure of Ad-Hoc join */
+	struct bss_descriptor bss;
+};
+
 #endif
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index f32fb00..a54b4f4 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -25,7 +25,7 @@ static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 	char fwver[32];
 
-	lbs_get_fwversion(priv->adapter, fwver, sizeof(fwver) - 1);
+	lbs_get_fwversion(priv, fwver, sizeof(fwver) - 1);
 
 	strcpy(info->driver, "libertas");
 	strcpy(info->version, lbs_driver_version);
@@ -46,7 +46,6 @@ static int lbs_ethtool_get_eeprom(struct net_device *dev,
                                   struct ethtool_eeprom *eeprom, u8 * bytes)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_ioctl_regrdwr regctrl;
 	char *ptr;
 	int ret;
@@ -60,10 +59,10 @@ static int lbs_ethtool_get_eeprom(struct net_device *dev,
 
 //      mutex_lock(&priv->mutex);
 
-	adapter->prdeeprom = kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
-	if (!adapter->prdeeprom)
+	priv->prdeeprom = kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
+	if (!priv->prdeeprom)
 		return -ENOMEM;
-	memcpy(adapter->prdeeprom, &regctrl, sizeof(regctrl));
+	memcpy(priv->prdeeprom, &regctrl, sizeof(regctrl));
 
 	/* +14 is for action, offset, and NOB in
 	 * response */
@@ -77,14 +76,14 @@ static int lbs_ethtool_get_eeprom(struct net_device *dev,
 				    &regctrl);
 
 	if (ret) {
-		if (adapter->prdeeprom)
-			kfree(adapter->prdeeprom);
+		if (priv->prdeeprom)
+			kfree(priv->prdeeprom);
 		goto done;
 	}
 
 	mdelay(10);
 
-	ptr = (char *)adapter->prdeeprom;
+	ptr = (char *)priv->prdeeprom;
 
 	/* skip the command header, but include the "value" u32 variable */
 	ptr = ptr + sizeof(struct lbs_ioctl_regrdwr) - 4;
@@ -94,8 +93,8 @@ static int lbs_ethtool_get_eeprom(struct net_device *dev,
 	 */
 	memcpy(bytes, ptr, eeprom->len);
 
-	if (adapter->prdeeprom)
-		kfree(adapter->prdeeprom);
+	if (priv->prdeeprom)
+		kfree(priv->prdeeprom);
 //	mutex_unlock(&priv->mutex);
 
 	ret = 0;
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 8508260..49a0178 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -255,7 +255,7 @@ static irqreturn_t if_cs_interrupt(int irq, void *data)
 
 	} else if (int_cause == 0xffff) {
 		/* Read in junk, the card has probably been removed */
-		card->priv->adapter->surpriseremoved = 1;
+		card->priv->surpriseremoved = 1;
 
 	} else {
 		if (int_cause & IF_CS_H_IC_TX_OVER)
@@ -644,7 +644,6 @@ static int if_cs_host_to_card(struct lbs_private *priv,
 static int if_cs_get_int_status(struct lbs_private *priv, u8 *ireg)
 {
 	struct if_cs_card *card = (struct if_cs_card *)priv->card;
-	/* struct lbs_adapter *adapter = priv->adapter; */
 	int ret = 0;
 	u16 int_cause;
 	u8 *cmdbuf;
@@ -652,7 +651,7 @@ static int if_cs_get_int_status(struct lbs_private *priv, u8 *ireg)
 
 	lbs_deb_enter(LBS_DEB_CS);
 
-	if (priv->adapter->surpriseremoved)
+	if (priv->surpriseremoved)
 		goto out;
 
 	int_cause = if_cs_read16(card, IF_CS_C_INT_CAUSE) & IF_CS_C_IC_MASK;
@@ -678,22 +677,22 @@ sbi_get_int_status_exit:
 
 	/* Card has a command result for us */
 	if (*ireg & IF_CS_C_S_CMD_UPLD_RDY) {
-		spin_lock(&priv->adapter->driver_lock);
-		if (!priv->adapter->cur_cmd) {
+		spin_lock(&priv->driver_lock);
+		if (!priv->cur_cmd) {
 			cmdbuf = priv->upld_buf;
-			priv->adapter->hisregcpy &= ~IF_CS_C_S_RX_UPLD_RDY;
+			priv->hisregcpy &= ~IF_CS_C_S_RX_UPLD_RDY;
 		} else {
-			cmdbuf = priv->adapter->cur_cmd->bufvirtualaddr;
+			cmdbuf = priv->cur_cmd->bufvirtualaddr;
 		}
 
 		ret = if_cs_receive_cmdres(priv, cmdbuf, &priv->upld_len);
-		spin_unlock(&priv->adapter->driver_lock);
+		spin_unlock(&priv->driver_lock);
 		if (ret < 0)
 			lbs_pr_err("could not receive cmd from card\n");
 	}
 
 out:
-	lbs_deb_leave_args(LBS_DEB_CS, "ret %d, ireg 0x%x, hisregcpy 0x%x", ret, *ireg, priv->adapter->hisregcpy);
+	lbs_deb_leave_args(LBS_DEB_CS, "ret %d, ireg 0x%x, hisregcpy 0x%x", ret, *ireg, priv->hisregcpy);
 	return ret;
 }
 
@@ -702,7 +701,7 @@ static int if_cs_read_event_cause(struct lbs_private *priv)
 {
 	lbs_deb_enter(LBS_DEB_CS);
 
-	priv->adapter->eventcause = (if_cs_read16(priv->card, IF_CS_C_STATUS) & IF_CS_C_S_STATUS_MASK) >> 5;
+	priv->eventcause = (if_cs_read16(priv->card, IF_CS_C_STATUS) & IF_CS_C_S_STATUS_MASK) >> 5;
 	if_cs_write16(priv->card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_HOST_EVENT);
 
 	return 0;
@@ -869,7 +868,7 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	priv->hw_get_int_status   = if_cs_get_int_status;
 	priv->hw_read_event_cause = if_cs_read_event_cause;
 
-	priv->adapter->fw_ready = 1;
+	priv->fw_ready = 1;
 
 	/* Now actually get the IRQ */
 	ret = request_irq(p_dev->irq.AssignedIRQ, if_cs_interrupt,
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 6f5a517..6456613 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -134,9 +134,9 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	spin_lock_irqsave(&card->priv->adapter->driver_lock, flags);
+	spin_lock_irqsave(&card->priv->driver_lock, flags);
 
-	if (!card->priv->adapter->cur_cmd) {
+	if (!card->priv->cur_cmd) {
 		lbs_deb_sdio("discarding spurious response\n");
 		ret = 0;
 		goto out;
@@ -149,7 +149,7 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 		goto out;
 	}
 
-	memcpy(card->priv->adapter->cur_cmd->bufvirtualaddr, buffer, size);
+	memcpy(card->priv->cur_cmd->bufvirtualaddr, buffer, size);
 	card->priv->upld_len = size;
 
 	card->int_cause |= MRVDRV_CMD_UPLD_RDY;
@@ -159,7 +159,7 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 	ret = 0;
 
 out:
-	spin_unlock_irqrestore(&card->priv->adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
 
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
 
@@ -231,14 +231,14 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 		event <<= SBI_EVENT_CAUSE_SHIFT;
 	}
 
-	spin_lock_irqsave(&card->priv->adapter->driver_lock, flags);
+	spin_lock_irqsave(&card->priv->driver_lock, flags);
 
 	card->event = event;
 	card->int_cause |= MRVDRV_CARDEVENT;
 
 	lbs_interrupt(card->priv->dev);
 
-	spin_unlock_irqrestore(&card->priv->adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
 
 	ret = 0;
 
@@ -800,7 +800,7 @@ static int if_sdio_read_event_cause(struct lbs_private *priv)
 
 	card = priv->card;
 
-	priv->adapter->eventcause = card->event;
+	priv->eventcause = card->event;
 
 	lbs_deb_leave(LBS_DEB_SDIO);
 
@@ -958,7 +958,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	priv->hw_get_int_status = if_sdio_get_int_status;
 	priv->hw_read_event_cause = if_sdio_read_event_cause;
 
-	priv->adapter->fw_ready = 1;
+	priv->fw_ready = 1;
 
 	/*
 	 * Enable interrupts now that everything is set up
@@ -981,7 +981,7 @@ out:
 err_activate_card:
 	flush_scheduled_work();
 	free_netdev(priv->dev);
-	kfree(priv->adapter);
+	kfree(priv);
 reclaim:
 	sdio_claim_host(func);
 release_int:
@@ -1011,7 +1011,7 @@ static void if_sdio_remove(struct sdio_func *func)
 
 	card = sdio_get_drvdata(func);
 
-	card->priv->adapter->surpriseremoved = 1;
+	card->priv->surpriseremoved = 1;
 
 	lbs_deb_sdio("call remove card\n");
 	lbs_stop_card(card->priv);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 7c4bd8d..87bed4a 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -229,7 +229,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	/* Delay 200 ms to waiting for the FW ready */
 	if_usb_submit_rx_urb(cardp);
 	msleep_interruptible(200);
-	priv->adapter->fw_ready = 1;
+	priv->fw_ready = 1;
 
 	if (lbs_start_card(priv))
 		goto err_start_card;
@@ -270,9 +270,8 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	cardp->surprise_removed = 1;
 
 	if (priv) {
-		struct lbs_adapter *adapter = priv->adapter;
 
-		adapter->surpriseremoved = 1;
+		priv->surpriseremoved = 1;
 		lbs_stop_card(priv);
 		lbs_remove_mesh(priv);
 		lbs_remove_card(priv);
@@ -609,14 +608,14 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 	if (!in_interrupt())
 		BUG();
 
-	spin_lock(&priv->adapter->driver_lock);
+	spin_lock(&priv->driver_lock);
 	/* take care of cur_cmd = NULL case by reading the
 	 * data to clear the interrupt */
-	if (!priv->adapter->cur_cmd) {
+	if (!priv->cur_cmd) {
 		cmdbuf = priv->upld_buf;
-		priv->adapter->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
+		priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
 	} else
-		cmdbuf = priv->adapter->cur_cmd->bufvirtualaddr;
+		cmdbuf = priv->cur_cmd->bufvirtualaddr;
 
 	cardp->usb_int_cause |= MRVDRV_CMD_UPLD_RDY;
 	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
@@ -625,7 +624,7 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 
 	kfree_skb(skb);
 	lbs_interrupt(priv->dev);
-	spin_unlock(&priv->adapter->driver_lock);
+	spin_unlock(&priv->driver_lock);
 
 	lbs_deb_usbd(&cardp->udev->dev,
 		    "Wake up main thread to handle cmd response\n");
@@ -685,20 +684,20 @@ static void if_usb_receive(struct urb *urb)
 
 	case CMD_TYPE_INDICATION:
 		/* Event cause handling */
-		spin_lock(&priv->adapter->driver_lock);
+		spin_lock(&priv->driver_lock);
 		cardp->usb_event_cause = le32_to_cpu(*(__le32 *) (recvbuff + MESSAGE_HEADER_LEN));
 		lbs_deb_usbd(&cardp->udev->dev,"**EVENT** 0x%X\n",
 			    cardp->usb_event_cause);
 		if (cardp->usb_event_cause & 0xffff0000) {
 			lbs_send_tx_feedback(priv);
-			spin_unlock(&priv->adapter->driver_lock);
+			spin_unlock(&priv->driver_lock);
 			break;
 		}
 		cardp->usb_event_cause <<= 3;
 		cardp->usb_int_cause |= MRVDRV_CARDEVENT;
 		kfree_skb(skb);
 		lbs_interrupt(priv->dev);
-		spin_unlock(&priv->adapter->driver_lock);
+		spin_unlock(&priv->driver_lock);
 		goto rx_exit;
 	default:
 		lbs_deb_usbd(&cardp->udev->dev, "Unknown command type 0x%X\n",
@@ -750,7 +749,7 @@ static int if_usb_host_to_card(struct lbs_private *priv,
 	                    nb + MESSAGE_HEADER_LEN);
 }
 
-/* called with adapter->driver_lock held */
+/* called with priv->driver_lock held */
 static int if_usb_get_int_status(struct lbs_private *priv, u8 *ireg)
 {
 	struct usb_card_rec *cardp = priv->card;
@@ -767,7 +766,7 @@ static int if_usb_read_event_cause(struct lbs_private *priv)
 {
 	struct usb_card_rec *cardp = priv->card;
 
-	priv->adapter->eventcause = cardp->usb_event_cause;
+	priv->eventcause = cardp->usb_event_cause;
 	/* Re-submit rx urb here to avoid event lost issue */
 	if_usb_submit_rx_urb(cardp);
 	return 0;
@@ -942,7 +941,7 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	if (priv->adapter->psstate != PS_STATE_FULL_POWER)
+	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
 	if (priv->mesh_dev && !priv->mesh_autostart_enabled) {
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 1550e6a..14425d9 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -30,13 +30,13 @@
  * NOTE: Setting the MSB of the basic rates need to be taken
  *   care, either before or after calling this function
  *
- *  @param adapter     A pointer to struct lbs_adapter structure
+ *  @param priv     A pointer to struct lbs_private structure
  *  @param rate1       the buffer which keeps input and output
  *  @param rate1_size  the size of rate1 buffer; new size of buffer on return
  *
  *  @return            0 or -1
  */
-static int get_common_rates(struct lbs_adapter *adapter,
+static int get_common_rates(struct lbs_private *priv,
 	u8 *rates,
 	u16 *rates_size)
 {
@@ -57,15 +57,15 @@ static int get_common_rates(struct lbs_adapter *adapter,
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
 	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
 	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
-	lbs_deb_join("TX data rate 0x%02x\n", adapter->cur_rate);
+	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
-	if (!adapter->auto_rate) {
+	if (!priv->auto_rate) {
 		for (i = 0; i < tmp_size; i++) {
-			if (tmp[i] == adapter->cur_rate)
+			if (tmp[i] == priv->cur_rate)
 				goto done;
 		}
 		lbs_pr_alert("Previously set fixed data rate %#x isn't "
-		       "compatible with the network.\n", adapter->cur_rate);
+		       "compatible with the network.\n", priv->cur_rate);
 		ret = -1;
 		goto done;
 	}
@@ -125,7 +125,6 @@ void lbs_unset_basic_rate_flags(u8 *rates, size_t len)
  */
 int lbs_associate(struct lbs_private *priv, struct assoc_request *assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
@@ -138,11 +137,11 @@ int lbs_associate(struct lbs_private *priv, struct assoc_request *assoc_req)
 		goto done;
 
 	/* set preamble to firmware */
-	if (   (adapter->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+	if (   (priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
 	    && (assoc_req->bss.capability & WLAN_CAPABILITY_SHORT_PREAMBLE))
-		adapter->preamble = CMD_TYPE_SHORT_PREAMBLE;
+		priv->preamble = CMD_TYPE_SHORT_PREAMBLE;
 	else
-		adapter->preamble = CMD_TYPE_LONG_PREAMBLE;
+		priv->preamble = CMD_TYPE_LONG_PREAMBLE;
 
 	lbs_set_radio_control(priv);
 
@@ -164,17 +163,16 @@ done:
 int lbs_start_adhoc_network(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
-	adapter->adhoccreate = 1;
+	priv->adhoccreate = 1;
 
-	if (adapter->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
+	if (priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE) {
 		lbs_deb_join("AdhocStart: Short preamble\n");
-		adapter->preamble = CMD_TYPE_SHORT_PREAMBLE;
+		priv->preamble = CMD_TYPE_SHORT_PREAMBLE;
 	} else {
 		lbs_deb_join("AdhocStart: Long preamble\n");
-		adapter->preamble = CMD_TYPE_LONG_PREAMBLE;
+		priv->preamble = CMD_TYPE_LONG_PREAMBLE;
 	}
 
 	lbs_set_radio_control(priv);
@@ -200,26 +198,25 @@ int lbs_start_adhoc_network(struct lbs_private *priv,
 int lbs_join_adhoc_network(struct lbs_private *priv,
 	struct assoc_request *assoc_req)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct bss_descriptor * bss = &assoc_req->bss;
 	int ret = 0;
 
 	lbs_deb_join("%s: Current SSID '%s', ssid length %u\n",
 	             __func__,
-	             escape_essid(adapter->curbssparams.ssid,
-	                          adapter->curbssparams.ssid_len),
-	             adapter->curbssparams.ssid_len);
+	             escape_essid(priv->curbssparams.ssid,
+	                          priv->curbssparams.ssid_len),
+	             priv->curbssparams.ssid_len);
 	lbs_deb_join("%s: requested ssid '%s', ssid length %u\n",
 	             __func__, escape_essid(bss->ssid, bss->ssid_len),
 	             bss->ssid_len);
 
 	/* check if the requested SSID is already joined */
-	if (   adapter->curbssparams.ssid_len
-	    && !lbs_ssid_cmp(adapter->curbssparams.ssid,
-	                          adapter->curbssparams.ssid_len,
+	if (   priv->curbssparams.ssid_len
+	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
+	                          priv->curbssparams.ssid_len,
 	                          bss->ssid, bss->ssid_len)
-	    && (adapter->mode == IW_MODE_ADHOC)
-	    && (adapter->connect_status == LBS_CONNECTED)) {
+	    && (priv->mode == IW_MODE_ADHOC)
+	    && (priv->connect_status == LBS_CONNECTED)) {
 		union iwreq_data wrqu;
 
 		lbs_deb_join("ADHOC_J_CMD: New ad-hoc SSID is the same as "
@@ -229,7 +226,7 @@ int lbs_join_adhoc_network(struct lbs_private *priv,
 		 * request really was successful, even if just a null-op.
 		 */
 		memset(&wrqu, 0, sizeof(wrqu));
-		memcpy(wrqu.ap_addr.sa_data, adapter->curbssparams.bssid,
+		memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid,
 		       ETH_ALEN);
 		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 		wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
@@ -239,12 +236,12 @@ int lbs_join_adhoc_network(struct lbs_private *priv,
 	/* Use shortpreamble only when both creator and card supports
 	   short preamble */
 	if (   !(bss->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-	    || !(adapter->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)) {
+	    || !(priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE)) {
 		lbs_deb_join("AdhocJoin: Long preamble\n");
-		adapter->preamble = CMD_TYPE_LONG_PREAMBLE;
+		priv->preamble = CMD_TYPE_LONG_PREAMBLE;
 	} else {
 		lbs_deb_join("AdhocJoin: Short preamble\n");
-		adapter->preamble = CMD_TYPE_SHORT_PREAMBLE;
+		priv->preamble = CMD_TYPE_SHORT_PREAMBLE;
 	}
 
 	lbs_set_radio_control(priv);
@@ -252,7 +249,7 @@ int lbs_join_adhoc_network(struct lbs_private *priv,
 	lbs_deb_join("AdhocJoin: channel = %d\n", assoc_req->channel);
 	lbs_deb_join("AdhocJoin: band = %c\n", assoc_req->band);
 
-	adapter->adhoccreate = 0;
+	priv->adhoccreate = 0;
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_AD_HOC_JOIN,
 				    0, CMD_OPTION_WAITFORRSP,
@@ -293,7 +290,6 @@ int lbs_cmd_80211_authenticate(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd,
 				 void *pdata_buf)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_authenticate *pauthenticate = &cmd->params.auth;
 	int ret = -1;
 	u8 *bssid = pdata_buf;
@@ -306,7 +302,7 @@ int lbs_cmd_80211_authenticate(struct lbs_private *priv,
 	                        + S_DS_GEN);
 
 	/* translate auth mode to 802.11 defined wire value */
-	switch (adapter->secinfo.auth_mode) {
+	switch (priv->secinfo.auth_mode) {
 	case IW_AUTH_ALG_OPEN_SYSTEM:
 		pauthenticate->authtype = 0x00;
 		break;
@@ -318,7 +314,7 @@ int lbs_cmd_80211_authenticate(struct lbs_private *priv,
 		break;
 	default:
 		lbs_deb_join("AUTH_CMD: invalid auth alg 0x%X\n",
-		             adapter->secinfo.auth_mode);
+		             priv->secinfo.auth_mode);
 		goto out;
 	}
 
@@ -336,7 +332,6 @@ out:
 int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 				   struct cmd_ds_command *cmd)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_deauthenticate *dauth = &cmd->params.deauth;
 
 	lbs_deb_enter(LBS_DEB_JOIN);
@@ -346,7 +341,7 @@ int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 			     S_DS_GEN);
 
 	/* set AP MAC address */
-	memmove(dauth->macaddr, adapter->curbssparams.bssid, ETH_ALEN);
+	memmove(dauth->macaddr, priv->curbssparams.bssid, ETH_ALEN);
 
 	/* Reason code 3 = Station is leaving */
 #define REASON_CODE_STA_LEAVING 3
@@ -359,7 +354,6 @@ int lbs_cmd_80211_deauthenticate(struct lbs_private *priv,
 int lbs_cmd_80211_associate(struct lbs_private *priv,
 			      struct cmd_ds_command *cmd, void *pdata_buf)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_associate *passo = &cmd->params.associate;
 	int ret = 0;
 	struct assoc_request * assoc_req = pdata_buf;
@@ -376,7 +370,7 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 
 	pos = (u8 *) passo;
 
-	if (!adapter) {
+	if (!priv) {
 		ret = -1;
 		goto done;
 	}
@@ -420,7 +414,7 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
 	tmplen = MAX_RATES;
-	if (get_common_rates(adapter, rates->rates, &tmplen)) {
+	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
 	}
@@ -429,8 +423,8 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	lbs_deb_assoc("ASSOC_CMD: num rates %u\n", tmplen);
 
 	/* Copy the infra. association rates into Current BSS state structure */
-	memset(&adapter->curbssparams.rates, 0, sizeof(adapter->curbssparams.rates));
-	memcpy(&adapter->curbssparams.rates, &rates->rates, tmplen);
+	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
+	memcpy(&priv->curbssparams.rates, &rates->rates, tmplen);
 
 	/* Set MSB on basic rates as the firmware requires, but _after_
 	 * copying to current bss rates.
@@ -450,7 +444,7 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	}
 
 	/* update curbssparams */
-	adapter->curbssparams.channel = bss->phyparamset.dsparamset.currentchan;
+	priv->curbssparams.channel = bss->phyparamset.dsparamset.currentchan;
 
 	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
 		ret = -1;
@@ -474,7 +468,6 @@ done:
 int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 				 struct cmd_ds_command *cmd, void *pdata_buf)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_ad_hoc_start *adhs = &cmd->params.ads;
 	int ret = 0;
 	int cmdappendsize = 0;
@@ -484,7 +477,7 @@ int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 
 	lbs_deb_enter(LBS_DEB_JOIN);
 
-	if (!adapter) {
+	if (!priv) {
 		ret = -1;
 		goto done;
 	}
@@ -494,7 +487,7 @@ int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 	/*
 	 * Fill in the parameters for 2 data structures:
 	 *   1. cmd_ds_802_11_ad_hoc_start command
-	 *   2. adapter->scantable[i]
+	 *   2. priv->scantable[i]
 	 *
 	 * Driver will fill up SSID, bsstype,IBSS param, Physical Param,
 	 *   probe delay, and cap info.
@@ -512,10 +505,10 @@ int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 
 	/* set the BSS type */
 	adhs->bsstype = CMD_BSS_TYPE_IBSS;
-	adapter->mode = IW_MODE_ADHOC;
-	if (adapter->beacon_period == 0)
-		adapter->beacon_period = MRVDRV_BEACON_INTERVAL;
-	adhs->beaconperiod = cpu_to_le16(adapter->beacon_period);
+	priv->mode = IW_MODE_ADHOC;
+	if (priv->beacon_period == 0)
+		priv->beacon_period = MRVDRV_BEACON_INTERVAL;
+	adhs->beaconperiod = cpu_to_le16(priv->beacon_period);
 
 	/* set Physical param set */
 #define DS_PARA_IE_ID   3
@@ -557,8 +550,8 @@ int lbs_cmd_80211_ad_hoc_start(struct lbs_private *priv,
 	memcpy(adhs->rates, lbs_bg_rates, ratesize);
 
 	/* Copy the ad-hoc creating rates into Current BSS state structure */
-	memset(&adapter->curbssparams.rates, 0, sizeof(adapter->curbssparams.rates));
-	memcpy(&adapter->curbssparams.rates, &adhs->rates, ratesize);
+	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
+	memcpy(&priv->curbssparams.rates, &adhs->rates, ratesize);
 
 	/* Set MSB on basic rates as the firmware requires, but _after_
 	 * copying to current bss rates.
@@ -597,7 +590,6 @@ int lbs_cmd_80211_ad_hoc_stop(struct lbs_private *priv,
 int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
 				struct cmd_ds_command *cmd, void *pdata_buf)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_ad_hoc_join *join_cmd = &cmd->params.adj;
 	struct assoc_request * assoc_req = pdata_buf;
 	struct bss_descriptor *bss = &assoc_req->bss;
@@ -638,21 +630,21 @@ int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
 	/* probedelay */
 	join_cmd->probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
 
-	adapter->curbssparams.channel = bss->channel;
+	priv->curbssparams.channel = bss->channel;
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(join_cmd->bss.rates, 0, sizeof(join_cmd->bss.rates));
 	ratesize = min_t(u16, sizeof(join_cmd->bss.rates), MAX_RATES);
 	memcpy(join_cmd->bss.rates, bss->rates, ratesize);
-	if (get_common_rates(adapter, join_cmd->bss.rates, &ratesize)) {
+	if (get_common_rates(priv, join_cmd->bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_J_CMD: get_common_rates returns error.\n");
 		ret = -1;
 		goto done;
 	}
 
 	/* Copy the ad-hoc creating rates into Current BSS state structure */
-	memset(&adapter->curbssparams.rates, 0, sizeof(adapter->curbssparams.rates));
-	memcpy(&adapter->curbssparams.rates, join_cmd->bss.rates, ratesize);
+	memset(&priv->curbssparams.rates, 0, sizeof(priv->curbssparams.rates));
+	memcpy(&priv->curbssparams.rates, join_cmd->bss.rates, ratesize);
 
 	/* Set MSB on basic rates as the firmware requires, but _after_
 	 * copying to current bss rates.
@@ -668,7 +660,7 @@ int lbs_cmd_80211_ad_hoc_join(struct lbs_private *priv,
 		join_cmd->bss.capability = cpu_to_le16(tmp);
 	}
 
-	if (adapter->psmode == LBS802_11POWERMODEMAX_PSP) {
+	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
 		/* wake up first */
 		__le32 Localpsmode;
 
@@ -700,7 +692,6 @@ done:
 int lbs_ret_80211_associate(struct lbs_private *priv,
 			      struct cmd_ds_command *resp)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	union iwreq_data wrqu;
 	struct ieeetypes_assocrsp *passocrsp;
@@ -709,12 +700,12 @@ int lbs_ret_80211_associate(struct lbs_private *priv,
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	if (!adapter->in_progress_assoc_req) {
+	if (!priv->in_progress_assoc_req) {
 		lbs_deb_assoc("ASSOC_RESP: no in-progress assoc request\n");
 		ret = -1;
 		goto done;
 	}
-	bss = &adapter->in_progress_assoc_req->bss;
+	bss = &priv->in_progress_assoc_req->bss;
 
 	passocrsp = (struct ieeetypes_assocrsp *) & resp->params;
 
@@ -771,29 +762,29 @@ int lbs_ret_80211_associate(struct lbs_private *priv,
 		le16_to_cpu(resp->size) - S_DS_GEN);
 
 	/* Send a Media Connected event, according to the Spec */
-	adapter->connect_status = LBS_CONNECTED;
+	priv->connect_status = LBS_CONNECTED;
 
 	/* Update current SSID and BSSID */
-	memcpy(&adapter->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
-	adapter->curbssparams.ssid_len = bss->ssid_len;
-	memcpy(adapter->curbssparams.bssid, bss->bssid, ETH_ALEN);
+	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
+	priv->curbssparams.ssid_len = bss->ssid_len;
+	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
 
 	lbs_deb_assoc("ASSOC_RESP: currentpacketfilter is 0x%x\n",
-		adapter->currentpacketfilter);
+		priv->currentpacketfilter);
 
-	adapter->SNR[TYPE_RXPD][TYPE_AVG] = 0;
-	adapter->NF[TYPE_RXPD][TYPE_AVG] = 0;
+	priv->SNR[TYPE_RXPD][TYPE_AVG] = 0;
+	priv->NF[TYPE_RXPD][TYPE_AVG] = 0;
 
-	memset(adapter->rawSNR, 0x00, sizeof(adapter->rawSNR));
-	memset(adapter->rawNF, 0x00, sizeof(adapter->rawNF));
-	adapter->nextSNRNF = 0;
-	adapter->numSNRNF = 0;
+	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
+	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
+	priv->nextSNRNF = 0;
+	priv->numSNRNF = 0;
 
 	netif_carrier_on(priv->dev);
 	netif_wake_queue(priv->dev);
 
 
-	memcpy(wrqu.ap_addr.sa_data, adapter->curbssparams.bssid, ETH_ALEN);
+	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
@@ -816,7 +807,6 @@ int lbs_ret_80211_disassociate(struct lbs_private *priv,
 int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 				 struct cmd_ds_command *resp)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u16 command = le16_to_cpu(resp->command);
 	u16 result = le16_to_cpu(resp->result);
@@ -833,19 +823,19 @@ int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 	lbs_deb_join("ADHOC_RESP: command = %x\n", command);
 	lbs_deb_join("ADHOC_RESP: result = %x\n", result);
 
-	if (!adapter->in_progress_assoc_req) {
+	if (!priv->in_progress_assoc_req) {
 		lbs_deb_join("ADHOC_RESP: no in-progress association request\n");
 		ret = -1;
 		goto done;
 	}
-	bss = &adapter->in_progress_assoc_req->bss;
+	bss = &priv->in_progress_assoc_req->bss;
 
 	/*
 	 * Join result code 0 --> SUCCESS
 	 */
 	if (result) {
 		lbs_deb_join("ADHOC_RESP: failed\n");
-		if (adapter->connect_status == LBS_CONNECTED) {
+		if (priv->connect_status == LBS_CONNECTED) {
 			lbs_mac_event_disconnected(priv);
 		}
 		ret = -1;
@@ -860,7 +850,7 @@ int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 	             escape_essid(bss->ssid, bss->ssid_len));
 
 	/* Send a Media Connected event, according to the Spec */
-	adapter->connect_status = LBS_CONNECTED;
+	priv->connect_status = LBS_CONNECTED;
 
 	if (command == CMD_RET(CMD_802_11_AD_HOC_START)) {
 		/* Update the created network descriptor with the new BSSID */
@@ -868,22 +858,22 @@ int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 	}
 
 	/* Set the BSSID from the joined/started descriptor */
-	memcpy(&adapter->curbssparams.bssid, bss->bssid, ETH_ALEN);
+	memcpy(&priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
 
 	/* Set the new SSID to current SSID */
-	memcpy(&adapter->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
-	adapter->curbssparams.ssid_len = bss->ssid_len;
+	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
+	priv->curbssparams.ssid_len = bss->ssid_len;
 
 	netif_carrier_on(priv->dev);
 	netif_wake_queue(priv->dev);
 
 	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, adapter->curbssparams.bssid, ETH_ALEN);
+	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
 	lbs_deb_join("ADHOC_RESP: - Joined/Started Ad Hoc\n");
-	lbs_deb_join("ADHOC_RESP: channel = %d\n", adapter->curbssparams.channel);
+	lbs_deb_join("ADHOC_RESP: channel = %d\n", priv->curbssparams.channel);
 	lbs_deb_join("ADHOC_RESP: BSSID = %s\n",
 		     print_mac(mac, padhocresult->bssid));
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 7155f48..243cdea 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -257,8 +257,7 @@ static ssize_t lbs_rtap_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
 {
 	struct lbs_private *priv = to_net_dev(dev)->priv;
-	struct lbs_adapter *adapter = priv->adapter;
-	return snprintf(buf, 5, "0x%X\n", adapter->monitormode);
+	return snprintf(buf, 5, "0x%X\n", priv->monitormode);
 }
 
 /**
@@ -269,31 +268,30 @@ static ssize_t lbs_rtap_set(struct device *dev,
 {
 	int monitor_mode;
 	struct lbs_private *priv = to_net_dev(dev)->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	sscanf(buf, "%x", &monitor_mode);
 	if (monitor_mode != LBS_MONITOR_OFF) {
-		if(adapter->monitormode == monitor_mode)
+		if(priv->monitormode == monitor_mode)
 			return strlen(buf);
-		if (adapter->monitormode == LBS_MONITOR_OFF) {
-			if (adapter->mode == IW_MODE_INFRA)
+		if (priv->monitormode == LBS_MONITOR_OFF) {
+			if (priv->mode == IW_MODE_INFRA)
 				lbs_send_deauthentication(priv);
-			else if (adapter->mode == IW_MODE_ADHOC)
+			else if (priv->mode == IW_MODE_ADHOC)
 				lbs_stop_adhoc_network(priv);
 			lbs_add_rtap(priv);
 		}
-		adapter->monitormode = monitor_mode;
+		priv->monitormode = monitor_mode;
 	}
 
 	else {
-		if (adapter->monitormode == LBS_MONITOR_OFF)
+		if (priv->monitormode == LBS_MONITOR_OFF)
 			return strlen(buf);
-		adapter->monitormode = LBS_MONITOR_OFF;
+		priv->monitormode = LBS_MONITOR_OFF;
 		lbs_remove_rtap(priv);
 
-		if (adapter->currenttxskb) {
-			dev_kfree_skb_any(adapter->currenttxskb);
-			adapter->currenttxskb = NULL;
+		if (priv->currenttxskb) {
+			dev_kfree_skb_any(priv->currenttxskb);
+			priv->currenttxskb = NULL;
 		}
 
 		/* Wake queues, command thread, etc. */
@@ -302,7 +300,7 @@ static ssize_t lbs_rtap_set(struct device *dev,
 
 	lbs_prepare_and_send_command(priv,
 			CMD_802_11_MONITOR_MODE, CMD_ACT_SET,
-			CMD_OPTION_WAITFORRSP, 0, &adapter->monitormode);
+			CMD_OPTION_WAITFORRSP, 0, &priv->monitormode);
 	return strlen(buf);
 }
 
@@ -382,14 +380,13 @@ static struct attribute_group lbs_mesh_attr_group = {
 static int pre_open_check(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int i = 0;
 
-	while (!adapter->fw_ready && i < 20) {
+	while (!priv->fw_ready && i < 20) {
 		i++;
 		msleep_interruptible(100);
 	}
-	if (!adapter->fw_ready) {
+	if (!priv->fw_ready) {
 		lbs_pr_err("firmware not ready\n");
 		return -1;
 	}
@@ -406,19 +403,18 @@ static int pre_open_check(struct net_device *dev)
 static int lbs_dev_open(struct net_device *dev)
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
 	priv->open = 1;
 
-	if (adapter->connect_status == LBS_CONNECTED)
+	if (priv->connect_status == LBS_CONNECTED)
 		netif_carrier_on(priv->dev);
 	else
 		netif_carrier_off(priv->dev);
 
 	if (priv->mesh_dev) {
-		if (adapter->mesh_connect_status == LBS_CONNECTED)
+		if (priv->mesh_connect_status == LBS_CONNECTED)
 			netif_carrier_on(priv->mesh_dev);
 		else
 			netif_carrier_off(priv->mesh_dev);
@@ -442,7 +438,7 @@ static int lbs_mesh_open(struct net_device *dev)
 	priv->mesh_open = 1 ;
 	netif_wake_queue(priv->mesh_dev);
 
-	priv->adapter->mesh_connect_status = LBS_CONNECTED;
+	priv->mesh_connect_status = LBS_CONNECTED;
 
 	netif_carrier_on(priv->mesh_dev);
 	netif_wake_queue(priv->mesh_dev);
@@ -534,7 +530,7 @@ static int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		priv->stats.tx_dropped++;
 		goto done;
 	}
-	if (priv->adapter->currenttxskb) {
+	if (priv->currenttxskb) {
 		lbs_pr_err("%s while TX skb pending\n", __func__);
 		priv->stats.tx_dropped++;
 		goto done;
@@ -562,7 +558,7 @@ static int lbs_mesh_pre_start_xmit(struct sk_buff *skb,
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_MESH);
-	if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
+	if (priv->monitormode != LBS_MONITOR_OFF) {
 		netif_stop_queue(dev);
 		return -EOPNOTSUPP;
 	}
@@ -585,7 +581,7 @@ static int lbs_pre_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	lbs_deb_enter(LBS_DEB_TX);
 
-	if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
+	if (priv->monitormode != LBS_MONITOR_OFF) {
 		netif_stop_queue(dev);
 		return -EOPNOTSUPP;
 	}
@@ -608,20 +604,20 @@ static void lbs_tx_timeout(struct net_device *dev)
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 	dev->trans_start = jiffies;
 
-	if (priv->adapter->currenttxskb) {
-		if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
+	if (priv->currenttxskb) {
+		if (priv->monitormode != LBS_MONITOR_OFF) {
 			/* If we are here, we have not received feedback from
 			   the previous packet.  Assume TX_FAIL and move on. */
-			priv->adapter->eventcause = 0x01000000;
+			priv->eventcause = 0x01000000;
 			lbs_send_tx_feedback(priv);
 		} else
 			wake_up_interruptible(&priv->waitq);
 	} else if (dev == priv->dev) {
-		if (priv->adapter->connect_status == LBS_CONNECTED)
+		if (priv->connect_status == LBS_CONNECTED)
 			netif_wake_queue(priv->dev);
 
 	} else if (dev == priv->mesh_dev) {
-		if (priv->adapter->mesh_connect_status == LBS_CONNECTED)
+		if (priv->mesh_connect_status == LBS_CONNECTED)
 			netif_wake_queue(priv->mesh_dev);
 	}
 
@@ -630,23 +626,22 @@ static void lbs_tx_timeout(struct net_device *dev)
 
 void lbs_host_to_card_done(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* Wake main thread if commands are pending */
-	if (!adapter->cur_cmd)
+	if (!priv->cur_cmd)
 		wake_up_interruptible(&priv->waitq);
 
 	/* Don't wake netif queues if we're in monitor mode and
 	   a TX packet is already pending. */
-	if (priv->adapter->currenttxskb)
+	if (priv->currenttxskb)
 		return;
 
-	if (priv->dev && adapter->connect_status == LBS_CONNECTED)
+	if (priv->dev && priv->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev && adapter->mesh_connect_status == LBS_CONNECTED)
+	if (priv->mesh_dev && priv->mesh_connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->mesh_dev);
 }
 EXPORT_SYMBOL_GPL(lbs_host_to_card_done);
@@ -668,7 +663,6 @@ static int lbs_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct sockaddr *phwaddr = addr;
 
 	lbs_deb_enter(LBS_DEB_NET);
@@ -676,13 +670,13 @@ static int lbs_set_mac_address(struct net_device *dev, void *addr)
 	/* In case it was called from the mesh device */
 	dev = priv->dev ;
 
-	memset(adapter->current_addr, 0, ETH_ALEN);
+	memset(priv->current_addr, 0, ETH_ALEN);
 
 	/* dev->dev_addr is 8 bytes */
 	lbs_deb_hex(LBS_DEB_NET, "dev->dev_addr", dev->dev_addr, ETH_ALEN);
 
 	lbs_deb_hex(LBS_DEB_NET, "addr", phwaddr->sa_data, ETH_ALEN);
-	memcpy(adapter->current_addr, phwaddr->sa_data, ETH_ALEN);
+	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_MAC_ADDRESS,
 				    CMD_ACT_SET,
@@ -694,24 +688,24 @@ static int lbs_set_mac_address(struct net_device *dev, void *addr)
 		goto done;
 	}
 
-	lbs_deb_hex(LBS_DEB_NET, "adapter->macaddr", adapter->current_addr, ETH_ALEN);
-	memcpy(dev->dev_addr, adapter->current_addr, ETH_ALEN);
+	lbs_deb_hex(LBS_DEB_NET, "priv->macaddr", priv->current_addr, ETH_ALEN);
+	memcpy(dev->dev_addr, priv->current_addr, ETH_ALEN);
 	if (priv->mesh_dev)
-		memcpy(priv->mesh_dev->dev_addr, adapter->current_addr, ETH_ALEN);
+		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
 	return ret;
 }
 
-static int lbs_copy_multicast_address(struct lbs_adapter *adapter,
+static int lbs_copy_multicast_address(struct lbs_private *priv,
 				     struct net_device *dev)
 {
 	int i = 0;
 	struct dev_mc_list *mcptr = dev->mc_list;
 
 	for (i = 0; i < dev->mc_count; i++) {
-		memcpy(&adapter->multicastlist[i], mcptr->dmi_addr, ETH_ALEN);
+		memcpy(&priv->multicastlist[i], mcptr->dmi_addr, ETH_ALEN);
 		mcptr = mcptr->next;
 	}
 
@@ -722,50 +716,49 @@ static int lbs_copy_multicast_address(struct lbs_adapter *adapter,
 static void lbs_set_multicast_list(struct net_device *dev)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int oldpacketfilter;
 	DECLARE_MAC_BUF(mac);
 
 	lbs_deb_enter(LBS_DEB_NET);
 
-	oldpacketfilter = adapter->currentpacketfilter;
+	oldpacketfilter = priv->currentpacketfilter;
 
 	if (dev->flags & IFF_PROMISC) {
 		lbs_deb_net("enable promiscuous mode\n");
-		adapter->currentpacketfilter |=
+		priv->currentpacketfilter |=
 		    CMD_ACT_MAC_PROMISCUOUS_ENABLE;
-		adapter->currentpacketfilter &=
+		priv->currentpacketfilter &=
 		    ~(CMD_ACT_MAC_ALL_MULTICAST_ENABLE |
 		      CMD_ACT_MAC_MULTICAST_ENABLE);
 	} else {
 		/* Multicast */
-		adapter->currentpacketfilter &=
+		priv->currentpacketfilter &=
 		    ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
 
 		if (dev->flags & IFF_ALLMULTI || dev->mc_count >
 		    MRVDRV_MAX_MULTICAST_LIST_SIZE) {
 			lbs_deb_net( "enabling all multicast\n");
-			adapter->currentpacketfilter |=
+			priv->currentpacketfilter |=
 			    CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
-			adapter->currentpacketfilter &=
+			priv->currentpacketfilter &=
 			    ~CMD_ACT_MAC_MULTICAST_ENABLE;
 		} else {
-			adapter->currentpacketfilter &=
+			priv->currentpacketfilter &=
 			    ~CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
 
 			if (!dev->mc_count) {
 				lbs_deb_net("no multicast addresses, "
 				       "disabling multicast\n");
-				adapter->currentpacketfilter &=
+				priv->currentpacketfilter &=
 				    ~CMD_ACT_MAC_MULTICAST_ENABLE;
 			} else {
 				int i;
 
-				adapter->currentpacketfilter |=
+				priv->currentpacketfilter |=
 				    CMD_ACT_MAC_MULTICAST_ENABLE;
 
-				adapter->nr_of_multicastmacaddr =
-				    lbs_copy_multicast_address(adapter, dev);
+				priv->nr_of_multicastmacaddr =
+				    lbs_copy_multicast_address(priv, dev);
 
 				lbs_deb_net("multicast addresses: %d\n",
 				       dev->mc_count);
@@ -773,7 +766,7 @@ static void lbs_set_multicast_list(struct net_device *dev)
 				for (i = 0; i < dev->mc_count; i++) {
 					lbs_deb_net("Multicast address %d:%s\n",
 					       i, print_mac(mac,
-					       adapter->multicastlist[i]));
+					       priv->multicastlist[i]));
 				}
 				/* send multicast addresses to firmware */
 				lbs_prepare_and_send_command(priv,
@@ -784,7 +777,7 @@ static void lbs_set_multicast_list(struct net_device *dev)
 		}
 	}
 
-	if (adapter->currentpacketfilter != oldpacketfilter) {
+	if (priv->currentpacketfilter != oldpacketfilter) {
 		lbs_set_mac_packet_filter(priv);
 	}
 
@@ -803,7 +796,6 @@ static int lbs_thread(void *data)
 {
 	struct net_device *dev = data;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	wait_queue_t wait;
 	u8 ireg = 0;
 
@@ -815,99 +807,99 @@ static int lbs_thread(void *data)
 
 	for (;;) {
 		lbs_deb_thread( "main-thread 111: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-				adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
+				priv->intcounter, priv->currenttxskb, priv->dnld_sent);
 
 		add_wait_queue(&priv->waitq, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
-		spin_lock_irq(&adapter->driver_lock);
+		spin_lock_irq(&priv->driver_lock);
 
-		if ((adapter->psstate == PS_STATE_SLEEP) ||
-		    (!adapter->intcounter && (priv->dnld_sent || adapter->cur_cmd || list_empty(&adapter->cmdpendingq)))) {
+		if ((priv->psstate == PS_STATE_SLEEP) ||
+		    (!priv->intcounter && (priv->dnld_sent || priv->cur_cmd || list_empty(&priv->cmdpendingq)))) {
 			lbs_deb_thread("main-thread sleeping... Conn=%d IntC=%d PS_mode=%d PS_State=%d\n",
-				       adapter->connect_status, adapter->intcounter,
-				       adapter->psmode, adapter->psstate);
-			spin_unlock_irq(&adapter->driver_lock);
+				       priv->connect_status, priv->intcounter,
+				       priv->psmode, priv->psstate);
+			spin_unlock_irq(&priv->driver_lock);
 			schedule();
 		} else
-			spin_unlock_irq(&adapter->driver_lock);
+			spin_unlock_irq(&priv->driver_lock);
 
 		lbs_deb_thread("main-thread 222 (waking up): intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-			       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
+			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&priv->waitq, &wait);
 		try_to_freeze();
 
 		lbs_deb_thread("main-thread 333: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-			       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
+			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
 
-		if (kthread_should_stop() || adapter->surpriseremoved) {
+		if (kthread_should_stop() || priv->surpriseremoved) {
 			lbs_deb_thread("main-thread: break from main thread: surpriseremoved=0x%x\n",
-				       adapter->surpriseremoved);
+				       priv->surpriseremoved);
 			break;
 		}
 
 
-		spin_lock_irq(&adapter->driver_lock);
+		spin_lock_irq(&priv->driver_lock);
 
-		if (adapter->intcounter) {
+		if (priv->intcounter) {
 			u8 int_status;
 
-			adapter->intcounter = 0;
+			priv->intcounter = 0;
 			int_status = priv->hw_get_int_status(priv, &ireg);
 
 			if (int_status) {
 				lbs_deb_thread("main-thread: reading HOST_INT_STATUS_REG failed\n");
-				spin_unlock_irq(&adapter->driver_lock);
+				spin_unlock_irq(&priv->driver_lock);
 				continue;
 			}
-			adapter->hisregcpy |= ireg;
+			priv->hisregcpy |= ireg;
 		}
 
 		lbs_deb_thread("main-thread 444: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-			       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent);
+			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
 
 		/* command response? */
-		if (adapter->hisregcpy & MRVDRV_CMD_UPLD_RDY) {
+		if (priv->hisregcpy & MRVDRV_CMD_UPLD_RDY) {
 			lbs_deb_thread("main-thread: cmd response ready\n");
 
-			adapter->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
-			spin_unlock_irq(&adapter->driver_lock);
+			priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
+			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_rx_command(priv);
-			spin_lock_irq(&adapter->driver_lock);
+			spin_lock_irq(&priv->driver_lock);
 		}
 
 		/* Any Card Event */
-		if (adapter->hisregcpy & MRVDRV_CARDEVENT) {
+		if (priv->hisregcpy & MRVDRV_CARDEVENT) {
 			lbs_deb_thread("main-thread: Card Event Activity\n");
 
-			adapter->hisregcpy &= ~MRVDRV_CARDEVENT;
+			priv->hisregcpy &= ~MRVDRV_CARDEVENT;
 
 			if (priv->hw_read_event_cause(priv)) {
 				lbs_pr_alert("main-thread: hw_read_event_cause failed\n");
-				spin_unlock_irq(&adapter->driver_lock);
+				spin_unlock_irq(&priv->driver_lock);
 				continue;
 			}
-			spin_unlock_irq(&adapter->driver_lock);
+			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv);
 		} else
-			spin_unlock_irq(&adapter->driver_lock);
+			spin_unlock_irq(&priv->driver_lock);
 
 		/* Check if we need to confirm Sleep Request received previously */
-		if (adapter->psstate == PS_STATE_PRE_SLEEP &&
-		    !priv->dnld_sent && !adapter->cur_cmd) {
-			if (adapter->connect_status == LBS_CONNECTED) {
+		if (priv->psstate == PS_STATE_PRE_SLEEP &&
+		    !priv->dnld_sent && !priv->cur_cmd) {
+			if (priv->connect_status == LBS_CONNECTED) {
 				lbs_deb_thread("main_thread: PRE_SLEEP--intcounter=%d currenttxskb=%p dnld_sent=%d cur_cmd=%p, confirm now\n",
-					       adapter->intcounter, adapter->currenttxskb, priv->dnld_sent, adapter->cur_cmd);
+					       priv->intcounter, priv->currenttxskb, priv->dnld_sent, priv->cur_cmd);
 
-				lbs_ps_confirm_sleep(priv, (u16) adapter->psmode);
+				lbs_ps_confirm_sleep(priv, (u16) priv->psmode);
 			} else {
 				/* workaround for firmware sending
 				 * deauth/linkloss event immediately
 				 * after sleep request; remove this
 				 * after firmware fixes it
 				 */
-				adapter->psstate = PS_STATE_AWAKE;
+				priv->psstate = PS_STATE_AWAKE;
 				lbs_pr_alert("main-thread: ignore PS_SleepConfirm in non-connected state\n");
 			}
 		}
@@ -915,25 +907,25 @@ static int lbs_thread(void *data)
 		/* The PS state is changed during processing of Sleep Request
 		 * event above
 		 */
-		if ((priv->adapter->psstate == PS_STATE_SLEEP) ||
-		    (priv->adapter->psstate == PS_STATE_PRE_SLEEP))
+		if ((priv->psstate == PS_STATE_SLEEP) ||
+		    (priv->psstate == PS_STATE_PRE_SLEEP))
 			continue;
 
 		/* Execute the next command */
-		if (!priv->dnld_sent && !priv->adapter->cur_cmd)
+		if (!priv->dnld_sent && !priv->cur_cmd)
 			lbs_execute_next_command(priv);
 
 		/* Wake-up command waiters which can't sleep in
 		 * lbs_prepare_and_send_command
 		 */
-		if (!list_empty(&adapter->cmdpendingq))
-			wake_up_all(&adapter->cmd_pending);
+		if (!list_empty(&priv->cmdpendingq))
+			wake_up_all(&priv->cmd_pending);
 
 		lbs_tx_runqueue(priv);
 	}
 
-	del_timer(&adapter->command_timer);
-	wake_up_all(&adapter->cmd_pending);
+	del_timer(&priv->command_timer);
+	wake_up_all(&priv->cmd_pending);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
 	return 0;
@@ -950,7 +942,6 @@ static int lbs_thread(void *data)
 static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_mesh_access mesh_access;
 
 	lbs_deb_enter(LBS_DEB_FW);
@@ -958,7 +949,7 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 	/*
 	 * Read MAC address from HW
 	 */
-	memset(adapter->current_addr, 0xff, ETH_ALEN);
+	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	ret = lbs_prepare_and_send_command(priv, CMD_GET_HW_SPEC,
 				    0, CMD_OPTION_WAITFORRSP, 0, NULL);
@@ -1008,12 +999,11 @@ done:
 static void command_timer_fn(unsigned long data)
 {
 	struct lbs_private *priv = (struct lbs_private *)data;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *ptempnode;
 	struct cmd_ds_command *cmd;
 	unsigned long flags;
 
-	ptempnode = adapter->cur_cmd;
+	ptempnode = priv->cur_cmd;
 	if (ptempnode == NULL) {
 		lbs_deb_fw("ptempnode empty\n");
 		return;
@@ -1027,15 +1017,15 @@ static void command_timer_fn(unsigned long data)
 
 	lbs_deb_fw("command_timer_fn fired, cmd %x\n", cmd->command);
 
-	if (!adapter->fw_ready)
+	if (!priv->fw_ready)
 		return;
 
-	spin_lock_irqsave(&adapter->driver_lock, flags);
-	adapter->cur_cmd = NULL;
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	priv->cur_cmd = NULL;
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	lbs_deb_fw("re-sending same command because of timeout\n");
-	lbs_queue_cmd(adapter, ptempnode, 0);
+	lbs_queue_cmd(priv, ptempnode, 0);
 
 	wake_up_interruptible(&priv->waitq);
 
@@ -1044,63 +1034,62 @@ static void command_timer_fn(unsigned long data)
 
 static int lbs_init_adapter(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	size_t bufsize;
 	int i, ret = 0;
 
 	/* Allocate buffer to store the BSSID list */
 	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
-	adapter->networks = kzalloc(bufsize, GFP_KERNEL);
-	if (!adapter->networks) {
+	priv->networks = kzalloc(bufsize, GFP_KERNEL);
+	if (!priv->networks) {
 		lbs_pr_err("Out of memory allocating beacons\n");
 		ret = -1;
 		goto out;
 	}
 
 	/* Initialize scan result lists */
-	INIT_LIST_HEAD(&adapter->network_free_list);
-	INIT_LIST_HEAD(&adapter->network_list);
+	INIT_LIST_HEAD(&priv->network_free_list);
+	INIT_LIST_HEAD(&priv->network_list);
 	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		list_add_tail(&adapter->networks[i].list,
-			      &adapter->network_free_list);
+		list_add_tail(&priv->networks[i].list,
+			      &priv->network_free_list);
 	}
 
-	adapter->lbs_ps_confirm_sleep.seqnum = cpu_to_le16(++adapter->seqnum);
-	adapter->lbs_ps_confirm_sleep.command =
+	priv->lbs_ps_confirm_sleep.seqnum = cpu_to_le16(++priv->seqnum);
+	priv->lbs_ps_confirm_sleep.command =
 	    cpu_to_le16(CMD_802_11_PS_MODE);
-	adapter->lbs_ps_confirm_sleep.size =
+	priv->lbs_ps_confirm_sleep.size =
 	    cpu_to_le16(sizeof(struct PS_CMD_ConfirmSleep));
-	adapter->lbs_ps_confirm_sleep.action =
+	priv->lbs_ps_confirm_sleep.action =
 	    cpu_to_le16(CMD_SUBCMD_SLEEP_CONFIRMED);
 
-	memset(adapter->current_addr, 0xff, ETH_ALEN);
+	memset(priv->current_addr, 0xff, ETH_ALEN);
 
-	adapter->connect_status = LBS_DISCONNECTED;
-	adapter->mesh_connect_status = LBS_DISCONNECTED;
-	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	adapter->mode = IW_MODE_INFRA;
-	adapter->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
-	adapter->currentpacketfilter = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
-	adapter->radioon = RADIO_ON;
-	adapter->auto_rate = 1;
-	adapter->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
-	adapter->psmode = LBS802_11POWERMODECAM;
-	adapter->psstate = PS_STATE_FULL_POWER;
+	priv->connect_status = LBS_DISCONNECTED;
+	priv->mesh_connect_status = LBS_DISCONNECTED;
+	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
+	priv->mode = IW_MODE_INFRA;
+	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
+	priv->currentpacketfilter = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
+	priv->radioon = RADIO_ON;
+	priv->auto_rate = 1;
+	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
+	priv->psmode = LBS802_11POWERMODECAM;
+	priv->psstate = PS_STATE_FULL_POWER;
 
-	mutex_init(&adapter->lock);
+	mutex_init(&priv->lock);
 
-	memset(&adapter->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*));
-	adapter->tx_queue_idx = 0;
-	spin_lock_init(&adapter->txqueue_lock);
+	memset(&priv->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*));
+	priv->tx_queue_idx = 0;
+	spin_lock_init(&priv->txqueue_lock);
 
-	setup_timer(&adapter->command_timer, command_timer_fn,
+	setup_timer(&priv->command_timer, command_timer_fn,
 	            (unsigned long)priv);
 
-	INIT_LIST_HEAD(&adapter->cmdfreeq);
-	INIT_LIST_HEAD(&adapter->cmdpendingq);
+	INIT_LIST_HEAD(&priv->cmdfreeq);
+	INIT_LIST_HEAD(&priv->cmdpendingq);
 
-	spin_lock_init(&adapter->driver_lock);
-	init_waitqueue_head(&adapter->cmd_pending);
+	spin_lock_init(&priv->driver_lock);
+	init_waitqueue_head(&priv->cmd_pending);
 
 	/* Allocate the command buffers */
 	if (lbs_allocate_cmd_buffer(priv)) {
@@ -1114,27 +1103,15 @@ out:
 
 static void lbs_free_adapter(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
-
-	if (!adapter) {
-		lbs_deb_fw("why double free adapter?\n");
-		return;
-	}
-
 	lbs_deb_fw("free command buffer\n");
 	lbs_free_cmd_buffer(priv);
 
 	lbs_deb_fw("free command_timer\n");
-	del_timer(&adapter->command_timer);
+	del_timer(&priv->command_timer);
 
 	lbs_deb_fw("free scan results table\n");
-	kfree(adapter->networks);
-	adapter->networks = NULL;
-
-	/* Free the adapter object itself */
-	lbs_deb_fw("free adapter\n");
-	kfree(adapter);
-	priv->adapter = NULL;
+	kfree(priv->networks);
+	priv->networks = NULL;
 }
 
 /**
@@ -1159,13 +1136,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	}
 	priv = dev->priv;
 
-	/* allocate buffer for struct lbs_adapter */
-	priv->adapter = kzalloc(sizeof(struct lbs_adapter), GFP_KERNEL);
-	if (!priv->adapter) {
-		lbs_pr_err("allocate buffer for struct lbs_adapter failed\n");
-		goto err_kzalloc;
-	}
-
 	if (lbs_init_adapter(priv)) {
 		lbs_pr_err("failed to initialize adapter structure.\n");
 		goto err_init_adapter;
@@ -1212,8 +1182,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 
 err_init_adapter:
 	lbs_free_adapter(priv);
-
-err_kzalloc:
 	free_netdev(dev);
 	priv = NULL;
 
@@ -1226,7 +1194,6 @@ EXPORT_SYMBOL_GPL(lbs_add_card);
 
 int lbs_remove_card(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct net_device *dev = priv->dev;
 	union iwreq_data wrqu;
 
@@ -1241,8 +1208,8 @@ int lbs_remove_card(struct lbs_private *priv)
 	cancel_delayed_work(&priv->assoc_work);
 	destroy_workqueue(priv->work_thread);
 
-	if (adapter->psmode == LBS802_11POWERMODEMAX_PSP) {
-		adapter->psmode = LBS802_11POWERMODECAM;
+	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
+		priv->psmode = LBS802_11POWERMODECAM;
 		lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 	}
 
@@ -1251,7 +1218,7 @@ int lbs_remove_card(struct lbs_private *priv)
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
 	/* Stop the thread servicing the interrupts */
-	adapter->surpriseremoved = 1;
+	priv->surpriseremoved = 1;
 	kthread_stop(priv->main_thread);
 
 	lbs_free_adapter(priv);
@@ -1315,12 +1282,12 @@ int lbs_stop_card(struct lbs_private *priv)
 	lbs_debugfs_remove_one(priv);
 
 	/* Flush pending command nodes */
-	spin_lock_irqsave(&priv->adapter->driver_lock, flags);
-	list_for_each_entry(cmdnode, &priv->adapter->cmdpendingq, list) {
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
 		cmdnode->cmdwaitqwoken = 1;
 		wake_up_interruptible(&cmdnode->cmdwait_q);
 	}
-	spin_unlock_irqrestore(&priv->adapter->driver_lock, flags);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	unregister_netdev(dev);
 
@@ -1452,7 +1419,6 @@ struct chan_freq_power *lbs_get_region_cfp_table(u8 region, u8 band, int *cfp_no
 
 int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	int i = 0;
 
@@ -1461,22 +1427,22 @@ int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	memset(adapter->region_channel, 0, sizeof(adapter->region_channel));
+	memset(priv->region_channel, 0, sizeof(priv->region_channel));
 
 	{
 		cfp = lbs_get_region_cfp_table(region, band, &cfp_no);
 		if (cfp != NULL) {
-			adapter->region_channel[i].nrcfp = cfp_no;
-			adapter->region_channel[i].CFP = cfp;
+			priv->region_channel[i].nrcfp = cfp_no;
+			priv->region_channel[i].CFP = cfp;
 		} else {
 			lbs_deb_main("wrong region code %#x in band B/G\n",
 			       region);
 			ret = -1;
 			goto out;
 		}
-		adapter->region_channel[i].valid = 1;
-		adapter->region_channel[i].region = region;
-		adapter->region_channel[i].band = band;
+		priv->region_channel[i].valid = 1;
+		priv->region_channel[i].region = region;
+		priv->region_channel[i].band = band;
 		i++;
 	}
 out:
@@ -1499,12 +1465,12 @@ void lbs_interrupt(struct net_device *dev)
 	lbs_deb_enter(LBS_DEB_THREAD);
 
 	lbs_deb_thread("lbs_interrupt: intcounter=%d\n",
-	       priv->adapter->intcounter);
+	       priv->intcounter);
 
-	priv->adapter->intcounter++;
+	priv->intcounter++;
 
-	if (priv->adapter->psstate == PS_STATE_SLEEP) {
-		priv->adapter->psstate = PS_STATE_AWAKE;
+	if (priv->psstate == PS_STATE_SLEEP) {
+		priv->psstate = PS_STATE_AWAKE;
 		netif_wake_queue(dev);
 		if (priv->mesh_dev)
 			netif_wake_queue(priv->mesh_dev);
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index a252a8f..58e8311 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -48,12 +48,11 @@ static u8 lbs_getavgsnr(struct lbs_private *priv)
 {
 	u8 i;
 	u16 temp = 0;
-	struct lbs_adapter *adapter = priv->adapter;
-	if (adapter->numSNRNF == 0)
+	if (priv->numSNRNF == 0)
 		return 0;
-	for (i = 0; i < adapter->numSNRNF; i++)
-		temp += adapter->rawSNR[i];
-	return (u8) (temp / adapter->numSNRNF);
+	for (i = 0; i < priv->numSNRNF; i++)
+		temp += priv->rawSNR[i];
+	return (u8) (temp / priv->numSNRNF);
 
 }
 
@@ -67,12 +66,11 @@ static u8 lbs_getavgnf(struct lbs_private *priv)
 {
 	u8 i;
 	u16 temp = 0;
-	struct lbs_adapter *adapter = priv->adapter;
-	if (adapter->numSNRNF == 0)
+	if (priv->numSNRNF == 0)
 		return 0;
-	for (i = 0; i < adapter->numSNRNF; i++)
-		temp += adapter->rawNF[i];
-	return (u8) (temp / adapter->numSNRNF);
+	for (i = 0; i < priv->numSNRNF; i++)
+		temp += priv->rawNF[i];
+	return (u8) (temp / priv->numSNRNF);
 
 }
 
@@ -85,14 +83,13 @@ static u8 lbs_getavgnf(struct lbs_private *priv)
  */
 static void lbs_save_rawSNRNF(struct lbs_private *priv, struct rxpd *p_rx_pd)
 {
-	struct lbs_adapter *adapter = priv->adapter;
-	if (adapter->numSNRNF < DEFAULT_DATA_AVG_FACTOR)
-		adapter->numSNRNF++;
-	adapter->rawSNR[adapter->nextSNRNF] = p_rx_pd->snr;
-	adapter->rawNF[adapter->nextSNRNF] = p_rx_pd->nf;
-	adapter->nextSNRNF++;
-	if (adapter->nextSNRNF >= DEFAULT_DATA_AVG_FACTOR)
-		adapter->nextSNRNF = 0;
+	if (priv->numSNRNF < DEFAULT_DATA_AVG_FACTOR)
+		priv->numSNRNF++;
+	priv->rawSNR[priv->nextSNRNF] = p_rx_pd->snr;
+	priv->rawNF[priv->nextSNRNF] = p_rx_pd->nf;
+	priv->nextSNRNF++;
+	if (priv->nextSNRNF >= DEFAULT_DATA_AVG_FACTOR)
+		priv->nextSNRNF = 0;
 	return;
 }
 
@@ -105,32 +102,31 @@ static void lbs_save_rawSNRNF(struct lbs_private *priv, struct rxpd *p_rx_pd)
  */
 static void lbs_compute_rssi(struct lbs_private *priv, struct rxpd *p_rx_pd)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_RX);
 
 	lbs_deb_rx("rxpd: SNR %d, NF %d\n", p_rx_pd->snr, p_rx_pd->nf);
 	lbs_deb_rx("before computing SNR: SNR-avg = %d, NF-avg = %d\n",
-	       adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-	       adapter->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
+	       priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
+	       priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
 
-	adapter->SNR[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->snr;
-	adapter->NF[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->nf;
+	priv->SNR[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->snr;
+	priv->NF[TYPE_RXPD][TYPE_NOAVG] = p_rx_pd->nf;
 	lbs_save_rawSNRNF(priv, p_rx_pd);
 
-	adapter->SNR[TYPE_RXPD][TYPE_AVG] = lbs_getavgsnr(priv) * AVG_SCALE;
-	adapter->NF[TYPE_RXPD][TYPE_AVG] = lbs_getavgnf(priv) * AVG_SCALE;
+	priv->SNR[TYPE_RXPD][TYPE_AVG] = lbs_getavgsnr(priv) * AVG_SCALE;
+	priv->NF[TYPE_RXPD][TYPE_AVG] = lbs_getavgnf(priv) * AVG_SCALE;
 	lbs_deb_rx("after computing SNR: SNR-avg = %d, NF-avg = %d\n",
-	       adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-	       adapter->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
+	       priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
+	       priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
 
-	adapter->RSSI[TYPE_RXPD][TYPE_NOAVG] =
-	    CAL_RSSI(adapter->SNR[TYPE_RXPD][TYPE_NOAVG],
-		     adapter->NF[TYPE_RXPD][TYPE_NOAVG]);
+	priv->RSSI[TYPE_RXPD][TYPE_NOAVG] =
+	    CAL_RSSI(priv->SNR[TYPE_RXPD][TYPE_NOAVG],
+		     priv->NF[TYPE_RXPD][TYPE_NOAVG]);
 
-	adapter->RSSI[TYPE_RXPD][TYPE_AVG] =
-	    CAL_RSSI(adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-		     adapter->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
+	priv->RSSI[TYPE_RXPD][TYPE_AVG] =
+	    CAL_RSSI(priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
+		     priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
 
 	lbs_deb_leave(LBS_DEB_RX);
 }
@@ -139,7 +135,7 @@ void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
 	lbs_deb_rx("skb->data %p\n", skb->data);
 
-	if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
+	if (priv->monitormode != LBS_MONITOR_OFF) {
 		skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
 	} else {
 		if (priv->mesh_dev && IS_MESH_FRAME(skb))
@@ -161,7 +157,6 @@ void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb)
  */
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	struct rxpackethdr *p_rx_pkt;
@@ -174,7 +169,7 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 
 	lbs_deb_enter(LBS_DEB_RX);
 
-	if (priv->adapter->monitormode != LBS_MONITOR_OFF)
+	if (priv->monitormode != LBS_MONITOR_OFF)
 		return process_rxed_802_11_packet(priv, skb);
 
 	p_rx_pkt = (struct rxpackethdr *) skb->data;
@@ -258,8 +253,8 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 	/* Take the data rate from the rxpd structure
 	 * only if the rate is auto
 	 */
-	if (adapter->auto_rate)
-		adapter->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
+	if (priv->auto_rate)
+		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
 
 	lbs_compute_rssi(priv, p_rx_pd);
 
@@ -327,7 +322,6 @@ static u8 convert_mv_rate_to_radiotap(u8 rate)
 static int process_rxed_802_11_packet(struct lbs_private *priv,
 	struct sk_buff *skb)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	struct rx80211packethdr *p_rx_pkt;
@@ -361,7 +355,7 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
 
 	/* create the exported radio header */
-	if (priv->adapter->monitormode == LBS_MONITOR_OFF) {
+	if (priv->monitormode == LBS_MONITOR_OFF) {
 		/* no radio header */
 		/* chop the rxpd */
 		skb_pull(skb, sizeof(struct rxpd));
@@ -410,8 +404,8 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	/* Take the data rate from the rxpd structure
 	 * only if the rate is auto
 	 */
-	if (adapter->auto_rate)
-		adapter->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
+	if (priv->auto_rate)
+		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
 
 	lbs_compute_rssi(priv, prxpd);
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 90c1888..8b6ce61 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -190,13 +190,13 @@ static inline int is_same_network(struct bss_descriptor *src,
  *    0       0        0       0     !=NONE     1      0    0   yes Dynamic WEP
  *
  *
- *  @param adapter A pointer to struct lbs_adapter
+ *  @param priv A pointer to struct lbs_private
  *  @param index   Index in scantable to check against current driver settings
  *  @param mode    Network mode: Infrastructure or IBSS
  *
  *  @return        Index in scantable, or error code if negative
  */
-static int is_network_compatible(struct lbs_adapter *adapter,
+static int is_network_compatible(struct lbs_private *priv,
 		struct bss_descriptor * bss, u8 mode)
 {
 	int matched = 0;
@@ -206,31 +206,31 @@ static int is_network_compatible(struct lbs_adapter *adapter,
 	if (bss->mode != mode)
 		goto done;
 
-	if ((matched = match_bss_no_security(&adapter->secinfo, bss))) {
+	if ((matched = match_bss_no_security(&priv->secinfo, bss))) {
 		goto done;
-	} else if ((matched = match_bss_static_wep(&adapter->secinfo, bss))) {
+	} else if ((matched = match_bss_static_wep(&priv->secinfo, bss))) {
 		goto done;
-	} else if ((matched = match_bss_wpa(&adapter->secinfo, bss))) {
+	} else if ((matched = match_bss_wpa(&priv->secinfo, bss))) {
 		lbs_deb_scan(
 		       "is_network_compatible() WPA: wpa_ie 0x%x "
 		       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
 		       "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
-		       adapter->secinfo.wep_enabled ? "e" : "d",
-		       adapter->secinfo.WPAenabled ? "e" : "d",
-		       adapter->secinfo.WPA2enabled ? "e" : "d",
+		       priv->secinfo.wep_enabled ? "e" : "d",
+		       priv->secinfo.WPAenabled ? "e" : "d",
+		       priv->secinfo.WPA2enabled ? "e" : "d",
 		       (bss->capability & WLAN_CAPABILITY_PRIVACY));
 		goto done;
-	} else if ((matched = match_bss_wpa2(&adapter->secinfo, bss))) {
+	} else if ((matched = match_bss_wpa2(&priv->secinfo, bss))) {
 		lbs_deb_scan(
 		       "is_network_compatible() WPA2: wpa_ie 0x%x "
 		       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
 		       "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
-		       adapter->secinfo.wep_enabled ? "e" : "d",
-		       adapter->secinfo.WPAenabled ? "e" : "d",
-		       adapter->secinfo.WPA2enabled ? "e" : "d",
+		       priv->secinfo.wep_enabled ? "e" : "d",
+		       priv->secinfo.WPAenabled ? "e" : "d",
+		       priv->secinfo.WPA2enabled ? "e" : "d",
 		       (bss->capability & WLAN_CAPABILITY_PRIVACY));
 		goto done;
-	} else if ((matched = match_bss_dynamic_wep(&adapter->secinfo, bss))) {
+	} else if ((matched = match_bss_dynamic_wep(&priv->secinfo, bss))) {
 		lbs_deb_scan(
 		       "is_network_compatible() dynamic WEP: "
 		       "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
@@ -244,9 +244,9 @@ static int is_network_compatible(struct lbs_adapter *adapter,
 	       "is_network_compatible() FAILED: wpa_ie 0x%x "
 	       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
 	       bss->wpa_ie[0], bss->rsn_ie[0],
-	       adapter->secinfo.wep_enabled ? "e" : "d",
-	       adapter->secinfo.WPAenabled ? "e" : "d",
-	       adapter->secinfo.WPA2enabled ? "e" : "d",
+	       priv->secinfo.wep_enabled ? "e" : "d",
+	       priv->secinfo.WPAenabled ? "e" : "d",
+	       priv->secinfo.WPA2enabled ? "e" : "d",
 	       (bss->capability & WLAN_CAPABILITY_PRIVACY));
 
 done:
@@ -298,7 +298,6 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
 					  u8 filteredscan)
 {
 
-	struct lbs_adapter *adapter = priv->adapter;
 	struct region_channel *scanregion;
 	struct chan_freq_power *cfp;
 	int rgnidx;
@@ -314,22 +313,22 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
 	 */
 	scantype = CMD_SCAN_TYPE_ACTIVE;
 
-	for (rgnidx = 0; rgnidx < ARRAY_SIZE(adapter->region_channel); rgnidx++) {
-		if (priv->adapter->enable11d &&
-		    (adapter->connect_status != LBS_CONNECTED) &&
-		    (adapter->mesh_connect_status != LBS_CONNECTED)) {
+	for (rgnidx = 0; rgnidx < ARRAY_SIZE(priv->region_channel); rgnidx++) {
+		if (priv->enable11d &&
+		    (priv->connect_status != LBS_CONNECTED) &&
+		    (priv->mesh_connect_status != LBS_CONNECTED)) {
 			/* Scan all the supported chan for the first scan */
-			if (!adapter->universal_channel[rgnidx].valid)
+			if (!priv->universal_channel[rgnidx].valid)
 				continue;
-			scanregion = &adapter->universal_channel[rgnidx];
+			scanregion = &priv->universal_channel[rgnidx];
 
 			/* clear the parsed_region_chan for the first scan */
-			memset(&adapter->parsed_region_chan, 0x00,
-			       sizeof(adapter->parsed_region_chan));
+			memset(&priv->parsed_region_chan, 0x00,
+			       sizeof(priv->parsed_region_chan));
 		} else {
-			if (!adapter->region_channel[rgnidx].valid)
+			if (!priv->region_channel[rgnidx].valid)
 				continue;
-			scanregion = &adapter->region_channel[rgnidx];
+			scanregion = &priv->region_channel[rgnidx];
 		}
 
 		for (nextchan = 0;
@@ -337,10 +336,10 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
 
 			cfp = scanregion->CFP + nextchan;
 
-			if (priv->adapter->enable11d) {
+			if (priv->enable11d) {
 				scantype =
 				    lbs_get_scan_type_11d(cfp->channel,
-							   &adapter->
+							   &priv->
 							   parsed_region_chan);
 			}
 
@@ -540,7 +539,6 @@ int lbs_scan_networks(struct lbs_private *priv,
 	const struct lbs_ioctl_user_scan_cfg *user_cfg,
                        int full_scan)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = -ENOMEM;
 	struct chanscanparamset *chan_list;
 	struct chanscanparamset *curr_chans;
@@ -598,12 +596,12 @@ int lbs_scan_networks(struct lbs_private *priv,
 
 	/* Prepare to continue an interrupted scan */
 	lbs_deb_scan("chan_count %d, last_scanned_channel %d\n",
-		chan_count, adapter->last_scanned_channel);
+		chan_count, priv->last_scanned_channel);
 	curr_chans = chan_list;
 	/* advance channel list by already-scanned-channels */
-	if (adapter->last_scanned_channel > 0) {
-		curr_chans += adapter->last_scanned_channel;
-		chan_count -= adapter->last_scanned_channel;
+	if (priv->last_scanned_channel > 0) {
+		curr_chans += priv->last_scanned_channel;
+		chan_count -= priv->last_scanned_channel;
 	}
 
 	/* Send scan command(s)
@@ -627,12 +625,12 @@ int lbs_scan_networks(struct lbs_private *priv,
 		/* somehow schedule the next part of the scan */
 		if (chan_count &&
 		    !full_scan &&
-		    !priv->adapter->surpriseremoved) {
+		    !priv->surpriseremoved) {
 			/* -1 marks just that we're currently scanning */
-			if (adapter->last_scanned_channel < 0)
-				adapter->last_scanned_channel = to_scan;
+			if (priv->last_scanned_channel < 0)
+				priv->last_scanned_channel = to_scan;
 			else
-				adapter->last_scanned_channel += to_scan;
+				priv->last_scanned_channel += to_scan;
 			cancel_delayed_work(&priv->scan_work);
 			queue_delayed_work(priv->work_thread, &priv->scan_work,
 				msecs_to_jiffies(300));
@@ -646,24 +644,24 @@ int lbs_scan_networks(struct lbs_private *priv,
 
 #ifdef CONFIG_LIBERTAS_DEBUG
 	/* Dump the scan table */
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 	lbs_deb_scan("scan table:\n");
-	list_for_each_entry(iter, &adapter->network_list, list)
+	list_for_each_entry(iter, &priv->network_list, list)
 		lbs_deb_scan("%02d: BSSID %s, RSSI %d, SSID '%s'\n",
 		       i++, print_mac(mac, iter->bssid), (s32) iter->rssi,
 		       escape_essid(iter->ssid, iter->ssid_len));
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 #endif
 
 out2:
-	adapter->last_scanned_channel = 0;
+	priv->last_scanned_channel = 0;
 
 out:
-	if (adapter->connect_status == LBS_CONNECTED) {
+	if (priv->connect_status == LBS_CONNECTED) {
 		netif_carrier_on(priv->dev);
 		netif_wake_queue(priv->dev);
 	}
-	if (priv->mesh_dev && (adapter->mesh_connect_status == LBS_CONNECTED)) {
+	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
 		netif_carrier_on(priv->mesh_dev);
 		netif_wake_queue(priv->mesh_dev);
 	}
@@ -931,13 +929,13 @@ done:
  *
  *  Used in association code
  *
- *  @param adapter  A pointer to struct lbs_adapter
+ *  @param priv  A pointer to struct lbs_private
  *  @param bssid    BSSID to find in the scan list
  *  @param mode     Network mode: Infrastructure or IBSS
  *
  *  @return         index in BSSID list, or error return code (< 0)
  */
-struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
 		u8 * bssid, u8 mode)
 {
 	struct bss_descriptor * iter_bss;
@@ -955,14 +953,14 @@ struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_adapter *adapter,
 	 *   continue past a matched bssid that is not compatible in case there
 	 *   is an AP with multiple SSIDs assigned to the same BSSID
 	 */
-	mutex_lock(&adapter->lock);
-	list_for_each_entry (iter_bss, &adapter->network_list, list) {
+	mutex_lock(&priv->lock);
+	list_for_each_entry (iter_bss, &priv->network_list, list) {
 		if (compare_ether_addr(iter_bss->bssid, bssid))
 			continue; /* bssid doesn't match */
 		switch (mode) {
 		case IW_MODE_INFRA:
 		case IW_MODE_ADHOC:
-			if (!is_network_compatible(adapter, iter_bss, mode))
+			if (!is_network_compatible(priv, iter_bss, mode))
 				break;
 			found_bss = iter_bss;
 			break;
@@ -971,7 +969,7 @@ struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_adapter *adapter,
 			break;
 		}
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
@@ -983,14 +981,14 @@ out:
  *
  *  Used in association code
  *
- *  @param adapter  A pointer to struct lbs_adapter
+ *  @param priv  A pointer to struct lbs_private
  *  @param ssid     SSID to find in the list
  *  @param bssid    BSSID to qualify the SSID selection (if provided)
  *  @param mode     Network mode: Infrastructure or IBSS
  *
  *  @return         index in BSSID list
  */
-struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
 		   u8 *ssid, u8 ssid_len, u8 * bssid, u8 mode,
 		   int channel)
 {
@@ -1001,9 +999,9 @@ struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 
-	list_for_each_entry (iter_bss, &adapter->network_list, list) {
+	list_for_each_entry (iter_bss, &priv->network_list, list) {
 		if (   !tmp_oldest
 		    || (iter_bss->last_scanned < tmp_oldest->last_scanned))
 			tmp_oldest = iter_bss;
@@ -1019,7 +1017,7 @@ struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
 		switch (mode) {
 		case IW_MODE_INFRA:
 		case IW_MODE_ADHOC:
-			if (!is_network_compatible(adapter, iter_bss, mode))
+			if (!is_network_compatible(priv, iter_bss, mode))
 				break;
 
 			if (bssid) {
@@ -1044,7 +1042,7 @@ struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
 	}
 
 out:
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
 	return found_bss;
 }
@@ -1055,12 +1053,12 @@ out:
  *  Search the scan table for the best SSID that also matches the current
  *   adapter network preference (infrastructure or adhoc)
  *
- *  @param adapter  A pointer to struct lbs_adapter
+ *  @param priv  A pointer to struct lbs_private
  *
  *  @return         index in BSSID list
  */
 static struct bss_descriptor *lbs_find_best_ssid_in_list(
-	struct lbs_adapter *adapter,
+	struct lbs_private *priv,
 	u8 mode)
 {
 	u8 bestrssi = 0;
@@ -1069,13 +1067,13 @@ static struct bss_descriptor *lbs_find_best_ssid_in_list(
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 
-	list_for_each_entry (iter_bss, &adapter->network_list, list) {
+	list_for_each_entry (iter_bss, &priv->network_list, list) {
 		switch (mode) {
 		case IW_MODE_INFRA:
 		case IW_MODE_ADHOC:
-			if (!is_network_compatible(adapter, iter_bss, mode))
+			if (!is_network_compatible(priv, iter_bss, mode))
 				break;
 			if (SCAN_RSSI(iter_bss->rssi) <= bestrssi)
 				break;
@@ -1092,7 +1090,7 @@ static struct bss_descriptor *lbs_find_best_ssid_in_list(
 		}
 	}
 
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 	lbs_deb_leave_args(LBS_DEB_SCAN, "best_bss %p", best_bss);
 	return best_bss;
 }
@@ -1110,17 +1108,16 @@ static struct bss_descriptor *lbs_find_best_ssid_in_list(
 int lbs_find_best_network_ssid(struct lbs_private *priv,
 		u8 *out_ssid, u8 *out_ssid_len, u8 preferred_mode, u8 *out_mode)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = -1;
 	struct bss_descriptor * found;
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
 	lbs_scan_networks(priv, NULL, 1);
-	if (adapter->surpriseremoved)
+	if (priv->surpriseremoved)
 		goto out;
 
-	found = lbs_find_best_ssid_in_list(adapter, preferred_mode);
+	found = lbs_find_best_ssid_in_list(priv, preferred_mode);
 	if (found && (found->ssid_len > 0)) {
 		memcpy(out_ssid, &found->ssid, IW_ESSID_MAX_SIZE);
 		*out_ssid_len = found->ssid_len;
@@ -1150,7 +1147,6 @@ out:
 int lbs_send_specific_ssid_scan(struct lbs_private *priv,
 			u8 *ssid, u8 ssid_len, u8 clear_ssid)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct lbs_ioctl_user_scan_cfg scancfg;
 	int ret = 0;
 
@@ -1166,7 +1162,7 @@ int lbs_send_specific_ssid_scan(struct lbs_private *priv,
 	scancfg.clear_ssid = clear_ssid;
 
 	lbs_scan_networks(priv, &scancfg, 1);
-	if (adapter->surpriseremoved) {
+	if (priv->surpriseremoved) {
 		ret = -1;
 		goto out;
 	}
@@ -1192,7 +1188,6 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
 					char *start, char *stop,
 					struct bss_descriptor *bss)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct chan_freq_power *cfp;
 	char *current_val;	/* For rates */
 	struct iw_event iwe;	/* Temporary buffer */
@@ -1204,7 +1199,7 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
-	cfp = lbs_find_cfp_by_band_and_channel(adapter, 0, bss->channel);
+	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, bss->channel);
 	if (!cfp) {
 		lbs_deb_scan("Invalid channel number %d\n", bss->channel);
 		start = NULL;
@@ -1247,25 +1242,25 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
 	if (iwe.u.qual.qual > 100)
 		iwe.u.qual.qual = 100;
 
-	if (adapter->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
+	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
 		iwe.u.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
 	} else {
 		iwe.u.qual.noise =
-		    CAL_NF(adapter->NF[TYPE_BEACON][TYPE_NOAVG]);
+		    CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
 	}
 
 	/* Locally created ad-hoc BSSs won't have beacons if this is the
 	 * only station in the adhoc network; so get signal strength
 	 * from receive statistics.
 	 */
-	if ((adapter->mode == IW_MODE_ADHOC)
-	    && adapter->adhoccreate
-	    && !lbs_ssid_cmp(adapter->curbssparams.ssid,
-	                          adapter->curbssparams.ssid_len,
+	if ((priv->mode == IW_MODE_ADHOC)
+	    && priv->adhoccreate
+	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
+	                          priv->curbssparams.ssid_len,
 	                          bss->ssid, bss->ssid_len)) {
 		int snr, nf;
-		snr = adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		nf = adapter->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
+		snr = priv->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
+		nf = priv->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
 		iwe.u.qual.level = CAL_RSSI(snr, nf);
 	}
 	start = iwe_stream_add_event(start, stop, &iwe, IW_EV_QUAL_LEN);
@@ -1294,10 +1289,10 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
 					 stop, &iwe, IW_EV_PARAM_LEN);
 	}
 	if ((bss->mode == IW_MODE_ADHOC)
-	    && !lbs_ssid_cmp(adapter->curbssparams.ssid,
-	                          adapter->curbssparams.ssid_len,
+	    && !lbs_ssid_cmp(priv->curbssparams.ssid,
+	                          priv->curbssparams.ssid_len,
 	                          bss->ssid, bss->ssid_len)
-	    && adapter->adhoccreate) {
+	    && priv->adhoccreate) {
 		iwe.u.bitrate.value = 22 * 500000;
 		current_val = iwe_stream_add_value(start, current_val,
 					 stop, &iwe, IW_EV_PARAM_LEN);
@@ -1356,7 +1351,6 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *wrqu, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
@@ -1380,9 +1374,9 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 		queue_delayed_work(priv->work_thread, &priv->scan_work,
 			msecs_to_jiffies(50));
 	/* set marker that currently a scan is taking place */
-	adapter->last_scanned_channel = -1;
+	priv->last_scanned_channel = -1;
 
-	if (adapter->surpriseremoved)
+	if (priv->surpriseremoved)
 		return -EIO;
 
 	lbs_deb_leave(LBS_DEB_SCAN);
@@ -1405,7 +1399,6 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 {
 #define SCAN_ITEM_SIZE 128
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int err = 0;
 	char *ev = extra;
 	char *stop = ev + dwrq->length;
@@ -1415,17 +1408,17 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 	lbs_deb_enter(LBS_DEB_SCAN);
 
 	/* iwlist should wait until the current scan is finished */
-	if (adapter->last_scanned_channel)
+	if (priv->last_scanned_channel)
 		return -EAGAIN;
 
 	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
-	if ((adapter->mode == IW_MODE_ADHOC) && adapter->adhoccreate) {
+	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate) {
 		lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
 					CMD_OPTION_WAITFORRSP, 0, NULL);
 	}
 
-	mutex_lock(&adapter->lock);
-	list_for_each_entry_safe (iter_bss, safe, &adapter->network_list, list) {
+	mutex_lock(&priv->lock);
+	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
 		char * next_ev;
 		unsigned long stale_time;
 
@@ -1442,7 +1435,7 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 		stale_time = iter_bss->last_scanned + DEFAULT_MAX_SCAN_AGE;
 		if (time_after(jiffies, stale_time)) {
 			list_move_tail (&iter_bss->list,
-			                &adapter->network_free_list);
+			                &priv->network_free_list);
 			clear_bss_descriptor(iter_bss);
 			continue;
 		}
@@ -1453,7 +1446,7 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 			continue;
 		ev = next_ev;
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	dwrq->length = (ev - extra);
 	dwrq->flags = 0;
@@ -1538,7 +1531,6 @@ int lbs_cmd_80211_scan(struct lbs_private *priv,
  */
 int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct cmd_ds_802_11_scan_rsp *pscan;
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * safe;
@@ -1552,11 +1544,11 @@ int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
 	lbs_deb_enter(LBS_DEB_SCAN);
 
 	/* Prune old entries from scan table */
-	list_for_each_entry_safe (iter_bss, safe, &adapter->network_list, list) {
+	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
 		unsigned long stale_time = iter_bss->last_scanned + DEFAULT_MAX_SCAN_AGE;
 		if (time_before(jiffies, stale_time))
 			continue;
-		list_move_tail (&iter_bss->list, &adapter->network_free_list);
+		list_move_tail (&iter_bss->list, &priv->network_free_list);
 		clear_bss_descriptor(iter_bss);
 	}
 
@@ -1609,7 +1601,7 @@ int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
 		}
 
 		/* Try to find this bss in the scan table */
-		list_for_each_entry (iter_bss, &adapter->network_list, list) {
+		list_for_each_entry (iter_bss, &priv->network_list, list) {
 			if (is_same_network(iter_bss, &new)) {
 				found = iter_bss;
 				break;
@@ -1623,16 +1615,16 @@ int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
 		if (found) {
 			/* found, clear it */
 			clear_bss_descriptor(found);
-		} else if (!list_empty(&adapter->network_free_list)) {
+		} else if (!list_empty(&priv->network_free_list)) {
 			/* Pull one from the free list */
-			found = list_entry(adapter->network_free_list.next,
+			found = list_entry(priv->network_free_list.next,
 					   struct bss_descriptor, list);
-			list_move_tail(&found->list, &adapter->network_list);
+			list_move_tail(&found->list, &priv->network_list);
 		} else if (oldest) {
 			/* If there are no more slots, expire the oldest */
 			found = oldest;
 			clear_bss_descriptor(found);
-			list_move_tail(&found->list, &adapter->network_list);
+			list_move_tail(&found->list, &priv->network_list);
 		} else {
 			continue;
 		}
diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
index 9b62e2b..319f70d 100644
--- a/drivers/net/wireless/libertas/scan.h
+++ b/drivers/net/wireless/libertas/scan.h
@@ -10,8 +10,6 @@
 #include <net/ieee80211.h>
 #include "hostcmd.h"
 
-struct lbs_adapter;
-
 /**
  *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
  *
@@ -168,11 +166,11 @@ struct bss_descriptor {
 
 int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len);
 
-struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_ssid_in_list(struct lbs_private *priv,
 		u8 *ssid, u8 ssid_len, u8 *bssid, u8 mode,
 		int channel);
 
-struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_adapter *adapter,
+struct bss_descriptor *lbs_find_bssid_in_list(struct lbs_private *priv,
 	u8 *bssid, u8 mode);
 
 int lbs_find_best_network_ssid(struct lbs_private *priv, u8 *out_ssid,
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 131ef3f..4cb39d3 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -64,11 +64,11 @@ static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 	u8 *p802x_hdr;
 	struct tx_radiotap_hdr *pradiotap_hdr;
 	u32 new_rate;
-	u8 *ptr = priv->adapter->tmptxbuf;
+	u8 *ptr = priv->tmptxbuf;
 
 	lbs_deb_enter(LBS_DEB_TX);
 
-	if (priv->adapter->surpriseremoved)
+	if (priv->surpriseremoved)
 		return -1;
 
 	if (!skb->len || (skb->len > MRVDRV_ETH_TX_PACKET_BUFFER_SIZE)) {
@@ -86,7 +86,7 @@ static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 	plocaltxpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
 
 	p802x_hdr = skb->data;
-	if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
+	if (priv->monitormode != LBS_MONITOR_OFF) {
 
 		/* locate radiotap header */
 		pradiotap_hdr = (struct tx_radiotap_hdr *)skb->data;
@@ -106,7 +106,7 @@ static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 
 	}
 	/* copy destination address from 802.3 or 802.11 header */
-	if (priv->adapter->monitormode != LBS_MONITOR_OFF)
+	if (priv->monitormode != LBS_MONITOR_OFF)
 		memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
 	else
 		memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
@@ -124,7 +124,7 @@ static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 	lbs_deb_hex(LBS_DEB_TX, "Tx Data", (u8 *) p802x_hdr, le16_to_cpu(plocaltxpd->tx_packet_length));
 	memcpy(ptr, p802x_hdr, le16_to_cpu(plocaltxpd->tx_packet_length));
 	ret = priv->hw_host_to_card(priv, MVMS_DAT,
-				    priv->adapter->tmptxbuf,
+				    priv->tmptxbuf,
 				    le16_to_cpu(plocaltxpd->tx_packet_length) +
 				    sizeof(struct txpd));
 
@@ -144,7 +144,7 @@ done:
 		priv->stats.tx_errors++;
 	}
 
-	if (!ret && priv->adapter->monitormode != LBS_MONITOR_OFF) {
+	if (!ret && priv->monitormode != LBS_MONITOR_OFF) {
 		/* Keep the skb to echo it back once Tx feedback is
 		   received from FW */
 		skb_orphan(skb);
@@ -154,7 +154,7 @@ done:
 			netif_stop_queue(priv->mesh_dev);
 
 		/* Keep the skb around for when we get feedback */
-		priv->adapter->currenttxskb = skb;
+		priv->currenttxskb = skb;
 	} else {
 		dev_kfree_skb_any(skb);
 	}
@@ -166,29 +166,27 @@ done:
 
 void lbs_tx_runqueue(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	int i;
 
-	spin_lock(&adapter->txqueue_lock);
-	for (i = 0; i < adapter->tx_queue_idx; i++) {
-		struct sk_buff *skb = adapter->tx_queue_ps[i];
-		spin_unlock(&adapter->txqueue_lock);
+	spin_lock(&priv->txqueue_lock);
+	for (i = 0; i < priv->tx_queue_idx; i++) {
+		struct sk_buff *skb = priv->tx_queue_ps[i];
+		spin_unlock(&priv->txqueue_lock);
 		SendSinglePacket(priv, skb);
-		spin_lock(&adapter->txqueue_lock);
+		spin_lock(&priv->txqueue_lock);
 	}
-	adapter->tx_queue_idx = 0;
-	spin_unlock(&adapter->txqueue_lock);
+	priv->tx_queue_idx = 0;
+	spin_unlock(&priv->txqueue_lock);
 }
 
 static void lbs_tx_queue(struct lbs_private *priv, struct sk_buff *skb)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 
-	spin_lock(&adapter->txqueue_lock);
+	spin_lock(&priv->txqueue_lock);
 
-	WARN_ON(priv->adapter->tx_queue_idx >= NR_TX_QUEUE);
-	adapter->tx_queue_ps[adapter->tx_queue_idx++] = skb;
-	if (adapter->tx_queue_idx == NR_TX_QUEUE) {
+	WARN_ON(priv->tx_queue_idx >= NR_TX_QUEUE);
+	priv->tx_queue_ps[priv->tx_queue_idx++] = skb;
+	if (priv->tx_queue_idx == NR_TX_QUEUE) {
 		netif_stop_queue(priv->dev);
 		if (priv->mesh_dev)
 			netif_stop_queue(priv->mesh_dev);
@@ -198,7 +196,7 @@ static void lbs_tx_queue(struct lbs_private *priv, struct sk_buff *skb)
 			netif_start_queue(priv->mesh_dev);
 	}
 
-	spin_unlock(&adapter->txqueue_lock);
+	spin_unlock(&priv->txqueue_lock);
 }
 
 /**
@@ -221,8 +219,8 @@ int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 		goto done;
 	}
 
-	if ((priv->adapter->psstate == PS_STATE_SLEEP) ||
-	    (priv->adapter->psstate == PS_STATE_PRE_SLEEP)) {
+	if ((priv->psstate == PS_STATE_SLEEP) ||
+	    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 		lbs_tx_queue(priv, skb);
 		return ret;
 	}
@@ -244,17 +242,16 @@ done:
  */
 void lbs_send_tx_feedback(struct lbs_private *priv)
 {
-	struct lbs_adapter *adapter = priv->adapter;
 	struct tx_radiotap_hdr *radiotap_hdr;
-	u32 status = adapter->eventcause;
+	u32 status = priv->eventcause;
 	int txfail;
 	int try_count;
 
-	if (adapter->monitormode == LBS_MONITOR_OFF ||
-	    adapter->currenttxskb == NULL)
+	if (priv->monitormode == LBS_MONITOR_OFF ||
+	    priv->currenttxskb == NULL)
 		return;
 
-	radiotap_hdr = (struct tx_radiotap_hdr *)adapter->currenttxskb->data;
+	radiotap_hdr = (struct tx_radiotap_hdr *)priv->currenttxskb->data;
 
 	txfail = (status >> 24);
 
@@ -267,14 +264,14 @@ void lbs_send_tx_feedback(struct lbs_private *priv)
 #endif
 	try_count = (status >> 16) & 0xff;
 	radiotap_hdr->data_retries = (try_count) ?
-	    (1 + adapter->txretrycount - try_count) : 0;
-	lbs_upload_rx_packet(priv, adapter->currenttxskb);
-	adapter->currenttxskb = NULL;
+	    (1 + priv->txretrycount - try_count) : 0;
+	lbs_upload_rx_packet(priv, priv->currenttxskb);
+	priv->currenttxskb = NULL;
 
-	if (adapter->connect_status == LBS_CONNECTED)
+	if (priv->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev && (adapter->mesh_connect_status == LBS_CONNECTED))
+	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED))
 		netif_wake_queue(priv->mesh_dev);
 }
 EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 1af140b..1e0b224 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -23,7 +23,7 @@
 
 static inline void lbs_postpone_association_work(struct lbs_private *priv)
 {
-	if (priv->adapter->surpriseremoved)
+	if (priv->surpriseremoved)
 		return;
 	cancel_delayed_work(&priv->assoc_work);
 	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
@@ -32,21 +32,21 @@ static inline void lbs_postpone_association_work(struct lbs_private *priv)
 static inline void lbs_cancel_association_work(struct lbs_private *priv)
 {
 	cancel_delayed_work(&priv->assoc_work);
-	kfree(priv->adapter->pending_assoc_req);
-	priv->adapter->pending_assoc_req = NULL;
+	kfree(priv->pending_assoc_req);
+	priv->pending_assoc_req = NULL;
 }
 
 
 /**
  *  @brief Find the channel frequency power info with specific channel
  *
- *  @param adapter 	A pointer to struct lbs_adapter structure
+ *  @param priv 	A pointer to struct lbs_private structure
  *  @param band		it can be BAND_A, BAND_G or BAND_B
  *  @param channel      the channel for looking
  *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
  */
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_adapter *adapter,
+	struct lbs_private *priv,
 	u8 band,
 	u16 channel)
 {
@@ -54,11 +54,11 @@ struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
 	struct region_channel *rc;
 	int i, j;
 
-	for (j = 0; !cfp && (j < ARRAY_SIZE(adapter->region_channel)); j++) {
-		rc = &adapter->region_channel[j];
+	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
+		rc = &priv->region_channel[j];
 
-		if (adapter->enable11d)
-			rc = &adapter->universal_channel[j];
+		if (priv->enable11d)
+			rc = &priv->universal_channel[j];
 		if (!rc->valid || !rc->CFP)
 			continue;
 		if (rc->band != band)
@@ -81,13 +81,13 @@ struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
 /**
  *  @brief Find the channel frequency power info with specific frequency
  *
- *  @param adapter 	A pointer to struct lbs_adapter structure
+ *  @param priv 	A pointer to struct lbs_private structure
  *  @param band		it can be BAND_A, BAND_G or BAND_B
  *  @param freq	        the frequency for looking
  *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
  */
 static struct chan_freq_power *find_cfp_by_band_and_freq(
-	struct lbs_adapter *adapter,
+	struct lbs_private *priv,
 	u8 band,
 	u32 freq)
 {
@@ -95,11 +95,11 @@ static struct chan_freq_power *find_cfp_by_band_and_freq(
 	struct region_channel *rc;
 	int i, j;
 
-	for (j = 0; !cfp && (j < ARRAY_SIZE(adapter->region_channel)); j++) {
-		rc = &adapter->region_channel[j];
+	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
+		rc = &priv->region_channel[j];
 
-		if (adapter->enable11d)
-			rc = &adapter->universal_channel[j];
+		if (priv->enable11d)
+			rc = &priv->universal_channel[j];
 		if (!rc->valid || !rc->CFP)
 			continue;
 		if (rc->band != band)
@@ -130,13 +130,12 @@ static struct chan_freq_power *find_cfp_by_band_and_freq(
 static int lbs_radio_ioctl(struct lbs_private *priv, u8 option)
 {
 	int ret = 0;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (adapter->radioon != option) {
+	if (priv->radioon != option) {
 		lbs_deb_wext("switching radio %s\n", option ? "on" : "off");
-		adapter->radioon = option;
+		priv->radioon = option;
 
 		ret = lbs_prepare_and_send_command(priv,
 					    CMD_802_11_RADIO_CONTROL,
@@ -151,18 +150,18 @@ static int lbs_radio_ioctl(struct lbs_private *priv, u8 option)
 /**
  *  @brief Copy active data rates based on adapter mode and status
  *
- *  @param adapter              A pointer to struct lbs_adapter structure
+ *  @param priv              A pointer to struct lbs_private structure
  *  @param rate		        The buf to return the active rates
  */
-static void copy_active_data_rates(struct lbs_adapter *adapter, u8 *rates)
+static void copy_active_data_rates(struct lbs_private *priv, u8 *rates)
 {
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if ((adapter->connect_status != LBS_CONNECTED) &&
-		(adapter->mesh_connect_status != LBS_CONNECTED))
+	if ((priv->connect_status != LBS_CONNECTED) &&
+		(priv->mesh_connect_status != LBS_CONNECTED))
 		memcpy(rates, lbs_bg_rates, MAX_RATES);
 	else
-		memcpy(rates, adapter->curbssparams.rates, MAX_RATES);
+		memcpy(rates, priv->curbssparams.rates, MAX_RATES);
 
 	lbs_deb_leave(LBS_DEB_WEXT);
 }
@@ -184,18 +183,17 @@ static int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_freq *fwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct chan_freq_power *cfp;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	cfp = lbs_find_cfp_by_band_and_channel(adapter, 0,
-					   adapter->curbssparams.channel);
+	cfp = lbs_find_cfp_by_band_and_channel(priv, 0,
+					   priv->curbssparams.channel);
 
 	if (!cfp) {
-		if (adapter->curbssparams.channel)
+		if (priv->curbssparams.channel)
 			lbs_deb_wext("invalid channel %d\n",
-			       adapter->curbssparams.channel);
+			       priv->curbssparams.channel);
 		return -EINVAL;
 	}
 
@@ -211,12 +209,11 @@ static int lbs_get_wap(struct net_device *dev, struct iw_request_info *info,
 			struct sockaddr *awrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (adapter->connect_status == LBS_CONNECTED) {
-		memcpy(awrq->sa_data, adapter->curbssparams.bssid, ETH_ALEN);
+	if (priv->connect_status == LBS_CONNECTED) {
+		memcpy(awrq->sa_data, priv->curbssparams.bssid, ETH_ALEN);
 	} else {
 		memset(awrq->sa_data, 0, ETH_ALEN);
 	}
@@ -230,7 +227,6 @@ static int lbs_set_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -242,10 +238,10 @@ static int lbs_set_nick(struct net_device *dev, struct iw_request_info *info,
 		return -E2BIG;
 	}
 
-	mutex_lock(&adapter->lock);
-	memset(adapter->nodename, 0, sizeof(adapter->nodename));
-	memcpy(adapter->nodename, extra, dwrq->length);
-	mutex_unlock(&adapter->lock);
+	mutex_lock(&priv->lock);
+	memset(priv->nodename, 0, sizeof(priv->nodename));
+	memcpy(priv->nodename, extra, dwrq->length);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
@@ -255,12 +251,11 @@ static int lbs_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	dwrq->length = strlen(adapter->nodename);
-	memcpy(extra, adapter->nodename, dwrq->length);
+	dwrq->length = strlen(priv->nodename);
+	memcpy(extra, priv->nodename, dwrq->length);
 	extra[dwrq->length] = '\0';
 
 	dwrq->flags = 1;	/* active */
@@ -273,13 +268,12 @@ static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	/* Use nickname to indicate that mesh is on */
 
-	if (adapter->mesh_connect_status == LBS_CONNECTED) {
+	if (priv->mesh_connect_status == LBS_CONNECTED) {
 		strncpy(extra, "Mesh", 12);
 		extra[12] = '\0';
 		dwrq->length = strlen(extra);
@@ -299,17 +293,16 @@ static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	u32 rthr = vwrq->value;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	if (vwrq->disabled) {
-		adapter->rtsthsd = rthr = MRVDRV_RTS_MAX_VALUE;
+		priv->rtsthsd = rthr = MRVDRV_RTS_MAX_VALUE;
 	} else {
 		if (rthr < MRVDRV_RTS_MIN_VALUE || rthr > MRVDRV_RTS_MAX_VALUE)
 			return -EINVAL;
-		adapter->rtsthsd = rthr;
+		priv->rtsthsd = rthr;
 	}
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
@@ -325,18 +318,17 @@ static int lbs_get_rts(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	adapter->rtsthsd = 0;
+	priv->rtsthsd = 0;
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
 				    CMD_ACT_GET, CMD_OPTION_WAITFORRSP,
 				    OID_802_11_RTS_THRESHOLD, NULL);
 	if (ret)
 		goto out;
 
-	vwrq->value = adapter->rtsthsd;
+	vwrq->value = priv->rtsthsd;
 	vwrq->disabled = ((vwrq->value < MRVDRV_RTS_MIN_VALUE)
 			  || (vwrq->value > MRVDRV_RTS_MAX_VALUE));
 	vwrq->fixed = 1;
@@ -352,17 +344,16 @@ static int lbs_set_frag(struct net_device *dev, struct iw_request_info *info,
 	int ret = 0;
 	u32 fthr = vwrq->value;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	if (vwrq->disabled) {
-		adapter->fragthsd = fthr = MRVDRV_FRAG_MAX_VALUE;
+		priv->fragthsd = fthr = MRVDRV_FRAG_MAX_VALUE;
 	} else {
 		if (fthr < MRVDRV_FRAG_MIN_VALUE
 		    || fthr > MRVDRV_FRAG_MAX_VALUE)
 			return -EINVAL;
-		adapter->fragthsd = fthr;
+		priv->fragthsd = fthr;
 	}
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
@@ -378,11 +369,10 @@ static int lbs_get_frag(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	adapter->fragthsd = 0;
+	priv->fragthsd = 0;
 	ret = lbs_prepare_and_send_command(priv,
 				    CMD_802_11_SNMP_MIB,
 				    CMD_ACT_GET, CMD_OPTION_WAITFORRSP,
@@ -390,7 +380,7 @@ static int lbs_get_frag(struct net_device *dev, struct iw_request_info *info,
 	if (ret)
 		goto out;
 
-	vwrq->value = adapter->fragthsd;
+	vwrq->value = priv->fragthsd;
 	vwrq->disabled = ((vwrq->value < MRVDRV_FRAG_MIN_VALUE)
 			  || (vwrq->value > MRVDRV_FRAG_MAX_VALUE));
 	vwrq->fixed = 1;
@@ -404,11 +394,10 @@ static int lbs_get_mode(struct net_device *dev,
 			 struct iw_request_info *info, u32 * uwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	*uwrq = adapter->mode;
+	*uwrq = priv->mode;
 
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
@@ -432,7 +421,6 @@ static int lbs_get_txpow(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -444,10 +432,10 @@ static int lbs_get_txpow(struct net_device *dev,
 	if (ret)
 		goto out;
 
-	lbs_deb_wext("tx power level %d dbm\n", adapter->txpowerlevel);
-	vwrq->value = adapter->txpowerlevel;
+	lbs_deb_wext("tx power level %d dbm\n", priv->txpowerlevel);
+	vwrq->value = priv->txpowerlevel;
 	vwrq->fixed = 1;
-	if (adapter->radioon) {
+	if (priv->radioon) {
 		vwrq->disabled = 0;
 		vwrq->flags = IW_TXPOW_DBM;
 	} else {
@@ -464,7 +452,6 @@ static int lbs_set_retry(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -477,7 +464,7 @@ static int lbs_set_retry(struct net_device *dev, struct iw_request_info *info,
 			return -EINVAL;
 
 		/* Adding 1 to convert retry count to try count */
-		adapter->txretrycount = vwrq->value + 1;
+		priv->txretrycount = vwrq->value + 1;
 
 		ret = lbs_prepare_and_send_command(priv, CMD_802_11_SNMP_MIB,
 					    CMD_ACT_SET,
@@ -499,12 +486,11 @@ static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	adapter->txretrycount = 0;
+	priv->txretrycount = 0;
 	ret = lbs_prepare_and_send_command(priv,
 				    CMD_802_11_SNMP_MIB,
 				    CMD_ACT_GET, CMD_OPTION_WAITFORRSP,
@@ -516,7 +502,7 @@ static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
 	if (!vwrq->flags) {
 		vwrq->flags = IW_RETRY_LIMIT;
 		/* Subtract 1 to convert try count to retry count */
-		vwrq->value = adapter->txretrycount - 1;
+		vwrq->value = priv->txretrycount - 1;
 	}
 
 out:
@@ -568,7 +554,6 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 {
 	int i, j;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct iw_range *range = (struct iw_range *)extra;
 	struct chan_freq_power *cfp;
 	u8 rates[MAX_RATES + 1];
@@ -584,7 +569,7 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 	range->max_nwid = 0;
 
 	memset(rates, 0, sizeof(rates));
-	copy_active_data_rates(adapter, rates);
+	copy_active_data_rates(priv, rates);
 	range->num_bitrates = strnlen(rates, IW_MAX_BITRATES);
 	for (i = 0; i < range->num_bitrates; i++)
 		range->bitrate[i] = rates[i] * 500000;
@@ -593,14 +578,14 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 	       range->num_bitrates);
 
 	range->num_frequency = 0;
-	if (priv->adapter->enable11d &&
-	    (adapter->connect_status == LBS_CONNECTED ||
-	    adapter->mesh_connect_status == LBS_CONNECTED)) {
+	if (priv->enable11d &&
+	    (priv->connect_status == LBS_CONNECTED ||
+	    priv->mesh_connect_status == LBS_CONNECTED)) {
 		u8 chan_no;
 		u8 band;
 
 		struct parsed_region_chan_11d *parsed_region_chan =
-		    &adapter->parsed_region_chan;
+		    &priv->parsed_region_chan;
 
 		if (parsed_region_chan == NULL) {
 			lbs_deb_wext("11d: parsed_region_chan is NULL\n");
@@ -624,12 +609,12 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 	}
 	if (!flag) {
 		for (j = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
-		     && (j < ARRAY_SIZE(adapter->region_channel)); j++) {
-			cfp = adapter->region_channel[j].CFP;
+		     && (j < ARRAY_SIZE(priv->region_channel)); j++) {
+			cfp = priv->region_channel[j].CFP;
 			for (i = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
-			     && adapter->region_channel[j].valid
+			     && priv->region_channel[j].valid
 			     && cfp
-			     && (i < adapter->region_channel[j].nrcfp); i++) {
+			     && (i < priv->region_channel[j].nrcfp); i++) {
 				range->freq[range->num_frequency].i =
 				    (long)cfp->channel;
 				range->freq[range->num_frequency].m =
@@ -729,7 +714,7 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 				IW_EVENT_CAPA_MASK(SIOCGIWSCAN));
 	range->event_capa[1] = IW_EVENT_CAPA_K_1;
 
-	if (adapter->fwcapinfo & FW_CAPINFO_WPA) {
+	if (priv->fwcapinfo & FW_CAPINFO_WPA) {
 		range->enc_capa =   IW_ENC_CAPA_WPA
 		                  | IW_ENC_CAPA_WPA2
 		                  | IW_ENC_CAPA_CIPHER_TKIP
@@ -745,7 +730,6 @@ static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -754,8 +738,8 @@ static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
 	 */
 
 	if (vwrq->disabled) {
-		adapter->psmode = LBS802_11POWERMODECAM;
-		if (adapter->psstate != PS_STATE_FULL_POWER) {
+		priv->psmode = LBS802_11POWERMODECAM;
+		if (priv->psstate != PS_STATE_FULL_POWER) {
 			lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 		}
 
@@ -771,13 +755,13 @@ static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
 		return -EINVAL;
 	}
 
-	if (adapter->psmode != LBS802_11POWERMODECAM) {
+	if (priv->psmode != LBS802_11POWERMODECAM) {
 		return 0;
 	}
 
-	adapter->psmode = LBS802_11POWERMODEMAX_PSP;
+	priv->psmode = LBS802_11POWERMODEMAX_PSP;
 
-	if (adapter->connect_status == LBS_CONNECTED) {
+	if (priv->connect_status == LBS_CONNECTED) {
 		lbs_ps_sleep(priv, CMD_OPTION_WAITFORRSP);
 	}
 
@@ -789,15 +773,14 @@ static int lbs_get_power(struct net_device *dev, struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int mode;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mode = adapter->psmode;
+	mode = priv->psmode;
 
 	if ((vwrq->disabled = (mode == LBS802_11POWERMODECAM))
-	    || adapter->connect_status == LBS_DISCONNECTED)
+	    || priv->connect_status == LBS_DISCONNECTED)
 	{
 		goto out;
 	}
@@ -820,7 +803,6 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 		PERFECT = 100
 	};
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	u32 rssi_qual;
 	u32 tx_qual;
 	u32 quality = 0;
@@ -830,23 +812,23 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	priv->wstats.status = adapter->mode;
+	priv->wstats.status = priv->mode;
 
 	/* If we're not associated, all quality values are meaningless */
-	if ((adapter->connect_status != LBS_CONNECTED) &&
-	    (adapter->mesh_connect_status != LBS_CONNECTED))
+	if ((priv->connect_status != LBS_CONNECTED) &&
+	    (priv->mesh_connect_status != LBS_CONNECTED))
 		goto out;
 
 	/* Quality by RSSI */
 	priv->wstats.qual.level =
-	    CAL_RSSI(adapter->SNR[TYPE_BEACON][TYPE_NOAVG],
-	     adapter->NF[TYPE_BEACON][TYPE_NOAVG]);
+	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
+	     priv->NF[TYPE_BEACON][TYPE_NOAVG]);
 
-	if (adapter->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
+	if (priv->NF[TYPE_BEACON][TYPE_NOAVG] == 0) {
 		priv->wstats.qual.noise = MRVDRV_NF_DEFAULT_SCAN_VALUE;
 	} else {
 		priv->wstats.qual.noise =
-		    CAL_NF(adapter->NF[TYPE_BEACON][TYPE_NOAVG]);
+		    CAL_NF(priv->NF[TYPE_BEACON][TYPE_NOAVG]);
 	}
 
 	lbs_deb_wext("signal level %#x\n", priv->wstats.qual.level);
@@ -870,7 +852,7 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 	/* Quality by TX errors */
 	priv->wstats.discard.retries = priv->stats.tx_errors;
 
-	tx_retries = le32_to_cpu(adapter->logmsg.retry);
+	tx_retries = le32_to_cpu(priv->logmsg.retry);
 
 	if (tx_retries > 75)
 		tx_qual = (90 - tx_retries) * POOR / 15;
@@ -886,10 +868,10 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 		    (PERFECT - VERY_GOOD) / 50 + VERY_GOOD;
 	quality = min(quality, tx_qual);
 
-	priv->wstats.discard.code = le32_to_cpu(adapter->logmsg.wepundecryptable);
-	priv->wstats.discard.fragment = le32_to_cpu(adapter->logmsg.rxfrag);
+	priv->wstats.discard.code = le32_to_cpu(priv->logmsg.wepundecryptable);
+	priv->wstats.discard.fragment = le32_to_cpu(priv->logmsg.rxfrag);
 	priv->wstats.discard.retries = tx_retries;
-	priv->wstats.discard.misc = le32_to_cpu(adapter->logmsg.ackfailure);
+	priv->wstats.discard.misc = le32_to_cpu(priv->logmsg.ackfailure);
 
 	/* Calculate quality */
 	priv->wstats.qual.qual = min_t(u8, quality, 100);
@@ -924,14 +906,13 @@ static int lbs_set_freq(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = -EINVAL;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct chan_freq_power *cfp;
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mutex_lock(&adapter->lock);
-	assoc_req = lbs_get_association_request(adapter);
+	mutex_lock(&priv->lock);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		ret = -ENOMEM;
 		goto out;
@@ -941,7 +922,7 @@ static int lbs_set_freq(struct net_device *dev, struct iw_request_info *info,
 	if (fwrq->e == 1) {
 		long f = fwrq->m / 100000;
 
-		cfp = find_cfp_by_band_and_freq(adapter, 0, f);
+		cfp = find_cfp_by_band_and_freq(priv, 0, f);
 		if (!cfp) {
 			lbs_deb_wext("invalid freq %ld\n", f);
 			goto out;
@@ -956,7 +937,7 @@ static int lbs_set_freq(struct net_device *dev, struct iw_request_info *info,
 		goto out;
 	}
 
-	cfp = lbs_find_cfp_by_band_and_channel(adapter, 0, fwrq->m);
+	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, fwrq->m);
 	if (!cfp) {
 		goto out;
 	}
@@ -971,7 +952,7 @@ out:
 	} else {
 		lbs_cancel_association_work(priv);
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -981,7 +962,6 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	u32 new_rate;
 	u16 action;
 	int ret = -EINVAL;
@@ -993,14 +973,14 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 	/* Auto rate? */
 	if (vwrq->value == -1) {
 		action = CMD_ACT_SET_TX_AUTO;
-		adapter->auto_rate = 1;
-		adapter->cur_rate = 0;
+		priv->auto_rate = 1;
+		priv->cur_rate = 0;
 	} else {
 		if (vwrq->value % 100000)
 			goto out;
 
 		memset(rates, 0, sizeof(rates));
-		copy_active_data_rates(adapter, rates);
+		copy_active_data_rates(priv, rates);
 		new_rate = vwrq->value / 500000;
 		if (!memchr(rates, new_rate, sizeof(rates))) {
 			lbs_pr_alert("fixed data rate 0x%X out of range\n",
@@ -1008,9 +988,9 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 			goto out;
 		}
 
-		adapter->cur_rate = new_rate;
+		priv->cur_rate = new_rate;
 		action = CMD_ACT_SET_TX_FIX_RATE;
-		adapter->auto_rate = 0;
+		priv->auto_rate = 0;
 	}
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_DATA_RATE,
@@ -1025,14 +1005,13 @@ static int lbs_get_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (adapter->connect_status == LBS_CONNECTED) {
-		vwrq->value = adapter->cur_rate * 500000;
+	if (priv->connect_status == LBS_CONNECTED) {
+		vwrq->value = priv->cur_rate * 500000;
 
-		if (adapter->auto_rate)
+		if (priv->auto_rate)
 			vwrq->fixed = 0;
 		else
 			vwrq->fixed = 1;
@@ -1051,7 +1030,6 @@ static int lbs_set_mode(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
@@ -1064,8 +1042,8 @@ static int lbs_set_mode(struct net_device *dev,
 		goto out;
 	}
 
-	mutex_lock(&adapter->lock);
-	assoc_req = lbs_get_association_request(adapter);
+	mutex_lock(&priv->lock);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		ret = -ENOMEM;
 		lbs_cancel_association_work(priv);
@@ -1075,7 +1053,7 @@ static int lbs_set_mode(struct net_device *dev,
 		lbs_postpone_association_work(priv);
 		lbs_deb_wext("Switching to mode: 0x%x\n", *uwrq);
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
@@ -1097,18 +1075,17 @@ static int lbs_get_encode(struct net_device *dev,
 			   struct iw_point *dwrq, u8 * extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	lbs_deb_wext("flags 0x%x, index %d, length %d, wep_tx_keyidx %d\n",
-	       dwrq->flags, index, dwrq->length, adapter->wep_tx_keyidx);
+	       dwrq->flags, index, dwrq->length, priv->wep_tx_keyidx);
 
 	dwrq->flags = 0;
 
 	/* Authentication method */
-	switch (adapter->secinfo.auth_mode) {
+	switch (priv->secinfo.auth_mode) {
 	case IW_AUTH_ALG_OPEN_SYSTEM:
 		dwrq->flags = IW_ENCODE_OPEN;
 		break;
@@ -1124,22 +1101,22 @@ static int lbs_get_encode(struct net_device *dev,
 
 	memset(extra, 0, 16);
 
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 
 	/* Default to returning current transmit key */
 	if (index < 0)
-		index = adapter->wep_tx_keyidx;
+		index = priv->wep_tx_keyidx;
 
-	if ((adapter->wep_keys[index].len) && adapter->secinfo.wep_enabled) {
-		memcpy(extra, adapter->wep_keys[index].key,
-		       adapter->wep_keys[index].len);
-		dwrq->length = adapter->wep_keys[index].len;
+	if ((priv->wep_keys[index].len) && priv->secinfo.wep_enabled) {
+		memcpy(extra, priv->wep_keys[index].key,
+		       priv->wep_keys[index].len);
+		dwrq->length = priv->wep_keys[index].len;
 
 		dwrq->flags |= (index + 1);
 		/* Return WEP enabled */
 		dwrq->flags &= ~IW_ENCODE_DISABLED;
-	} else if ((adapter->secinfo.WPAenabled)
-		   || (adapter->secinfo.WPA2enabled)) {
+	} else if ((priv->secinfo.WPAenabled)
+		   || (priv->secinfo.WPA2enabled)) {
 		/* return WPA enabled */
 		dwrq->flags &= ~IW_ENCODE_DISABLED;
 		dwrq->flags |= IW_ENCODE_NOKEY;
@@ -1147,7 +1124,7 @@ static int lbs_get_encode(struct net_device *dev,
 		dwrq->flags |= IW_ENCODE_DISABLED;
 	}
 
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_wext("key: %02x:%02x:%02x:%02x:%02x:%02x, keylen %d\n",
 	       extra[0], extra[1], extra[2],
@@ -1293,14 +1270,13 @@ static int lbs_set_encode(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 	u16 is_default = 0, index = 0, set_tx_key = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mutex_lock(&adapter->lock);
-	assoc_req = lbs_get_association_request(adapter);
+	mutex_lock(&priv->lock);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		ret = -ENOMEM;
 		goto out;
@@ -1348,7 +1324,7 @@ out:
 	} else {
 		lbs_cancel_association_work(priv);
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -1370,7 +1346,6 @@ static int lbs_get_encodeext(struct net_device *dev,
 {
 	int ret = -EINVAL;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int index, max_key_len;
 
@@ -1386,46 +1361,46 @@ static int lbs_get_encodeext(struct net_device *dev,
 			goto out;
 		index--;
 	} else {
-		index = adapter->wep_tx_keyidx;
+		index = priv->wep_tx_keyidx;
 	}
 
 	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP) {
-		if (index != 0 || adapter->mode != IW_MODE_INFRA)
+		if (index != 0 || priv->mode != IW_MODE_INFRA)
 			goto out;
 	}
 
 	dwrq->flags = index + 1;
 	memset(ext, 0, sizeof(*ext));
 
-	if (   !adapter->secinfo.wep_enabled
-	    && !adapter->secinfo.WPAenabled
-	    && !adapter->secinfo.WPA2enabled) {
+	if (   !priv->secinfo.wep_enabled
+	    && !priv->secinfo.WPAenabled
+	    && !priv->secinfo.WPA2enabled) {
 		ext->alg = IW_ENCODE_ALG_NONE;
 		ext->key_len = 0;
 		dwrq->flags |= IW_ENCODE_DISABLED;
 	} else {
 		u8 *key = NULL;
 
-		if (   adapter->secinfo.wep_enabled
-		    && !adapter->secinfo.WPAenabled
-		    && !adapter->secinfo.WPA2enabled) {
+		if (   priv->secinfo.wep_enabled
+		    && !priv->secinfo.WPAenabled
+		    && !priv->secinfo.WPA2enabled) {
 			/* WEP */
 			ext->alg = IW_ENCODE_ALG_WEP;
-			ext->key_len = adapter->wep_keys[index].len;
-			key = &adapter->wep_keys[index].key[0];
-		} else if (   !adapter->secinfo.wep_enabled
-		           && (adapter->secinfo.WPAenabled ||
-		               adapter->secinfo.WPA2enabled)) {
+			ext->key_len = priv->wep_keys[index].len;
+			key = &priv->wep_keys[index].key[0];
+		} else if (   !priv->secinfo.wep_enabled
+		           && (priv->secinfo.WPAenabled ||
+		               priv->secinfo.WPA2enabled)) {
 			/* WPA */
 			struct enc_key * pkey = NULL;
 
-			if (   adapter->wpa_mcast_key.len
-			    && (adapter->wpa_mcast_key.flags & KEY_INFO_WPA_ENABLED))
-				pkey = &adapter->wpa_mcast_key;
-			else if (   adapter->wpa_unicast_key.len
-			         && (adapter->wpa_unicast_key.flags & KEY_INFO_WPA_ENABLED))
-				pkey = &adapter->wpa_unicast_key;
+			if (   priv->wpa_mcast_key.len
+			    && (priv->wpa_mcast_key.flags & KEY_INFO_WPA_ENABLED))
+				pkey = &priv->wpa_mcast_key;
+			else if (   priv->wpa_unicast_key.len
+			         && (priv->wpa_unicast_key.flags & KEY_INFO_WPA_ENABLED))
+				pkey = &priv->wpa_unicast_key;
 
 			if (pkey) {
 				if (pkey->type == KEY_TYPE_ID_AES) {
@@ -1477,15 +1452,14 @@ static int lbs_set_encodeext(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int alg = ext->alg;
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mutex_lock(&adapter->lock);
-	assoc_req = lbs_get_association_request(adapter);
+	mutex_lock(&priv->lock);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		ret = -ENOMEM;
 		goto out;
@@ -1589,7 +1563,7 @@ out:
 	} else {
 		lbs_cancel_association_work(priv);
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -1602,14 +1576,13 @@ static int lbs_set_genie(struct net_device *dev,
 			  char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct assoc_request * assoc_req;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mutex_lock(&adapter->lock);
-	assoc_req = lbs_get_association_request(adapter);
+	mutex_lock(&priv->lock);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		ret = -ENOMEM;
 		goto out;
@@ -1625,7 +1598,7 @@ static int lbs_set_genie(struct net_device *dev,
 		memcpy(&assoc_req->wpa_ie[0], extra, dwrq->length);
 		assoc_req->wpa_ie_len = dwrq->length;
 	} else {
-		memset(&assoc_req->wpa_ie[0], 0, sizeof(adapter->wpa_ie));
+		memset(&assoc_req->wpa_ie[0], 0, sizeof(priv->wpa_ie));
 		assoc_req->wpa_ie_len = 0;
 	}
 
@@ -1636,7 +1609,7 @@ out:
 	} else {
 		lbs_cancel_association_work(priv);
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -1649,22 +1622,21 @@ static int lbs_get_genie(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (adapter->wpa_ie_len == 0) {
+	if (priv->wpa_ie_len == 0) {
 		dwrq->length = 0;
 		goto out;
 	}
 
-	if (dwrq->length < adapter->wpa_ie_len) {
+	if (dwrq->length < priv->wpa_ie_len) {
 		ret = -E2BIG;
 		goto out;
 	}
 
-	dwrq->length = adapter->wpa_ie_len;
-	memcpy(extra, &adapter->wpa_ie[0], adapter->wpa_ie_len);
+	dwrq->length = priv->wpa_ie_len;
+	memcpy(extra, &priv->wpa_ie[0], priv->wpa_ie_len);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
@@ -1678,15 +1650,14 @@ static int lbs_set_auth(struct net_device *dev,
 			 char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 	int ret = 0;
 	int updated = 0;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mutex_lock(&adapter->lock);
-	assoc_req = lbs_get_association_request(adapter);
+	mutex_lock(&priv->lock);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		ret = -ENOMEM;
 		goto out;
@@ -1765,7 +1736,7 @@ out:
 	} else if (ret != -EOPNOTSUPP) {
 		lbs_cancel_association_work(priv);
 	}
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -1778,27 +1749,26 @@ static int lbs_get_auth(struct net_device *dev,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	switch (dwrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		dwrq->value = 0;
-		if (adapter->secinfo.WPAenabled)
+		if (priv->secinfo.WPAenabled)
 			dwrq->value |= IW_AUTH_WPA_VERSION_WPA;
-		if (adapter->secinfo.WPA2enabled)
+		if (priv->secinfo.WPA2enabled)
 			dwrq->value |= IW_AUTH_WPA_VERSION_WPA2;
 		if (!dwrq->value)
 			dwrq->value |= IW_AUTH_WPA_VERSION_DISABLED;
 		break;
 
 	case IW_AUTH_80211_AUTH_ALG:
-		dwrq->value = adapter->secinfo.auth_mode;
+		dwrq->value = priv->secinfo.auth_mode;
 		break;
 
 	case IW_AUTH_WPA_ENABLED:
-		if (adapter->secinfo.WPAenabled && adapter->secinfo.WPA2enabled)
+		if (priv->secinfo.WPAenabled && priv->secinfo.WPA2enabled)
 			dwrq->value = 1;
 		break;
 
@@ -1816,7 +1786,6 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 {
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	u16 dbm;
 
@@ -1827,7 +1796,7 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 		return 0;
 	}
 
-	adapter->preamble = CMD_TYPE_AUTO_PREAMBLE;
+	priv->preamble = CMD_TYPE_AUTO_PREAMBLE;
 
 	lbs_radio_ioctl(priv, RADIO_ON);
 
@@ -1858,7 +1827,6 @@ static int lbs_get_essid(struct net_device *dev, struct iw_request_info *info,
 		   struct iw_point *dwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -1870,19 +1838,19 @@ static int lbs_get_essid(struct net_device *dev, struct iw_request_info *info,
 	/*
 	 * Get the current SSID
 	 */
-	if (adapter->connect_status == LBS_CONNECTED) {
-		memcpy(extra, adapter->curbssparams.ssid,
-		       adapter->curbssparams.ssid_len);
-		extra[adapter->curbssparams.ssid_len] = '\0';
+	if (priv->connect_status == LBS_CONNECTED) {
+		memcpy(extra, priv->curbssparams.ssid,
+		       priv->curbssparams.ssid_len);
+		extra[priv->curbssparams.ssid_len] = '\0';
 	} else {
 		memset(extra, 0, 32);
-		extra[adapter->curbssparams.ssid_len] = '\0';
+		extra[priv->curbssparams.ssid_len] = '\0';
 	}
 	/*
 	 * If none, we may want to get the one that was set
 	 */
 
-	dwrq->length = adapter->curbssparams.ssid_len;
+	dwrq->length = priv->curbssparams.ssid_len;
 
 	dwrq->flags = 1;	/* active */
 
@@ -1894,7 +1862,6 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 		   struct iw_point *dwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u8 ssid[IW_ESSID_MAX_SIZE];
 	u8 ssid_len = 0;
@@ -1927,10 +1894,10 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 	}
 
 out:
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 	if (ret == 0) {
 		/* Get or create the current association request */
-		assoc_req = lbs_get_association_request(adapter);
+		assoc_req = lbs_get_association_request(priv);
 		if (!assoc_req) {
 			ret = -ENOMEM;
 		} else {
@@ -1947,7 +1914,7 @@ out:
 		lbs_cancel_association_work(priv);
 	}
 
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
@@ -1966,7 +1933,6 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 		 struct sockaddr *awrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	struct lbs_adapter *adapter = priv->adapter;
 	struct assoc_request * assoc_req;
 	int ret = 0;
 	DECLARE_MAC_BUF(mac);
@@ -1978,10 +1944,10 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_wext("ASSOC: WAP: sa_data %s\n", print_mac(mac, awrq->sa_data));
 
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 
 	/* Get or create the current association request */
-	assoc_req = lbs_get_association_request(adapter);
+	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
 		lbs_cancel_association_work(priv);
 		ret = -ENOMEM;
@@ -1992,30 +1958,30 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 		lbs_postpone_association_work(priv);
 	}
 
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 
 	return ret;
 }
 
-void lbs_get_fwversion(struct lbs_adapter *adapter, char *fwversion, int maxlen)
+void lbs_get_fwversion(struct lbs_private *priv, char *fwversion, int maxlen)
 {
 	char fwver[32];
 
-	mutex_lock(&adapter->lock);
+	mutex_lock(&priv->lock);
 
-	if (adapter->fwreleasenumber[3] == 0)
+	if (priv->fwreleasenumber[3] == 0)
 		sprintf(fwver, "%u.%u.%u",
-			adapter->fwreleasenumber[2],
-			adapter->fwreleasenumber[1],
-			adapter->fwreleasenumber[0]);
+			priv->fwreleasenumber[2],
+			priv->fwreleasenumber[1],
+			priv->fwreleasenumber[0]);
 	else
 		sprintf(fwver, "%u.%u.%u.p%u",
-			adapter->fwreleasenumber[2],
-			adapter->fwreleasenumber[1],
-			adapter->fwreleasenumber[0],
-			adapter->fwreleasenumber[3]);
+			priv->fwreleasenumber[2],
+			priv->fwreleasenumber[1],
+			priv->fwreleasenumber[0],
+			priv->fwreleasenumber[3]);
 
-	mutex_unlock(&adapter->lock);
+	mutex_unlock(&priv->lock);
 	snprintf(fwversion, maxlen, fwver);
 }
 
-- 
1.5.3.4

