Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:30166 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZJPNW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 09:22:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 23411148004
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 15:21:49 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AiHL7zdLJyaD for <linux-wireless@vger.kernel.org>;
	Fri, 16 Oct 2009 15:21:48 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA148.dip0.t-ipconnect.de [217.95.161.72])
	by mx51.mymxserver.com (Postfix) with ESMTP id ABCAF14800A
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 15:21:39 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 6FDF01E0050
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 15:21:20 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [WIP, RFC] libertas: cfg80211 support for WEP, WPA, WPA2 and NO-ENCRYPTION
Date: Fri, 16 Oct 2009 15:21:12 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910161521.13039.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[WIP, RFC] libertas: scanning and basic WEP support via cfg80211

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

* make C=2 CF=-D__CHECK_ENDIAN__ and checkpatch.pl (only one warning
  that I want to keep)



Nice stuff:

* scan.{h,c}, wext.{h,c}, 11d.{h,c}, assoc.{h,c} and hostcmd.h are now
  all history.

* no more #include <linux/wireless.h> :-)


Now, that's the nice stuff. Now to the ugly stuff:

* This is a very intrusive patch, I cared for function, and will
  create little patchlets once we know if and how this function should
  become of the Kernel

* There are some open points, all marked as TODO

* scan.{h,c}, wext.{h,c}, 11d.{h,c}, assoc.{h,c} are just disabled.
  The will go for good. But for now I kept them -> easier grepping

* no suport for IBSS yet

* no support for MESH yet (and won't be implemented by me)

* no support for monitor mode yet

* no support for RTS threshold etc

* formula for calculation of dBm migth be wrong

* no AUTH TLV for newer libertas' firmware

* still some fields in "struct libertas_private" that I want to get
  rid of, e.g. priv->connect_status. I think I can re-use something
  from struct wireless_dev for that?

* "iw eth1 connect SSID" doesn't work, you HAVE to specify the BSSID
  of an access-point: "iw eth1 connect SSID 00:11:22:33:44:55". And
  the AP has to be in cfg80211's BSS list.

  This is because of a impedance mismatch of cfg80211's
  .connect/.disconnect API and libertas firmware.

  Ah, and cfg80211's .auth/.deauth .assoc/.disassoc API doesn't suit
  the libertas firmware that much better.

* no short preamble support yet (easy to add)

* should probably sent some IE with cfg80211_disconnected()

* No support to get TX rate out of the firmware and into "iw link".
  I'm quite unsure if the firmware allows this at all.



Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Do not apply, but please look at the code and comment harshly :-)

--- /dev/null
+++ linux-wl/drivers/net/wireless/libertas/cfg.h
@@ -0,0 +1,16 @@
+#ifndef __LBS_CFG80211_H__
+#define __LBS_CFG80211_H__
+
+
+struct lbs_private;
+
+
+struct wireless_dev *lbs_cfg_alloc(struct device *dev);
+int lbs_cfg_register(struct lbs_private *priv);
+void lbs_cfg_free(struct lbs_private *priv);
+
+
+void lbs_cfg_scan_worker(struct work_struct *work);
+
+
+#endif
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
@@ -75,21 +82,586 @@
 	WLAN_CIPHER_SUITE_CCMP,
 };
 
+/* Time to stay on the channel */
+#define LBS_SCAN_DWELL_PASSIVE 100
+#define LBS_SCAN_DWELL_ACTIVE  40
 
 
+
+/***************************************************************************
+ * TLV utility functions
+ *
+ * TLVs are Marvell specific. They are very similar to IEs, they have the
+ * structure (type, length, data*). The only difference: for IEs, the type
+ * and length is an u8, Whereas for the TLVs type and length are __le16.
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
+			param->maxscantime = cpu_to_le16(LBS_SCAN_DWELL_ACTIVE);
+		} else {
+			param->chanscanmode.passivescan = 1;
+			param->maxscantime = cpu_to_le16(LBS_SCAN_DWELL_PASSIVE);
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
+ *
+ * 04 00  TLV_TYPE_CF
+ * 06 00  len
+ * 00     cfpcnt
+ * 00     cfpperiod
+ * 00 00  cfpmaxduration
+ * 00 00  cfpdurationremaining
+ */
+#define LBS_MAX_CF_PARAM_TLV_SIZE		\
+	sizeof(struct mrvl_ie_header)
+
+static int lbs_add_cf_param_tlv(u8 *tlv)
+{
+	struct mrvl_ie_cf_param_set *cf = (void *)tlv;
+
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
+	 + 64 /* TODO: I guessed the size */)
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
+
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
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+/***************************************************************************
+ * Scanning
+ */
+
+/*
+ * When scanning, the firmware doesn't send a nul packet with the power-safe
+ * bit on to the AP. So we cannot stay away from our current channel too
+ * long, otherwise we loose data. So take a "nap" while scanning every other
+ * while.
+ */
+#define LBS_SCAN_BEFORE_NAP 4
+
+/*
+ * Our scan command contains a TLV, consting of a SSID TLV, a channel list
+ * TLV and a rates TLV. Determine the maximum size of them:
+ */
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
+	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
+	nr_sets = le16_to_cpu(resp->size);
+
+	/*
+	 * The general layout of the scan response is described in
+	 * chapter 5.7.1. Basically we have a common part, then
+	 * any number off BSS descriptor sections. Finally we have
+	 * one data section with the same number of TSFs.
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
+		ielen = left = len - 6-1-8-2-2;
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
+void lbs_cfg_scan_worker(struct work_struct *work)
+{
+	struct lbs_private *priv =
+		container_of(work, struct lbs_private, scan_work.work);
+	struct cmd_ds_802_11_scan *scan_cmd;
+	u8 *tlv; /* pointer into our current, growing TLV storage area */
+	int last_channel;
+	int running, carrier;
+	int mesh_running = false;
+	int mesh_carrier = false;
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
+	if (priv->mesh_dev) {
+		mesh_running = !netif_queue_stopped(priv->mesh_dev);
+		mesh_carrier = netif_carrier_ok(priv->mesh_dev);
+		if (mesh_running)
+			netif_stop_queue(priv->mesh_dev);
+		if (mesh_carrier)
+			netif_carrier_off(priv->mesh_dev);
+	}
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
+	if (mesh_carrier)
+		netif_carrier_on(priv->mesh_dev);
+	if (mesh_running && !priv->tx_pending_len)
+		netif_wake_queue(priv->mesh_dev);
+
+	kfree(scan_cmd);
+
+ out_no_scan_cmd:
+	lbs_deb_leave(LBS_DEB_SCAN);
+}
+
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
 
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
@@ -98,9 +670,770 @@
 
 
 
+/***************************************************************************
+ * Connect/disconnect
+ */
+
+
+/*
+ * Convert NL80211's auth_type to the one from Libertas, see chapter 5.9.1
+ * in the firmware spec
+ */
+static int lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
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
+static int lbs_set_key_material(struct lbs_private *priv,
+				int key_type,
+				int key_info,
+				u8 *key, u16 key_len)
+{
+	/* This differs from cmd_ds_802_11_key_material by only having one
+	 * keyParamSet */
+	struct cmd_ds_key_material {
+		struct cmd_header hdr;
+
+		__le16 action;
+		struct MrvlIEtype_keyParamSet param;
+	} __attribute__ ((packed));
+	struct cmd_ds_key_material cmd;
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
+	 /* TODO: auth type TLV */                 \
+	 + LBS_MAX_WPA_TLV_SIZE)
+
+static int lbs_associate(struct lbs_private *priv,
+	      struct cfg80211_bss *bss,
+	      const u8 *ie, int ie_len)
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
+		lbs_pr_err("##HS TODO authentication suites as TLV\n");
+
+	/* add WPA/WPA2 TLV */
+	if (ie && ie_len)
+		pos += lbs_add_wpa_tlv(pos, ie, ie_len);
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
+	/*
+	 * TODO: do we need to convert the status values into something
+	 * that cfg80211 can digest ?
+	 */
+	lbs_deb_assoc("status %d, capability 0x%04x\n", status,
+		      le16_to_cpu(resp->capability));
+
+	resp_ie_len = le16_to_cpu(resp->hdr.size)
+		- sizeof(resp->hdr)
+		- 6;
+	cfg80211_connect_result(priv->dev,
+				priv->assoc_bss,
+				ie, ie_len,
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
+		lbs_pr_err("TODO unsupported cipher group 0x%x\n",
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
+	lbs_associate(priv, bss, sme->ie, sme->ie_len);
+
+ done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
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
+}
+
+
+#ifdef TODO
+static int lbs_cfg_get_key(struct wiphy *wiphy, struct net_device *netdev,
+		   u8 key_index, const u8 *mac_addr, void *cookie,
+		   void (*callback)(void *cookie, struct key_params*))
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO */
+
+	lbs_pr_assoc("##HS key_index %d\n", key_index);
+	lbs_pr_assoc("##HS mac_addr %pM\n", mac_addr);
+	lbs_pr_assoc("##HS cookie %p\n", cookie);
+
+	return -ENOTSUPP;
+}
+#endif
+
+
+
+
+/***************************************************************************
+ */
+
+static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
+			      u8 *mac, struct station_info *sinfo)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret;
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
+	{
+		struct cmd_ds_802_11_rssi cmd;
+
+		cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+		cmd.n_or_snr = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
+		ret = lbs_cmd_with_response(priv, CMD_802_11_RSSI, &cmd);
+		if (ret == 0) {
+			sinfo->signal = CAL_RSSI(le16_to_cpu(cmd.n_or_snr),
+						 le16_to_cpu(cmd.nf));
+			sinfo->filled |= STATION_INFO_SIGNAL;
+		}
+	}
+
+
+#ifdef TODO
+	/*
+	 * Get current TX rate.
+	 *
+	 * Unfortunately, my firmware doesn't execute this command. Maybe I
+	 * have to enable TPC beforehand ?
+	 */
+	{
+		struct cmd_tx_rate_query cmd;
+		int i;
+		u16 tx_rate;
+
+		cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+		cmd.tx_rate = 0;
+		ret = lbs_cmd_with_response(priv,
+					    CMD_802_11_TX_RATE_QUERY, &cmd);
+		if (ret == 0) {
+			tx_rate = le16_to_cpu(cmd.tx_rate);
+			for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
+				if (tx_rate == lbs_rates[i].hw_value) {
+					sinfo->txrate.legacy =
+						lbs_rates[i].bitrate;
+					sinfo->filled |=
+						STATION_INFO_TX_BITRATE;
+					break;
+				}
+			}
+		}
+	}
+#endif
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
 
 static struct cfg80211_ops lbs_cfg80211_ops = {
 	.set_channel = lbs_cfg_set_channel,
+	.scan = lbs_cfg_scan,
+	.connect = lbs_cfg_connect,
+	.disconnect = lbs_cfg_disconnect,
+	.add_key = lbs_cfg_add_key,
+	.del_key = lbs_cfg_del_key,
+	.set_default_key = lbs_cfg_set_default_key,
+	.get_station = lbs_cfg_get_station,
 };
 
 
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -7,75 +7,14 @@
 #define _LBS_DEV_H_
 
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/ethtool.h>
 #include <linux/debugfs.h>
+#include <net/cfg80211.h>
 
-#include "defs.h"
-#include "hostcmd.h"
+#include "host.h"
 
 extern const struct ethtool_ops lbs_ethtool_ops;
 
