Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575AbZEWABQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 20:01:16 -0400
Subject: [PATCH 1/5] libertas: simplify and clean up association/start/join
 setup
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 22 May 2009 20:01:21 -0400
Message-Id: <1243036881.2495.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the parameters for association/join/start commands aren't
used (like the FH and CF IEs for IBSS, and the FH IE for BSS), so
get rid of their unions to reduce indirection.  Also clean up
structure names for kernel style.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index a0e440c..d4d1d80 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -219,11 +219,10 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 	memcpy(&cmd.bss.bssid, &bss->bssid, ETH_ALEN);
 	memcpy(&cmd.bss.ssid, &bss->ssid, bss->ssid_len);
 
-	memcpy(&cmd.bss.phyparamset, &bss->phyparamset,
-	       sizeof(union ieeetypes_phyparamset));
+	memcpy(&cmd.bss.ds, &bss->phy.ds, sizeof(struct ieee_ie_ds_param_set));
 
-	memcpy(&cmd.bss.ssparamset, &bss->ssparamset,
-	       sizeof(union IEEEtypes_ssparamset));
+	memcpy(&cmd.bss.ibss, &bss->ss.ibss,
+	       sizeof(struct ieee_ie_ibss_param_set));
 
 	cmd.bss.capability = cpu_to_le16(bss->capability & CAPINFO_MASK);
 	lbs_deb_join("ADHOC_J_CMD: tmpcap=%4X CAPINFO_MASK=%4X\n",
@@ -260,7 +259,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 	 */
 	lbs_set_basic_rate_flags(cmd.bss.rates, ratesize);
 
-	cmd.bss.ssparamset.ibssparamset.atimwindow = cpu_to_le16(bss->atimwindow);
+	cmd.bss.ibss.atimwindow = bss->atimwindow;
 
 	if (assoc_req->secinfo.wep_enabled) {
 		u16 tmp = le16_to_cpu(cmd.bss.capability);
@@ -343,14 +342,14 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 	WARN_ON(!assoc_req->channel);
 
 	/* set Physical parameter set */
-	cmd.phyparamset.dsparamset.elementid = WLAN_EID_DS_PARAMS;
-	cmd.phyparamset.dsparamset.len = 1;
-	cmd.phyparamset.dsparamset.currentchan = assoc_req->channel;
+	cmd.ds.elementid = WLAN_EID_DS_PARAMS;
+	cmd.ds.len = 1;
+	cmd.ds.channel = assoc_req->channel;
 
 	/* set IBSS parameter set */
-	cmd.ssparamset.ibssparamset.elementid = WLAN_EID_IBSS_PARAMS;
-	cmd.ssparamset.ibssparamset.len = 2;
-	cmd.ssparamset.ibssparamset.atimwindow = 0;
+	cmd.ibss.elementid = WLAN_EID_IBSS_PARAMS;
+	cmd.ibss.len = 2;
+	cmd.ibss.atimwindow = cpu_to_le16(0);
 
 	/* set capability info */
 	tmpcap = WLAN_CAPABILITY_IBSS;
@@ -1560,8 +1559,8 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	u8 *pos;
 	u16 tmpcap, tmplen;
 	struct mrvlietypes_ssidparamset *ssid;
-	struct mrvlietypes_phyparamset *phy;
-	struct mrvlietypes_ssparamset *ss;
+	struct mrvlietypes_dsparamset *ds;
+	struct mrvlietypes_cfparamset *cf;
 	struct mrvlietypes_ratesparamset *rates;
 	struct mrvlietypes_rsnparamset *rsn;
 
@@ -1594,20 +1593,18 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	memcpy(ssid->ssid, bss->ssid, tmplen);
 	pos += sizeof(ssid->header) + tmplen;
 
-	phy = (struct mrvlietypes_phyparamset *) pos;
-	phy->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
-	tmplen = sizeof(phy->fh_ds.dsparamset);
-	phy->header.len = cpu_to_le16(tmplen);
-	memcpy(&phy->fh_ds.dsparamset,
-	       &bss->phyparamset.dsparamset.currentchan,
-	       tmplen);
-	pos += sizeof(phy->header) + tmplen;
-
-	ss = (struct mrvlietypes_ssparamset *) pos;
-	ss->header.type = cpu_to_le16(TLV_TYPE_CF);
-	tmplen = sizeof(ss->cf_ibss.cfparamset);
-	ss->header.len = cpu_to_le16(tmplen);
-	pos += sizeof(ss->header) + tmplen;
+	ds = (struct mrvlietypes_dsparamset *) pos;
+	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
+	ds->header.len = cpu_to_le16(1);
+	ds->channel = bss->phy.ds.channel;
+	pos += sizeof(ds->header) + 1;
+
+	cf = (struct mrvlietypes_cfparamset *) pos;
+	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
+	tmplen = sizeof(*cf) - sizeof (cf->header);
+	cf->header.len = cpu_to_le16(tmplen);
+	/* IE payload should be zeroed, firmware fills it in for us */
+	pos += sizeof(*cf);
 
 	rates = (struct mrvlietypes_ratesparamset *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
@@ -1643,7 +1640,7 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	}
 
 	/* update curbssparams */
-	priv->curbssparams.channel = bss->phyparamset.dsparamset.currentchan;
+	priv->curbssparams.channel = bss->phy.ds.channel;
 
 	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
 		ret = -1;
@@ -1669,7 +1666,7 @@ int lbs_ret_80211_associate(struct lbs_private *priv,
 {
 	int ret = 0;
 	union iwreq_data wrqu;
-	struct ieeetypes_assocrsp *passocrsp;
+	struct ieee_assoc_response *passocrsp;
 	struct bss_descriptor *bss;
 	u16 status_code;
 
@@ -1682,7 +1679,7 @@ int lbs_ret_80211_associate(struct lbs_private *priv,
 	}
 	bss = &priv->in_progress_assoc_req->bss;
 
-	passocrsp = (struct ieeetypes_assocrsp *) &resp->params;
+	passocrsp = (struct ieee_assoc_response *) &resp->params;
 
 	/*
 	 * Older FW versions map the IEEE 802.11 Status Code in the association
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index cbaafa6..a1443e5 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -338,7 +338,7 @@ struct bss_descriptor {
 	u32 rssi;
 	u32 channel;
 	u16 beaconperiod;
-	u32 atimwindow;
+	__le16 atimwindow;
 
 	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
 	u8 mode;
@@ -348,8 +348,8 @@ struct bss_descriptor {
 
 	unsigned long last_scanned;
 
-	union ieeetypes_phyparamset phyparamset;
-	union IEEEtypes_ssparamset ssparamset;
+	union ieee_phy_param_set phy;
+	union ieee_ss_param_set ss;
 
 	struct ieeetypes_countryinfofullset countryinfo;
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 391c54a..463ff97 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -278,7 +278,7 @@ struct cmd_ds_802_11_associate {
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_associate_rsp {
-	struct ieeetypes_assocrsp assocRsp;
+	struct ieee_assoc_response response;
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_set_wep {
@@ -535,9 +535,11 @@ struct cmd_ds_802_11_ad_hoc_start {
 	u8 bsstype;
 	__le16 beaconperiod;
 	u8 dtimperiod;   /* Reserved on v9 and later */
-	union IEEEtypes_ssparamset ssparamset;
-	union ieeetypes_phyparamset phyparamset;
-	__le16 probedelay;
+	struct ieee_ie_ibss_param_set ibss;
+	u8 reserved1[4];
+	struct ieee_ie_ds_param_set ds;
+	u8 reserved2[4];
+	__le16 probedelay;  /* Reserved on v9 and later */
 	__le16 capability;
 	u8 rates[MAX_RATES];
 	u8 tlv_memory_size_pad[100];
@@ -558,8 +560,10 @@ struct adhoc_bssdesc {
 	u8 dtimperiod;
 	__le64 timestamp;
 	__le64 localtime;
-	union ieeetypes_phyparamset phyparamset;
-	union IEEEtypes_ssparamset ssparamset;
+	struct ieee_ie_ds_param_set ds;
+	u8 reserved1[4];
+	struct ieee_ie_ibss_param_set ibss;
+	u8 reserved2[4];
 	__le16 capability;
 	u8 rates[MAX_RATES];
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 8124db3..38b0560 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -513,10 +513,10 @@ void lbs_scan_worker(struct work_struct *work)
 static int lbs_process_bss(struct bss_descriptor *bss,
 			   uint8_t **pbeaconinfo, int *bytesleft)
 {
-	struct ieeetypes_fhparamset *pFH;
-	struct ieeetypes_dsparamset *pDS;
-	struct ieeetypes_cfparamset *pCF;
-	struct ieeetypes_ibssparamset *pibss;
+	struct ieee_ie_fh_param_set *fh;
+	struct ieee_ie_ds_param_set *ds;
+	struct ieee_ie_cf_param_set *cf;
+	struct ieee_ie_ibss_param_set *ibss;
 	DECLARE_SSID_BUF(ssid);
 	struct ieeetypes_countryinfoset *pcountryinfo;
 	uint8_t *pos, *end, *p;
@@ -616,32 +616,28 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 			break;
 
 		case WLAN_EID_FH_PARAMS:
-			pFH = (struct ieeetypes_fhparamset *) pos;
-			memmove(&bss->phyparamset.fhparamset, pFH,
-				sizeof(struct ieeetypes_fhparamset));
+			fh = (struct ieee_ie_fh_param_set *) pos;
+			memcpy(&bss->phy.fh, fh, sizeof(*fh));
 			lbs_deb_scan("got FH IE\n");
 			break;
 
 		case WLAN_EID_DS_PARAMS:
-			pDS = (struct ieeetypes_dsparamset *) pos;
-			bss->channel = pDS->currentchan;
-			memcpy(&bss->phyparamset.dsparamset, pDS,
-			       sizeof(struct ieeetypes_dsparamset));
+			ds = (struct ieee_ie_ds_param_set *) pos;
+			bss->channel = ds->channel;
+			memcpy(&bss->phy.ds, ds, sizeof(*ds));
 			lbs_deb_scan("got DS IE, channel %d\n", bss->channel);
 			break;
 
 		case WLAN_EID_CF_PARAMS:
-			pCF = (struct ieeetypes_cfparamset *) pos;
-			memcpy(&bss->ssparamset.cfparamset, pCF,
-			       sizeof(struct ieeetypes_cfparamset));
+			cf = (struct ieee_ie_cf_param_set *) pos;
+			memcpy(&bss->ss.cf, cf, sizeof(*cf));
 			lbs_deb_scan("got CF IE\n");
 			break;
 
 		case WLAN_EID_IBSS_PARAMS:
-			pibss = (struct ieeetypes_ibssparamset *) pos;
-			bss->atimwindow = le16_to_cpu(pibss->atimwindow);
-			memmove(&bss->ssparamset.ibssparamset, pibss,
-				sizeof(struct ieeetypes_ibssparamset));
+			ibss = (struct ieee_ie_ibss_param_set *) pos;
+			bss->atimwindow = ibss->atimwindow;
+			memcpy(&bss->ss.ibss, ibss, sizeof(*ibss));
 			lbs_deb_scan("got IBSS IE\n");
 			break;
 
diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
index de03b9c..b8d2ce9 100644
--- a/drivers/net/wireless/libertas/types.h
+++ b/drivers/net/wireless/libertas/types.h
@@ -8,7 +8,7 @@
 #include <asm/byteorder.h>
 #include <linux/wireless.h>
 
-struct ieeetypes_cfparamset {
+struct ieee_ie_cf_param_set {
 	u8 elementid;
 	u8 len;
 	u8 cfpcnt;
@@ -18,18 +18,18 @@ struct ieeetypes_cfparamset {
 } __attribute__ ((packed));
 
 
-struct ieeetypes_ibssparamset {
+struct ieee_ie_ibss_param_set {
 	u8 elementid;
 	u8 len;
 	__le16 atimwindow;
 } __attribute__ ((packed));
 
-union IEEEtypes_ssparamset {
-	struct ieeetypes_cfparamset cfparamset;
-	struct ieeetypes_ibssparamset ibssparamset;
+union ieee_ss_param_set {
+	struct ieee_ie_cf_param_set cf;
+	struct ieee_ie_ibss_param_set ibss;
 } __attribute__ ((packed));
 
-struct ieeetypes_fhparamset {
+struct ieee_ie_fh_param_set {
 	u8 elementid;
 	u8 len;
 	__le16 dwelltime;
@@ -38,18 +38,18 @@ struct ieeetypes_fhparamset {
 	u8 hopindex;
 } __attribute__ ((packed));
 
-struct ieeetypes_dsparamset {
+struct ieee_ie_ds_param_set {
 	u8 elementid;
 	u8 len;
-	u8 currentchan;
+	u8 channel;
 } __attribute__ ((packed));
 
-union ieeetypes_phyparamset {
-	struct ieeetypes_fhparamset fhparamset;
-	struct ieeetypes_dsparamset dsparamset;
+union ieee_phy_param_set {
+	struct ieee_ie_fh_param_set fh;
+	struct ieee_ie_ds_param_set ds;
 } __attribute__ ((packed));
 
-struct ieeetypes_assocrsp {
+struct ieee_assoc_response {
 	__le16 capability;
 	__le16 statuscode;
 	__le16 aid;
@@ -149,42 +149,17 @@ struct mrvlietypes_chanlistparamset {
 	struct chanscanparamset chanscanparam[1];
 } __attribute__ ((packed));
 
-struct cfparamset {
+struct mrvlietypes_cfparamset {
+	struct mrvlietypesheader header;
 	u8 cfpcnt;
 	u8 cfpperiod;
 	__le16 cfpmaxduration;
 	__le16 cfpdurationremaining;
 } __attribute__ ((packed));
 
-struct ibssparamset {
-	__le16 atimwindow;
-} __attribute__ ((packed));
-
-struct mrvlietypes_ssparamset {
-	struct mrvlietypesheader header;
-	union {
-		struct cfparamset cfparamset[1];
-		struct ibssparamset ibssparamset[1];
-	} cf_ibss;
-} __attribute__ ((packed));
-
-struct fhparamset {
-	__le16 dwelltime;
-	u8 hopset;
-	u8 hoppattern;
-	u8 hopindex;
-} __attribute__ ((packed));
-
-struct dsparamset {
-	u8 currentchan;
-} __attribute__ ((packed));
-
-struct mrvlietypes_phyparamset {
+struct mrvlietypes_dsparamset {
 	struct mrvlietypesheader header;
-	union {
-		struct fhparamset fhparamset[1];
-		struct dsparamset dsparamset[1];
-	} fh_ds;
+	u8 channel;
 } __attribute__ ((packed));
 
 struct mrvlietypes_rsnparamset {

