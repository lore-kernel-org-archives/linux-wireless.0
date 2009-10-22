Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:3113 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbZJVNgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:36:05 -0400
Message-Id: <20091022133426.577619784@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:31:01 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 18/19] [RFC, v3] libertas: cfg80211 support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v1: scanning
v2: + WEP, WPA, WPA2
v3: + disconnect & MIC events, 11D region hint to cfg80211, auth_type TLV


Things that I tested:

* iw eth1 scan / scan trigger / scan dump, including passive-scanning,
  scan-for-ssid, scan-on-specified-freq

* "iw eth1 connect SSID 2437 00:11:22:33:44:55 key 0:99999" (the
  mentions MAC address must be in the bss list that you get via "iw
  scan dump")

* "iw eth1 connect SSID 2437 00:11:22:33:44:55" (that is, to connect
  to some AP without any encryption at all.

* "./wpa_supplicant -D nl80211" with WEP, WPA and WPA2.

* "iw link" gives some output

* "make C=2 CF=-D__CHECK_ENDIAN__" and "scripts/checkpatch.pl" clean

* getting region from the card into cfg80211

* disconnect and MIC events



Now, that's the nice stuff. Now to the ugly stuff:

* There are some open points, all marked as TODO in the source

* no support for IBSS yet

* no support for MESH yet (and won't be implemented by me)

* no support for monitor mode yet (I have an untested monitor patch
  ready that doesn't yet support injection)

* no support for RTS threshold etc

* formula for calculation of dBm migth be wrong

* still some fields in "struct libertas_private" that I want to get
  rid of, e.g. priv->connect_status.

* "iw eth1 connect SSID" doesn't work, you HAVE to specify the BSSID
  of an access-point: "iw eth1 connect SSID 00:11:22:33:44:55". And
  the AP has to be in cfg80211's BSS list.

  This is because of a impedance mismatch of cfg80211's
  .connect/.disconnect API and libertas firmware.

  Ah, and cfg80211's .auth/.deauth .assoc/.disassoc API doesn't suit
  the libertas firmware that much better.

* no short preamble support yet (easy to add)

* should probably sent some IE with cfg80211_disconnected()



Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Do not apply, but please look at the code and comment harshly :-)

--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c
+++ linux-wl/drivers/net/wireless/libertas/cfg.c
@@ -6,10 +6,16 @@
  *
  */
 
+#include <linux/ieee80211.h>
+#include <linux/sched.h>
 #include <net/cfg80211.h>
+#include <net/lib80211.h> /* for print_ssid only */
+#include <asm/unaligned.h>
 
 #include "cfg.h"
 #include "cmd.h"
+#include "host.h"
+#include "dev.h"
 
 
 #define CHAN2G(_channel, _freq, _flags) {        \
@@ -38,26 +44,27 @@
 	CHAN2G(14, 2484, 0),
 };
 
-#define RATETAB_ENT(_rate, _rateid, _flags) { \
-	.bitrate  = (_rate),                  \
-	.hw_value = (_rateid),                \
-	.flags    = (_flags),                 \
+#define RATETAB_ENT(_rate, _hw_value, _flags) { \
+	.bitrate  = (_rate),                    \
+	.hw_value = (_hw_value),                \
+	.flags    = (_flags),                   \
 }
 
 
+/* Table 6 in section 3.2.1.1 */
 static struct ieee80211_rate lbs_rates[] = {
-	RATETAB_ENT(10,  0x1,   0),
-	RATETAB_ENT(20,  0x2,   0),
-	RATETAB_ENT(55,  0x4,   0),
-	RATETAB_ENT(110, 0x8,   0),
-	RATETAB_ENT(60,  0x10,  0),
-	RATETAB_ENT(90,  0x20,  0),
-	RATETAB_ENT(120, 0x40,  0),
-	RATETAB_ENT(180, 0x80,  0),
-	RATETAB_ENT(240, 0x100, 0),
-	RATETAB_ENT(360, 0x200, 0),
-	RATETAB_ENT(480, 0x400, 0),
-	RATETAB_ENT(540, 0x800, 0),
+	RATETAB_ENT(10,  0,  0),
+	RATETAB_ENT(20,  1,  0),
+	RATETAB_ENT(55,  2,  0),
+	RATETAB_ENT(110, 3,  0),
+	RATETAB_ENT(60,  9,  0),
+	RATETAB_ENT(90,  6,  0),
+	RATETAB_ENT(120, 7,  0),
+	RATETAB_ENT(180, 8,  0),
+	RATETAB_ENT(240, 9,  0),
+	RATETAB_ENT(360, 10, 0),
+	RATETAB_ENT(480, 11, 0),
+	RATETAB_ENT(540, 12, 0),
 };
 
 static struct ieee80211_supported_band lbs_band_2ghz = {
@@ -75,21 +82,344 @@
 	WLAN_CIPHER_SUITE_CCMP,
 };
 
+/* Time to stay on the channel */
+#define LBS_DWELL_PASSIVE 100
+#define LBS_DWELL_ACTIVE  40
 
 
+
+/***************************************************************************
+ * Misc utility functions
+ *
+ * TLVs are Marvell specific. They are very similar to IEs, they have the
+ * same structure: type, length, data*. The only difference: for IEs, the
+ * type and length are u8, but for TLVs they're __le16.
+ */
+
+#ifdef CONFIG_LIBERTAS_CFG80211
+/*
+ * Convert NL80211's auth_type to the one from Libertas, see chapter 5.9.1
+ * in the firmware spec
+ */
+static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
+{
+	int ret = -ENOTSUPP;
+
+	switch (auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		ret = auth_type;
+		break;
+	case NL80211_AUTHTYPE_AUTOMATIC:
+		ret = NL80211_AUTHTYPE_OPEN_SYSTEM;
+		break;
+	case NL80211_AUTHTYPE_NETWORK_EAP:
+		ret = 0x80;
+		break;
+	default:
+		/* silence compiler */
+		break;
+	}
+	return ret;
+}
+
+
+
+
+/***************************************************************************
+ * TLV utility functions
+ *
+ * TLVs are Marvell specific. They are very similar to IEs, they have the
+ * same structure: type, length, data*. The only difference: for IEs, the
+ * type and length are u8, but for TLVs they're __le16.
+ */
+
+
+/*
+ * Add ssid TLV
+ */
+#define LBS_MAX_SSID_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + IEEE80211_MAX_SSID_LEN)
+
+static int lbs_add_ssid_tlv(u8 *tlv, const u8 *ssid, int ssid_len)
+{
+	struct mrvl_ie_ssid_param_set *ssid_tlv = (void *)tlv;
+
+	/*
+	 * TLV-ID SSID  00 00
+	 * length       06 00
+	 * ssid         4d 4e 54 45 53 54
+	 */
+	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
+	ssid_tlv->header.len = cpu_to_le16(ssid_len);
+	memcpy(ssid_tlv->ssid, ssid, ssid_len);
+	return sizeof(ssid_tlv->header) + ssid_len;
+}
+
+
+/*
+ * Add channel list TLV (section 8.4.2)
+ *
+ * Actual channel data comes from priv->wiphy->channels.
+ */
+#define LBS_MAX_CHANNEL_LIST_TLV_SIZE					\
+	(sizeof(struct mrvl_ie_header)					\
+	 + (LBS_SCAN_BEFORE_NAP * sizeof(struct chanscanparamset)))
+
+static int lbs_add_channel_list_tlv(struct lbs_private *priv, u8 *tlv,
+				    int last_channel, int active_scan)
+{
+	int chanscanparamsize = sizeof(struct chanscanparamset) *
+		(last_channel - priv->scan_channel);
+
+	struct mrvl_ie_header *header = (void *) tlv;
+
+	/*
+	 * TLV-ID CHANLIST  01 01
+	 * length           0e 00
+	 * channel          00 01 00 00 00 64 00
+	 *   radio type     00
+	 *   channel           01
+	 *   scan type            00
+	 *   min scan time           00 00
+	 *   max scan time                 64 00
+	 * channel 2        00 02 00 00 00 64 00
+	 *
+	 */
+
+	header->type = cpu_to_le16(TLV_TYPE_CHANLIST);
+	header->len  = cpu_to_le16(chanscanparamsize);
+	tlv += sizeof(struct mrvl_ie_header);
+
+	/* lbs_deb_scan("scan: channels %d to %d\n", priv->scan_channel,
+		     last_channel); */
+	memset(tlv, 0, chanscanparamsize);
+
+	while (priv->scan_channel < last_channel) {
+		struct chanscanparamset *param = (void *) tlv;
+
+		param->radiotype = CMD_SCAN_RADIO_TYPE_BG;
+		param->channumber =
+			priv->scan_req->channels[priv->scan_channel]->hw_value;
+		if (active_scan) {
+			param->maxscantime = cpu_to_le16(LBS_DWELL_ACTIVE);
+		} else {
+			param->chanscanmode.passivescan = 1;
+			param->maxscantime = cpu_to_le16(LBS_DWELL_PASSIVE);
+		}
+		tlv += sizeof(struct chanscanparamset);
+		priv->scan_channel++;
+	}
+	return sizeof(struct mrvl_ie_header) + chanscanparamsize;
+}
+
+
+/*
+ * Add rates TLV
+ *
+ * The rates are in lbs_bg_rates[], but for the 802.11b
+ * rates the high bit is set. We add this TLV only because
+ * there's a firmware which otherwise doesn't report all
+ * APs in range.
+ */
+#define LBS_MAX_RATES_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + (ARRAY_SIZE(lbs_rates)))
+
+/* Adds a TLV with all rates the hardware supports */
+static int lbs_add_supported_rates_tlv(u8 *tlv)
+{
+	int i;
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
+
+	/*
+	 * TLV-ID RATES  01 00
+	 * length        0e 00
+	 * rates         82 84 8b 96 0c 12 18 24 30 48 60 6c
+	 */
+	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	tlv += sizeof(rate_tlv->header);
+	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
+		*tlv = lbs_rates[i].bitrate / 5;
+		/* This code makes sure that the 802.11b rates (1 MBit/s, 2
+		   MBit/s, 5.5 MBit/s and 11 MBit/s get's the high bit set.
+		   Note that the values are MBit/s * 2, to mark them as
+		   basic rates so that the firmware likes it better */
+		if (*tlv == 0x02 || *tlv == 0x04 ||
+		    *tlv == 0x0b || *tlv == 0x16)
+			*tlv |= 0x80;
+		tlv++;
+	}
+	rate_tlv->header.len = cpu_to_le16(i);
+	return sizeof(rate_tlv->header) + i;
+}
+
+
+/*
+ * Adds a TLV with all rates the hardware *and* BSS supports.
+ */
+static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
+{
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
+	const u8 *rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+	int n;
+
+	/*
+	 * 01 00                   TLV_TYPE_RATES
+	 * 04 00                   len
+	 * 82 84 8b 96             rates
+	 */
+	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	tlv += sizeof(rate_tlv->header);
+
+	if (!rates_eid) {
+		/* Fallback: add basic 802.11b rates */
+		*tlv++ = 0x82;
+		*tlv++ = 0x84;
+		*tlv++ = 0x8b;
+		*tlv++ = 0x96;
+		n = 4;
+	} else {
+		int hw, ap;
+		u8 ap_max = rates_eid[1];
+		n = 0;
+		for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
+			u8 hw_rate = lbs_rates[hw].bitrate / 5;
+			for (ap = 0; ap < ap_max; ap++) {
+				if (hw_rate == (rates_eid[ap+2] & 0x7f)) {
+					*tlv++ = rates_eid[ap+2];
+					n++;
+				}
+			}
+		}
+	}
+
+	rate_tlv->header.len = cpu_to_le16(n);
+	return sizeof(rate_tlv->header) + n;
+}
+
+
+/*
+ * Add auth type TLV.
+ *
+ * This is only needed for newer firmware (V9 and up).
+ */
+#define LBS_MAX_AUTH_TYPE_TLV_SIZE \
+	sizeof(struct mrvl_ie_auth_type)
+
+static int lbs_add_auth_type_tlv(u8 *tlv, enum nl80211_auth_type auth_type)
+{
+	struct mrvl_ie_auth_type *auth = (void *) tlv;
+
+	/*
+	 * 1f 01  TLV_TYPE_AUTH_TYPE
+	 * 01 00  len
+	 * 01     auth type
+	 */
+	auth->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+	auth->header.len = cpu_to_le16(sizeof(*auth)-sizeof(auth->header));
+	auth->auth = cpu_to_le16(lbs_auth_to_authtype(auth_type));
+	return sizeof(*auth);
+}
+
+
+/*
+ * Add channel (phy ds) TLV
+ */
+#define LBS_MAX_CHANNEL_TLV_SIZE \
+	sizeof(struct mrvl_ie_header)
+
+static int lbs_add_channel_tlv(u8 *tlv, u8 channel)
+{
+	struct mrvl_ie_ds_param_set *ds = (void *) tlv;
+
+	/*
+	 * 03 00  TLV_TYPE_PHY_DS
+	 * 01 00  len
+	 * 06     channel
+	 */
+	ds->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
+	ds->header.len = cpu_to_le16(sizeof(*ds)-sizeof(ds->header));
+	ds->channel = channel;
+	return sizeof(*ds);
+}
+
+
+/*
+ * Add (empty) CF param TLV of the form:
+ */
+#define LBS_MAX_CF_PARAM_TLV_SIZE		\
+	sizeof(struct mrvl_ie_header)
+
+static int lbs_add_cf_param_tlv(u8 *tlv)
+{
+	struct mrvl_ie_cf_param_set *cf = (void *)tlv;
+
+	/*
+	 * 04 00  TLV_TYPE_CF
+	 * 06 00  len
+	 * 00     cfpcnt
+	 * 00     cfpperiod
+	 * 00 00  cfpmaxduration
+	 * 00 00  cfpdurationremaining
+	 */
+	cf->header.type = cpu_to_le16(TLV_TYPE_CF);
+	cf->header.len = cpu_to_le16(sizeof(*cf)-sizeof(cf->header));
+	return sizeof(*cf);
+}
+
+/*
+ * Add WPA TLV
+ */
+#define LBS_MAX_WPA_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + 128 /* TODO: I guessed the size */)
+
+static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
+{
+	size_t tlv_len;
+
+	/*
+	 * We need just convert an IE to an TLV. IEs use u8 for the header,
+	 *   u8      type
+	 *   u8      len
+	 *   u8[]    data
+	 * but TLVs use __le16 instead:
+	 *   __le16  type
+	 *   __le16  len
+	 *   u8[]    data
+	 */
+	*tlv++ = *ie++;
+	*tlv++ = 0;
+	tlv_len = *tlv++ = *ie++;
+	*tlv++ = 0;
+	while (tlv_len--)
+		*tlv++ = *ie++;
+	/* the TLV is two bytes larger than the IE */
+	return ie_len + 2;
+}
+#endif
+
+
+/***************************************************************************
+ * Set Channel
+ */
+
 static int lbs_cfg_set_channel(struct wiphy *wiphy,
-	struct ieee80211_channel *chan,
+	struct ieee80211_channel *channel,
 	enum nl80211_channel_type channel_type)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = -ENOTSUPP;
 