-#define	MAX_BSSID_PER_CHANNEL		16
-
-#define NR_TX_QUEUE			3
-
-/* For the extended Scan */
-#define MAX_EXTENDED_SCAN_BSSID_LIST    MAX_BSSID_PER_CHANNEL * \
-						MRVDRV_MAX_CHANNEL_SIZE + 1
-
-#define	MAX_REGION_CHANNEL_NUM	2
-
-/** Chan-freq-TxPower mapping table*/
-struct chan_freq_power {
-	/** channel Number		*/
-	u16 channel;
-	/** frequency of this channel	*/
-	u32 freq;
-	/** Max allowed Tx power level	*/
-	u16 maxtxpower;
-	/** TRUE:channel unsupported;  FLASE:supported*/
-	u8 unsupported;
-};
-
-/** region-band mapping table*/
-struct region_channel {
-	/** TRUE if this entry is valid		     */
-	u8 valid;
-	/** region code for US, Japan ...	     */
-	u8 region;
-	/** band B/G/A, used for BAND_CONFIG cmd	     */
-	u8 band;
-	/** Actual No. of elements in the array below */
-	u8 nrcfp;
-	/** chan-freq-txpower mapping table*/
-	struct chan_freq_power *CFP;
-};
-
-struct lbs_802_11_security {
-	u8 WPAenabled;
-	u8 WPA2enabled;
-	u8 wep_enabled;
-	u8 auth_mode;
-	u32 key_mgmt;
-};
-
-/** Current Basic Service Set State Structure */
-struct current_bss_params {
-	/** bssid */
-	u8 bssid[ETH_ALEN];
-	/** ssid */
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 ssid_len;
-
-	/** band */
-	u8 band;
-	/** channel */
-	u8 channel;
-	/** zero-terminated array of supported data rates */
-	u8 rates[MAX_RATES + 1];
-};
-
 /** sleep_params */
 struct sleep_params {
 	uint16_t sp_error;
@@ -100,329 +39,143 @@
 
 /** Private structure for the MV device */
 struct lbs_private {
+	/*** basic networking ***/
+	struct work_struct mcast_work;
+	struct net_device *dev;
+	int infra_open;
+	u8 multicastlist[MRVDRV_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
+	u32 nr_of_multicastmacaddr;
+	u32 connect_status;
+
+	/*** cfg80211  ***/
 	struct wireless_dev *wdev;
+	struct cfg80211_scan_request *scan_req;
+	u8 assoc_bss[ETH_ALEN];
+	u8 disassoc_reason;
+
+	/*** mesh ***/
+	struct net_device *mesh_dev; /* Virtual device */
+	struct lbs_mesh_stats mstats;
 	int mesh_open;
 	int mesh_fw_ver;
-	int infra_open;
 	int mesh_autostart_enabled;
+	struct work_struct sync_channel;
+	uint16_t mesh_tlv;
+	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN];
+	u8 mesh_ssid_len;
+	u32 mesh_connect_status;
 
-	char name[DEV_NAME_LEN];
-
-	void *card;
-	struct net_device *dev;
-
-	struct net_device *mesh_dev; /* Virtual device */
+	/*** monitor-mode ***/
 	struct net_device *rtap_net_dev;
+	u32 monitormode;
 
-	struct iw_statistics wstats;
-	struct lbs_mesh_stats mstats;
+	/*** debugfs ***/
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_debug;
 	struct dentry *debugfs_files[6];
-
 	struct dentry *events_dir;
 	struct dentry *debugfs_events_files[6];
-
 	struct dentry *regs_dir;
 	struct dentry *debugfs_regs_files[6];
 
+	/*** hardware-debugging ***/
 	u32 mac_offset;
 	u32 bbp_offset;
 	u32 rf_offset;
 
-	/** Deep sleep flag */
+	/*** Deep sleep  ***/
 	int is_deep_sleep;
-	/** Auto deep sleep enabled flag */
 	int is_auto_deep_sleep_enabled;
-	/** Device wakeup required flag */
 	int wakeup_dev_required;
-	/** Auto deep sleep flag*/
 	int is_activity_detected;
-	/** Auto deep sleep timeout (in miliseconds) */
-	int auto_deep_sleep_timeout;
-
-	/** Deep sleep wait queue */
-	wait_queue_head_t       ds_awake_q;
+	int auto_deep_sleep_timeout; /* in ms */
+	wait_queue_head_t ds_awake_q;
+	struct timer_list auto_deepsleep_timer;
 
+	/*** command download ***/
 	/* Download sent:
 	   bit0 1/0=data_sent/data_tx_done,
 	   bit1 1/0=cmd_sent/cmd_tx_done,
 	   all other bits reserved 0 */
+	u8 fw_ready;
 	u8 dnld_sent;
+	u16 seqnum;
+	struct cmd_ctrl_node *cmd_array;
+	struct cmd_ctrl_node *cur_cmd;
+	int cur_cmd_retcode;
+	struct list_head cmdfreeq;    /* free command buffers */
+	struct list_head cmdpendingq; /* pending command buffers */
+	wait_queue_head_t cmd_pending;
+	struct timer_list command_timer;
+	int nr_retries;
+	int cmd_timed_out;
 
-	/** thread to service interrupts */
+	/* Command responses sent from the hardware to the driver */
+	u8 resp_idx;
+	u8 resp_buf[2][LBS_UPLD_SIZE];
+	u32 resp_len[2];
+
+	/* Events sent from hardware to driver */
+	struct kfifo *event_fifo;
+
+	/*** Thread to service interrupts ***/
 	struct task_struct *main_thread;
 	wait_queue_head_t waitq;
 	struct workqueue_struct *work_thread;
 
-	struct work_struct mcast_work;
-
-	/** Scanning */
+	/*** Scanning ***/
 	struct delayed_work scan_work;
-	struct delayed_work assoc_work;
-	struct work_struct sync_channel;
-	/* remember which channel was scanned last, != 0 if currently scanning */
 	int scan_channel;
-	u8 scan_ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 scan_ssid_len;
 
-	/** Hardware access */
+	/*** Key material */
+	u8 wep_tx_key;
+	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
+	u8 wep_key_len[4];
+
+	/*** Hardware access ***/
+	void *card;
+	u8 surpriseremoved;
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
 	void (*reset_card) (struct lbs_private *priv);
 	int (*enter_deep_sleep) (struct lbs_private *priv);
 	int (*exit_deep_sleep) (struct lbs_private *priv);
 	int (*reset_deep_sleep_wakeup) (struct lbs_private *priv);
 
-	/* Wake On LAN */
+	/*** Wake On LAN ***/
 	uint32_t wol_criteria;
 	uint8_t wol_gpio;
 	uint8_t wol_gap;
 
-	/** Wlan adapter data structure*/
-	/** STATUS variables */
+	/*** adapter info (from eeprom) ***/
 	u32 fwrelease;
 	u32 fwcapinfo;
+	u16 regioncode;
+	u8 current_addr[ETH_ALEN];
 
 	struct mutex lock;
+	spinlock_t driver_lock;
 
-	/* TX packet ready to be sent... */
-	int tx_pending_len;		/* -1 while building packet */
-
+	/*** transmitting ***/
+	int tx_pending_len; /* -1 while building packet */
 	u8 tx_pending_buf[LBS_UPLD_SIZE];
 	/* protected by hard_start_xmit serialization */
-
-	/** command-related variables */
-	u16 seqnum;
-
-	struct cmd_ctrl_node *cmd_array;
-	/** Current command */
-	struct cmd_ctrl_node *cur_cmd;
-	int cur_cmd_retcode;
-	/** command Queues */
-	/** Free command buffers */
-	struct list_head cmdfreeq;
-	/** Pending command buffers */
-	struct list_head cmdpendingq;
-
-	wait_queue_head_t cmd_pending;
-
-	/* Command responses sent from the hardware to the driver */
-	u8 resp_idx;
-	u8 resp_buf[2][LBS_UPLD_SIZE];
-	u32 resp_len[2];
-
-	/* Events sent from hardware to driver */
-	struct kfifo *event_fifo;
-
-	/* nickname */
-	u8 nodename[16];
-
-	/** spin locks */
-	spinlock_t driver_lock;
-
-	/** Timers */
-	struct timer_list command_timer;
-	struct timer_list auto_deepsleep_timer;
-	int nr_retries;
-	int cmd_timed_out;
-
-	/** current ssid/bssid related parameters*/
-	struct current_bss_params curbssparams;
-
-	uint16_t mesh_tlv;
-	u8 mesh_ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 mesh_ssid_len;
-
-	/* IW_MODE_* */
-	u8 mode;
-
-	/* Scan results list */
-	struct list_head network_list;
-	struct list_head network_free_list;
-	struct bss_descriptor *networks;
-
-	u16 beacon_period;
-	u8 beacon_enable;
-	u8 adhoccreate;
-
-	/** capability Info used in Association, start, join */
-	u16 capability;
-
-	/** MAC address information */
-	u8 current_addr[ETH_ALEN];
-	u8 multicastlist[MRVDRV_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
-	u32 nr_of_multicastmacaddr;
-
-	/** 802.11 statistics */
-//	struct cmd_DS_802_11_GET_STAT wlan802_11Stat;
-
-	uint16_t enablehwauto;
-	uint16_t ratebitmap;
-
 	u8 txretrycount;
-
-	/** Tx-related variables (for single packet tx) */
 	struct sk_buff *currenttxskb;
 
-	/** NIC Operation characteristics */
-	u16 mac_control;
-	u32 connect_status;
-	u32 mesh_connect_status;
-	u16 regioncode;
-	s16 txpower_cur;
-	s16 txpower_min;
-	s16 txpower_max;
-
-	/** POWER MANAGEMENT AND PnP SUPPORT */
-	u8 surpriseremoved;
-
-	u16 psmode;		/* Wlan802_11PowermodeCAM=disable
-				   Wlan802_11PowermodeMAX_PSP=enable */
+	/*** power management ***/
+	u16 psmode;
 	u32 psstate;
 	u8 needtowakeup;
 
-	struct assoc_request * pending_assoc_req;
-	struct assoc_request * in_progress_assoc_req;
-
-	/** Encryption parameter */
-	struct lbs_802_11_security secinfo;
-
-	/** WEP keys */
-	struct enc_key wep_keys[4];
-	u16 wep_tx_keyidx;
-
-	/** WPA keys */
-	struct enc_key wpa_mcast_key;
-	struct enc_key wpa_unicast_key;
-
-/*
- * In theory, the IE is limited to the IE length, 255,
- * but in practice 64 bytes are enough.
- */
-#define MAX_WPA_IE_LEN 64
-
-	/** WPA Information Elements*/
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
-
-	/** Requested Signal Strength*/
-	u16 SNR[MAX_TYPE_B][MAX_TYPE_AVG];
-	u16 NF[MAX_TYPE_B][MAX_TYPE_AVG];
-	u8 RSSI[MAX_TYPE_B][MAX_TYPE_AVG];
-	u8 rawSNR[DEFAULT_DATA_AVG_FACTOR];
-	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
-	u16 nextSNRNF;
-	u16 numSNRNF;
-
+	/*** NIC operation characteristics ***/
+	u8 channel;
+	u16 mac_control;
 	u8 radio_on;
 
-	/** data rate stuff */
-	u8 cur_rate;
-
-	/** RF calibration data */
-
-#define	MAX_REGION_CHANNEL_NUM	2
-	/** region channel data */
-	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
-
-	struct region_channel universal_channel[MAX_REGION_CHANNEL_NUM];
-
-	/** 11D and Domain Regulatory Data */
-	struct lbs_802_11d_domain_reg domainreg;
-	struct parsed_region_chan_11d parsed_region_chan;
-
-	/** FSM variable for 11d support */
-	u32 enable11d;
-
-	/**	MISCELLANEOUS */
 	struct lbs_offset_value offsetvalue;
 
-	u32 monitormode;
-	u8 fw_ready;
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;
 
-/**
- *  @brief Structure used to store information for each beacon/probe response
- */
-struct bss_descriptor {
-	u8 bssid[ETH_ALEN];
-
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 ssid_len;
-
-	u16 capability;
-	u32 rssi;
-	u32 channel;
-	u16 beaconperiod;
-	__le16 atimwindow;
-
-	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
-	u8 mode;
-
-	/* zero-terminated array of supported data rates */
-	u8 rates[MAX_RATES + 1];
-
-	unsigned long last_scanned;
-
-	union ieee_phy_param_set phy;
-	union ieee_ss_param_set ss;
-
-	struct ieee_ie_country_info_full_set countryinfo;
-
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	size_t wpa_ie_len;
-	u8 rsn_ie[MAX_WPA_IE_LEN];
-	size_t rsn_ie_len;
-
-	u8 mesh;
-
-	struct list_head list;
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
-	u8 bssid[ETH_ALEN] __attribute__ ((aligned (2)));
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
-
-	/** WPA Information Elements*/
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
-
-	/* BSS to associate with for infrastructure of Ad-Hoc join */
-	struct bss_descriptor bss;
-};
-
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile
+++ linux-wl/drivers/net/wireless/libertas/Makefile
@@ -1,5 +1,3 @@
-libertas-y += 11d.o
-libertas-y += assoc.o
 libertas-y += cfg.o
 libertas-y += cmd.o
 libertas-y += cmdresp.o
@@ -8,9 +6,7 @@
 libertas-y += main.o
 libertas-y += persistcfg.o
 libertas-y += rx.o
-libertas-y += scan.o
 libertas-y += tx.o
-libertas-y += wext.o
 
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -13,18 +13,15 @@
 #include <linux/kfifo.h>
 #include <linux/stddef.h>
 #include <linux/ieee80211.h>
-#include <net/iw_handler.h>
 #include <net/cfg80211.h>
 
+#include "cmd.h"
 #include "host.h"
 #include "decl.h"
-#include "dev.h"
-#include "wext.h"
 #include "cfg.h"
 #include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
-#include "cmd.h"
+#include "dev.h"
+
 
 #define DRIVER_RELEASE_VERSION "323.p0"
 const char lbs_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
@@ -44,176 +41,6 @@
  * fast as possible down to the firmware. */
 struct cmd_confirm_sleep confirm_sleep;
 
-
-#define LBS_TX_PWR_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_US_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_JP_DEFAULT		16	/*50mW */
-#define LBS_TX_PWR_FR_DEFAULT		20	/*100mW */
-#define LBS_TX_PWR_EMEA_DEFAULT	20	/*100mW */
-
-/* Format { channel, frequency (MHz), maxtxpower } */
-/* band: 'B/G', region: USA FCC/Canada IC */
-static struct chan_freq_power channel_freq_power_US_BG[] = {
-	{1, 2412, LBS_TX_PWR_US_DEFAULT},
-	{2, 2417, LBS_TX_PWR_US_DEFAULT},
-	{3, 2422, LBS_TX_PWR_US_DEFAULT},
-	{4, 2427, LBS_TX_PWR_US_DEFAULT},
-	{5, 2432, LBS_TX_PWR_US_DEFAULT},
-	{6, 2437, LBS_TX_PWR_US_DEFAULT},
-	{7, 2442, LBS_TX_PWR_US_DEFAULT},
-	{8, 2447, LBS_TX_PWR_US_DEFAULT},
-	{9, 2452, LBS_TX_PWR_US_DEFAULT},
-	{10, 2457, LBS_TX_PWR_US_DEFAULT},
-	{11, 2462, LBS_TX_PWR_US_DEFAULT}
-};
-
-/* band: 'B/G', region: Europe ETSI */
-static struct chan_freq_power channel_freq_power_EU_BG[] = {
-	{1, 2412, LBS_TX_PWR_EMEA_DEFAULT},
-	{2, 2417, LBS_TX_PWR_EMEA_DEFAULT},
-	{3, 2422, LBS_TX_PWR_EMEA_DEFAULT},
-	{4, 2427, LBS_TX_PWR_EMEA_DEFAULT},
-	{5, 2432, LBS_TX_PWR_EMEA_DEFAULT},
-	{6, 2437, LBS_TX_PWR_EMEA_DEFAULT},
-	{7, 2442, LBS_TX_PWR_EMEA_DEFAULT},
-	{8, 2447, LBS_TX_PWR_EMEA_DEFAULT},
-	{9, 2452, LBS_TX_PWR_EMEA_DEFAULT},
-	{10, 2457, LBS_TX_PWR_EMEA_DEFAULT},
-	{11, 2462, LBS_TX_PWR_EMEA_DEFAULT},
-	{12, 2467, LBS_TX_PWR_EMEA_DEFAULT},
-	{13, 2472, LBS_TX_PWR_EMEA_DEFAULT}
-};
-
-/* band: 'B/G', region: Spain */
-static struct chan_freq_power channel_freq_power_SPN_BG[] = {
-	{10, 2457, LBS_TX_PWR_DEFAULT},
-	{11, 2462, LBS_TX_PWR_DEFAULT}
-};
-
-/* band: 'B/G', region: France */
-static struct chan_freq_power channel_freq_power_FR_BG[] = {
-	{10, 2457, LBS_TX_PWR_FR_DEFAULT},
-	{11, 2462, LBS_TX_PWR_FR_DEFAULT},
-	{12, 2467, LBS_TX_PWR_FR_DEFAULT},
-	{13, 2472, LBS_TX_PWR_FR_DEFAULT}
-};
-
-/* band: 'B/G', region: Japan */
-static struct chan_freq_power channel_freq_power_JPN_BG[] = {
-	{1, 2412, LBS_TX_PWR_JP_DEFAULT},
-	{2, 2417, LBS_TX_PWR_JP_DEFAULT},
-	{3, 2422, LBS_TX_PWR_JP_DEFAULT},
-	{4, 2427, LBS_TX_PWR_JP_DEFAULT},
-	{5, 2432, LBS_TX_PWR_JP_DEFAULT},
-	{6, 2437, LBS_TX_PWR_JP_DEFAULT},
-	{7, 2442, LBS_TX_PWR_JP_DEFAULT},
-	{8, 2447, LBS_TX_PWR_JP_DEFAULT},
-	{9, 2452, LBS_TX_PWR_JP_DEFAULT},
-	{10, 2457, LBS_TX_PWR_JP_DEFAULT},
-	{11, 2462, LBS_TX_PWR_JP_DEFAULT},
-	{12, 2467, LBS_TX_PWR_JP_DEFAULT},
-	{13, 2472, LBS_TX_PWR_JP_DEFAULT},
-	{14, 2484, LBS_TX_PWR_JP_DEFAULT}
-};
-
-/**
- * the structure for channel, frequency and power
- */
-struct region_cfp_table {
-	u8 region;
-	struct chan_freq_power *cfp_BG;
-	int cfp_no_BG;
-};
-
-/**
- * the structure for the mapping between region and CFP
- */
-static struct region_cfp_table region_cfp_table[] = {
-	{0x10,			/*US FCC */
-	 channel_freq_power_US_BG,
-	 ARRAY_SIZE(channel_freq_power_US_BG),
-	 }
-	,
-	{0x20,			/*CANADA IC */
-	 channel_freq_power_US_BG,
-	 ARRAY_SIZE(channel_freq_power_US_BG),
-	 }
-	,
-	{0x30, /*EU*/ channel_freq_power_EU_BG,
-	 ARRAY_SIZE(channel_freq_power_EU_BG),
-	 }
-	,
-	{0x31, /*SPAIN*/ channel_freq_power_SPN_BG,
-	 ARRAY_SIZE(channel_freq_power_SPN_BG),
-	 }
-	,
-	{0x32, /*FRANCE*/ channel_freq_power_FR_BG,
-	 ARRAY_SIZE(channel_freq_power_FR_BG),
-	 }
-	,
-	{0x40, /*JAPAN*/ channel_freq_power_JPN_BG,
-	 ARRAY_SIZE(channel_freq_power_JPN_BG),
-	 }
-	,
-/*Add new region here */
-};
-
-/**
- * the table to keep region code
- */
-u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE] =
-    { 0x10, 0x20, 0x30, 0x31, 0x32, 0x40 };
-
-/**
- * 802.11b/g supported bitrates (in 500Kb/s units)
- */
-u8 lbs_bg_rates[MAX_RATES] =
-    { 0x02, 0x04, 0x0b, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6c,
-0x00, 0x00 };
-
-/**
- * FW rate table.  FW refers to rates by their index in this table, not by the
- * rate value itself.  Values of 0x00 are
- * reserved positions.
- */
-static u8 fw_data_rates[MAX_RATES] =
-    { 0x02, 0x04, 0x0B, 0x16, 0x00, 0x0C, 0x12,
-      0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x00
-};
-
-/**
- *  @brief use index to get the data rate
- *
- *  @param idx                The index of data rate
- *  @return 	   		data rate or 0
- */
-u32 lbs_fw_index_to_data_rate(u8 idx)
-{
-	if (idx >= sizeof(fw_data_rates))
-		idx = 0;
-	return fw_data_rates[idx];
-}
-
-/**
- *  @brief use rate to get the index
- *
- *  @param rate                 data rate
- *  @return 	   		index or 0
- */
-u8 lbs_data_rate_to_fw_index(u32 rate)
-{
-	u8 i;
-
-	if (!rate)
-		return 0;
-
-	for (i = 0; i < sizeof(fw_data_rates); i++) {
-		if (rate == fw_data_rates[i])
-			return i;
-	}
-	return 0;
-}
-
 /**
  * Attributes exported through sysfs
  */
@@ -343,12 +170,15 @@
 		if (!priv->monitormode) {
 			if (priv->infra_open || priv->mesh_open)
 				return -EBUSY;
+			BUG();
+#ifdef TODO
 			if (priv->mode == IW_MODE_INFRA)
 				lbs_cmd_80211_deauthenticate(priv,
 							     priv->curbssparams.bssid,
 							     WLAN_REASON_DEAUTH_LEAVING);
 			else if (priv->mode == IW_MODE_ADHOC)
 				lbs_adhoc_stop(priv);
+#endif
 			lbs_add_rtap(priv);
 		}
 		priv->monitormode = monitor_mode;
@@ -405,7 +235,7 @@
 		return count;
 	if (enable)
 		action = CMD_ACT_MESH_CONFIG_START;
-	ret = lbs_mesh_config(priv, action, priv->curbssparams.channel);
+	ret = lbs_mesh_config(priv, action, priv->channel);
 	if (ret)
 		return ret;
 
@@ -559,8 +389,10 @@
 	   firmware has crapped itself -- rather than just a very
 	   busy medium. So send a harmless command, and if/when
 	   _that_ times out, we'll kick it in the head. */
+#ifdef TODO
 	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
 				     0, 0, NULL);
+#endif
 
 	lbs_deb_leave(LBS_DEB_TX);
 }
