Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47677 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbZEWADE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 20:03:04 -0400
Subject: [PATCH 2/5] libertas: restyle Marvell & IEEE TLV structure names
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 22 May 2009 20:03:09 -0400
Message-Id: <1243036989.2495.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Easier to read and more conformant with kernel style.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/11d.c b/drivers/net/wireless/libertas/11d.c
index 4bc46a6..9a5408e 100644
--- a/drivers/net/wireless/libertas/11d.c
+++ b/drivers/net/wireless/libertas/11d.c
@@ -207,7 +207,7 @@ static int generate_domain_info_11d(struct parsed_region_chan_11d
 	lbs_deb_11d("nr_subband=%x\n", domaininfo->nr_subband);
 	lbs_deb_hex(LBS_DEB_11D, "domaininfo", (char *)domaininfo,
 		COUNTRY_CODE_LEN + 1 +
-		sizeof(struct ieeetypes_subbandset) * nr_subband);
+		sizeof(struct ieee_subbandset) * nr_subband);
 	return 0;
 }
 
@@ -302,11 +302,9 @@ done:
  *  @param parsed_region_chan   pointer to parsed_region_chan_11d
  *  @return 	                0
 */
-static int parse_domain_info_11d(struct ieeetypes_countryinfofullset*
-				 countryinfo,
+static int parse_domain_info_11d(struct ieee_ie_country_info_full_set *countryinfo,
 				 u8 band,
-				 struct parsed_region_chan_11d *
-				 parsed_region_chan)
+				 struct parsed_region_chan_11d *parsed_region_chan)
 {
 	u8 nr_subband, nrchan;
 	u8 lastchan, firstchan;
@@ -331,7 +329,7 @@ static int parse_domain_info_11d(struct ieeetypes_countryinfofullset*
 	lbs_deb_hex(LBS_DEB_11D, "countryinfo", (u8 *) countryinfo, 30);
 
 	if ((*(countryinfo->countrycode)) == 0
-	    || (countryinfo->len <= COUNTRY_CODE_LEN)) {
+	    || (countryinfo->header.len <= COUNTRY_CODE_LEN)) {
 		/* No region Info or Wrong region info: treat as No 11D info */
 		goto done;
 	}
@@ -349,8 +347,8 @@ static int parse_domain_info_11d(struct ieeetypes_countryinfofullset*
 	memcpy(parsed_region_chan->countrycode, countryinfo->countrycode,
 	       COUNTRY_CODE_LEN);
 
-	nr_subband = (countryinfo->len - COUNTRY_CODE_LEN) /
-	    sizeof(struct ieeetypes_subbandset);
+	nr_subband = (countryinfo->header.len - COUNTRY_CODE_LEN) /
+	    sizeof(struct ieee_subbandset);
 
 	for (j = 0, lastchan = 0; j < nr_subband; j++) {
 
@@ -502,7 +500,7 @@ int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 {
 	struct cmd_ds_802_11d_domain_info *pdomaininfo =
 	    &cmd->params.domaininfo;
-	struct mrvlietypes_domainparamset *domain = &pdomaininfo->domain;
+	struct mrvl_ie_domain_param_set *domain = &pdomaininfo->domain;
 	u8 nr_subband = priv->domainreg.nr_subband;
 
 	lbs_deb_enter(LBS_DEB_11D);
@@ -524,16 +522,16 @@ int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 	       sizeof(domain->countrycode));
 
 	domain->header.len =
-	    cpu_to_le16(nr_subband * sizeof(struct ieeetypes_subbandset) +
+	    cpu_to_le16(nr_subband * sizeof(struct ieee_subbandset) +
 			     sizeof(domain->countrycode));
 
 	if (nr_subband) {
 		memcpy(domain->subband, priv->domainreg.subband,
-		       nr_subband * sizeof(struct ieeetypes_subbandset));
+		       nr_subband * sizeof(struct ieee_subbandset));
 
 		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
 					     le16_to_cpu(domain->header.len) +
-					     sizeof(struct mrvlietypesheader) +
+					     sizeof(struct mrvl_ie_header) +
 					     S_DS_GEN);
 	} else {
 		cmd->size =
@@ -556,7 +554,7 @@ done:
 int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11d_domain_info *domaininfo = &resp->params.domaininforesp;
-	struct mrvlietypes_domainparamset *domain = &domaininfo->domain;
+	struct mrvl_ie_domain_param_set *domain = &domaininfo->domain;
 	u16 action = le16_to_cpu(domaininfo->action);
 	s16 ret = 0;
 	u8 nr_subband = 0;
@@ -567,7 +565,7 @@ int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
 		(int)le16_to_cpu(resp->size));
 
 	nr_subband = (le16_to_cpu(domain->header.len) - COUNTRY_CODE_LEN) /
-		      sizeof(struct ieeetypes_subbandset);
+		      sizeof(struct ieee_subbandset);
 
 	lbs_deb_11d("domain info resp: nr_subband %d\n", nr_subband);
 
diff --git a/drivers/net/wireless/libertas/11d.h b/drivers/net/wireless/libertas/11d.h
index 4f4f47f..fb75d3e 100644
--- a/drivers/net/wireless/libertas/11d.h
+++ b/drivers/net/wireless/libertas/11d.h
@@ -20,35 +20,36 @@
 struct cmd_ds_command;
 
 /** Data structure for Country IE*/
-struct ieeetypes_subbandset {
+struct ieee_subbandset {
 	u8 firstchan;
 	u8 nrchan;
 	u8 maxtxpwr;
 } __attribute__ ((packed));
 
-struct ieeetypes_countryinfoset {
-	u8 element_id;
-	u8 len;
+struct ieee_ie_country_info_set {
+	struct ieee_ie_header header;
+
 	u8 countrycode[COUNTRY_CODE_LEN];
-	struct ieeetypes_subbandset subband[1];
+	struct ieee_subbandset subband[1];
 };
 
-struct ieeetypes_countryinfofullset {
-	u8 element_id;
-	u8 len;
+struct ieee_ie_country_info_full_set {
+	struct ieee_ie_header header;
+
 	u8 countrycode[COUNTRY_CODE_LEN];
-	struct ieeetypes_subbandset subband[MRVDRV_MAX_SUBBAND_802_11D];
+	struct ieee_subbandset subband[MRVDRV_MAX_SUBBAND_802_11D];
 } __attribute__ ((packed));
 
-struct mrvlietypes_domainparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_domain_param_set {
+	struct mrvl_ie_header header;
+
 	u8 countrycode[COUNTRY_CODE_LEN];
-	struct ieeetypes_subbandset subband[1];
+	struct ieee_subbandset subband[1];
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11d_domain_info {
 	__le16 action;
-	struct mrvlietypes_domainparamset domain;
+	struct mrvl_ie_domain_param_set domain;
 } __attribute__ ((packed));
 
 /** domain regulatory information */
@@ -57,7 +58,7 @@ struct lbs_802_11d_domain_reg {
 	u8 countrycode[COUNTRY_CODE_LEN];
 	/** No. of subband*/
 	u8 nr_subband;
-	struct ieeetypes_subbandset subband[MRVDRV_MAX_SUBBAND_802_11D];
+	struct ieee_subbandset subband[MRVDRV_MAX_SUBBAND_802_11D];
 };
 
 struct chan_power_11d {
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index d4d1d80..75c67c9 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -342,13 +342,13 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 	WARN_ON(!assoc_req->channel);
 
 	/* set Physical parameter set */
-	cmd.ds.elementid = WLAN_EID_DS_PARAMS;
-	cmd.ds.len = 1;
+	cmd.ds.header.id = WLAN_EID_DS_PARAMS;
+	cmd.ds.header.len = 1;
 	cmd.ds.channel = assoc_req->channel;
 
 	/* set IBSS parameter set */
-	cmd.ibss.elementid = WLAN_EID_IBSS_PARAMS;
-	cmd.ibss.len = 2;
+	cmd.ibss.header.id = WLAN_EID_IBSS_PARAMS;
+	cmd.ibss.header.len = 2;
 	cmd.ibss.atimwindow = cpu_to_le16(0);
 
 	/* set capability info */
@@ -1558,11 +1558,11 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	struct bss_descriptor *bss = &assoc_req->bss;
 	u8 *pos;
 	u16 tmpcap, tmplen;
-	struct mrvlietypes_ssidparamset *ssid;
-	struct mrvlietypes_dsparamset *ds;
-	struct mrvlietypes_cfparamset *cf;
-	struct mrvlietypes_ratesparamset *rates;
-	struct mrvlietypes_rsnparamset *rsn;
+	struct mrvl_ie_ssid_param_set *ssid;
+	struct mrvl_ie_ds_param_set *ds;
+	struct mrvl_ie_cf_param_set *cf;
+	struct mrvl_ie_rates_param_set *rates;
+	struct mrvl_ie_rsn_param_set *rsn;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
@@ -1586,27 +1586,27 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	pos += sizeof(passo->bcnperiod);
 	pos += sizeof(passo->dtimperiod);
 
-	ssid = (struct mrvlietypes_ssidparamset *) pos;
+	ssid = (struct mrvl_ie_ssid_param_set *) pos;
 	ssid->header.type = cpu_to_le16(TLV_TYPE_SSID);
 	tmplen = bss->ssid_len;
 	ssid->header.len = cpu_to_le16(tmplen);
 	memcpy(ssid->ssid, bss->ssid, tmplen);
 	pos += sizeof(ssid->header) + tmplen;
 
-	ds = (struct mrvlietypes_dsparamset *) pos;
+	ds = (struct mrvl_ie_ds_param_set *) pos;
 	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
 	ds->header.len = cpu_to_le16(1);
 	ds->channel = bss->phy.ds.channel;
 	pos += sizeof(ds->header) + 1;
 
-	cf = (struct mrvlietypes_cfparamset *) pos;
+	cf = (struct mrvl_ie_cf_param_set *) pos;
 	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
 	tmplen = sizeof(*cf) - sizeof (cf->header);
 	cf->header.len = cpu_to_le16(tmplen);
 	/* IE payload should be zeroed, firmware fills it in for us */
 	pos += sizeof(*cf);
 
-	rates = (struct mrvlietypes_ratesparamset *) pos;
+	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
 	tmplen = MAX_RATES;
@@ -1628,7 +1628,7 @@ int lbs_cmd_80211_associate(struct lbs_private *priv,
 	lbs_set_basic_rate_flags(rates->rates, tmplen);
 
 	if (assoc_req->secinfo.WPAenabled || assoc_req->secinfo.WPA2enabled) {
-		rsn = (struct mrvlietypes_rsnparamset *) pos;
+		rsn = (struct mrvl_ie_rsn_param_set *) pos;
 		/* WPA_IE or WPA2_IE */
 		rsn->header.type = cpu_to_le16((u16) assoc_req->wpa_ie[0]);
 		tmplen = (u16) assoc_req->wpa_ie[1];
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c455b9a..ed079c1 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1470,8 +1470,8 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		break;
 	case CMD_802_11_LED_GPIO_CTRL:
 		{
-			struct mrvlietypes_ledgpio *gpio =
-			    (struct mrvlietypes_ledgpio*)
+			struct mrvl_ie_ledgpio *gpio =
+			    (struct mrvl_ie_ledgpio*)
 			    cmdptr->params.ledgpio.data;
 
 			memmove(&cmdptr->params.ledgpio,
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 50e28a0..811ffc3 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -183,12 +183,12 @@ out_unlock:
  */
 static void *lbs_tlv_find(uint16_t tlv_type, const uint8_t *tlv, uint16_t size)
 {
-	struct mrvlietypesheader *tlv_h;
+	struct mrvl_ie_header *tlv_h;
 	uint16_t length;
 	ssize_t pos = 0;
 
 	while (pos < size) {
-		tlv_h = (struct mrvlietypesheader *) tlv;
+		tlv_h = (struct mrvl_ie_header *) tlv;
 		if (!tlv_h->len)
 			return NULL;
 		if (tlv_h->type == cpu_to_le16(tlv_type))
@@ -206,7 +206,7 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 				  size_t count, loff_t *ppos)
 {
 	struct cmd_ds_802_11_subscribe_event *subscribed;
-	struct mrvlietypes_thresholds *got;
+	struct mrvl_ie_thresholds *got;
 	struct lbs_private *priv = file->private_data;
 	ssize_t ret = 0;
 	size_t pos = 0;
@@ -259,7 +259,7 @@ static ssize_t lbs_threshold_write(uint16_t tlv_type, uint16_t event_mask,
 				   loff_t *ppos)
 {
 	struct cmd_ds_802_11_subscribe_event *events;
-	struct mrvlietypes_thresholds *tlv;
+	struct mrvl_ie_thresholds *tlv;
 	struct lbs_private *priv = file->private_data;
 	ssize_t buf_size;
 	int value, freq, new_mask;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index a1443e5..f9ec69e 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -351,7 +351,7 @@ struct bss_descriptor {
 	union ieee_phy_param_set phy;
 	union ieee_ss_param_set ss;
 
-	struct ieeetypes_countryinfofullset countryinfo;
+	struct ieee_ie_country_info_full_set countryinfo;
 
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	size_t wpa_ie_len;
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 38b0560..e5e30b2 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -27,12 +27,12 @@
                              + 40)	/* 40 for WPAIE */
 
 //! Memory needed to store a max sized channel List TLV for a firmware scan
-#define CHAN_TLV_MAX_SIZE  (sizeof(struct mrvlietypesheader)    \
+#define CHAN_TLV_MAX_SIZE  (sizeof(struct mrvl_ie_header)    \
                             + (MRVDRV_MAX_CHANNELS_PER_SCAN     \
                                * sizeof(struct chanscanparamset)))
 
 //! Memory needed to store a max number/size SSID TLV for a firmware scan
-#define SSID_TLV_MAX_SIZE  (1 * sizeof(struct mrvlietypes_ssidparamset))
+#define SSID_TLV_MAX_SIZE  (1 * sizeof(struct mrvl_ie_ssid_param_set))
 
 //! Maximum memory needed for a cmd_ds_802_11_scan with all TLVs at max
 #define MAX_SCAN_CFG_ALLOC (sizeof(struct cmd_ds_802_11_scan)	\
@@ -211,7 +211,7 @@ static int lbs_scan_create_channel_list(struct lbs_private *priv,
  */
 static int lbs_scan_add_ssid_tlv(struct lbs_private *priv, u8 *tlv)
 {
-	struct mrvlietypes_ssidparamset *ssid_tlv = (void *)tlv;
+	struct mrvl_ie_ssid_param_set *ssid_tlv = (void *)tlv;
 
 	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
 	ssid_tlv->header.len = cpu_to_le16(priv->scan_ssid_len);
@@ -249,7 +249,7 @@ static int lbs_scan_add_chanlist_tlv(uint8_t *tlv,
 				     int chan_count)
 {
 	size_t size = sizeof(struct chanscanparamset) *chan_count;
-	struct mrvlietypes_chanlistparamset *chan_tlv = (void *)tlv;
+	struct mrvl_ie_chanlist_param_set *chan_tlv = (void *)tlv;
 
 	chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
 	memcpy(chan_tlv->chanscanparam, chan_list, size);
@@ -270,7 +270,7 @@ static int lbs_scan_add_chanlist_tlv(uint8_t *tlv,
 static int lbs_scan_add_rates_tlv(uint8_t *tlv)
 {
 	int i;
-	struct mrvlietypes_ratesparamset *rate_tlv = (void *)tlv;
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
 
 	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	tlv += sizeof(rate_tlv->header);
@@ -518,7 +518,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 	struct ieee_ie_cf_param_set *cf;
 	struct ieee_ie_ibss_param_set *ibss;
 	DECLARE_SSID_BUF(ssid);
-	struct ieeetypes_countryinfoset *pcountryinfo;
+	struct ieee_ie_country_info_set *pcountryinfo;
 	uint8_t *pos, *end, *p;
 	uint8_t n_ex_rates = 0, got_basic_rates = 0, n_basic_rates = 0;
 	uint16_t beaconsize = 0;
@@ -642,20 +642,23 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 			break;
 
 		case WLAN_EID_COUNTRY:
-			pcountryinfo = (struct ieeetypes_countryinfoset *) pos;
+			pcountryinfo = (struct ieee_ie_country_info_set *) pos;
 			lbs_deb_scan("got COUNTRY IE\n");
-			if (pcountryinfo->len < sizeof(pcountryinfo->countrycode)
-			    || pcountryinfo->len > 254) {
-				lbs_deb_scan("process_bss: 11D- Err CountryInfo len %d, min %zd, max 254\n",
-					     pcountryinfo->len, sizeof(pcountryinfo->countrycode));
+			if (pcountryinfo->header.len < sizeof(pcountryinfo->countrycode)
+			    || pcountryinfo->header.len > 254) {
+				lbs_deb_scan("%s: 11D- Err CountryInfo len %d, min %zd, max 254\n",
+					     __func__,
+					     pcountryinfo->header.len,
+					     sizeof(pcountryinfo->countrycode));
 				ret = -1;
 				goto done;
 			}
 
-			memcpy(&bss->countryinfo, pcountryinfo, pcountryinfo->len + 2);
+			memcpy(&bss->countryinfo, pcountryinfo,
+				pcountryinfo->header.len + 2);
 			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: 11d countryinfo",
 				    (uint8_t *) pcountryinfo,
-				    (int) (pcountryinfo->len + 2));
+				    (int) (pcountryinfo->header.len + 2));
 			break;
 
 		case WLAN_EID_EXT_SUPP_RATES:
diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
index b8d2ce9..1055ecf 100644
--- a/drivers/net/wireless/libertas/types.h
+++ b/drivers/net/wireless/libertas/types.h
@@ -8,9 +8,14 @@
 #include <asm/byteorder.h>
 #include <linux/wireless.h>
 
-struct ieee_ie_cf_param_set {
-	u8 elementid;
+struct ieee_ie_header {
+	u8 id;
 	u8 len;
+} __attribute__ ((packed));
+
+struct ieee_ie_cf_param_set {
+	struct ieee_ie_header header;
+
 	u8 cfpcnt;
 	u8 cfpperiod;
 	__le16 cfpmaxduration;
@@ -19,8 +24,8 @@ struct ieee_ie_cf_param_set {
 
 
 struct ieee_ie_ibss_param_set {
-	u8 elementid;
-	u8 len;
+	struct ieee_ie_header header;
+
 	__le16 atimwindow;
 } __attribute__ ((packed));
 
@@ -30,8 +35,8 @@ union ieee_ss_param_set {
 } __attribute__ ((packed));
 
 struct ieee_ie_fh_param_set {
-	u8 elementid;
-	u8 len;
+	struct ieee_ie_header header;
+
 	__le16 dwelltime;
 	u8 hopset;
 	u8 hoppattern;
@@ -39,8 +44,8 @@ struct ieee_ie_fh_param_set {
 } __attribute__ ((packed));
 
 struct ieee_ie_ds_param_set {
-	u8 elementid;
-	u8 len;
+	struct ieee_ie_header header;
+
 	u8 channel;
 } __attribute__ ((packed));
 
@@ -98,28 +103,28 @@ struct ieee_assoc_response {
 #define TLV_TYPE_OLD_MESH_ID        (PROPRIETARY_TLV_BASE_ID + 291)
 
 /** TLV related data structures*/
-struct mrvlietypesheader {
+struct mrvl_ie_header {
 	__le16 type;
 	__le16 len;
 } __attribute__ ((packed));
 
-struct mrvlietypes_data {
-	struct mrvlietypesheader header;
+struct mrvl_ie_data {
+	struct mrvl_ie_header header;
 	u8 Data[1];
 } __attribute__ ((packed));
 
-struct mrvlietypes_ratesparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_rates_param_set {
+	struct mrvl_ie_header header;
 	u8 rates[1];
 } __attribute__ ((packed));
 
-struct mrvlietypes_ssidparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_ssid_param_set {
+	struct mrvl_ie_header header;
 	u8 ssid[1];
 } __attribute__ ((packed));
 
-struct mrvlietypes_wildcardssidparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_wildcard_ssid_param_set {
+	struct mrvl_ie_header header;
 	u8 MaxSsidlength;
 	u8 ssid[1];
 } __attribute__ ((packed));
@@ -144,66 +149,66 @@ struct chanscanparamset {
 	__le16 maxscantime;
 } __attribute__ ((packed));
 
-struct mrvlietypes_chanlistparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_chanlist_param_set {
+	struct mrvl_ie_header header;
 	struct chanscanparamset chanscanparam[1];
 } __attribute__ ((packed));
 
-struct mrvlietypes_cfparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_cf_param_set {
+	struct mrvl_ie_header header;
 	u8 cfpcnt;
 	u8 cfpperiod;
 	__le16 cfpmaxduration;
 	__le16 cfpdurationremaining;
 } __attribute__ ((packed));
 
-struct mrvlietypes_dsparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_ds_param_set {
+	struct mrvl_ie_header header;
 	u8 channel;
 } __attribute__ ((packed));
 
-struct mrvlietypes_rsnparamset {
-	struct mrvlietypesheader header;
+struct mrvl_ie_rsn_param_set {
+	struct mrvl_ie_header header;
 	u8 rsnie[1];
 } __attribute__ ((packed));
 
-struct mrvlietypes_tsftimestamp {
-	struct mrvlietypesheader header;
+struct mrvl_ie_tsf_timestamp {
+	struct mrvl_ie_header header;
 	__le64 tsftable[1];
 } __attribute__ ((packed));
 
 /**  Local Power capability */
-struct mrvlietypes_powercapability {
-	struct mrvlietypesheader header;
+struct mrvl_ie_power_capability {
+	struct mrvl_ie_header header;
 	s8 minpower;
 	s8 maxpower;
 } __attribute__ ((packed));
 
 /* used in CMD_802_11_SUBSCRIBE_EVENT for SNR, RSSI and Failure */
-struct mrvlietypes_thresholds {
-	struct mrvlietypesheader header;
+struct mrvl_ie_thresholds {
+	struct mrvl_ie_header header;
 	u8 value;
 	u8 freq;
 } __attribute__ ((packed));
 
-struct mrvlietypes_beaconsmissed {
-	struct mrvlietypesheader header;
+struct mrvl_ie_beacons_missed {
+	struct mrvl_ie_header header;
 	u8 beaconmissed;
 	u8 reserved;
 } __attribute__ ((packed));
 
-struct mrvlietypes_numprobes {
-	struct mrvlietypesheader header;
+struct mrvl_ie_num_probes {
+	struct mrvl_ie_header header;
 	__le16 numprobes;
 } __attribute__ ((packed));
 
-struct mrvlietypes_bcastprobe {
-	struct mrvlietypesheader header;
+struct mrvl_ie_bcast_probe {
+	struct mrvl_ie_header header;
 	__le16 bcastprobe;
 } __attribute__ ((packed));
 
-struct mrvlietypes_numssidprobe {
-	struct mrvlietypesheader header;
+struct mrvl_ie_num_ssid_probe {
+	struct mrvl_ie_header header;
 	__le16 numssidprobe;
 } __attribute__ ((packed));
 
@@ -212,8 +217,8 @@ struct led_pin {
 	u8 pin;
 } __attribute__ ((packed));
 
-struct mrvlietypes_ledgpio {
-	struct mrvlietypesheader header;
+struct mrvl_ie_ledgpio {
+	struct mrvl_ie_header header;
 	struct led_pin ledpin[1];
 } __attribute__ ((packed));
 
@@ -225,8 +230,8 @@ struct led_bhv {
 } __attribute__ ((packed));
 
 
-struct mrvlietypes_ledbhv {
-	struct mrvlietypesheader header;
+struct mrvl_ie_ledbhv {
+	struct mrvl_ie_header header;
 	struct led_bhv ledbhv[1];
 } __attribute__ ((packed));
 