-	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d", chan->center_freq, channel_type);
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d",
+			   channel->center_freq, channel_type);
 
 	if (channel_type != NL80211_CHAN_NO_HT)
 		goto out;
 
-	ret = lbs_set_channel(priv, chan->hw_value);
+	ret = lbs_set_channel(priv, channel->hw_value);
 
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
@@ -97,26 +427,1101 @@
 }
 
 
+
+/***************************************************************************
+ * Scanning
+ */
+
 #ifdef CONFIG_LIBERTAS_CFG80211
+
+/*
+ * When scanning, the firmware doesn't send a nul packet with the power-safe
+ * bit to the AP. So we cannot stay away from our current channel too long,
+ * otherwise we loose data. So take a "nap" while scanning every other
+ * while.
+ */
+#define LBS_SCAN_BEFORE_NAP 4
+
+
+/*
+ * When the firmware reports back a scan-result, it gives us an "u8 rssi",
+ * which isn't really an RSSI, as it becomes larger when moving away from
+ * the AP. Anyway, we need to convert that into mBm.
+ *
+ * TODO: check the formula. I know it's not correct, but it's the best I have
+ * so far.
+ */
+#define LBS_SCAN_RSSI_TO_MBM(rssi) \
+	((-(int)rssi + 3)*100)
+
+static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
+	struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
+	int bsssize;
+	const u8 *pos;
+	u16 nr_sets;
+	const u8 *tsfdesc;
+	int tsfsize;
+	int i;
+	int ret = -EILSEQ;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
+	nr_sets = le16_to_cpu(resp->size);
+
+	/*
+	 * The general layout of the scan response is described in chapter
+	 * 5.7.1. Basically we have a common part, then any number of BSS
+	 * descriptor sections. Finally we have section with the same number
+	 * of TSFs.
+	 *
+	 * cmd_ds_802_11_scan_rsp
+	 *   cmd_header
+	 *   pos_size
+	 *   nr_sets
+	 *   bssdesc 1
+	 *     bssid
+	 *     rssi
+	 *     timestamp
+	 *     intvl
+	 *     capa
+	 *     IEs
+	 *   bssdesc 2
+	 *   bssdesc n
+	 *   MrvlIEtypes_TsfFimestamp_t
+	 *     TSF for BSS 1
+	 *     TSF for BSS 2
+	 *     TSF for BSS n
+	 */
+
+	pos = scanresp->bssdesc_and_tlvbuffer;
+
+	tsfdesc = pos + bsssize;
+	tsfsize = 4 + 8 * scanresp->nr_sets;
+
+	/* Validity check: we expect a Marvell-Local TLV */
+	i = get_unaligned_le16(tsfdesc);
+	tsfdesc += 2;
+	if (i != TLV_TYPE_TSFTIMESTAMP)
+		goto done;
+	/* Validity check: the TLV holds TSF values with 8 bytes each, so
+	 * the size in the TLV must match the nr_sets value */
+	i = get_unaligned_le16(tsfdesc);
+	tsfdesc += 2;
+	if (i / 8 != scanresp->nr_sets)
+		goto done;
+
+	for (i = 0; i < scanresp->nr_sets; i++) {
+		const u8 *bssid;
+		const u8 *ie;
+		int left;
+		int ielen;
+		int rssi;
+		u16 intvl;
+		u16 capa;
+		int chan_no = -1;
+		const u8 *ssid = NULL;
+		u8 ssid_len = 0;
+		DECLARE_SSID_BUF(ssid_buf);
+
+		int len = get_unaligned_le16(pos);
+		pos += 2;
+
+		/* BSSID */
+		bssid = pos;
+		pos += ETH_ALEN;
+		/* RSSI */
+		rssi = *pos++;
+		/* Packet time stamp */
+		pos += 8;
+		/* Beacon interval */
+		intvl = get_unaligned_le16(pos);
+		pos += 2;
+		/* Capabilities */
+		capa = get_unaligned_le16(pos);
+		pos += 2;
+
+		/* To find out the channel, we must parse the IEs */
+		ie = pos;
+		/* 6+1+8+2+2: size of BSSID, RSSI, time stamp, beacon
+		   interval, capabilities */
+		ielen = left = len - (6 + 1 + 8 + 2 + 2);
+		while (left >= 2) {
+			u8 id, elen;
+			id = *pos++;
+			elen = *pos++;
+			left -= 2;
+			if (elen > left || elen == 0)
+				goto done;
+			if (id == WLAN_EID_DS_PARAMS)
+				chan_no = *pos;
+			if (id == WLAN_EID_SSID) {
+				ssid = pos;
+				ssid_len = elen;
+			}
+			left -= elen;
+			pos += elen;
+		}
+
+		/* No channel, no luck */
+		if (chan_no != -1) {
+			struct wiphy *wiphy = priv->wdev->wiphy;
+			int freq = ieee80211_channel_to_frequency(chan_no);
+			struct ieee80211_channel *channel =
+				ieee80211_get_channel(wiphy, freq);
+
+			lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %s, "
+				     "%d dBm\n",
+				     bssid, capa, chan_no,
+				     print_ssid(ssid_buf, ssid, ssid_len),
+				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
+
+			if (channel ||
+			    !(channel->flags & IEEE80211_CHAN_DISABLED))
+				cfg80211_inform_bss(wiphy, channel,
+					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
+					capa, intvl, ie, ielen,
+					LBS_SCAN_RSSI_TO_MBM(rssi),
+					GFP_KERNEL);
+		}
+		tsfdesc += 8;
+	}
+	ret = 0;
+
+ done:
+	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Our scan command contains a TLV, consting of a SSID TLV, a channel list
+ * TLV and a rates TLV. Determine the maximum size of them:
+ */
+#define LBS_SCAN_MAX_CMD_SIZE			\
+	(sizeof(struct cmd_ds_802_11_scan)	\
+	 + LBS_MAX_SSID_TLV_SIZE		\
+	 + LBS_MAX_CHANNEL_LIST_TLV_SIZE	\
+	 + LBS_MAX_RATES_TLV_SIZE)
+
+/*
+ * Assumes priv->scan_req is initialized and valid
+ * Assumes priv->scan_channel is initialized
+ */
 void lbs_scan_worker(struct work_struct *work)
 {
-	/* TODO */
+	struct lbs_private *priv =
+		container_of(work, struct lbs_private, scan_work.work);
+	struct cmd_ds_802_11_scan *scan_cmd;
+	u8 *tlv; /* pointer into our current, growing TLV storage area */
+	int last_channel;
+	int running, carrier;
+
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	scan_cmd = kzalloc(LBS_SCAN_MAX_CMD_SIZE, GFP_KERNEL);
+	if (scan_cmd == NULL)
+		goto out_no_scan_cmd;
+
+	/* prepare fixed part of scan command */
+	scan_cmd->bsstype = CMD_BSS_TYPE_ANY;
+
+	/* stop network while we're away from our main channel */
+	running = !netif_queue_stopped(priv->dev);
+	carrier = netif_carrier_ok(priv->dev);
+	if (running)
+		netif_stop_queue(priv->dev);
+	if (carrier)
+		netif_carrier_off(priv->dev);
+
+	/* prepare fixed part of scan command */
+	tlv = scan_cmd->tlvbuffer;
+
+	/* add SSID TLV */
+	if (priv->scan_req->n_ssids)
+		tlv += lbs_add_ssid_tlv(tlv,
+					priv->scan_req->ssids[0].ssid,
+					priv->scan_req->ssids[0].ssid_len);
+
+	/* add channel TLVs */
+	last_channel = priv->scan_channel + LBS_SCAN_BEFORE_NAP;
+	if (last_channel > priv->scan_req->n_channels)
+		last_channel = priv->scan_req->n_channels;
+	tlv += lbs_add_channel_list_tlv(priv, tlv, last_channel,
+		priv->scan_req->n_ssids);
+
+	/* add rates TLV */
+	tlv += lbs_add_supported_rates_tlv(tlv);
+
+	if (priv->scan_channel < priv->scan_req->n_channels) {
+		cancel_delayed_work(&priv->scan_work);
+		queue_delayed_work(priv->work_thread, &priv->scan_work,
+			msecs_to_jiffies(300));
+	}
+
+	/* This is the final data we are about to send */
+	scan_cmd->hdr.size = cpu_to_le16(tlv - (u8 *)scan_cmd);
+	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_CMD", (void *)scan_cmd,
+		    sizeof(*scan_cmd));
+	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_TLV", scan_cmd->tlvbuffer,
+		    tlv - scan_cmd->tlvbuffer);
+
+	__lbs_cmd(priv, CMD_802_11_SCAN, &scan_cmd->hdr,
+		le16_to_cpu(scan_cmd->hdr.size),
+		lbs_ret_scan, 0);
+
+	if (priv->scan_channel >= priv->scan_req->n_channels) {
+		/* Mark scan done */
+		cfg80211_scan_done(priv->scan_req, false);
+		priv->scan_req = NULL;
+	}
+
+	/* Restart network */
+	if (carrier)
+		netif_carrier_on(priv->dev);
+	if (running && !priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	kfree(scan_cmd);
+
+ out_no_scan_cmd:
+	lbs_deb_leave(LBS_DEB_SCAN);
 }
 