@@ -1019,7 +851,6 @@
 static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
-	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
@@ -1029,14 +860,6 @@
 	if (ret)
 		goto done;
 
-	/* Read power levels if available */
-	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
-	if (ret == 0) {
-		priv->txpower_cur = curlevel;
-		priv->txpower_min = minlevel;
-		priv->txpower_max = maxlevel;
-	}
-
 	lbs_set_mac_control(priv);
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
@@ -1098,32 +921,6 @@
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
-int lbs_enter_auto_deep_sleep(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_SDIO);
-
-	priv->is_auto_deep_sleep_enabled = 1;
-	if (priv->is_deep_sleep)
-		priv->wakeup_dev_required = 1;
-	mod_timer(&priv->auto_deepsleep_timer ,
-			jiffies + (priv->auto_deep_sleep_timeout * HZ)/1000);
-
-	lbs_deb_leave(LBS_DEB_SDIO);
-	return 0;
-}
-
-int lbs_exit_auto_deep_sleep(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_SDIO);
-
-	priv->is_auto_deep_sleep_enabled = 0;
-	priv->auto_deep_sleep_timeout = 0;
-	del_timer(&priv->auto_deepsleep_timer);
-
-	lbs_deb_leave(LBS_DEB_SDIO);
-	return 0;
-}
-
 static void lbs_sync_channel_worker(struct work_struct *work)
 {
 	struct lbs_private *priv = container_of(work, struct lbs_private,
@@ -1135,42 +932,19 @@
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
-
 static int lbs_init_adapter(struct lbs_private *priv)
 {
-	size_t bufsize;
-	int i, ret = 0;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	/* Allocate buffer to store the BSSID list */
-	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
-	priv->networks = kzalloc(bufsize, GFP_KERNEL);
-	if (!priv->networks) {
-		lbs_pr_err("Out of memory allocating beacons\n");
-		ret = -1;
-		goto out;
-	}
-
-	/* Initialize scan result lists */
-	INIT_LIST_HEAD(&priv->network_free_list);
-	INIT_LIST_HEAD(&priv->network_list);
-	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		list_add_tail(&priv->networks[i].list,
-			      &priv->network_free_list);
-	}
-
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	priv->connect_status = LBS_DISCONNECTED;
 	priv->mesh_connect_status = LBS_DISCONNECTED;
-	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	priv->mode = IW_MODE_INFRA;
-	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
+	priv->channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
-	priv->enablehwauto = 1;
-	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
 	priv->is_deep_sleep = 0;
@@ -1223,8 +997,6 @@
 		kfifo_free(priv->event_fifo);
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
-	kfree(priv->networks);
-	priv->networks = NULL;
 
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
@@ -1261,7 +1033,6 @@
 		lbs_pr_err("cfg80211 init failed\n");
 		goto done;
 	}
-	/* TODO? */
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	priv = wdev_priv(wdev);
 	priv->wdev = wdev;
@@ -1271,7 +1042,6 @@
 		goto err_wdev;
 	}
 
-	//TODO? dev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
 	dev = alloc_netdev(0, "wlan%d", ether_setup);
 	if (!dev) {
 		dev_err(dmdev, "no memory for network device instance\n");
@@ -1287,20 +1057,12 @@
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->ethtool_ops = &lbs_ethtool_ops;
-#ifdef	WIRELESS_EXT
-	dev->wireless_handlers = &lbs_handler_def;
-#endif
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 
-
-	// TODO: kzalloc + iwm_init_default_profile(iwm, iwm->umac_profile); ??
-
-
 	priv->card = card;
 	priv->mesh_open = 0;
 	priv->infra_open = 0;
 
-
 	priv->rtap_net_dev = NULL;
 	strcpy(dev->name, "wlan%d");
 
@@ -1313,8 +1075,7 @@
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
-	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
-	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
+	INIT_DELAYED_WORK(&priv->scan_work, lbs_cfg_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
@@ -1347,7 +1108,6 @@
 void lbs_remove_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
-	union iwreq_data wrqu;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
@@ -1357,7 +1117,6 @@
 	dev = priv->dev;
 
 	cancel_delayed_work_sync(&priv->scan_work);
-	cancel_delayed_work_sync(&priv->assoc_work);
 	cancel_work_sync(&priv->mcast_work);
 
 	/* worker thread destruction blocks on the in-flight command which
@@ -1372,10 +1131,6 @@
 		lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 	}
 
-	memset(wrqu.ap_addr.sa_data, 0xaa, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
 	if (priv->is_deep_sleep) {
 		priv->is_deep_sleep = 0;
 		wake_up_interruptible(&priv->ds_awake_q);
@@ -1408,9 +1163,6 @@
 	if (ret)
 		goto done;
 
-	/* init 802.11d */
-	lbs_init_11d(priv);
-
 	if (lbs_cfg_register(priv)) {
 		lbs_pr_err("cannot register device\n");
 		goto done;
@@ -1437,10 +1189,10 @@
 
 		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
 		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->curbssparams.channel)) {
+				    priv->channel)) {
 			priv->mesh_tlv = TLV_TYPE_MESH_ID;
 			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-					    priv->curbssparams.channel))
+					    priv->channel))
 				priv->mesh_tlv = 0;
 		}
 	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
@@ -1449,7 +1201,7 @@
 		 */
 		priv->mesh_tlv = TLV_TYPE_MESH_ID;
 		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->curbssparams.channel))
+				    priv->channel))
 			priv->mesh_tlv = 0;
 	}
 	if (priv->mesh_tlv) {
@@ -1568,9 +1320,6 @@
 
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
-#ifdef	WIRELESS_EXT
-	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
-#endif
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
@@ -1620,68 +1369,6 @@
 	lbs_deb_leave(LBS_DEB_MESH);
 }
 