+
+static int lbs_cfg_scan(struct wiphy *wiphy,
+	struct net_device *dev,
+	struct cfg80211_scan_request *request)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (priv->scan_req || delayed_work_pending(&priv->scan_work)) {
+		/* old scan request not yet processed */
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	lbs_deb_scan("scan: ssids %d, channels %d, ie_len %d\n",
+		request->n_ssids, request->n_channels, request->ie_len);
+
+	priv->scan_channel = 0;
+	queue_delayed_work(priv->work_thread, &priv->scan_work,
+		msecs_to_jiffies(50));
+
+	if (priv->surpriseremoved)
+		ret = -EIO;
+
+	priv->scan_req = request;
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+
+/***************************************************************************
+ * Events
+ */
+
+#ifdef CONFIG_LIBERTAS_CFG80211
 void lbs_send_disconnect_notification(struct lbs_private *priv)
 {
-	/* TODO */
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	cfg80211_disconnected(priv->dev,
+		0,
+		NULL, 0,
+		GFP_KERNEL);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
 }
 
 void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
 {
-	/* TODO */
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	cfg80211_michael_mic_failure(priv->dev,
+		priv->assoc_bss,
+		event == MACREG_INT_CODE_MIC_ERR_MULTICAST ?
+			NL80211_KEYTYPE_GROUP :
+			NL80211_KEYTYPE_PAIRWISE,
+		-1,
+		NULL,
+		GFP_KERNEL);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
+
+#endif
+
+
+
+
+/***************************************************************************
+ * Connect/disconnect
+ */
+
+
+/*
+ * This removes all WEP keys
+ */
+static int lbs_remove_wep_keys(struct lbs_private *priv)
+{
+	struct cmd_ds_802_11_set_wep cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.keyindex = cpu_to_le16(priv->wep_tx_key);
+	cmd.action = cpu_to_le16(CMD_ACT_REMOVE);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+/*
+ * Set WEP keys
+ */
+static int lbs_set_wep_keys(struct lbs_private *priv)
+{
+	struct cmd_ds_802_11_set_wep cmd;
+	int i;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/*
+	 * command         13 00
+	 * size            50 00
+	 * sequence        xx xx
+	 * result          00 00
+	 * action          02 00     ACT_ADD
+	 * transmit key    00 00
+	 * type for key 1  01        WEP40
+	 * type for key 2  00
+	 * type for key 3  00
+	 * type for key 4  00
+	 * key 1           39 39 39 39 39 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * key 2           00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * key 3           00 00 00 00 00 00 00 00
+	 *                 00 00 00 00 00 00 00 00
+	 * key 4           00 00 00 00 00 00 00 00
+	 */
+	if (priv->wep_key_len[0] || priv->wep_key_len[1] ||
+	    priv->wep_key_len[2] || priv->wep_key_len[3]) {
+		/* Only set wep keys if we have at least one of them */
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+		cmd.keyindex = cpu_to_le16(priv->wep_tx_key);
+		cmd.action = cpu_to_le16(CMD_ACT_ADD);
+
+		for (i = 0; i < 4; i++) {
+			switch (priv->wep_key_len[i]) {
+			case WLAN_KEY_LEN_WEP40:
+				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
+				break;
+			case WLAN_KEY_LEN_WEP104:
+				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
+				break;
+			default:
+				cmd.keytype[i] = 0;
+				break;
+			}
+			memcpy(cmd.keymaterial[i], priv->wep_key[i],
+			       priv->wep_key_len[i]);
+		}
+
+		ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
+	} else {
+		/* Otherwise remove all wep keys */
+		ret = lbs_remove_wep_keys(priv);
+	}
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+/*
+ * Enable/Disable RSN status
+ */
+static int lbs_enable_rsn(struct lbs_private *priv, int enable)
+{
+	struct cmd_ds_802_11_enable_rsn cmd;
+	int ret;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", enable);
+
+	/*
+	 * cmd       2f 00
+	 * size      0c 00
+	 * sequence  xx xx
+	 * result    00 00
+	 * action    01 00    ACT_SET
+	 * enable    01 00
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.enable = cpu_to_le16(enable);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+/*
+ * Set WPA/WPA key material
+ */
+
+/* like "struct cmd_ds_802_11_key_material", but with cmd_header. Once we
+ * get rid of WEXT, this should go into host.h */
+
+struct cmd_key_material {
+	struct cmd_header hdr;
+
+	__le16 action;
+	struct MrvlIEtype_keyParamSet param;
+} __attribute__ ((packed));
+
+static int lbs_set_key_material(struct lbs_private *priv,
+				int key_type,
+				int key_info,
+				u8 *key, u16 key_len)
+{
+	struct cmd_key_material cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/*
+	 * Example for WPA (TKIP):
+	 *
+	 * cmd       5e 00
+	 * size      34 00
+	 * sequence  xx xx
+	 * result    00 00
+	 * action    01 00
+	 * TLV type  00 01    key param
+	 * length    00 26
+	 * key type  01 00    TKIP
+	 * key info  06 00    UNICAST | ENABLED
+	 * key len   20 00
+	 * key       32 bytes
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.param.type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+	cmd.param.length = cpu_to_le16(sizeof(cmd.param) - 4);
+	cmd.param.keytypeid = cpu_to_le16(key_type);
+	cmd.param.keyinfo = cpu_to_le16(key_info);
+	cmd.param.keylen = cpu_to_le16(key_len);
+	if (key && key_len)
+		memcpy(cmd.param.key, key, key_len);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return ret;
+}
+
+
+/*
+ * Sets the auth type (open, shared, etc) in the firmware. That
+ * we use CMD_802_11_AUTHENTICATE is misleading, this firmware
+ * command doesn't send an authentication frame at all, it just
+ * stores the auth_type.
+ */
+static int lbs_set_authtype(struct lbs_private *priv,
+			    struct cfg80211_connect_params *sme)
+{
+	struct cmd_ds_802_11_authenticate cmd;
+	int ret;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", sme->auth_type);
+
+	/*
+	 * cmd        11 00
+	 * size       19 00
+	 * sequence   xx xx
+	 * result     00 00
+	 * BSS id     00 13 19 80 da 30
+	 * auth type  00
+	 * reserved   00 00 00 00 00 00 00 00 00 00
+	 */
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	if (sme->bssid)
+		memcpy(cmd.bssid, sme->bssid, ETH_ALEN);
+	/* convert auth_type */
+	ret = lbs_auth_to_authtype(sme->auth_type);
+	if (ret < 0)
+		goto done;
+
+	cmd.authtype = ret;
+	ret = lbs_cmd_with_response(priv, CMD_802_11_AUTHENTICATE, &cmd);
+
+ done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Create association request
+ */
+#define LBS_ASSOC_MAX_CMD_SIZE                     \
+	(sizeof(struct cmd_ds_802_11_associate)    \
+	 - 512 /* cmd_ds_802_11_associate.iebuf */ \
+	 + LBS_MAX_SSID_TLV_SIZE                   \
+	 + LBS_MAX_CHANNEL_TLV_SIZE                \
+	 + LBS_MAX_CF_PARAM_TLV_SIZE               \
+	 + LBS_MAX_AUTH_TYPE_TLV_SIZE              \
+	 + LBS_MAX_WPA_TLV_SIZE)
+
+static int lbs_associate(struct lbs_private *priv,
+		struct cfg80211_bss *bss,
+		struct cfg80211_connect_params *sme)
+{
+	struct cmd_ds_802_11_associate_response *resp;
+	struct cmd_ds_802_11_associate *cmd = kzalloc(LBS_ASSOC_MAX_CMD_SIZE,
+						      GFP_KERNEL);
+	const u8 *ssid_eid;
+	size_t len, resp_ie_len;
+	int status;
+	int ret;
+	u8 *pos = &(cmd->iebuf[0]);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	/*
+	 * cmd              50 00
+	 * length           34 00
+	 * sequence         xx xx
+	 * result           00 00
+	 * BSS id           00 13 19 80 da 30
+	 * capabilities     11 00
+	 * listen interval  0a 00
+	 * beacon interval  00 00
+	 * DTIM period      00
+	 * TLVs             xx   (up to 512 bytes)
+	 */
+	cmd->hdr.command = cpu_to_le16(CMD_802_11_ASSOCIATE);
+
+	/* Fill in static fields */
+	memcpy(cmd->bssid, bss->bssid, ETH_ALEN);
+	cmd->listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
+	cmd->capability = cpu_to_le16(bss->capability);
+
+	/* add SSID TLV */
+	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
+	if (ssid_eid)
+		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_eid[1]);
+	else
+		lbs_deb_assoc("no SSID\n");
+
+	/* add DS param TLV */
+	if (bss->channel)
+		pos += lbs_add_channel_tlv(pos, bss->channel->hw_value);
+	else
+		lbs_deb_assoc("no channel\n");
+
+	/* add (empty) CF param TLV */
+	pos += lbs_add_cf_param_tlv(pos);
+
+	/* add rates TLV */
+	pos += lbs_add_common_rates_tlv(pos, bss);
+
+	/* add auth type TLV */
+	if (priv->fwrelease >= 0x09000000)
+		pos += lbs_add_auth_type_tlv(pos, sme->auth_type);
+
+	/* add WPA/WPA2 TLV */
+	if (sme->ie && sme->ie_len)
+		pos += lbs_add_wpa_tlv(pos, sme->ie, sme->ie_len);
+
+	len = (sizeof(*cmd) - sizeof(cmd->iebuf)) +
+		(u16)(pos - (u8 *) &cmd->iebuf);
+	cmd->hdr.size = cpu_to_le16(len);
+
+	/* store for later use */
+	memcpy(priv->assoc_bss, bss->bssid, ETH_ALEN);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_ASSOCIATE, cmd);
+	if (ret)
+		goto done;
+
+
+	/* generate connect message to cfg80211 */
+
+	resp = (void *) cmd; /* recast for easier field access */
+	status = le16_to_cpu(resp->statuscode);
+
+	/* Convert statis code of old firmware */
+	if (priv->fwrelease < 0x09000000)
+		switch (status) {
+		case 0:
+			break;
+		case 1:
+			lbs_deb_assoc("invalid association parameters\n");
+			status = WLAN_STATUS_CAPS_UNSUPPORTED;
+			break;
+		case 2:
+			lbs_deb_assoc("timer expired while waiting for AP\n");
+			status = WLAN_STATUS_AUTH_TIMEOUT;
+			break;
+		case 3:
+			lbs_deb_assoc("association refused by AP\n");
+			status = WLAN_STATUS_ASSOC_DENIED_UNSPEC;
+			break;
+		case 4:
+			lbs_deb_assoc("authentication refused by AP\n");
+			status = WLAN_STATUS_UNKNOWN_AUTH_TRANSACTION;
+			break;
+		default:
+			lbs_deb_assoc("association failure %d\n", status);
+			status = WLAN_STATUS_UNSPECIFIED_FAILURE;
+	}
+
+	lbs_deb_assoc("status %d, capability 0x%04x\n", status,
+		      le16_to_cpu(resp->capability));
+
+	resp_ie_len = le16_to_cpu(resp->hdr.size)
+		- sizeof(resp->hdr)
+		- 6;
+	cfg80211_connect_result(priv->dev,
+				priv->assoc_bss,
+				sme->ie, sme->ie_len,
+				resp->iebuf, resp_ie_len,
+				status,
+				GFP_KERNEL);
+
+	if (status == 0) {
+		/* TODO: get rid of priv->connect_status */
+		priv->connect_status = LBS_CONNECTED;
+		netif_carrier_on(priv->dev);
+		if (!priv->tx_pending_len)
+			netif_tx_wake_all_queues(priv->dev);
+	}
+
+
+done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_connect_params *sme)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cfg80211_bss *bss;
+	int ret = 0;
+	u8 preamble = RADIO_PREAMBLE_LONG;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (sme->bssid) {
+		bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
+			sme->ssid, sme->ssid_len,
+			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	} else {
+		/*
+		 * Here we have an impedance mismatch. The firmware command
+		 * CMD_802_11_ASSOCIATE always needs a BSSID, it cannot
+		 * connect otherwise. However, for the connect-API of
+		 * cfg80211 the bssid is purely optional. We don't get one,
+		 * except the user specifies one on the "iw" command line.
+		 *
+		 * If we don't got one, we could initiate a scan and look
+		 * for the best matching cfg80211_bss entry.
+		 *
+		 * Or, better yet, net/wireless/sme.c get's rewritten into
+		 * something more generally useful.
+		 */
+		lbs_pr_err("TODO: no BSS specified\n");
+		ret = -ENOTSUPP;
+		goto done;
+	}
+
+
+	if (!bss) {
+		lbs_pr_err("assicate: bss %pM not in scan results\n",
+			   sme->bssid);
+		ret = -ENOENT;
+		goto done;
+	}
+	lbs_deb_assoc("trying %pM", sme->bssid);
+	lbs_deb_assoc("cipher 0x%x, key index %d, key len %d\n",
+		      sme->crypto.cipher_group,
+		      sme->key_idx, sme->key_len);
+
+	/* As this is a new connection, clear locally stored WEP keys */
+	priv->wep_tx_key = 0;
+	memset(priv->wep_key, 0, sizeof(priv->wep_key));
+	memset(priv->wep_key_len, 0, sizeof(priv->wep_key_len));
+
+	/*
+	 * TODO: The whole key stuff seems quite fishy. Why do I think this?
+	 * Because the kdoc is very incomplete. For example, I don't have a
+	 * clue what those fields mean and/or if I should check/use them:
+	 *
+	 * sme->privacy               is this needed or redundant?  We have
+	 *                            sme->crypto.cipher_group
+	 *
+	 * crypto.wpa_versions        is this needed or redundant?  We have
+	 *                            sme->crypto.cipher_group
+	 *
+	 * crypto.n_ciphers_pairwise  for what should I use this?  Is there
+	 * crypto.ciphers_pairwise    a case where it isn't 0 (WEP) or
+	 *                            1 (WPA/WPA2) ?  I ignore them and
+	 *                            still get connected and can ping
+	 *                            throught the link.
+	 *
+	 * akm_suites                 What is "AKM" ?
+	 *
+	 * control_port               seems to be uninterting for a
+	 *                            station-only driver, or?
+	 */
+
+	/* set/remove WEP keys */
+	switch (sme->crypto.cipher_group) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		/* Store provided WEP keys in priv-> */
+		priv->wep_tx_key = sme->key_idx;
+		priv->wep_key_len[sme->key_idx] = sme->key_len;
+		memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
+		/* Set WEP keys and WEP mode */
+		lbs_set_wep_keys(priv);
+		priv->mac_control |= CMD_ACT_MAC_WEP_ENABLE;
+		lbs_set_mac_control(priv);
+		/* No RSN mode for WEP */
+		lbs_enable_rsn(priv, 0);
+		break;
+	case 0: /* there's no WLAN_CIPHER_SUITE_NONE definition */
+		/*
+		 * If we don't have no WEP, no WPA and no WPA2,
+		 * we remove all keys like in the WPA/WPA2 setup,
+		 * we just don't set RSN.
+		 *
+		 * Therefore: fall-throught
+		 */
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		/* Remove WEP keys and WEP mode */
+		lbs_remove_wep_keys(priv);
+		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
+		lbs_set_mac_control(priv);
+
+		/* clear the WPA/WPA2 keys */
+		lbs_set_key_material(priv,
+			KEY_TYPE_ID_WEP, /* doesn't matter */
+			KEY_INFO_WPA_UNICAST,
+			NULL, 0);
+		lbs_set_key_material(priv,
+			KEY_TYPE_ID_WEP, /* doesn't matter */
+			KEY_INFO_WPA_MCAST,
+			NULL, 0);
+		/* RSN mode for WPA/WPA2 */
+		lbs_enable_rsn(priv, sme->crypto.cipher_group != 0);
+		break;
+	default:
+		lbs_pr_err("unsupported cipher group 0x%x\n",
+			   sme->crypto.cipher_group);
+		ret = -ENOTSUPP;
+		goto done;
+	}
+
+	/* set authentication type (open, shared, etc) */
+	lbs_set_authtype(priv, sme);
+
+	/* TODO: here we could also set short preamble */
+	lbs_set_radio(priv, preamble, 1);
+
+	/* Do the actual association */
+	lbs_associate(priv, bss, sme);
+
+ done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+
+/* callback from lbs_cfg_disconnect() */
+static int lbs_cfg_ret_disconnect(struct lbs_private *priv, unsigned long dummy,
+			      struct cmd_header *resp)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	cfg80211_disconnected(priv->dev,
+			      priv->disassoc_reason,
+			      NULL, 0, /* TODO? */
+			      GFP_KERNEL);
+
+	/* TODO: get rid of priv->connect_status */
+	priv->connect_status = LBS_CONNECTED;
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return 0;
+}
+
+
+static int lbs_cfg_disconnect(struct wiphy *wiphy, struct net_device *dev,
+	u16 reason_code)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cmd_ds_802_11_deauthenticate cmd;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "reason_code %d", reason_code);
+
+	/* store for lbs_cfg_ret_disconnect() */
+	priv->disassoc_reason = reason_code;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	/* Mildly ugly to use a locally store my own BSSID ... */
+	memcpy(cmd.macaddr, &priv->assoc_bss, ETH_ALEN);
+	cmd.reasoncode = cpu_to_le16(reason_code);
+
+	__lbs_cmd_async(priv, CMD_802_11_DEAUTHENTICATE,
+			&cmd.hdr, sizeof(cmd),
+			lbs_cfg_ret_disconnect, 0);
+
+	return 0;
+}
+
+
+static int lbs_cfg_set_default_key(struct wiphy *wiphy,
+				   struct net_device *netdev,
+				   u8 key_index)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (key_index != priv->wep_tx_key) {
+		lbs_deb_assoc("set_default_key: to %d\n", key_index);
+		priv->wep_tx_key = key_index;
+		lbs_set_wep_keys(priv);
+	}
+
+	return 0;
+}
+
+
+static int lbs_cfg_add_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 idx, const u8 *mac_addr,
+			   struct key_params *params)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	u16 key_info;
+	u16 key_type;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	lbs_deb_assoc("add_key: cipher 0x%x, mac_addr %pM\n",
+		      params->cipher, mac_addr);
+	lbs_deb_assoc("add_key: key index %d, key len %d\n",
+		      idx, params->key_len);
+	if (params->key_len)
+		lbs_deb_hex(LBS_DEB_CFG80211, "KEY",
+			    params->key, params->key_len);
+
+	lbs_deb_assoc("add_key: seq len %d\n", params->seq_len);
+	if (params->seq_len)
+		lbs_deb_hex(LBS_DEB_CFG80211, "SEQ",
+			    params->seq, params->seq_len);
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		/* actually compare if something has changed ... */
+		if ((priv->wep_key_len[idx] != params->key_len) ||
+			memcmp(priv->wep_key[idx],
+			       params->key, params->key_len) != 0) {
+			priv->wep_key_len[idx] = params->key_len;
+			memcpy(priv->wep_key[idx],
+			       params->key, params->key_len);
+			lbs_set_wep_keys(priv);
+		}
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		key_info = KEY_INFO_WPA_ENABLED | ((idx == 0)
+						   ? KEY_INFO_WPA_UNICAST
+						   : KEY_INFO_WPA_MCAST);
+		key_type = (params->cipher == WLAN_CIPHER_SUITE_TKIP)
+			? KEY_TYPE_ID_TKIP
+			: KEY_TYPE_ID_AES;
+		lbs_set_key_material(priv,
+				     key_type,
+				     key_info,
+				     params->key, params->key_len);
+		break;
+	default:
+		lbs_pr_err("unhandled cipher 0x%x\n", params->cipher);
+		ret = -ENOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+
+static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, const u8 *mac_addr)
+{
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	lbs_deb_assoc("del_key: key_idx %d, mac_addr %pM\n",
+		      key_index, mac_addr);
+
+#ifdef TODO
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	/*
+	 * I think can keep this a NO-OP, because:
+
+	 * - we clear all keys whenever we do lbs_cfg_connect() anyway
+	 * - neither "iw" nor "wpa_supplicant" won't call this during
+	 *   an ongoing connection
+	 * - we've not kzallec() something when we've added a key at
+	 *   lbs_cfg_connect() or lbs_cfg_add_key().
+	 *
+	 * This causes lbs_cfg_del_key() only called at disconnect time,
+	 * where we'd just waste time deleting a key that is not going
+	 * to be used anyway.
+	 */
+	if (key_index < 3 && priv->wep_key_len[key_index]) {
+		priv->wep_key_len[key_index] = 0;
+		lbs_set_wep_keys(priv);
+	}
+#endif
+
+	return 0;
 }
 #endif
 
 
+
+/***************************************************************************
+ * Get station
+ */
+
+/*
+ * Returns the signal or 0 in case of an error.
+ */
+
+/* like "struct cmd_ds_802_11_rssi", but with cmd_header. Once we get rid
+ * of WEXT, this should go into host.h */
+struct cmd_rssi {
+	struct cmd_header hdr;
+
+	__le16 n_or_snr;
+	__le16 nf;
+	__le16 avg_snr;
+	__le16 avg_nf;
+} __attribute__ ((packed));
+
+static int lbs_get_signal(struct lbs_private *priv, s8 *signal, s8 *noise)
+{
+	struct cmd_rssi cmd;
+	int ret;
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.n_or_snr = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RSSI, &cmd);
+
+	if (ret == 0) {
+		*signal = CAL_RSSI(le16_to_cpu(cmd.n_or_snr),
+				le16_to_cpu(cmd.nf));
+		*noise  = CAL_NF(le16_to_cpu(cmd.nf));
+	}
+	return ret;
+}
+
+
+static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
+			      u8 *mac, struct station_info *sinfo)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	s8 signal, noise;
+	int ret;
+	size_t i;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	sinfo->filled |= STATION_INFO_TX_BYTES |
+			 STATION_INFO_TX_PACKETS |
+			 STATION_INFO_RX_BYTES |
+			 STATION_INFO_RX_PACKETS;
+	sinfo->tx_bytes = priv->dev->stats.tx_bytes;
+	sinfo->tx_packets = priv->dev->stats.tx_packets;
+	sinfo->rx_bytes = priv->dev->stats.rx_bytes;
+	sinfo->rx_packets = priv->dev->stats.rx_packets;
+
+	/* Get current RSSI */
+	ret = lbs_get_signal(priv, &signal, &noise);
+	if (ret == 0) {
+		sinfo->signal = signal;
+		sinfo->filled |= STATION_INFO_SIGNAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
+		if (priv->cur_rate == lbs_rates[i].hw_value) {
+			sinfo->txrate.legacy = lbs_rates[i].bitrate;
+			sinfo->filled |= STATION_INFO_TX_BITRATE;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+
+
+
+/***************************************************************************
+ * Initialization
+ */
+
 static struct cfg80211_ops lbs_cfg80211_ops = {
 	.set_channel = lbs_cfg_set_channel,
+#ifdef CONFIG_LIBERTAS_CFG80211
+	.scan = lbs_cfg_scan,
+	.connect = lbs_cfg_connect,
+	.disconnect = lbs_cfg_disconnect,
+	.add_key = lbs_cfg_add_key,
+	.del_key = lbs_cfg_del_key,
+	.set_default_key = lbs_cfg_set_default_key,
+#endif
+	.get_station = lbs_cfg_get_station,
 };
 
 
@@ -156,6 +1561,36 @@
 }
 
 
+static void lbs_cfg_set_regulatory_hint(struct lbs_private *priv)
+{
+	struct region_code_mapping {
+		const char *cn;
+		int code;
+	};
+
+	/* Section 5.17.2 */
+	static struct region_code_mapping regmap[] = {
+		{"US ", 0x10}, /* US FCC */
+		{"CA ", 0x20}, /* Canada */
+		{"EU ", 0x30}, /* ETSI   */
+		{"ES ", 0x31}, /* Spain  */
+		{"FR ", 0x32}, /* France */
+		{"JP ", 0x40}, /* Japan  */
+	};
+	size_t i;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	for (i = 0; i < ARRAY_SIZE(regmap); i++)
+		if (regmap[i].code == priv->regioncode) {
+			regulatory_hint(priv->wdev->wiphy, regmap[i].cn);
+			break;
+		}
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
+
+
 /*
  * This function get's called after lbs_setup_firmware() determined the
  * firmware capabities. So we can setup the wiphy according to our
@@ -171,10 +1606,10 @@
 	wdev->wiphy->max_scan_ssids = 1;
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-	/* TODO: BIT(NL80211_IFTYPE_ADHOC); */
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	/* TODO: BIT(NL80211_IFTYPE_ADHOC); */
+	/* TODO: BIT(NL80211_IFTYPE_MONITOR); */
 
-	/* TODO: honor priv->regioncode */
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
 
 	/*
@@ -192,6 +1627,8 @@
 	if (ret)
 		lbs_pr_err("cannot register network device\n");
 
+	lbs_cfg_set_regulatory_hint(priv);
+
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
 }
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -48,6 +48,9 @@
 
 	/* CFG80211 */
 	struct wireless_dev *wdev;
+	struct cfg80211_scan_request *scan_req;
+	u8 assoc_bss[ETH_ALEN];
+	u8 disassoc_reason;
 
 	/* Mesh */
 	struct net_device *mesh_dev; /* Virtual device */
@@ -148,9 +151,14 @@
 	struct enc_key wpa_unicast_key;
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
-#endif
 	u16 wep_tx_keyidx;
 	struct enc_key wep_keys[4];
+#endif
+#ifdef CONFIG_LIBERTAS_CFG80211
+	u8 wep_tx_key;
+	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
+	u8 wep_key_len[4];
+#endif
 
 	/* Wake On LAN */
 	uint32_t wol_criteria;
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -1156,7 +1156,7 @@
 		lbs_pr_err("cfg80211 init failed\n");
 		goto done;
 	}
-	/* TODO? */
+
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	priv = wdev_priv(wdev);
 	priv->wdev = wdev;
@@ -1166,7 +1166,6 @@
 		goto err_wdev;
 	}
 
-	//TODO? dev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
 	dev = alloc_netdev(0, "wlan%d", ether_setup);
 	if (!dev) {
 		dev_err(dmdev, "no memory for network device instance\n");
@@ -1187,10 +1186,6 @@
 #endif
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 
-
-	// TODO: kzalloc + iwm_init_default_profile(iwm, iwm->umac_profile); ??
-
-
 	priv->card = card;
 	priv->mesh_open = 0;
 	priv->infra_open = 0;

-- 