-/**
- *  @brief This function finds the CFP in
- *  region_cfp_table based on region and band parameter.
- *
- *  @param region  The region code
- *  @param band	   The band
- *  @param cfp_no  A pointer to CFP number
- *  @return 	   A pointer to CFP
- */
-struct chan_freq_power *lbs_get_region_cfp_table(u8 region, int *cfp_no)
-{
-	int i, end;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	end = ARRAY_SIZE(region_cfp_table);
-
-	for (i = 0; i < end ; i++) {
-		lbs_deb_main("region_cfp_table[i].region=%d\n",
-			region_cfp_table[i].region);
-		if (region_cfp_table[i].region == region) {
-			*cfp_no = region_cfp_table[i].cfp_no_BG;
-			lbs_deb_leave(LBS_DEB_MAIN);
-			return region_cfp_table[i].cfp_BG;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret NULL");
-	return NULL;
-}
-
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
-{
-	int ret = 0;
-	int i = 0;
-
-	struct chan_freq_power *cfp;
-	int cfp_no;
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	memset(priv->region_channel, 0, sizeof(priv->region_channel));
-
-	cfp = lbs_get_region_cfp_table(region, &cfp_no);
-	if (cfp != NULL) {
-		priv->region_channel[i].nrcfp = cfp_no;
-		priv->region_channel[i].CFP = cfp;
-	} else {
-		lbs_deb_main("wrong region code %#x in band B/G\n",
-		       region);
-		ret = -1;
-		goto out;
-	}
-	priv->region_channel[i].valid = 1;
-	priv->region_channel[i].region = region;
-	priv->region_channel[i].band = band;
-	i++;
-out:
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
-	return ret;
-}
-
 void lbs_queue_event(struct lbs_private *priv, u32 event)
 {
 	unsigned long flags;
--- linux-wl.orig/drivers/net/wireless/libertas/persistcfg.c
+++ linux-wl/drivers/net/wireless/libertas/persistcfg.c
@@ -6,15 +6,10 @@
 #include <linux/kthread.h>
 #include <linux/kfifo.h>
 
-#include "host.h"
 #include "decl.h"
-#include "dev.h"
-#include "wext.h"
-#include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
 #include "cmd.h"
 
+
 static int mesh_get_default_parameters(struct device *dev,
 				       struct mrvl_mesh_defaults *defs)
 {
@@ -187,9 +182,9 @@
 	if (ret)
 		return ret;
 
-	if (defs.meshie.val.mesh_id_len > IW_ESSID_MAX_SIZE) {
+	if (defs.meshie.val.mesh_id_len > IEEE80211_MAX_SSID_LEN) {
 		lbs_pr_err("inconsistent mesh ID length");
-		defs.meshie.val.mesh_id_len = IW_ESSID_MAX_SIZE;
+		defs.meshie.val.mesh_id_len = IEEE80211_MAX_SSID_LEN;
 	}
 
 	/* SSID not null terminated: reserve room for \0 + \n */
@@ -214,7 +209,7 @@
 	int len;
 	int ret;
 
-	if (count < 2 || count > IW_ESSID_MAX_SIZE + 1)
+	if (count < 2 || count > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
 
 	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
@@ -233,7 +228,7 @@
 	/* SSID len */
 	ie->val.mesh_id_len = len;
 	/* IE len */
-	ie->len = sizeof(struct mrvl_meshie_val) - IW_ESSID_MAX_SIZE + len;
+	ie->len = sizeof(struct mrvl_meshie_val) - IEEE80211_MAX_SSID_LEN + len;
 
 	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
 				   CMD_TYPE_MESH_SET_MESH_IE);
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -3,18 +3,13 @@
   * It prepares command and sends it to firmware when it is ready.
   */
 
-#include <net/iw_handler.h>
 #include <net/lib80211.h>
 #include <linux/kfifo.h>
 #include <linux/sched.h>
-#include "host.h"
-#include "hostcmd.h"
-#include "decl.h"
-#include "defs.h"
-#include "dev.h"
-#include "assoc.h"
-#include "wext.h"
+
 #include "cmd.h"
+#include "dev.h"
+
 
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
 
@@ -86,16 +81,12 @@
 {
 	int ret = 1;
 
-	lbs_deb_enter(LBS_DEB_CMD);
-
 	if (!priv->is_auto_deep_sleep_enabled) {
 		if (priv->is_deep_sleep) {
 			lbs_deb_cmd("command not allowed in deep sleep\n");
 			ret = 0;
 		}
 	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
 }
 
@@ -106,6 +97,8 @@
  *
  *  @return 	   	0 on success, error on failure
  */
+static u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE] =
+{ 0x10, 0x20, 0x30, 0x31, 0x32, 0x40 };
 int lbs_update_hw_spec(struct lbs_private *priv)
 {
 	struct cmd_ds_get_hw_spec cmd;
@@ -187,16 +180,6 @@
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
-	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
-		ret = -1;
-		goto out;
-	}
-
-	if (lbs_set_universaltable(priv, 0)) {
-		ret = -1;
-		goto out;
-	}
-
 out:
 	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
@@ -245,7 +228,7 @@
 
 	cmd->command = cpu_to_le16(CMD_802_11_PS_MODE);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_ps_mode) +
-				S_DS_GEN);
+				sizeof(struct cmd_header));
 	psm->action = cpu_to_le16(cmd_action);
 	psm->multipledtim = 0;
 	switch (cmd_action) {
@@ -274,33 +257,6 @@
 	return 0;
 }
 
-int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
-				      uint16_t cmd_action, uint16_t *timeout)
-{
-	struct cmd_ds_802_11_inactivity_timeout cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.hdr.command = cpu_to_le16(CMD_802_11_INACTIVITY_TIMEOUT);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_SET)
-		cmd.timeout = cpu_to_le16(*timeout);
-	else
-		cmd.timeout = 0;
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_INACTIVITY_TIMEOUT, &cmd);
-
-	if (!ret)
-		*timeout = le16_to_cpu(cmd.timeout);
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return 0;
-}
-
 int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
 				struct sleep_params *sp)
 {
@@ -343,251 +299,6 @@
 	return 0;
 }
 
-static int lbs_wait_for_ds_awake(struct lbs_private *priv)
-{
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (priv->is_deep_sleep) {
-		if (!wait_event_interruptible_timeout(priv->ds_awake_q,
-					!priv->is_deep_sleep, (10 * HZ))) {
-			lbs_pr_err("ds_awake_q: timer expired\n");
-			ret = -1;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep)
-{
-	int ret =  0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (deep_sleep) {
-		if (priv->is_deep_sleep != 1) {
-			lbs_deb_cmd("deep sleep: sleep\n");
-			BUG_ON(!priv->enter_deep_sleep);
-			ret = priv->enter_deep_sleep(priv);
-			if (!ret) {
-				netif_stop_queue(priv->dev);
-				netif_carrier_off(priv->dev);
-			}
-		} else {
-			lbs_pr_err("deep sleep: already enabled\n");
-		}
-	} else {
-		if (priv->is_deep_sleep) {
-			lbs_deb_cmd("deep sleep: wakeup\n");
-			BUG_ON(!priv->exit_deep_sleep);
-			ret = priv->exit_deep_sleep(priv);
-			if (!ret) {
-				ret = lbs_wait_for_ds_awake(priv);
-				if (ret)
-					lbs_pr_err("deep sleep: wakeup"
-							"failed\n");
-			}
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
-			   struct assoc_request *assoc)
-{
-	struct cmd_ds_802_11_set_wep cmd;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_ADD) {
-		int i;
-
-		/* default tx key index */
-		cmd.keyindex = cpu_to_le16(assoc->wep_tx_keyidx &
-					   CMD_WEP_KEY_INDEX_MASK);
-
-		/* Copy key types and material to host command structure */
-		for (i = 0; i < 4; i++) {
-			struct enc_key *pkey = &assoc->wep_keys[i];
-
-			switch (pkey->len) {
-			case KEY_LEN_WEP_40:
-				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
-				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
-				lbs_deb_cmd("SET_WEP: add key %d (40 bit)\n", i);
-				break;
-			case KEY_LEN_WEP_104:
-				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
-				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
-				lbs_deb_cmd("SET_WEP: add key %d (104 bit)\n", i);
-				break;
-			case 0:
-				break;
-			default:
-				lbs_deb_cmd("SET_WEP: invalid key %d, length %d\n",
-					    i, pkey->len);
-				ret = -1;
-				goto done;
-				break;
-			}
-		}
-	} else if (cmd_action == CMD_ACT_REMOVE) {
-		/* ACT_REMOVE clears _all_ WEP keys */
-
-		/* default tx key index */
-		cmd.keyindex = cpu_to_le16(priv->wep_tx_keyidx &
-					   CMD_WEP_KEY_INDEX_MASK);
-		lbs_deb_cmd("SET_WEP: remove key %d\n", priv->wep_tx_keyidx);
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
-done:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
-			      uint16_t *enable)
-{
-	struct cmd_ds_802_11_enable_rsn cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_GET)
-		cmd.enable = 0;
-	else {
-		if (*enable)
-			cmd.enable = cpu_to_le16(CMD_ENABLE_RSN);
-		else
-			cmd.enable = cpu_to_le16(CMD_DISABLE_RSN);
-		lbs_deb_cmd("ENABLE_RSN: %d\n", *enable);
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_ENABLE_RSN, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET)
-		*enable = le16_to_cpu(cmd.enable);
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-static void set_one_wpa_key(struct MrvlIEtype_keyParamSet *keyparam,
-                            struct enc_key *key)
-{
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (key->flags & KEY_INFO_WPA_ENABLED)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_ENABLED);
-	if (key->flags & KEY_INFO_WPA_UNICAST)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_UNICAST);
-	if (key->flags & KEY_INFO_WPA_MCAST)
-		keyparam->keyinfo |= cpu_to_le16(KEY_INFO_WPA_MCAST);
-
-	keyparam->type = cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
-	keyparam->keytypeid = cpu_to_le16(key->type);
-	keyparam->keylen = cpu_to_le16(key->len);
-	memcpy(keyparam->key, key->key, key->len);
-
-	/* Length field doesn't include the {type,length} header */
-	keyparam->length = cpu_to_le16(sizeof(*keyparam) - 4);
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
-int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
-				struct assoc_request *assoc)
-{
-	struct cmd_ds_802_11_key_material cmd;
-	int ret = 0;
-	int index = 0;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.action = cpu_to_le16(cmd_action);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	if (cmd_action == CMD_ACT_GET) {
-		cmd.hdr.size = cpu_to_le16(S_DS_GEN + 2);
-	} else {
-		memset(cmd.keyParamSet, 0, sizeof(cmd.keyParamSet));
-
-		if (test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc->flags)) {
-			set_one_wpa_key(&cmd.keyParamSet[index],
-					&assoc->wpa_unicast_key);
-			index++;
-		}
-
-		if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc->flags)) {
-			set_one_wpa_key(&cmd.keyParamSet[index],
-					&assoc->wpa_mcast_key);
-			index++;
-		}
-
-		/* The common header and as many keys as we included */
-		cmd.hdr.size = cpu_to_le16(offsetof(typeof(cmd),
-						    keyParamSet[index]));
-	}
-	ret = lbs_cmd_with_response(priv, CMD_802_11_KEY_MATERIAL, &cmd);
-	/* Copy the returned key to driver private data */
-	if (!ret && cmd_action == CMD_ACT_GET) {
-		void *buf_ptr = cmd.keyParamSet;
-		void *resp_end = &(&cmd)[1];
-
-		while (buf_ptr < resp_end) {
-			struct MrvlIEtype_keyParamSet *keyparam = buf_ptr;
-			struct enc_key *key;
-			uint16_t param_set_len = le16_to_cpu(keyparam->length);
-			uint16_t key_len = le16_to_cpu(keyparam->keylen);
-			uint16_t key_flags = le16_to_cpu(keyparam->keyinfo);
-			uint16_t key_type = le16_to_cpu(keyparam->keytypeid);
-			void *end;
-
-			end = (void *)keyparam + sizeof(keyparam->type)
-				+ sizeof(keyparam->length) + param_set_len;
-
-			/* Make sure we don't access past the end of the IEs */
-			if (end > resp_end)
-				break;
-
-			if (key_flags & KEY_INFO_WPA_UNICAST)
-				key = &priv->wpa_unicast_key;
-			else if (key_flags & KEY_INFO_WPA_MCAST)
-				key = &priv->wpa_mcast_key;
-			else
-				break;
-
-			/* Copy returned key into driver */
-			memset(key, 0, sizeof(struct enc_key));
-			if (key_len > sizeof(key->key))
-				break;
-			key->type = key_type;
-			key->flags = key_flags;
-			key->len = key_len;
-			memcpy(key->key, keyparam->key, key->len);
-
-			buf_ptr = end + 1;
-		}
-	}
-
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
 /**
  *  @brief Set an SNMP MIB value
  *
@@ -687,201 +398,69 @@
 	return ret;
 }
 
-/**
- *  @brief Get the min, max, and current TX power
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param curlevel  	Current power level in dBm
- *  @param minlevel  	Minimum supported power level in dBm (optional)
- *  @param maxlevel  	Maximum supported power level in dBm (optional)
- *
- *  @return 	   	0 on success, error on failure
- */
-int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
-		     s16 *maxlevel)
-{
-	struct cmd_ds_802_11_rf_tx_power cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(CMD_ACT_GET);
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_TX_POWER, &cmd);
-	if (ret == 0) {
-		*curlevel = le16_to_cpu(cmd.curlevel);
-		if (minlevel)
-			*minlevel = cmd.minlevel;
-		if (maxlevel)
-			*maxlevel = cmd.maxlevel;
-	}
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return ret;
-}
-
-/**
- *  @brief Set the TX power
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param dbm  	The desired power level in dBm
- *
- *  @return 	   	0 on success, error on failure
- */
-int lbs_set_tx_power(struct lbs_private *priv, s16 dbm)
+int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on)
 {
-	struct cmd_ds_802_11_rf_tx_power cmd;
-	int ret;
+	struct cmd_ds_802_11_radio_control cmd;
+	int ret = -EINVAL;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
-	cmd.curlevel = cpu_to_le16(dbm);
-
-	lbs_deb_cmd("SET_RF_TX_POWER: %d dBm\n", dbm);
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_TX_POWER, &cmd);
 
-	lbs_deb_leave(LBS_DEB_CMD);
-	return ret;
-}
-
-static int lbs_cmd_802_11_monitor_mode(struct cmd_ds_command *cmd,
-				      u16 cmd_action, void *pdata_buf)
-{
-	struct cmd_ds_802_11_monitor_mode *monitor = &cmd->params.monitor;
-
-	cmd->command = cpu_to_le16(CMD_802_11_MONITOR_MODE);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_monitor_mode) +
-			     S_DS_GEN);
-
-	monitor->action = cpu_to_le16(cmd_action);
-	if (cmd_action == CMD_ACT_SET) {
-		monitor->mode =
-		    cpu_to_le16((u16) (*(u32 *) pdata_buf));
+	/* Only v8 and below support setting the preamble */
+	if (priv->fwrelease < 0x09000000) {
+		switch (preamble) {
+		case RADIO_PREAMBLE_SHORT:
+		case RADIO_PREAMBLE_AUTO:
+		case RADIO_PREAMBLE_LONG:
+			cmd.control = cpu_to_le16(preamble);
+			break;
+		default:
+			goto out;
+		}
 	}
 
-	return 0;
-}
-
-static __le16 lbs_rate_to_fw_bitmap(int rate, int lower_rates_ok)
-{
-/*		Bit  	Rate
-*		15:13 Reserved
-*		12    54 Mbps
-*		11    48 Mbps
-*		10    36 Mbps
-*		9     24 Mbps
-*		8     18 Mbps
-*		7     12 Mbps
-*		6     9 Mbps
-*		5     6 Mbps
-*		4     Reserved
-*		3     11 Mbps
-*		2     5.5 Mbps
-*		1     2 Mbps
-*		0     1 Mbps
-**/
-
-	uint16_t ratemask;
-	int i = lbs_data_rate_to_fw_index(rate);
-	if (lower_rates_ok)
-		ratemask = (0x1fef >> (12 - i));
+	if (radio_on)
+		cmd.control |= cpu_to_le16(0x1);
 	else
-		ratemask = (1 << i);
-	return cpu_to_le16(ratemask);
-}
-
-int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
-				      uint16_t cmd_action)
-{
-	struct cmd_ds_802_11_rate_adapt_rateset cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CMD);
+		cmd.control &= cpu_to_le16(~0x1);
 
-	if (!priv->cur_rate && !priv->enablehwauto)
-		return -EINVAL;
+	lbs_deb_cmd("RADIO_CONTROL: radio %s, preamble %d\n",
+		    radio_on ? "ON" : "OFF", preamble);
 
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	priv->radio_on = radio_on;
 
-	cmd.action = cpu_to_le16(cmd_action);
-	cmd.enablehwauto = cpu_to_le16(priv->enablehwauto);
-	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET) {
-		priv->ratebitmap = le16_to_cpu(cmd.bitmap);
-		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
-	}
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RADIO_CONTROL, &cmd);
 
+out:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lbs_cmd_802_11_rate_adapt_rateset);
 
-/**
- *  @brief Set the data rate
- *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param rate  	The desired data rate, or 0 to clear a locked rate
- *
- *  @return 	   	0 on success, error on failure
- */
-int lbs_set_data_rate(struct lbs_private *priv, u8 rate)
+void lbs_set_mac_control(struct lbs_private *priv)
 {
-	struct cmd_ds_802_11_data_rate cmd;
-	int ret = 0;
+	struct cmd_ds_mac_control cmd;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(priv->mac_control);
+	cmd.reserved = 0;
 
-	if (rate > 0) {
-		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_FIX_RATE);
-		cmd.rates[0] = lbs_data_rate_to_fw_index(rate);
-		if (cmd.rates[0] == 0) {
-			lbs_deb_cmd("DATA_RATE: invalid requested rate of"
-			            " 0x%02X\n", rate);
-			ret = 0;
-			goto out;
-		}
-		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n", cmd.rates[0]);
-	} else {
-		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_AUTO);
-		lbs_deb_cmd("DATA_RATE: setting auto\n");
-	}
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
-	if (ret)
-		goto out;
-
-	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof (cmd));
-
-	/* FIXME: get actual rates FW can do if this command actually returns
-	 * all data rates supported.
-	 */
-	priv->cur_rate = lbs_fw_index_to_data_rate(cmd.rates[0]);
-	lbs_deb_cmd("DATA_RATE: current rate is 0x%02x\n", priv->cur_rate);
+	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
 
-out:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
+	lbs_deb_leave(LBS_DEB_CMD);
 }
 
 /**
  *  @brief Get the radio channel
  *
- *  @param priv    	A pointer to struct lbs_private structure
+ *  @param priv         A pointer to struct lbs_private structure
  *
- *  @return 	   	The channel on success, error on failure
+ *  @return             The channel on success, error on failure
  */
-int lbs_get_channel(struct lbs_private *priv)
+static int lbs_get_channel(struct lbs_private *priv)
 {
 	struct cmd_ds_802_11_rf_channel cmd;
 	int ret = 0;
@@ -904,21 +483,6 @@
 	return ret;
 }
 
-int lbs_update_channel(struct lbs_private *priv)
-{
-	int ret;
-
-	/* the channel in f/w could be out of sync; get the current channel */
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	ret = lbs_get_channel(priv);
-	if (ret > 0) {
-		priv->curbssparams.channel = ret;
-		ret = 0;
-	}
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
 
 /**
  *  @brief Set the radio channel
@@ -932,7 +496,7 @@
 {
 	struct cmd_ds_802_11_rf_channel cmd;
 #ifdef DEBUG
-	u8 old_channel = priv->curbssparams.channel;
+	u8 old_channel = priv->channel;
 #endif
 	int ret = 0;
 
@@ -947,34 +511,29 @@
 	if (ret)
 		goto out;
 
-	priv->curbssparams.channel = (uint8_t) le16_to_cpu(cmd.channel);
+	priv->channel = (uint8_t) le16_to_cpu(cmd.channel);
 	lbs_deb_cmd("channel switch from %d to %d\n", old_channel,
-		priv->curbssparams.channel);
+		priv->channel);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
 
-static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *cmd)
+int lbs_update_channel(struct lbs_private *priv)
 {
+	int ret;
 
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
+	/* the channel in f/w could be out of sync; get the current channel */
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	ret = lbs_get_channel(priv);
+	if (ret > 0) {
+		priv->channel = ret;
+		ret = 0;
+	}
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
+	return ret;
 }
 
 static int lbs_cmd_reg_access(struct cmd_ds_command *cmdptr,
@@ -993,7 +552,7 @@
 
 			cmdptr->size =
 			    cpu_to_le16(sizeof (struct cmd_ds_mac_reg_access)
-					+ S_DS_GEN);
+					+ sizeof(struct cmd_header));
 			macreg =
 			    (struct cmd_ds_mac_reg_access *)&cmdptr->params.
 			    macreg;
@@ -1012,7 +571,7 @@
 			cmdptr->size =
 			    cpu_to_le16(sizeof
 					     (struct cmd_ds_bbp_reg_access)
-					     + S_DS_GEN);
+					     + sizeof(struct cmd_header));
 			bbpreg =
 			    (struct cmd_ds_bbp_reg_access *)&cmdptr->params.
 			    bbpreg;
@@ -1031,7 +590,7 @@
 			cmdptr->size =
 			    cpu_to_le16(sizeof
 					     (struct cmd_ds_rf_reg_access) +
-					     S_DS_GEN);
+					     sizeof(struct cmd_header));
 			rfreg =
 			    (struct cmd_ds_rf_reg_access *)&cmdptr->params.
 			    rfreg;
@@ -1058,18 +617,21 @@
 	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
 	cmd->command = cpu_to_le16(CMD_BT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access) + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access)
+				+ sizeof(struct cmd_header));
 	cmd->result = 0;
 	bt_access->action = cpu_to_le16(cmd_action);
 
 	switch (cmd_action) {
 	case CMD_ACT_BT_ACCESS_ADD:
 		memcpy(bt_access->addr1, pdata_buf, 2 * ETH_ALEN);
-		lbs_deb_hex(LBS_DEB_MESH, "BT_ADD: blinded MAC addr", bt_access->addr1, 6);
+		lbs_deb_hex(LBS_DEB_MESH, "BT_ADD: blinded MAC addr",
+			    bt_access->addr1, 6);
 		break;
 	case CMD_ACT_BT_ACCESS_DEL:
 		memcpy(bt_access->addr1, pdata_buf, 1 * ETH_ALEN);
-		lbs_deb_hex(LBS_DEB_MESH, "BT_DEL: blinded MAC addr", bt_access->addr1, 6);
+		lbs_deb_hex(LBS_DEB_MESH, "BT_DEL: blinded MAC addr",
+			    bt_access->addr1, 6);
 		break;
 	case CMD_ACT_BT_ACCESS_LIST:
 		bt_access->id = cpu_to_le32(*(u32 *) pdata_buf);
@@ -1095,7 +657,8 @@
 	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
 	cmd->command = cpu_to_le16(CMD_FWT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) +
+				sizeof(struct cmd_header));
 	cmd->result = 0;
 
 	if (pdata_buf)
@@ -1201,7 +764,7 @@
 		ie->val.mesh_id_len = priv->mesh_ssid_len;
 		memcpy(ie->val.mesh_id, priv->mesh_ssid, priv->mesh_ssid_len);
 		ie->len = sizeof(struct mrvl_meshie_val) -
-			IW_ESSID_MAX_SIZE + priv->mesh_ssid_len;
+			IEEE80211_MAX_SSID_LEN + priv->mesh_ssid_len;
 		cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie_val));
 		break;
 	case CMD_ACT_MESH_CONFIG_STOP:
@@ -1216,27 +779,6 @@
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
 
-static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
-				struct cmd_ds_command *cmd,
-				u16 cmd_action)
-{
-	struct cmd_ds_802_11_beacon_control
-		*bcn_ctrl = &cmd->params.bcn_ctrl;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_beacon_control)
-			     + S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
-
-	bcn_ctrl->action = cpu_to_le16(cmd_action);
-	bcn_ctrl->beacon_enable = cpu_to_le16(priv->beacon_enable);
-	bcn_ctrl->beacon_period = cpu_to_le16(priv->beacon_period);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static void lbs_queue_cmd(struct lbs_private *priv,
 			  struct cmd_ctrl_node *cmdnode)
 {
@@ -1382,66 +924,6 @@
 	priv->cur_cmd = NULL;
 }
 
-int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on)
-{
-	struct cmd_ds_802_11_radio_control cmd;
-	int ret = -EINVAL;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(CMD_ACT_SET);
-
-	/* Only v8 and below support setting the preamble */
-	if (priv->fwrelease < 0x09000000) {
-		switch (preamble) {
-		case RADIO_PREAMBLE_SHORT:
-			if (!(priv->capability & WLAN_CAPABILITY_SHORT_PREAMBLE))
-				goto out;
-			/* Fall through */
-		case RADIO_PREAMBLE_AUTO:
-		case RADIO_PREAMBLE_LONG:
-			cmd.control = cpu_to_le16(preamble);
-			break;
-		default:
-			goto out;
-		}
-	}
-
-	if (radio_on)
-		cmd.control |= cpu_to_le16(0x1);
-	else {
-		cmd.control &= cpu_to_le16(~0x1);
-		priv->txpower_cur = 0;
-	}
-
-	lbs_deb_cmd("RADIO_CONTROL: radio %s, preamble %d\n",
-		    radio_on ? "ON" : "OFF", preamble);
-
-	priv->radio_on = radio_on;
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_RADIO_CONTROL, &cmd);
-
-out:
-	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-	return ret;
-}
-
-void lbs_set_mac_control(struct lbs_private *priv)
-{
-	struct cmd_ds_mac_control cmd;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(priv->mac_control);
-	cmd.reserved = 0;
-
-	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
-
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
 /**
  *  @brief This function prepare the command before send to firmware.
  *
@@ -1518,68 +1000,6 @@
 		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_MONITOR_MODE:
-		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
-				          cmd_action, pdata_buf);
-		break;
-
-	case CMD_802_11_RSSI:
-		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
-		break;
-
-	case CMD_802_11_SET_AFC:
-	case CMD_802_11_GET_AFC:
-
-		cmdptr->command = cpu_to_le16(cmd_no);
-		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_afc) +
-					   S_DS_GEN);
-
-		memmove(&cmdptr->params.afc,
-			pdata_buf, sizeof(struct cmd_ds_802_11_afc));
-
-		ret = 0;
-		goto done;
-
-	case CMD_802_11D_DOMAIN_INFO:
-		ret = lbs_cmd_802_11d_domain_info(priv, cmdptr,
-						   cmd_no, cmd_action);
-		break;
-
-	case CMD_802_11_TPC_CFG:
-		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
-		cmdptr->size =
-		    cpu_to_le16(sizeof(struct cmd_ds_802_11_tpc_cfg) +
-				     S_DS_GEN);
-
-		memmove(&cmdptr->params.tpccfg,
-			pdata_buf, sizeof(struct cmd_ds_802_11_tpc_cfg));
-
-		ret = 0;
-		break;
-	case CMD_802_11_LED_GPIO_CTRL:
-		{
-			struct mrvl_ie_ledgpio *gpio =
-			    (struct mrvl_ie_ledgpio*)
-			    cmdptr->params.ledgpio.data;
-
-			memmove(&cmdptr->params.ledgpio,
-				pdata_buf,
-				sizeof(struct cmd_ds_802_11_led_ctrl));
-
-			cmdptr->command =
-			    cpu_to_le16(CMD_802_11_LED_GPIO_CTRL);
-
-#define ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN 8
-			cmdptr->size =
-			    cpu_to_le16(le16_to_cpu(gpio->header.len)
-				+ S_DS_GEN
-				+ ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
-			gpio->header.len = gpio->header.len;
-
-			ret = 0;
-			break;
-		}
-
 	case CMD_BT_ACCESS:
 		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
 		break;
@@ -1588,18 +1008,9 @@
 		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_GET_TSF:
-		cmdptr->command = cpu_to_le16(CMD_GET_TSF);
-		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_get_tsf) +
-					   S_DS_GEN);
-		ret = 0;
-		break;
-	case CMD_802_11_BEACON_CTRL:
-		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
-		break;
 	case CMD_802_11_DEEP_SLEEP:
 		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
-		cmdptr->size = cpu_to_le16(S_DS_GEN);
+		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
 		break;
 	default:
 		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
@@ -1893,6 +1304,7 @@
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
 		    ((priv->connect_status == LBS_CONNECTED) ||
 		    (priv->mesh_connect_status == LBS_CONNECTED))) {
+#ifdef TODO
 			if (priv->secinfo.WPAenabled ||
 			    priv->secinfo.WPA2enabled) {
 				/* check for valid WPA group keys */
@@ -1909,6 +1321,7 @@
 				       "go back to PS_SLEEP");
 				lbs_ps_sleep(priv, 0);
 			}
+#endif
 		}
 	}
 
@@ -1918,30 +1331,6 @@
 	return ret;
 }
 
-void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
-{
-	union iwreq_data iwrq;
-	u8 buf[50];
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	memset(&iwrq, 0, sizeof(union iwreq_data));
-	memset(buf, 0, sizeof(buf));
-
-	snprintf(buf, sizeof(buf) - 1, "%s", str);
-
-	iwrq.data.length = strlen(buf) + 1 + IW_EV_LCP_LEN;
-
-	/* Send Event to upper layer */
-	lbs_deb_wext("event indication string %s\n", (char *)buf);
-	lbs_deb_wext("event indication length %d\n", iwrq.data.length);
-	lbs_deb_wext("sending wireless event IWEVCUSTOM for %s\n", str);
-
-	wireless_send_event(priv->dev, IWEVCUSTOM, &iwrq, buf);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-}
-
 static void lbs_send_confirmsleep(struct lbs_private *priv)
 {
 	unsigned long flags;
@@ -1973,21 +1362,6 @@
 	lbs_deb_leave(LBS_DEB_HOST);
 }
 
-void lbs_ps_sleep(struct lbs_private *priv, int wait_option)
-{
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	/*
-	 * PS is currently supported only in Infrastructure mode
-	 * Remove this check if it is to be supported in IBSS mode also
-	 */
-
-	lbs_prepare_and_send_command(priv, CMD_802_11_PS_MODE,
-			      CMD_SUBCMD_ENTER_PS, wait_option, 0, NULL);
-
-	lbs_deb_leave(LBS_DEB_HOST);
-}
-
 /**
  *  @brief This function sends Exit_PS command to firmware.
  *
@@ -2055,70 +1429,6 @@
 }
 
 
-/**
- * @brief Configures the transmission power control functionality.
- *
- * @param priv		A pointer to struct lbs_private structure
- * @param enable	Transmission power control enable
- * @param p0		Power level when link quality is good (dBm).
- * @param p1		Power level when link quality is fair (dBm).
- * @param p2		Power level when link quality is poor (dBm).
- * @param usesnr	Use Signal to Noise Ratio in TPC
- *
- * @return 0 on success
- */
-int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
-		int8_t p2, int usesnr)
-{
-	struct cmd_ds_802_11_tpc_cfg cmd;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(CMD_ACT_SET);
-	cmd.enable = !!enable;
-	cmd.usesnr = !!usesnr;
-	cmd.P0 = p0;
-	cmd.P1 = p1;
-	cmd.P2 = p2;
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_TPC_CFG, &cmd);
-
-	return ret;
-}
-
-/**
- * @brief Configures the power adaptation settings.
- *
- * @param priv		A pointer to struct lbs_private structure
- * @param enable	Power adaptation enable
- * @param p0		Power level for 1, 2, 5.5 and 11 Mbps (dBm).
- * @param p1		Power level for 6, 9, 12, 18, 22, 24 and 36 Mbps (dBm).
- * @param p2		Power level for 48 and 54 Mbps (dBm).
- *
- * @return 0 on Success
- */
-
-int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
-		int8_t p1, int8_t p2)
-{
-	struct cmd_ds_802_11_pa_cfg cmd;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(CMD_ACT_SET);
-	cmd.enable = !!enable;
-	cmd.P0 = p0;
-	cmd.P1 = p1;
-	cmd.P2 = p2;
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_PA_CFG , &cmd);
-
-	return ret;
-}
-
-
 struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
@@ -2217,5 +1527,3 @@
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__lbs_cmd);
-
-
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -7,14 +7,10 @@
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
 #include <asm/unaligned.h>
-#include <net/iw_handler.h>
 
-#include "host.h"
-#include "decl.h"
-#include "defs.h"
+#include "cmd.h"
 #include "dev.h"
-#include "assoc.h"
-#include "wext.h"
+
 
 /**
  *  @brief This function handles disconnect event. it
@@ -24,26 +20,13 @@
  *  @param priv    A pointer to struct lbs_private structure
  *  @return 	   n/a
  */
-void lbs_mac_event_disconnected(struct lbs_private *priv)
+static void lbs_mac_event_disconnected(struct lbs_private *priv)
 {
-	union iwreq_data wrqu;
-
 	if (priv->connect_status != LBS_CONNECTED)
 		return;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-
-	/*
-	 * Cisco AP sends EAP failure and de-auth in less than 0.5 ms.
-	 * It causes problem in the Supplicant
-	 */
-
-	msleep_interruptible(1000);
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
 	/* report disconnect to upper layer */
 	netif_stop_queue(priv->dev);
 	netif_carrier_off(priv->dev);
@@ -53,23 +36,8 @@
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 
-	/* reset SNR/NF/RSSI values */
-	memset(priv->SNR, 0x00, sizeof(priv->SNR));
-	memset(priv->NF, 0x00, sizeof(priv->NF));
-	memset(priv->RSSI, 0x00, sizeof(priv->RSSI));
-	memset(priv->rawSNR, 0x00, sizeof(priv->rawSNR));
-	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
-	priv->nextSNRNF = 0;
-	priv->numSNRNF = 0;
 	priv->connect_status = LBS_DISCONNECTED;
 
-	/* Clear out associated SSID and BSSID since connection is
-	 * no longer valid.
-	 */
-	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
-	memset(&priv->curbssparams.ssid, 0, IW_ESSID_MAX_SIZE);
-	priv->curbssparams.ssid_len = 0;
-
 	if (priv->psstate != PS_STATE_FULL_POWER) {
 		/* make firmware to exit PS mode */
 		lbs_deb_cmd("disconnected, so exit PS mode\n");
@@ -100,7 +68,7 @@
 		strcat(buf, "multicast ");
 	}
 
-	lbs_send_iwevcustom_event(priv, buf);
+	/* TODO */
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
@@ -147,53 +115,6 @@
 	return ret;
 }
 
-static int lbs_ret_802_11_rssi(struct lbs_private *priv,
-				struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rssi_rsp *rssirsp = &resp->params.rssirsp;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/* store the non average value */
-	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->SNR);
-	priv->NF[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->noisefloor);
-
-	priv->SNR[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgSNR);
-	priv->NF[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgnoisefloor);
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
-static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
-					struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_beacon_control *bcn_ctrl =
-	    &resp->params.bcn_ctrl;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (bcn_ctrl->action == CMD_ACT_GET) {
-		priv->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
-		priv->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
-	}
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
 static inline int handle_cmd_response(struct lbs_private *priv,
 				      struct cmd_header *cmd_response)
 {
@@ -211,45 +132,6 @@
 		ret = lbs_ret_reg_access(priv, respcmd, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_SET_AFC):
-	case CMD_RET(CMD_802_11_GET_AFC):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.afc,
-			sizeof(struct cmd_ds_802_11_afc));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-
-		break;
-
-	case CMD_RET(CMD_802_11_BEACON_STOP):
-		break;
-
-	case CMD_RET(CMD_802_11_RSSI):
-		ret = lbs_ret_802_11_rssi(priv, resp);
-		break;
-
-	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
-		ret = lbs_ret_802_11d_domain_info(resp);
-		break;
-
-	case CMD_RET(CMD_802_11_TPC_CFG):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
-			sizeof(struct cmd_ds_802_11_tpc_cfg));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
-	case CMD_RET(CMD_802_11_LED_GPIO_CTRL):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.ledgpio,
-			sizeof(struct cmd_ds_802_11_led_ctrl));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
-
-	case CMD_RET(CMD_GET_TSF):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memcpy((void *)priv->cur_cmd->callback_arg,
-		       &resp->params.gettsf.tsfvalue, sizeof(u64));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
 	case CMD_RET(CMD_BT_ACCESS):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (priv->cur_cmd->callback_arg)
@@ -264,9 +146,6 @@
 			       sizeof(resp->params.fwt));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
-	case CMD_RET(CMD_802_11_BEACON_CTRL):
-		ret = lbs_ret_802_11_bcn_ctrl(priv, resp);
-		break;
 
 	default:
 		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
@@ -359,7 +238,7 @@
 			 * ad-hoc mode. It takes place in
 			 * lbs_execute_next_command().
 			 */
-			if (priv->mode == IW_MODE_ADHOC &&
+			if (priv->wdev->iftype == NL80211_IFTYPE_ADHOC &&
 			    action == CMD_SUBCMD_ENTER_PS)
 				priv->psmode = LBS802_11POWERMODECAM;
 		} else if (action == CMD_SUBCMD_ENTER_PS) {
@@ -591,7 +470,14 @@
 			if (!priv->tx_pending_len)
 				netif_wake_queue(priv->mesh_dev);
 		}
+#ifdef TODO
+		/* This used to be:
 		priv->mode = IW_MODE_ADHOC;
+		  ... but ...
+		  priv->wdev->iftype NL80211_IFTYPE_ADHOC
+		is equally broken */
+#endif
+		BUG();
 		schedule_work(&priv->sync_channel);
 		break;
 
--- linux-wl.orig/drivers/net/wireless/libertas/ethtool.c
+++ linux-wl/drivers/net/wireless/libertas/ethtool.c
@@ -2,12 +2,9 @@
 #include <linux/ethtool.h>
 #include <linux/delay.h>
 
-#include "host.h"
-#include "decl.h"
-#include "defs.h"
-#include "dev.h"
-#include "wext.h"
 #include "cmd.h"
+#include "dev.h"
+
 
 static const char * mesh_stat_strings[]= {
 			"drop_duplicate_bcast",
--- linux-wl.orig/drivers/net/wireless/libertas/rx.c
+++ linux-wl/drivers/net/wireless/libertas/rx.c
@@ -3,12 +3,12 @@
   */
 #include <linux/etherdevice.h>
 #include <linux/types.h>
+#include <linux/ieee80211.h>
 
-#include "hostcmd.h"
-#include "radiotap.h"
 #include "decl.h"
+#include "radiotap.h"
 #include "dev.h"
-#include "wext.h"
+
 
 struct eth803hdr {
 	u8 dest_addr[6];
@@ -38,99 +38,6 @@
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
@@ -232,14 +139,6 @@
 	 */
 	skb_pull(skb, hdrchop);
 
-	/* Take the data rate from the rxpd structure
-	 * only if the rate is auto
-	 */
-	if (priv->enablehwauto)
-		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
-
-	lbs_compute_rssi(priv, p_rx_pd);
-
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
@@ -360,14 +259,6 @@
 	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
 	memcpy(pradiotap_hdr, &radiotap_hdr, sizeof(struct rx_radiotap_hdr));
 
-	/* Take the data rate from the rxpd structure
-	 * only if the rate is auto
-	 */
-	if (priv->enablehwauto)
-		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
-
-	lbs_compute_rssi(priv, prxpd);
-
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
--- linux-wl.orig/drivers/net/wireless/libertas/tx.c
+++ linux-wl/drivers/net/wireless/libertas/tx.c
@@ -4,13 +4,12 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
+#include <linux/ieee80211.h>
 
-#include "hostcmd.h"
-#include "radiotap.h"
 #include "decl.h"
-#include "defs.h"
+#include "radiotap.h"
 #include "dev.h"
-#include "wext.h"
+
 
 /**
  *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
+++ linux-wl/drivers/net/wireless/libertas/cmd.h
@@ -3,11 +3,29 @@
 #ifndef _LBS_CMD_H_
 #define _LBS_CMD_H_
 
-#include "hostcmd.h"
-#include "dev.h"
+#include "host.h"
+
+struct sleep_params;
+
+/* Command execution */
+
+struct cmd_ctrl_node {
+	struct list_head list;
+	int result;
+	/* command response */
+	int (*callback)(struct lbs_private *,
+			unsigned long,
+			struct cmd_header *);
+	unsigned long callback_arg;
+	/* command data */
+	struct cmd_header *cmdbuf;
+	/* wait queue */
+	u16 cmdwaitqwoken;
+	wait_queue_head_t cmdwait_q;
+};
 
 /* lbs_cmd() infers the size of the buffer to copy data back into, from
-   the size of the target of the pointer. Since the command to be sent 
+   the size of the target of the pointer. Since the command to be sent
    may often be smaller, that size is set in cmd->size by the caller.*/
 #define lbs_cmd(priv, cmdnr, cmd, cb, cb_arg)	({		\
 	uint16_t __sz = le16_to_cpu((cmd)->hdr.size);		\
@@ -18,6 +36,11 @@
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
 
+int lbs_prepare_and_send_command(struct lbs_private *priv,
+				 u16 cmd_no,
+				 u16 cmd_action,
+				 u16 wait_option, u32 cmd_oid, void *pdata_buf);
+
 void lbs_cmd_async(struct lbs_private *priv, uint16_t command,
 	struct cmd_header *in_cmd, int in_cmd_size);
 
@@ -31,62 +54,63 @@
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	unsigned long callback_arg);
 
-int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
-		int8_t p1, int8_t p2);
+int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
+		     struct cmd_header *resp);
 
-int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
-		int8_t p2, int usesnr);
+int lbs_allocate_cmd_buffer(struct lbs_private *priv);
+int lbs_free_cmd_buffer(struct lbs_private *priv);
 
-int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
-		int8_t p1, int8_t p2);
+int lbs_execute_next_command(struct lbs_private *priv);
+void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
+			  int result);
+int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
 
-int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
-		int8_t p2, int usesnr);
+void lbs_queue_event(struct lbs_private *priv, u32 event);
+int lbs_process_event(struct lbs_private *priv, u32 event);
 
-int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
-		     struct cmd_header *resp);
+
+/* Code for actual commands */
+
+int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val);
+
+int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val);
+
+int lbs_set_channel(struct lbs_private *priv, u8 channel);
+
+int lbs_update_channel(struct lbs_private *priv);
+
+int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
+
+void lbs_set_mac_control(struct lbs_private *priv);
 
 int lbs_update_hw_spec(struct lbs_private *priv);
 
+int lbs_suspend(struct lbs_private *priv);
+
+void lbs_resume(struct lbs_private *priv);
+
+
+
+/* Mesh related */
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 		    struct cmd_ds_mesh_access *cmd);
 
-int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
-
-int lbs_get_channel(struct lbs_private *priv);
-int lbs_set_channel(struct lbs_private *priv, u8 channel);
+int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
 
 int lbs_mesh_config_send(struct lbs_private *priv,
 			 struct cmd_ds_mesh_config *cmd,
 			 uint16_t action, uint16_t type);
-int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
 
+/* Sleep related */
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
-		struct wol_config *p_wol_config);
-int lbs_suspend(struct lbs_private *priv);
-void lbs_resume(struct lbs_private *priv);
+		       struct wol_config *p_wol_config);
 
-int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
-				      uint16_t cmd_action);
-int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
-				      uint16_t cmd_action, uint16_t *timeout);
 int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
 				struct sleep_params *sp);
-int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
-			   struct assoc_request *assoc);
-int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
-			      uint16_t *enable);
-int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
-				struct assoc_request *assoc);
-
-int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
-		     s16 *maxlevel);
-int lbs_set_tx_power(struct lbs_private *priv, s16 dbm);
 
-int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
+void lbs_ps_confirm_sleep(struct lbs_private *priv);
 
-int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val);
+void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
 
-int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val);
 
 #endif /* _LBS_CMD_H */
--- linux-wl.orig/drivers/net/wireless/libertas/debugfs.c
+++ linux-wl/drivers/net/wireless/libertas/debugfs.c
@@ -4,20 +4,14 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <net/iw_handler.h>
 #include <net/lib80211.h>
 
-#include "dev.h"
-#include "decl.h"
-#include "host.h"
 #include "debugfs.h"
 #include "cmd.h"
+#include "dev.h"
+
 
 static struct dentry *lbs_dir;
-static char *szStates[] = {
-	"Connected",
-	"Disconnected"
-};
 
 #ifdef PROC_DEBUG
 static void lbs_debug_init(struct lbs_private *priv);
@@ -48,8 +42,6 @@
 	if (!buf)
 		return -ENOMEM;
 
-	pos += snprintf(buf+pos, len-pos, "state = %s\n",
-				szStates[priv->connect_status]);
 	pos += snprintf(buf+pos, len-pos, "region_code = %02x\n",
 				(u32) priv->regioncode);
 
@@ -60,50 +52,6 @@
 }
 
 
-static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	size_t pos = 0;
-	int numscansdone = 0, res;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-	DECLARE_SSID_BUF(ssid);
-	struct bss_descriptor * iter_bss;
-	if (!buf)
-		return -ENOMEM;
-
-	pos += snprintf(buf+pos, len-pos,
-		"# | ch  | rssi |       bssid       |   cap    | Qual | SSID \n");
-
-	mutex_lock(&priv->lock);
-	list_for_each_entry (iter_bss, &priv->network_list, list) {
-		u16 ibss = (iter_bss->capability & WLAN_CAPABILITY_IBSS);
-		u16 privacy = (iter_bss->capability & WLAN_CAPABILITY_PRIVACY);
-		u16 spectrum_mgmt = (iter_bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT);
-
-		pos += snprintf(buf+pos, len-pos, "%02u| %03d | %04d | %pM |",
-			numscansdone, iter_bss->channel, iter_bss->rssi,
-			iter_bss->bssid);
-		pos += snprintf(buf+pos, len-pos, " %04x-", iter_bss->capability);
-		pos += snprintf(buf+pos, len-pos, "%c%c%c |",
-				ibss ? 'A' : 'I', privacy ? 'P' : ' ',
-				spectrum_mgmt ? 'S' : ' ');
-		pos += snprintf(buf+pos, len-pos, " %04d |", SCAN_RSSI(iter_bss->rssi));
-		pos += snprintf(buf+pos, len-pos, " %s\n",
-		                print_ssid(ssid, iter_bss->ssid,
-					   iter_bss->ssid_len));
-
-		numscansdone++;
-	}
-	mutex_unlock(&priv->lock);
-
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return res;
-}
-
 static ssize_t lbs_sleepparams_write(struct file *file,
 				const char __user *user_buf, size_t count,
 				loff_t *ppos)
@@ -189,6 +137,7 @@
  * and returns a pointer to the first data byte of the TLV, or to NULL
  * if the TLV hasn't been found.
  */
+#ifdef TODO
 static void *lbs_tlv_find(uint16_t tlv_type, const uint8_t *tlv, uint16_t size)
 {
 	struct mrvl_ie_header *tlv_h;
@@ -429,7 +378,7 @@
 	return lbs_threshold_write(TLV_TYPE_BCNMISS, CMD_SUBSCRIBE_BCNMISS,
 				   file, userbuf, count, ppos);
 }
-
+#endif
 
 
 static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
@@ -722,12 +671,11 @@
 
 static const struct lbs_debugfs_files debugfs_files[] = {
 	{ "info", 0444, FOPS(lbs_dev_info, write_file_dummy), },
-	{ "getscantable", 0444, FOPS(lbs_getscantable,
-					write_file_dummy), },
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
 };
 
+#ifdef TODO
 static const struct lbs_debugfs_files debugfs_events_files[] = {
 	{"low_rssi", 0644, FOPS(lbs_lowrssi_read,
 				lbs_lowrssi_write), },
@@ -742,6 +690,7 @@
 	{"high_snr", 0644, FOPS(lbs_highsnr_read,
 				lbs_highsnr_write), },
 };
+#endif
 
 static const struct lbs_debugfs_files debugfs_regs_files[] = {
 	{"rdmac", 0644, FOPS(lbs_rdmac_read, lbs_rdmac_write), },
@@ -791,6 +740,7 @@
 	if (!priv->events_dir)
 		goto exit;
 
+#ifdef TODO
 	for (i=0; i<ARRAY_SIZE(debugfs_events_files); i++) {
 		files = &debugfs_events_files[i];
 		priv->debugfs_events_files[i] = debugfs_create_file(files->name,
@@ -799,6 +749,7 @@
 							     priv,
 							     &files->fops);
 	}
+#endif
 
 	priv->regs_dir = debugfs_create_dir("registers", priv->debugfs_dir);
 	if (!priv->regs_dir)
@@ -829,8 +780,10 @@
 
 	debugfs_remove(priv->regs_dir);
 
+#ifdef TODO
 	for(i=0; i<ARRAY_SIZE(debugfs_events_files); i++)
 		debugfs_remove(priv->debugfs_events_files[i]);
+#endif
 
 	debugfs_remove(priv->events_dir);
 #ifdef PROC_DEBUG
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -17,65 +17,28 @@
 struct cmd_ctrl_node;
 struct cmd_ds_command;
 
-void lbs_set_mac_control(struct lbs_private *priv);
+/* rx.c */
+int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
+/* tx.c */
 void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count);
-
-int lbs_free_cmd_buffer(struct lbs_private *priv);
-
-int lbs_prepare_and_send_command(struct lbs_private *priv,
-	u16 cmd_no,
-	u16 cmd_action,
-	u16 wait_option, u32 cmd_oid, void *pdata_buf);
-
-int lbs_allocate_cmd_buffer(struct lbs_private *priv);
-int lbs_execute_next_command(struct lbs_private *priv);
-int lbs_process_event(struct lbs_private *priv, u32 event);
-void lbs_queue_event(struct lbs_private *priv, u32 event);
-void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
-int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
-int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
-int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
-
-u32 lbs_fw_index_to_data_rate(u8 index);
-u8 lbs_data_rate_to_fw_index(u32 rate);
-
-/** The proc fs interface */
-int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
-void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
-			  int result);
 netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *dev);
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
 
-int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
-void lbs_ps_sleep(struct lbs_private *priv, int wait_option);
-void lbs_ps_confirm_sleep(struct lbs_private *priv);
-void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
-
-struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_private *priv,
-	u8 band,
-	u16 channel);
-
-void lbs_mac_event_disconnected(struct lbs_private *priv);
+/* main.c */
+void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
 
-void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
 
 /* persistcfg.c */
 void lbs_persist_config_init(struct net_device *net);
 void lbs_persist_config_remove(struct net_device *net);
 
 /* main.c */
-struct chan_freq_power *lbs_get_region_cfp_table(u8 region,
-	int *cfp_no);
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
 void lbs_remove_card(struct lbs_private *priv);
 int lbs_start_card(struct lbs_private *priv);
 void lbs_stop_card(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
-int lbs_update_channel(struct lbs_private *priv);
-
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/defs.h
+++ linux-wl/drivers/net/wireless/libertas/defs.h
@@ -320,9 +320,6 @@
 
 /** Global Variable Declaration */
 extern const char lbs_driver_version[];
-extern u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE];
-
-extern u8 lbs_bg_rates[MAX_RATES];
 
 /** ENUM definition*/
 /** SNRNF_TYPE */
--- linux-wl.orig/drivers/net/wireless/libertas/types.h
+++ linux-wl/drivers/net/wireless/libertas/types.h
@@ -5,8 +5,8 @@
 #define _LBS_TYPES_H_
 
 #include <linux/if_ether.h>
+#include <linux/ieee80211.h>
 #include <asm/byteorder.h>
-#include <linux/wireless.h>
 
 struct ieee_ie_header {
 	u8 id;
@@ -247,7 +247,7 @@
 	uint8_t active_metric_id;
 	uint8_t mesh_capability;
 	uint8_t mesh_id_len;
-	uint8_t mesh_id[IW_ESSID_MAX_SIZE];
+	uint8_t mesh_id[IEEE80211_MAX_SSID_LEN];
 } __attribute__ ((packed));
 
 struct mrvl_meshie {
--- linux-wl.orig/drivers/net/wireless/libertas/host.h
+++ linux-wl/drivers/net/wireless/libertas/host.h
@@ -1,13 +1,16 @@
-/**
-  * This file contains definitions of WLAN commands.
-  */
+/*
+ * This file contains the function prototypes, data structure
+ * and defines for all the host/station commands
+ */
+#ifndef _LBS_HOSTCMD_H
+#define _LBS_HOSTCMD_H
+
+#include "types.h"
+#include "defs.h"
 
-#ifndef _LBS_HOST_H_
-#define _LBS_HOST_H_
+struct lbs_private;
 
-/** PUBLIC DEFINITIONS */
 #define DEFAULT_AD_HOC_CHANNEL			6
-#define	DEFAULT_AD_HOC_CHANNEL_A		36
 
 #define CMD_OPTION_WAITFORRSP			0x0002
 
@@ -98,30 +101,16 @@
 #define CMD_SUBCMD_FULL_POWERDOWN	0x0035
 #define CMD_SUBCMD_FULL_POWERUP		0x0036
 
-#define CMD_ENABLE_RSN			0x0001
-#define CMD_DISABLE_RSN			0x0000
-
 #define CMD_ACT_GET			0x0000
 #define CMD_ACT_SET			0x0001
-#define CMD_ACT_GET_AES			0x0002
-#define CMD_ACT_SET_AES			0x0003
-#define CMD_ACT_REMOVE_AES		0x0004
 
 /* Define action or option for CMD_802_11_SET_WEP */
 #define CMD_ACT_ADD			0x0002
 #define CMD_ACT_REMOVE			0x0004
-#define CMD_ACT_USE_DEFAULT		0x0008
 
 #define CMD_TYPE_WEP_40_BIT		0x01
 #define CMD_TYPE_WEP_104_BIT		0x02
 
-#define CMD_NUM_OF_WEP_KEYS		4
-
-#define CMD_WEP_KEY_INDEX_MASK		0x3fff
-
-/* Define action or option for CMD_802_11_RESET */
-#define CMD_ACT_HALT			0x0003
-
 /* Define action or option for CMD_802_11_SCAN */
 #define CMD_BSS_TYPE_BSS		0x0001
 #define CMD_BSS_TYPE_IBSS		0x0002
@@ -168,12 +157,14 @@
 #define CMD_ACT_SET_TX_FIX_RATE		0x0001
 #define CMD_ACT_GET_TX_RATE		0x0002
 
+#ifdef TODO
 #define CMD_ACT_SET_RX			0x0001
 #define	CMD_ACT_SET_TX			0x0002
 #define CMD_ACT_SET_BOTH		0x0003
 #define	CMD_ACT_GET_RX			0x0004
 #define CMD_ACT_GET_TX			0x0008
 #define	CMD_ACT_GET_BOTH		0x000c
+#endif
 
 /* Define action or option for CMD_802_11_PS_MODE */
 #define CMD_TYPE_CAM			0x0000
@@ -303,4 +294,464 @@
 #define MACREG_INT_CODE_MESH_AUTO_STARTED	35
 #define MACREG_INT_CODE_FIRMWARE_READY		48
 
+
+/* 802.11-related definitions */
+
+/* TxPD descriptor */
+struct txpd {
+	/* union to cope up with later FW revisions */
+	union {
+		/* Current Tx packet status */
+		__le32 tx_status;
+		struct {
+			/* BSS type: client, AP, etc. */
+			u8 bss_type;
+			/* BSS number */
+			u8 bss_num;
+			/* Reserved */
+			__le16 reserved;
+		} bss;
+	} u;
+	/* Tx control */
+	__le32 tx_control;
+	__le32 tx_packet_location;
+	/* Tx packet length */
+	__le16 tx_packet_length;
+	/* First 2 byte of destination MAC address */
+	u8 tx_dest_addr_high[2];
+	/* Last 4 byte of destination MAC address */
+	u8 tx_dest_addr_low[4];
+	/* Pkt Priority */
+	u8 priority;
+	/* Pkt Trasnit Power control */
+	u8 powermgmt;
+	/* Amount of time the packet has been queued (units = 2ms) */
+	u8 pktdelay_2ms;
+	/* reserved */
+	u8 reserved1;
+} __attribute__ ((packed));
+
+/* RxPD Descriptor */
+struct rxpd {
+	/* union to cope up with later FW revisions */
+	union {
+		/* Current Rx packet status */
+		__le16 status;
+		struct {
+			/* BSS type: client, AP, etc. */
+			u8 bss_type;
+			/* BSS number */
+			u8 bss_num;
+		} __attribute__ ((packed)) bss;
+	} __attribute__ ((packed)) u;
+
+	/* SNR */
+	u8 snr;
+
+	/* Tx control */
+	u8 rx_control;
+
+	/* Pkt length */
+	__le16 pkt_len;
+
+	/* Noise Floor */
+	u8 nf;
+
+	/* Rx Packet Rate */
+	u8 rx_rate;
+
+	/* Pkt addr */
+	__le32 pkt_ptr;
+
+	/* Next Rx RxPD addr */
+	__le32 next_rxpd_ptr;
+
+	/* Pkt Priority */
+	u8 priority;
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+struct cmd_header {
+	__le16 command;
+	__le16 size;
+	__le16 seqnum;
+	__le16 result;
+} __attribute__ ((packed));
+
+/* lbs_offset_value */
+struct lbs_offset_value {
+	u32 offset;
+	u32 value;
+} __attribute__ ((packed));
+
+/*
+ * Define data structure for CMD_GET_HW_SPEC
+ * This structure defines the response for the GET_HW_SPEC command
+ */
+struct cmd_ds_get_hw_spec {
+	struct cmd_header hdr;
+
+	/* HW Interface version number */
+	__le16 hwifversion;
+	/* HW version number */
+	__le16 version;
+	/* Max number of TxPD FW can handle */
+	__le16 nr_txpd;
+	/* Max no of Multicast address */
+	__le16 nr_mcast_adr;
+	/* MAC address */
+	u8 permanentaddr[6];
+
+	/* region Code */
+	__le16 regioncode;
+
+	/* Number of antenna used */
+	__le16 nr_antenna;
+
+	/* FW release number, example 0x01030304 = 2.3.4p1 */
+	__le32 fwrelease;
+
+	/* Base Address of TxPD queue */
+	__le32 wcb_base;
+	/* Read Pointer of RxPd queue */
+	__le32 rxpd_rdptr;
+
+	/* Write Pointer of RxPd queue */
+	__le32 rxpd_wrptr;
+
+	/*FW/HW capability */
+	__le32 fwcapinfo;
+} __attribute__ ((packed));
+
+/*
+ * This scan handle Country Information IE(802.11d compliant)
+ * Define data structure for CMD_802_11_SCAN
+ */
+struct cmd_ds_802_11_scan {
+	struct cmd_header hdr;
+
+	uint8_t bsstype;
+	uint8_t bssid[ETH_ALEN];
+	uint8_t tlvbuffer[0];
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_scan_rsp {
+	struct cmd_header hdr;
+
+	__le16 bssdescriptsize;
+	uint8_t nr_sets;
+	uint8_t bssdesc_and_tlvbuffer[0];
+} __attribute__ ((packed));
+
+struct cmd_ds_mac_control {
+	struct cmd_header hdr;
+	__le16 action;
+	u16 reserved;
+} __attribute__ ((packed));
+
+struct cmd_ds_mac_multicast_adr {
+	struct cmd_header hdr;
+	__le16 action;
+	__le16 nr_of_adrs;
+	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_authenticate {
+	struct cmd_header hdr;
+
+	u8 bssid[ETH_ALEN];
+	u8 authtype;
+	u8 reserved[10];
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_deauthenticate {
+	struct cmd_header hdr;
+
+	u8 macaddr[ETH_ALEN];
+	__le16 reasoncode;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_associate {
+	struct cmd_header hdr;
+
+	u8 bssid[6];
+	__le16 capability;
+	__le16 listeninterval;
+	__le16 bcnperiod;
+	u8 dtimperiod;
+	u8 iebuf[512];    /* Enough for required and most optional IEs */
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_associate_response {
+	struct cmd_header hdr;
+
+	__le16 capability;
+	__le16 statuscode;
+	__le16 aid;
+	u8 iebuf[512];
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_set_wep {
+	struct cmd_header hdr;
+
+	/* ACT_ADD, ACT_REMOVE or ACT_ENABLE */
+	__le16 action;
+
+	/* key Index selected for Tx */
+	__le16 keyindex;
+
+	/* 40, 128bit or TXWEP */
+	uint8_t keytype[4];
+	uint8_t keymaterial[4][16];
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_snmp_mib {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 oid;
+	__le16 bufsize;
+	u8 value[128];
+} __attribute__ ((packed));
+
+struct cmd_ds_mac_reg_access {
+	__le16 action;
+	__le16 offset;
+	__le32 value;
+} __attribute__ ((packed));
+
+struct cmd_ds_bbp_reg_access {
+	__le16 action;
+	__le16 offset;
+	u8 value;
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+struct cmd_ds_rf_reg_access {
+	__le16 action;
+	__le16 offset;
+	u8 value;
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_radio_control {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 control;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_sleep_params {
+	struct cmd_header hdr;
+
+	/* ACT_GET/ACT_SET */
+	__le16 action;
+
+	/* Sleep clock error in ppm */
+	__le16 error;
+
+	/* Wakeup offset in usec */
+	__le16 offset;
+
+	/* Clock stabilization time in usec */
+	__le16 stabletime;
+
+	/* control periodic calibration */
+	uint8_t calcontrol;
+
+	/* control the use of external sleep clock */
+	uint8_t externalsleepclk;
+
+	/* reserved field, should be set to zero */
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_rf_channel {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 channel;
+	__le16 rftype;      /* unused */
+	__le16 reserved;    /* unused */
+	u8 channellist[32]; /* unused */
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_rssi {
+	struct cmd_header hdr;
+
+	__le16 n_or_snr;
+	__le16 nf;
+	__le16 avg_snr;
+	__le16 avg_nf;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_mac_address {
+	struct cmd_header hdr;
+
+	__le16 action;
+	u8 macadd[ETH_ALEN];
+} __attribute__ ((packed));
+
+struct cmd_ds_set_boot2_ver {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 version;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_fw_wake_method {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 method;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_ps_mode {
+	__le16 action;
+	__le16 nullpktinterval;
+	__le16 multipledtim;
+	__le16 reserved;
+	__le16 locallisteninterval;
+} __attribute__ ((packed));
+
+struct cmd_confirm_sleep {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 nullpktinterval;
+	__le16 multipledtim;
+	__le16 reserved;
+	__le16 locallisteninterval;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_enable_rsn {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 enable;
+} __attribute__ ((packed));
+
+struct MrvlIEtype_keyParamSet {
+	/* type ID */
+	__le16 type;
+
+	/* length of Payload */
+	__le16 length;
+
+	/* type of key: WEP=0, TKIP=1, AES=2 */
+	__le16 keytypeid;
+
+	/* key control Info specific to a keytypeid */
+	__le16 keyinfo;
+
+	/* length of key */
+	__le16 keylen;
+
+	/* key material of size keylen */
+	u8 key[32];
+} __attribute__ ((packed));
+
+#define MAX_WOL_RULES 		16
+
+struct host_wol_rule {
+	uint8_t rule_no;
+	uint8_t rule_ops;
+	__le16 sig_offset;
+	__le16 sig_length;
+	__le16 reserve;
+	__be32 sig_mask;
+	__be32 signature;
+} __attribute__ ((packed));
+
+struct wol_config {
+	uint8_t action;
+	uint8_t pattern;
+	uint8_t no_rules_in_cmd;
+	uint8_t result;
+	struct host_wol_rule rule[MAX_WOL_RULES];
+} __attribute__ ((packed));
+
+struct cmd_ds_host_sleep {
+	struct cmd_header hdr;
+	__le32 criteria;
+	uint8_t gpio;
+	uint16_t gap;
+	struct wol_config wol_conf;
+} __attribute__ ((packed));
+
+struct cmd_ds_802_11_eeprom_access {
+	struct cmd_header hdr;
+	__le16 action;
+	__le16 offset;
+	__le16 len;
+	/* firmware says it returns a maximum of 20 bytes */
+#define LBS_EEPROM_READ_LEN 20
+	u8 value[LBS_EEPROM_READ_LEN];
+} __attribute__ ((packed));
+
+struct cmd_ds_bt_access {
+	__le16 action;
+	__le32 id;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+} __attribute__ ((packed));
+
+struct cmd_ds_fwt_access {
+	__le16 action;
+	__le32 id;
+	u8 valid;
+	u8 da[ETH_ALEN];
+	u8 dir;
+	u8 ra[ETH_ALEN];
+	__le32 ssn;
+	__le32 dsn;
+	__le32 metric;
+	u8 rate;
+	u8 hopcount;
+	u8 ttl;
+	__le32 expiration;
+	u8 sleepmode;
+	__le32 snr;
+	__le32 references;
+	u8 prec[ETH_ALEN];
+} __attribute__ ((packed));
+
+struct cmd_ds_mesh_config {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le16 channel;
+	__le16 type;
+	__le16 length;
+	u8 data[128];	/* last position reserved */
+} __attribute__ ((packed));
+
+struct cmd_ds_mesh_access {
+	struct cmd_header hdr;
+
+	__le16 action;
+	__le32 data[32];	/* last position reserved */
+} __attribute__ ((packed));
+
+/* Number of stats counters returned by the firmware */
+#define MESH_STATS_NUM 8
+
+struct cmd_ds_command {
+	/* command header */
+	__le16 command;
+	__le16 size;
+	__le16 seqnum;
+	__le16 result;
+
+	/* command Body */
+	union {
+		struct cmd_ds_802_11_ps_mode psmode;
+		struct cmd_ds_mac_reg_access macreg;
+		struct cmd_ds_bbp_reg_access bbpreg;
+		struct cmd_ds_rf_reg_access rfreg;
+		struct cmd_ds_bt_access bt;
+		struct cmd_ds_fwt_access fwt;
+	} params;
+} __attribute__ ((packed));
+
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/if_cs.c
+++ linux-wl/drivers/net/wireless/libertas/if_cs.c
@@ -36,8 +36,8 @@
 
 #define DRV_NAME "libertas_cs"
 
+#include "cmd.h"
 #include "decl.h"
-#include "defs.h"
 #include "dev.h"
 
 
--- linux-wl.orig/drivers/net/wireless/libertas/if_sdio.c
+++ linux-wl/drivers/net/wireless/libertas/if_sdio.c
@@ -37,7 +37,6 @@
 
 #include "host.h"
 #include "decl.h"
-#include "defs.h"
 #include "dev.h"
 #include "cmd.h"
 #include "if_sdio.h"
--- linux-wl.orig/drivers/net/wireless/libertas/if_spi.c
+++ linux-wl/drivers/net/wireless/libertas/if_spi.c
@@ -26,11 +26,11 @@
 #include <linux/spi/libertas_spi.h>
 #include <linux/spi/spi.h>
 
-#include "host.h"
+#include "if_spi.h"
+#include "cmd.h"
 #include "decl.h"
-#include "defs.h"
 #include "dev.h"
-#include "if_spi.h"
+
 
 struct if_spi_packet {
 	struct list_head		list;
--- linux-wl.orig/drivers/net/wireless/libertas/if_usb.c
+++ linux-wl/drivers/net/wireless/libertas/if_usb.c
@@ -15,7 +15,6 @@
 
 #include "host.h"
 #include "decl.h"
-#include "defs.h"
 #include "dev.h"
 #include "cmd.h"
 #include "if_usb.h"
--- linux-wl.orig/drivers/net/wireless/libertas/debugfs.h
+++ linux-wl/drivers/net/wireless/libertas/debugfs.h
@@ -1,6 +1,8 @@
 #ifndef _LBS_DEBUGFS_H_
 #define _LBS_DEBUGFS_H_
 
+struct lbs_private;
+
 void lbs_debugfs_init(void);
 void lbs_debugfs_remove(void);
 

-- 
http://www.holgerschurig.de
