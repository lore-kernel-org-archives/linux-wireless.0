Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:52618 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbZJNOxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 10:53:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id F053D14800E
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 16:52:34 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tTAzNQzYuJ+U for <linux-wireless@vger.kernel.org>;
	Wed, 14 Oct 2009 16:52:34 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA374.dip0.t-ipconnect.de [217.95.163.116])
	by mx51.mymxserver.com (Postfix) with ESMTP id 3A0B6148006
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 16:52:30 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 717191E0010
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 16:52:15 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [WIP, RFC] libertas: allow scanning via "iw"
Date: Wed, 14 Oct 2009 16:52:10 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910141652.11203.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not apply, but please look at the code and comment harshly :-)



Things that work in some basic way:

* iw eth1 scan / scan trigger / scan dump, including
  passive-scanning, scan-for-ssid, scan-on-specified-freq

* iw eth1 connect SSID 2437 00:11:22:33:44:55 key 0:99999
  (the mentions MAC address must be in the bss list that you
  get via "iw scan dump")

* ./wpa_supplicant -D nl80211 with
  network={
          ssid="SSID"
          key_mgmt=NONE
          wep_key0="99999"
          wep_tx_keyidx=0
          scan_ssid=1
          scan_freq=2437
  }

* "iw link" gives basic output




Now, that's the nice stuff. Now to the ugly stuff:

* There are some open points, all marked as TODO

* scan.{h,c}, wext.{h,c}, 11d.{h,c}, assoc.{h,c} are just
  disabled. The will go for good. But for now I kept them
  -> easier grepping

* no support for WPA / WPA2 yet

* no support for IBSS yet

* no support for MESH yet (and won't be implemented by me)

* no support for monitor mode yet

* formula for calculation of dBm migth be wrong

* no AUTH TLV for new libertas' firmware

* still dead code in the file (the .auth/.deauth, .assoc/.diassoc approach)

* no clue what IE i should send in cfg80211_connect_result()

* still some fields in "struct libertas_private" that I want to get rid of,
  e.g. priv->connect_status. I think I can re-use something from struct
  wireless_dev for that?

* "iw eth1 connect SSID" doesn't work, you HAVE to specify the BSSID of an
  access-point. This is because of a impedance mismatch of cfg80211's 
  .connect/.disconnect API and libertas firmware.

  Ah, and  cfg80211's .auth/.deauth .assoc/.disassoc API doesn't suit the
  libertas firmware that much better.

* no short preamble support yet

* no clue which IE to send in cfg80211_disconnected()

* WEP: no support for tx key != rx key, or keys != 1 yet. And no support
  to delete keys yet. Or to get them back.

* no support to get TX rate out of the firmware and into "iw link".



Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Do not apply, but please look at the code and comment harshly :-)

--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c
+++ linux-wl/drivers/net/wireless/libertas/cfg.c
@@ -6,10 +6,18 @@
  *
  */
 
+#include <linux/ieee80211.h>
+#include <linux/sched.h>
+#include <net/lib80211.h>
 #include <net/cfg80211.h>
+#include <asm/unaligned.h>
 
 #include "cfg.h"
 #include "cmd.h"
+#include "host.h"
+#include "decl.h"
+
+#define USE_CONNECT
 
 
 #define CHAN2G(_channel, _freq, _flags) {        \
@@ -38,26 +46,27 @@
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
@@ -71,25 +80,244 @@
 static const u32 cipher_suites[] = {
 	WLAN_CIPHER_SUITE_WEP40,
 	WLAN_CIPHER_SUITE_WEP104,
-	WLAN_CIPHER_SUITE_TKIP,
-	WLAN_CIPHER_SUITE_CCMP,
+//TODO	WLAN_CIPHER_SUITE_TKIP,
+//TODO	WLAN_CIPHER_SUITE_CCMP,
 };
 
+/* Time to stay on the channel */
+#define LBS_SCAN_DWELL_PASSIVE 100
+#define LBS_SCAN_DWELL_ACTIVE  40
+
+
+
+/***************************************************************************
+ * TLV utility functions
+ */
+
+
+/*
+ * Add ssid TLV of the form:
+ *
+ * TLV-ID SSID     00 00
+ * length          06 00
+ * ssid            4d 4e 54 45 53 54
+ */
+#define LBS_MAX_SSID_TLV_SIZE			\
+	(sizeof(struct mrvl_ie_header)		\
+	 + IEEE80211_MAX_SSID_LEN)
+
+static int lbs_add_ssid_tlv(u8 *tlv, const u8 *ssid, int ssid_len)
+{
+	struct mrvl_ie_ssid_param_set *ssid_tlv = (void *)tlv;
+
+	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
+	ssid_tlv->header.len = cpu_to_le16(ssid_len);
+	memcpy(ssid_tlv->ssid, ssid, ssid_len);
+	return sizeof(ssid_tlv->header) + ssid_len;
+}
+
+
+/*
+ * Add channel list TLV of the form:
+ *
+ * TLV-ID CHANLIST 01 01
+ * length          0e 00
+ * channel         00 01 00 00 00 64 00
+ *   radio type    00
+ *   channel          01
+ *   scan type           00
+ *   min scan time          00 00
+ *   max scan time                64 00
+ * channel 2       00 02 00 00 00 64 00
+ *
+ * It adds the channel from priv->scan_channel to the TLV. Actual channel
+ * data comes from priv->wiphy->channels. This TLV is described in section
+ * 8.4.2
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
+	header->type = cpu_to_le16(TLV_TYPE_CHANLIST);
+	header->len  = cpu_to_le16(chanscanparamsize);
+	tlv += sizeof(struct mrvl_ie_header);
+
+	lbs_deb_scan("scan channels %d to %d\n", priv->scan_channel,
+		     last_channel);
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
+ * Add rates TLV of the form
+ *
+ * TLV-ID RATES    01 00
+ * length          0e 00
+ * rates           82 84 8b 96 0c 12 18 24 30 48 60 6c
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
+ * Adds a TLV with all rates the hardware AND bss supports. Example:
+ *
+ * 01 00                   TLV_TYPE_RATES
+ * 04 00                   len
+ * 82 84 8b 96             rates
+ */
+static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
+{
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
+	const u8 *rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+	int n;
+
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
+		for (hw=0; hw<ARRAY_SIZE(lbs_rates); hw++) {
+			u8 hw_rate = lbs_rates[hw].bitrate / 5;
+			for (ap=0; ap < ap_max; ap++) {
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
+/* Add channel TLV of the form
+ *
+ * 03 00                   TLV_TYPE_PHY_DS
+ * 01 00                   len
+ * 06                      channel
+ */
+#define LBS_MAX_CHANNEL_TLV_SIZE		\
+	sizeof(struct mrvl_ie_header)
+
+static int lbs_add_channel_tlv(u8 *tlv, u8 channel)
+{
+	struct mrvl_ie_ds_param_set *ds = (void *) tlv;
+
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
+ * 04 00                   TLV_TYPE_CF
+ * 06 00                   len
+ * 00                      cfpcnt
+ * 00                      cfpperiod
+ * 00 00                   cfpmaxduration
+ * 00 00                   cfpdurationremaining
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
@@ -98,9 +326,1091 @@
 
 
 
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
+	/* The general layout of the scan response is described in
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
+			left -= elen;
+			pos += elen;
+		}
+
+		if (chan_no != -1) {
+			struct wiphy *wiphy = priv->wdev->wiphy;
+			int freq = ieee80211_channel_to_frequency(chan_no);
+			struct ieee80211_channel *channel =
+				ieee80211_get_channel(wiphy, freq);
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
+		lbs_deb_scan("reschedule scan\n");
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
+	lbs_deb_leave(LBS_DEB_CFG80211);
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
+	lbs_deb_cfg80211("n_ssids %d, n_channels %d, ie_len %d\n",
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
+/***************************************************************************
+ * Connect/disconnect
+ */
+
+
+/*
+ * Convert NL80211's auth_type to the one from Libertas, see chapter 5.9.1
+ * in the firmware spec
+ */
+static int lbs_cfg80211_auth_to_lbs_auth(enum nl80211_auth_type auth_type)
+{
+	int ret = -ENOTSUPP;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", auth_type);
+
+	switch(auth_type) {
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
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Create association request
+ *
+ * Sample request:
+ *
+ * 50 00                   CMD_802_11_ASSOCIATE
+ * 34 00                   length
+ * 18 00                   sequence no.
+ * 00 00                   return code
+ * 00 13 19 80 da 30       BSS id
+ * 11 00                   capabilities
+ * 0a 00                   listen interval
+ * 00 00                   beacon interval
+ * 00                      DTIM period
+ * ie                      IE data (up to 512 bytes)
+ */
+#define LBS_ASSOC_MAX_CMD_SIZE				\
+	(sizeof(struct cmd_ds_802_11_associate)		\
+	 - 512 /* cmd_ds_802_11_associate.iebuf */	\
+	 + LBS_MAX_SSID_TLV_SIZE			\
+	 + LBS_MAX_CHANNEL_TLV_SIZE			\
+	 + LBS_MAX_CF_PARAM_TLV_SIZE			\
+	 /* TODO: LBS_MAX_AUTH_TLV_SIZE */		\
+	 /* TODO: WPA/WPA2 IE */)
+
+static int lbs_do_assoc(struct wiphy *wiphy,
+	struct cfg80211_bss *bss,
+	const u8 *ie, int ie_len,
+	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *))
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cmd_ds_802_11_associate *cmd = kzalloc(LBS_ASSOC_MAX_CMD_SIZE, GFP_KERNEL);
+	const u8 *ssid_eid;
+	size_t len;
+	u8 *pos = &(cmd->iebuf[0]);
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
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
+		printk("##HS no SSID\n");
+
+	/* add DS param TLV */
+	if (bss->channel)
+		pos += lbs_add_channel_tlv(pos, bss->channel->hw_value);
+	else
+		printk("##HS no channel\n");
+
+	/* add (empty) CF param TLV */
+	pos += lbs_add_cf_param_tlv(pos);
+
+	/* add rates TLV */
+	pos += lbs_add_common_rates_tlv(pos, bss);
+
+	/* add auth type TLV */
+	if (priv->fwrelease >= 0x09000000) {
+		printk("##HS TODO authentication suites as TLV\n");
+	}
+
+	/* add WPA/WPA2 IEs */
+	if (ie && ie_len) {
+		//struct mrvl_ie_rsn_param_set *rsn = pos;
+		//rsn->header.len = cpu_to_le16(ie_len);
+		//memcpy(rsn->rsnie, ie, ie_len);
+		// pos += ie_len;
+		printk("##HS TODO need to copy %d bytes for IE\n", ie_len);
+	}
+
+	len = (sizeof(*cmd) - sizeof(cmd->iebuf)) +
+		(u16)(pos - (u8 *) &cmd->iebuf);
+	cmd->hdr.size = cpu_to_le16(len);
+
+	/* store for later use */
+	memcpy(priv->assoc_bss, bss->bssid, ETH_ALEN);
+
+	__lbs_cmd_async(priv, CMD_802_11_ASSOCIATE,
+			&cmd->hdr, len,
+			callback, 0);
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+
+ done:
+	return ret;
+}
+
+
+
+#ifndef USE_CONNECT
+
+/*
+ * Sample response:
+ *
+ * 11 80                            RSP_802_11_AUTHENTICATE
+ * 19 00                            cmd_len
+ * 16 00                            sequence no
+ * 00 00                            result
+ * 00 13 19 80 da 30                BSS id
+ * 00                               ignored
+ * 00 00 02 00 00 00 00 00 00 00    ignored
+ */
+static int lbs_cfg_ret_auth(struct lbs_private *priv, unsigned long dummy,
+                              struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_authenticate *auth_resp = (void *)resp;
+	struct ieee80211_mgmt mgmt;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+
+	/* Fake a management frame */
+	memset(&mgmt, 0, sizeof(mgmt));
+	mgmt.frame_control = cpu_to_le16(0xb0);
+	memcpy(mgmt.bssid, auth_resp->bssid, ETH_ALEN);
+	memcpy(mgmt.sa, auth_resp->bssid, ETH_ALEN);
+	memcpy(mgmt.da, priv->current_addr, ETH_ALEN);
+	mgmt.u.auth.status_code = cpu_to_le16(auth_resp->authtype);
+	cfg80211_send_rx_auth(priv->dev, (u8*)&mgmt, sizeof(mgmt));
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return 0;
+}
+
+
+/*
+ * Sample command:
+ *
+ * 11 00                            CMD_802_11_AUTHENTICATE
+ * 19 00                            cmd length
+ * 16 00                            sequence no.
+ * 00 00                            result
+ * 00 13 19 80 da 30                BSS id
+ * 00                               auth type
+ * 00 00 00 00 00 00 00 00 00 00    10 bytes reserved
+ */
+static int lbs_cfg_auth(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_auth_request *req)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cmd_ds_802_11_authenticate cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	memcpy(cmd.bssid, req->bss->bssid, ETH_ALEN);
+	ret = lbs_cfg80211_auth_to_lbs_auth(req->auth_type);
+	if (ret < 0)
+		goto done;
+	cmd.authtype = ret;
+
+	__lbs_cmd_async(priv, CMD_802_11_AUTHENTICATE,
+			      &cmd.hdr, sizeof(cmd),
+			      lbs_cfg_ret_auth, 0);
+	ret = 0;
+
+ done:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Sample response:
+ *
+ * 12 80                            RSP_802_11_AUTHENTICATE
+ * 14 00                            cmd_len
+ * 18 00                            sequence no
+ * 00 00                            result
+ * 11 00                            capability
+ * 00 00                            status code
+ * 01 c0                            aid
+ * ie                               IEs
+ *
+ * Sample IE:
+ *
+ * 01                               WLAN_EID_SSID
+ *  04                              len
+ *  82 84 8b 96                     SSID
+ */
+static int lbs_cfg_ret_assoc(struct lbs_private *priv, unsigned long dummy,
+			    struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_associate_response *assoc_resp = (void *)resp;
+	struct ieee80211_mgmt mgmt;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* Fake a management frame */
+	memset(&mgmt, 0, sizeof(mgmt));
+	mgmt.frame_control = cpu_to_le16(0x10);
+	memcpy(mgmt.bssid, priv->assoc_bss, ETH_ALEN);
+	memcpy(mgmt.sa, priv->assoc_bss, ETH_ALEN);
+	memcpy(mgmt.da, priv->current_addr, ETH_ALEN);
+	mgmt.u.assoc_resp.capab_info = assoc_resp->capability;
+	mgmt.u.assoc_resp.status_code = assoc_resp->statuscode;
+	mgmt.u.assoc_resp.aid = assoc_resp->aid;
+	cfg80211_send_rx_assoc(priv->dev, (u8*)&mgmt, sizeof(mgmt));
+	//TODO append IE
+
+	return 0;
+}
+
+
+static int lbs_cfg_assoc(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_assoc_request *req)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	ret = lbs_set_channel(priv, req->bss->channel->hw_value);
+
+	/* TODO: radio control (long/short preamble)
+	 *
+	 * Sample request:
+	 * 1c 00 0c 00 17 00 00 00 01 00 01 00
+	 * Sample response
+	 * 1c 80 0c 00 17 00 00 00 01 00 01 00
+	 */
+
+	ret = lbs_do_assoc(wiphy, req->bss,
+			   req->ie, req->ie_len,
+			   lbs_cfg_ret_assoc);
+
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+static int lbs_cfg_ret_deauth(struct lbs_private *priv, unsigned long dummy,
+			    struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_deauthenticate *deauth_resp = (void *)resp;
+	struct ieee80211_mgmt mgmt;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* Fake a management frame */
+	memset(&mgmt, 0, sizeof(mgmt));
+	mgmt.frame_control = cpu_to_le16(0xc0);
+	memcpy(mgmt.bssid, deauth_resp->macaddr, ETH_ALEN);
+	/* Note: .sa / .da swapped */
+	memcpy(mgmt.da, deauth_resp->macaddr, ETH_ALEN);
+	memcpy(mgmt.sa, priv->current_addr, ETH_ALEN);
+	mgmt.u.deauth.reason_code = cpu_to_le16(priv->disassoc_reason);
+	if (dummy)
+		__cfg80211_send_deauth(priv->dev, (u8 *)&mgmt, sizeof(mgmt));
+	else
+		cfg80211_send_deauth(priv->dev, (u8 *)&mgmt, sizeof(mgmt));
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return 0;
+}
+
+
+static int lbs_cfg_deauth(struct wiphy *wiphy, struct net_device *dev,
+			  struct cfg80211_deauth_request *req,
+			  void *cookie)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cmd_ds_802_11_deauthenticate cmd;
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	memcpy(cmd.macaddr, &req->bss->bssid, ETH_ALEN);
+	cmd.reasoncode = cpu_to_le16(req->reason_code);
+	priv->disassoc_reason = req->reason_code;
+
+	__lbs_cmd_async(priv, CMD_802_11_DEAUTHENTICATE,
+			&cmd.hdr, sizeof(cmd),
+			lbs_cfg_ret_deauth, 0);
+
+	return 0;
+}
+
+
+static int lbs_cfg_disassoc(struct wiphy *wiphy, struct net_device *dev,
+	struct cfg80211_disassoc_request *req,
+	void *cookie)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO The firmware doesn't have a disassociate command */
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return 0;
+}
+
+#endif
+
+
+
+#ifdef USE_CONNECT
+
+/*
+ * Set / Unset wep key, sample command:
+ *
+ * 13 00                       command
+ * 50 00                       size
+ * 07 00                       sequence
+ * 00 00                       result
+ * 02 00                       action, here ACT_ADD
+ * 00 00                       transmit key
+ * 01                          type for key 1, here WEP40
+ * 00 00 00                    types for keys 2 .. 4
+ * 39 39 39 39 39 00 00 00 00  key 1
+ *       00 00 00 00 00 00 00
+ * 00 00 00 00 00 00 00 00 00  key 2
+ *       00 00 00 00 00 00 00
+ * 00 00 00 00 00 00 00 00 00  key 3
+ *       00 00 00 00 00 00 00
+ * 00 00 00 00 00 00 00 00 00  key 4
+*/
+static int lbs_cfg_set_wep(struct lbs_private *priv,
+			   u8 key_idx,
+			   const u8 *key,
+			   u8 key_len)
+{
+	struct cmd_ds_802_11_set_wep cmd;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.keyindex = cpu_to_le16(key_idx);
+	if (key && key_len) {
+		cmd.action = cpu_to_le16(CMD_ACT_ADD);
+		cmd.keytype[key_idx] = key_len == 5 ? CMD_TYPE_WEP_40_BIT : CMD_TYPE_WEP_104_BIT;
+		memcpy(cmd.keymaterial[key_idx], key, key_len);
+	} else {
+		cmd.action = cpu_to_le16(CMD_ACT_REMOVE);
+	}
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
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
+ *
+ *
+ * Sample command:
+ *
+ * 11 00                            CMD_802_11_AUTHENTICATE
+ * 19 00                            cmd length
+ * 16 00                            sequence no.
+ * 00 00                            result
+ * 00 13 19 80 da 30                BSS id
+ * 00                               auth type
+ * 00 00 00 00 00 00 00 00 00 00    10 bytes reserved
+ */
+static int lbs_cfg_set_authtype(struct lbs_private *priv,
+				struct cfg80211_connect_params *sme)
+{
+	struct cmd_ds_802_11_authenticate cmd;
+	int ret;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", sme->auth_type);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	if (sme->bssid)
+		memcpy(cmd.bssid, sme->bssid, ETH_ALEN);
+	/* convert auth_type */
+	ret = lbs_cfg80211_auth_to_lbs_auth(sme->auth_type);
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
+static int lbs_cfg_ret_connect(struct lbs_private *priv, unsigned long dummy,
+			    struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_associate_response *assoc_resp = (void *)resp;
+	size_t resp_ie_len;
+	int status = le16_to_cpu(assoc_resp->statuscode);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	lbs_deb_assoc("status %d, capability 0x%04x\n",
+		      status,
+		      le16_to_cpu(assoc_resp->capability));
+
+	resp_ie_len = le16_to_cpu(resp->size);
+	cfg80211_connect_result(priv->dev,
+				priv->assoc_bss,
+				NULL, 0, //TODO what IE should I copy here?
+				assoc_resp->iebuf, resp_ie_len,
+				status,
+				GFP_KERNEL);
+
+	if (status == 0) {
+		// TODO: get rid of priv->connect_status
+		priv->connect_status = LBS_CONNECTED;
+		netif_carrier_on(priv->dev);
+		if (!priv->tx_pending_len)
+			netif_tx_wake_all_queues(priv->dev);
+	}
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return 0;
+}
+
+
+static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_connect_params *sme)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	struct cfg80211_bss *bss;
+	int ret = 0;
+	u8 preamble = RADIO_PREAMBLE_LONG;
+	DECLARE_SSID_BUF(ssid);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+
+	if (sme->ssid)
+		lbs_deb_assoc("ssid %s\n", print_ssid(ssid, sme->ssid, sme->ssid_len));
+	if (sme->bssid) {
+		bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
+			sme->ssid, sme->ssid_len,
+			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	} else {
+		/*
+		 * Here we have an impedance mismatch. The firmware command
+		 * CMD_802_11_ASSOCIATE always needs a BSSID, it cannot connect
+		 * otherwise. However, for the connect-API of cfg80211 the bssid is
+		 * purely optional. We don't get one, except the user specifies one
+		 * on the "iw" command line.
+		 *
+		 * If we don't got one, we could initiate a scan and look for the
+		 * best matching cfg80211_bss entry.
+		 *
+		 * Or, better yet, net/wireless/sme.c get's rewritten into
+		 * something more generally useful.
+		 */
+		printk("##HS TODO: search for a bss\n");
+		ret = -ENOTSUPP;
+		goto done;
+	}
+
+
+	if (!bss) {
+		lbs_deb_assoc("bss %pM not in scan results\n", sme->bssid);
+		ret = -ENOENT;
+		goto done;
+	}
+	printk("##HS bss %pM found in scan results\n", sme->bssid);
+
+	printk("##HS auth_type %d\n", sme->auth_type);
+	printk("##HS privacy %d\n", sme->privacy);
+	printk("##HS crypto wpa_version %d\n", sme->crypto.wpa_versions);
+	printk("##HS crypto cipher_group 0x%x\n", sme->crypto.cipher_group);
+	printk("##HS crypto n_ciphers_pairwise %d\n", sme->crypto.n_ciphers_pairwise);
+	printk("##HS crypto n_akm_suites %d\n", sme->crypto.n_akm_suites);
+	printk("##HS crypto control_port %d\n", sme->crypto.control_port);
+	printk("##HS key %p, key_len %d, key_idx %d\n", sme->key, sme->key_len, sme->key_idx);
+	printk("##HS ie %p, ie_len %d\n", sme->ie, sme->ie_len);
+	if (sme->ie && sme->ie_len)
+		lbs_deb_hex(LBS_DEB_CFG80211, "IE", sme->ie, sme->ie_len);
+
+	/* set authentication type (open, shared, etc) */
+	lbs_cfg_set_authtype(priv, sme);
+
+	/* TODO set short preamble */
+	lbs_set_radio(priv, preamble, 1);
+
+	ret = lbs_do_assoc(wiphy, bss,
+			   sme->ie, sme->ie_len,
+			   lbs_cfg_ret_connect);
+
+	if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) {
+		priv->mac_control |= CMD_ACT_MAC_WEP_ENABLE;
+		lbs_cfg_set_wep(priv, sme->key_idx, sme->key, sme->key_len);
+	} else {
+		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
+	}
+
+	/*
+	 * Sample command:
+	 *
+	 * cmd 28 00 0c 00 08 00 00 00 0b 00 00 00
+	 */
+	lbs_set_mac_control(priv);
+
+	// TODO enable/disable RSN
+
+
+	// set priv filter
+
+
+	/* iw eth1 connect MNHS
+	   --------------------
+	   ssid MNHS
+	   auth_type 4
+	   ie (null), ie_len 0
+	   privacy 0
+	   crypto wpa_version 0
+	   crypto cipher_group 0
+	   crypto n_ciphers_pairwise 0
+	   crypto n_akm_suites 0
+	   crypto control_port 0
+	   key (null), key_len 0, key_idx 0
+
+	   iw eth1 connect MNHS key 0:54321
+	   --------------------------------
+	   ssid MNHS
+	   auth_type 4
+	   ie (null), ie_len 0
+	   privacy 1
+	   crypto wpa_version 0
+	   crypto cipher_group 1027073
+	   crypto n_ciphers_pairwise 1
+	   crypto n_akm_suites 0
+	   crypto control_port 0
+	   key f7b9ce78, key_len 5, key_idx 0
+	 */
+
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
+			      NULL, 0, // TODO?
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
+	// Mildly ugly to use a locally store my own BSSID ...
+	memcpy(cmd.macaddr, &priv->assoc_bss, ETH_ALEN);
+	cmd.reasoncode = cpu_to_le16(reason_code);
+
+	__lbs_cmd_async(priv, CMD_802_11_DEAUTHENTICATE,
+			&cmd.hdr, sizeof(cmd),
+			lbs_cfg_ret_disconnect, 0);
+
+	return 0;
+}
+#endif
+
+
+static int lbs_cfg_add_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, const u8 *mac_addr,
+			   struct key_params *params)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO */
+
+	/*
+	 * iw eth1 connect MNHS 2437 key 0:99999
+	 * -------------------------------------
+	 * key_index 0
+	 * mac_addr (null)
+	 * cipher 0xfac01
+	 * keylen 5, seqlen 0
+	 */
+
+	printk("##HS key_index %d\n", key_index);
+	printk("##HS mac_addr %pM\n", mac_addr);
+	printk("##HS cipher 0x%x\n", params->cipher);
+	printk("##HS keylen %d, seqlen %d\n", params->key_len, params->seq_len);
+
+	return 0;
+}
+
+
+static int lbs_cfg_set_default_key(struct wiphy *wiphy,
+				   struct net_device *netdev,
+				   u8 key_index)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO */
+
+	/*
+	 * iw eth1 connect MNHS 2437 key 0:99999
+	 * -------------------------------------
+	 * key_index 0
+	 */
+
+	printk("##HS key_index %d\n", key_index);
+	return 0;
+}
+
+
+static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, const u8 *mac_addr)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO */
+
+	//printk("##HS key_index %d\n", key_index);
+	//printk("##HS mac_addr %pM\n", mac_addr);
+
+	return -ENOTSUPP;
+}
+
+
+static int lbs_cfg_get_key(struct wiphy *wiphy, struct net_device *netdev,
+		   u8 key_index, const u8 *mac_addr, void *cookie,
+		   void (*callback)(void *cookie, struct key_params*))
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	/* TODO */
+
+	//printk("##HS key_index %d\n", key_index);
+	//printk("##HS mac_addr %pM\n", mac_addr);
+	//printk("##HS cookie %p\n", cookie);
+
+	return -ENOTSUPP;
+}
+
+
+
+
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
+#ifdef TODO
+	//My firmware doesn't execute this command
+
+	/* Get current TX rate */
+	{
+		struct cmd_tx_rate_query cmd;
+		int i;
+		u16 tx_rate;
+
+		cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+		cmd.tx_rate = 0;
+		ret = lbs_cmd_with_response(priv, CMD_802_11_TX_RATE_QUERY, &cmd);
+		if (ret == 0) {
+			tx_rate = le16_to_cpu(cmd.tx_rate);
+			//printk("##HS txrate %d\n", tx_rate);
+			for (i=0; i<ARRAY_SIZE(lbs_rates); i++) {
+				if (tx_rate == lbs_rates[i].hw_value) {
+					sinfo->txrate.legacy = lbs_rates[i].bitrate;
+					sinfo->filled |= STATION_INFO_TX_BITRATE;
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
+#ifdef USE_CONNECT
+	.connect = lbs_cfg_connect,
+	.disconnect = lbs_cfg_disconnect,
+#else
+	.auth = lbs_cfg_auth,
+	.deauth = lbs_cfg_deauth,
+	.assoc = lbs_cfg_assoc,
+	.disassoc = lbs_cfg_disassoc,
+#endif
+	.add_key = lbs_cfg_add_key,
+	.get_key = lbs_cfg_get_key,
+	.del_key = lbs_cfg_del_key,
+	.set_default_key = lbs_cfg_set_default_key,
+	.get_station = lbs_cfg_get_station,
 };
 
 
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -10,6 +10,7 @@
 #include <linux/wireless.h>
 #include <linux/ethtool.h>
 #include <linux/debugfs.h>
+#include <net/cfg80211.h>
 
 #include "defs.h"
 #include "hostcmd.h"
@@ -61,6 +62,7 @@
 };
 
 /** Current Basic Service Set State Structure */
+#ifdef TODO
 struct current_bss_params {
 	/** bssid */
 	u8 bssid[ETH_ALEN];
@@ -75,6 +77,7 @@
 	/** zero-terminated array of supported data rates */
 	u8 rates[MAX_RATES + 1];
 };
+#endif
 
 /** sleep_params */
 struct sleep_params {
@@ -100,13 +103,20 @@
 
 /** Private structure for the MV device */
 struct lbs_private {
+	/* cfg80211-related */
 	struct wireless_dev *wdev;
+	struct cfg80211_scan_request *scan_req;
+	u8 assoc_bss[ETH_ALEN];
+	u8 disassoc_reason;
+
 	int mesh_open;
 	int mesh_fw_ver;
 	int infra_open;
 	int mesh_autostart_enabled;
 
+#ifdef TODO
 	char name[DEV_NAME_LEN];
+#endif
 
 	void *card;
 	struct net_device *dev;
@@ -114,7 +124,9 @@
 	struct net_device *mesh_dev; /* Virtual device */
 	struct net_device *rtap_net_dev;
 
+#ifdef TODO
 	struct iw_statistics wstats;
+#endif
 	struct lbs_mesh_stats mstats;
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_debug;
@@ -159,7 +171,6 @@
 
 	/** Scanning */
 	struct delayed_work scan_work;
-	struct delayed_work assoc_work;
 	struct work_struct sync_channel;
 	/* remember which channel was scanned last, != 0 if currently scanning */
 	int scan_channel;
@@ -214,8 +225,10 @@
 	/* Events sent from hardware to driver */
 	struct kfifo *event_fifo;
 
+#ifdef TODO
 	/* nickname */
 	u8 nodename[16];
+#endif
 
 	/** spin locks */
 	spinlock_t driver_lock;
@@ -226,8 +239,11 @@
 	int nr_retries;
 	int cmd_timed_out;
 
+#ifdef TODO
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
+#endif
+	u8 channel;
 
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IW_ESSID_MAX_SIZE + 1];
@@ -236,10 +252,12 @@
 	/* IW_MODE_* */
 	u8 mode;
 
+#ifdef TODO
 	/* Scan results list */
 	struct list_head network_list;
 	struct list_head network_free_list;
 	struct bss_descriptor *networks;
+#endif
 
 	u16 beacon_period;
 	u8 beacon_enable;
@@ -254,10 +272,10 @@
 	u32 nr_of_multicastmacaddr;
 
 	/** 802.11 statistics */
-//	struct cmd_DS_802_11_GET_STAT wlan802_11Stat;
-
 	uint16_t enablehwauto;
+#ifdef TODO
 	uint16_t ratebitmap;
+#endif
 
 	u8 txretrycount;
 
@@ -281,6 +299,7 @@
 	u32 psstate;
 	u8 needtowakeup;
 
+#ifdef TODO
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
 
@@ -313,16 +332,16 @@
 	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
 	u16 nextSNRNF;
 	u16 numSNRNF;
+#endif
 
 	u8 radio_on;
 
 	/** data rate stuff */
 	u8 cur_rate;
 
-	/** RF calibration data */
-
-#define	MAX_REGION_CHANNEL_NUM	2
+#ifdef TODO
 	/** region channel data */
+#define	MAX_REGION_CHANNEL_NUM	2
 	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
 
 	struct region_channel universal_channel[MAX_REGION_CHANNEL_NUM];
@@ -333,6 +352,7 @@
 
 	/** FSM variable for 11d support */
 	u32 enable11d;
+#endif
 
 	/**	MISCELLANEOUS */
 	struct lbs_offset_value offsetvalue;
@@ -346,6 +366,7 @@
 /**
  *  @brief Structure used to store information for each beacon/probe response
  */
+#ifdef TODO
 struct bss_descriptor {
 	u8 bssid[ETH_ALEN];
 
@@ -424,5 +445,6 @@
 	/* BSS to associate with for infrastructure of Ad-Hoc join */
 	struct bss_descriptor bss;
 };
+#endif
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -16,9 +16,6 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
-#include "wext.h"
-#include "scan.h"
-#include "assoc.h"
 #include "cmd.h"
 
 
@@ -2217,8 +2214,8 @@
 	(iw_handler) lbs_get_wap,	/* SIOCGIWAP */
 	(iw_handler) NULL,	/* SIOCSIWMLME */
 	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
-	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
-	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
+	(iw_handler) NULL, 	/* SIOCSIWSCAN */
+	(iw_handler) NULL,	/* SIOCGIWSCAN */
 	(iw_handler) lbs_set_essid,	/* SIOCSIWESSID */
 	(iw_handler) lbs_get_essid,	/* SIOCGIWESSID */
 	(iw_handler) lbs_set_nick,	/* SIOCSIWNICKN */
@@ -2275,8 +2272,8 @@
 	(iw_handler) NULL,	/* SIOCGIWAP */
 	(iw_handler) NULL,	/* SIOCSIWMLME */
 	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
-	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
-	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
+	(iw_handler) NULL,	/* SIOCSIWSCAN */
+	(iw_handler) NULL,	/* SIOCGIWSCAN */
 	(iw_handler) lbs_mesh_set_essid,/* SIOCSIWESSID */
 	(iw_handler) lbs_mesh_get_essid,/* SIOCGIWESSID */
 	(iw_handler) NULL,		/* SIOCSIWNICKN */
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile
+++ linux-wl/drivers/net/wireless/libertas/Makefile
@@ -1,5 +1,5 @@
-libertas-y += 11d.o
-libertas-y += assoc.o
+#libertas-y += 11d.o
+#libertas-y += assoc.o
 libertas-y += cfg.o
 libertas-y += cmd.o
 libertas-y += cmdresp.o
@@ -8,9 +8,9 @@
 libertas-y += main.o
 libertas-y += persistcfg.o
 libertas-y += rx.o
-libertas-y += scan.o
+#libertas-y += scan.o
 libertas-y += tx.o
-libertas-y += wext.o
+#libertas-y += wext.o
 
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -6,10 +6,9 @@
 #include <linux/if_arp.h>
 #include <net/lib80211.h>
 
-#include "assoc.h"
 #include "decl.h"
 #include "host.h"
-#include "scan.h"
+#include "cfg.h"
 #include "cmd.h"
 
 static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -13,17 +13,17 @@
 #include <linux/kfifo.h>
 #include <linux/stddef.h>
 #include <linux/ieee80211.h>
-#include <net/iw_handler.h>
+#ifdef TODO
+//#include <net/iw_handler.h>
+#endif
 #include <net/cfg80211.h>
 
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
-#include "wext.h"
 #include "cfg.h"
 #include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
+#include "cfg.h"
 #include "cmd.h"
 
 #define DRIVER_RELEASE_VERSION "323.p0"
@@ -343,12 +343,14 @@
 		if (!priv->monitormode) {
 			if (priv->infra_open || priv->mesh_open)
 				return -EBUSY;
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
@@ -405,7 +407,7 @@
 		return count;
 	if (enable)
 		action = CMD_ACT_MESH_CONFIG_START;
-	ret = lbs_mesh_config(priv, action, priv->curbssparams.channel);
+	ret = lbs_mesh_config(priv, action, priv->channel);
 	if (ret)
 		return ret;
 
@@ -559,8 +561,10 @@
 	   firmware has crapped itself -- rather than just a very
 	   busy medium. So send a harmless command, and if/when
 	   _that_ times out, we'll kick it in the head. */
+#ifdef TODO
 	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
 				     0, 0, NULL);
+#endif
 
 	lbs_deb_leave(LBS_DEB_TX);
 }
@@ -1135,14 +1139,21 @@
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
-
+#ifdef TODO
+#define MAX_NETWORK_COUNT 128
+#endif
 static int lbs_init_adapter(struct lbs_private *priv)
 {
+#ifdef TODO
 	size_t bufsize;
 	int i, ret = 0;
+#else
+	int ret = 0;
+#endif
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
+#ifdef TODO
 	/* Allocate buffer to store the BSSID list */
 	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
 	priv->networks = kzalloc(bufsize, GFP_KERNEL);
@@ -1159,14 +1170,17 @@
 		list_add_tail(&priv->networks[i].list,
 			      &priv->network_free_list);
 	}
+#endif
 
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	priv->connect_status = LBS_DISCONNECTED;
 	priv->mesh_connect_status = LBS_DISCONNECTED;
+#ifdef TODO
 	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
+#endif
 	priv->mode = IW_MODE_INFRA;
-	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
+	priv->channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
 	priv->enablehwauto = 1;
@@ -1223,8 +1237,10 @@
 		kfifo_free(priv->event_fifo);
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
+#ifdef TODO
 	kfree(priv->networks);
 	priv->networks = NULL;
+#endif
 
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
@@ -1287,9 +1303,6 @@
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->ethtool_ops = &lbs_ethtool_ops;
-#ifdef	WIRELESS_EXT
-	dev->wireless_handlers = &lbs_handler_def;
-#endif
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 
 
@@ -1313,8 +1326,7 @@
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
-	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
-	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
+	INIT_DELAYED_WORK(&priv->scan_work, lbs_cfg_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
@@ -1347,7 +1359,9 @@
 void lbs_remove_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
+#ifdef TODO
 	union iwreq_data wrqu;
+#endif
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
@@ -1357,7 +1371,6 @@
 	dev = priv->dev;
 
 	cancel_delayed_work_sync(&priv->scan_work);
-	cancel_delayed_work_sync(&priv->assoc_work);
 	cancel_work_sync(&priv->mcast_work);
 
 	/* worker thread destruction blocks on the in-flight command which
@@ -1372,9 +1385,11 @@
 		lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 	}
 
+#ifdef TODO
 	memset(wrqu.ap_addr.sa_data, 0xaa, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+#endif
 
 	if (priv->is_deep_sleep) {
 		priv->is_deep_sleep = 0;
@@ -1408,8 +1423,10 @@
 	if (ret)
 		goto done;
 
+#ifdef TODO
 	/* init 802.11d */
 	lbs_init_11d(priv);
+#endif
 
 	if (lbs_cfg_register(priv)) {
 		lbs_pr_err("cannot register device\n");
@@ -1437,10 +1454,10 @@
 
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
@@ -1449,7 +1466,7 @@
 		 */
 		priv->mesh_tlv = TLV_TYPE_MESH_ID;
 		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->curbssparams.channel))
+				    priv->channel))
 			priv->mesh_tlv = 0;
 	}
 	if (priv->mesh_tlv) {
@@ -1568,9 +1585,6 @@
 
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
-#ifdef	WIRELESS_EXT
-	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
-#endif
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
@@ -1651,6 +1665,7 @@
 	return NULL;
 }
 
+#ifdef TODO
 int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
 {
 	int ret = 0;
@@ -1681,6 +1696,7 @@
 	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
 	return ret;
 }
+#endif
 
 void lbs_queue_event(struct lbs_private *priv, u32 event)
 {
--- linux-wl.orig/drivers/net/wireless/libertas/persistcfg.c
+++ linux-wl/drivers/net/wireless/libertas/persistcfg.c
@@ -9,10 +9,7 @@
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
-#include "wext.h"
 #include "debugfs.h"
-#include "scan.h"
-#include "assoc.h"
 #include "cmd.h"
 
 static int mesh_get_default_parameters(struct device *dev,
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -3,6 +3,8 @@
   *
   * IOCTL handlers as well as command preperation and response routines
   *  for sending scan commands to the firmware.
+  *
+  * TODO: remove this file
   */
 #include <linux/types.h>
 #include <linux/kernel.h>
--- linux-wl.orig/drivers/net/wireless/libertas/scan.h
+++ linux-wl/drivers/net/wireless/libertas/scan.h
@@ -1,3 +1,6 @@
+#error don't include scan.h
+/* TODO: remove this file */
+
 /**
   * Interface for the wlan network scan routines
   *
--- linux-wl.orig/drivers/net/wireless/libertas/11d.c
+++ linux-wl/drivers/net/wireless/libertas/11d.c
@@ -9,7 +9,6 @@
 #include "decl.h"
 #include "11d.h"
 #include "dev.h"
-#include "wext.h"
 
 #define TX_PWR_DEFAULT	10
 
@@ -43,6 +42,7 @@
 	{14, 2484, TX_PWR_DEFAULT}
 };
 
+#ifdef TODO
 static u8 lbs_region_2_code(u8 *region)
 {
 	u8 i;
@@ -59,6 +59,7 @@
 	/* default is US */
 	return (region_code_mapping[0].code);
 }
+#endif
 
 static u8 *lbs_code_2_region(u8 code)
 {
@@ -79,6 +80,7 @@
  *  @param nrchan   number of channels
  *  @return 	      the nrchan-th chan number
 */
+#ifdef TODO
 static u8 lbs_get_chan_11d(u8 firstchan, u8 nrchan, u8 *chan)
 /*find the nrchan-th chan after the firstchan*/
 {
@@ -106,6 +108,7 @@
 
 	return 0;
 }
+#endif
 
 /**
  *  @brief This function Checks if chan txpwr is learned from AP/IBSS
@@ -264,6 +267,7 @@
  *  @param chan                 chan
  *  @return 	                TRUE;FALSE
 */
+#ifdef TODO
 static u8 lbs_region_chan_supported_11d(u8 region, u8 chan)
 {
 	struct chan_freq_power *cfp;
@@ -401,6 +405,7 @@
 	lbs_deb_enter(LBS_DEB_11D);
 	return 0;
 }
+#endif
 
 /**
  *  @brief This function calculates the scan type for channels
@@ -595,6 +600,7 @@
  *  @param priv    pointer to struct lbs_private
  *  @return 	   0; -1
  */
+#ifdef TODO
 int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
                                         struct bss_descriptor * bss)
 {
@@ -694,3 +700,4 @@
 	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
 	return ret;
 }
+#endif
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
+++ linux-wl/drivers/net/wireless/libertas/assoc.h
@@ -1,3 +1,6 @@
+#error don't include wext.h
+/* TODO: remove this file */
+
 /* Copyright (C) 2006, Red Hat, Inc. */
 
 #ifndef _LBS_ASSOC_H_
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -3,17 +3,18 @@
   * It prepares command and sends it to firmware when it is ready.
   */
 
-#include <net/iw_handler.h>
+#ifdef TODO
+//#include <net/iw_handler.h>
+#endif
 #include <net/lib80211.h>
 #include <linux/kfifo.h>
 #include <linux/sched.h>
+
 #include "host.h"
 #include "hostcmd.h"
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
-#include "assoc.h"
-#include "wext.h"
 #include "cmd.h"
 
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
@@ -187,6 +188,7 @@
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
+#ifdef TODO
 	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
 		ret = -1;
 		goto out;
@@ -196,6 +198,7 @@
 		ret = -1;
 		goto out;
 	}
+#endif
 
 out:
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -397,6 +400,7 @@
 	return ret;
 }
 
+#ifdef TODO
 int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
 			   struct assoc_request *assoc)
 {
@@ -587,6 +591,7 @@
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
+#endif
 
 /**
  *  @brief Set an SNMP MIB value
@@ -815,7 +820,6 @@
 	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
 	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
 	if (!ret && cmd_action == CMD_ACT_GET) {
-		priv->ratebitmap = le16_to_cpu(cmd.bitmap);
 		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
 	}
 
@@ -913,7 +917,7 @@
 
 	ret = lbs_get_channel(priv);
 	if (ret > 0) {
-		priv->curbssparams.channel = ret;
+		priv->channel = ret;
 		ret = 0;
 	}
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -932,7 +936,7 @@
 {
 	struct cmd_ds_802_11_rf_channel cmd;
 #ifdef DEBUG
-	u8 old_channel = priv->curbssparams.channel;
+	u8 old_channel = priv->channel;
 #endif
 	int ret = 0;
 
@@ -947,36 +951,15 @@
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
@@ -1523,10 +1506,6 @@
 				          cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_RSSI:
-		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
-		break;
-
 	case CMD_802_11_SET_AFC:
 	case CMD_802_11_GET_AFC:
 
@@ -1540,10 +1519,12 @@
 		ret = 0;
 		goto done;
 
+#ifdef TODO
 	case CMD_802_11D_DOMAIN_INFO:
 		ret = lbs_cmd_802_11d_domain_info(priv, cmdptr,
 						   cmd_no, cmd_action);
 		break;
+#endif
 
 	case CMD_802_11_TPC_CFG:
 		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
@@ -1893,6 +1874,7 @@
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
 		    ((priv->connect_status == LBS_CONNECTED) ||
 		    (priv->mesh_connect_status == LBS_CONNECTED))) {
+#ifdef TODO
 			if (priv->secinfo.WPAenabled ||
 			    priv->secinfo.WPA2enabled) {
 				/* check for valid WPA group keys */
@@ -1909,6 +1891,7 @@
 				       "go back to PS_SLEEP");
 				lbs_ps_sleep(priv, 0);
 			}
+#endif
 		}
 	}
 
@@ -1918,6 +1901,7 @@
 	return ret;
 }
 
+#ifdef TODO
 void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
 {
 	union iwreq_data iwrq;
@@ -1941,6 +1925,7 @@
 
 	lbs_deb_leave(LBS_DEB_WEXT);
 }
+#endif
 
 static void lbs_send_confirmsleep(struct lbs_private *priv)
 {
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -7,14 +7,14 @@
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
 #include <asm/unaligned.h>
-#include <net/iw_handler.h>
+#ifdef TODO
+//#include <net/iw_handler.h>
+#endif
 
 #include "host.h"
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
-#include "assoc.h"
-#include "wext.h"
 
 /**
  *  @brief This function handles disconnect event. it
@@ -26,13 +26,16 @@
  */
 void lbs_mac_event_disconnected(struct lbs_private *priv)
 {
+#ifdef TODO
 	union iwreq_data wrqu;
+#endif
 
 	if (priv->connect_status != LBS_CONNECTED)
 		return;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
+#ifdef TODO
 	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 
@@ -43,6 +46,7 @@
 
 	msleep_interruptible(1000);
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+#endif
 
 	/* report disconnect to upper layer */
 	netif_stop_queue(priv->dev);
@@ -53,14 +57,7 @@
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
+#ifdef TODO
 	priv->connect_status = LBS_DISCONNECTED;
 
 	/* Clear out associated SSID and BSSID since connection is
@@ -69,6 +66,7 @@
 	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
 	memset(&priv->curbssparams.ssid, 0, IW_ESSID_MAX_SIZE);
 	priv->curbssparams.ssid_len = 0;
+#endif
 
 	if (priv->psstate != PS_STATE_FULL_POWER) {
 		/* make firmware to exit PS mode */
@@ -100,7 +98,9 @@
 		strcat(buf, "multicast ");
 	}
 
+#ifdef TODO
 	lbs_send_iwevcustom_event(priv, buf);
+#endif
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
@@ -147,36 +147,6 @@
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
 static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
 					struct cmd_ds_command *resp)
 {
@@ -223,13 +193,11 @@
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_802_11_RSSI):
-		ret = lbs_ret_802_11_rssi(priv, resp);
-		break;
-
+#ifdef TODO
 	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
 		ret = lbs_ret_802_11d_domain_info(resp);
 		break;
+#endif
 
 	case CMD_RET(CMD_802_11_TPC_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
--- linux-wl.orig/drivers/net/wireless/libertas/ethtool.c
+++ linux-wl/drivers/net/wireless/libertas/ethtool.c
@@ -6,7 +6,6 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
-#include "wext.h"
 #include "cmd.h"
 
 static const char * mesh_stat_strings[]= {
--- linux-wl.orig/drivers/net/wireless/libertas/rx.c
+++ linux-wl/drivers/net/wireless/libertas/rx.c
@@ -8,7 +8,6 @@
 #include "radiotap.h"
 #include "decl.h"
 #include "dev.h"
-#include "wext.h"
 
 struct eth803hdr {
 	u8 dest_addr[6];
@@ -38,99 +37,6 @@
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
@@ -238,8 +144,6 @@
 	if (priv->enablehwauto)
 		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
 
-	lbs_compute_rssi(priv, p_rx_pd);
-
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
@@ -366,8 +270,6 @@
 	if (priv->enablehwauto)
 		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
 
-	lbs_compute_rssi(priv, prxpd);
-
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
 	dev->stats.rx_packets++;
--- linux-wl.orig/drivers/net/wireless/libertas/tx.c
+++ linux-wl/drivers/net/wireless/libertas/tx.c
@@ -10,7 +10,6 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
-#include "wext.h"
 
 /**
  *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -1,3 +1,6 @@
+#error don't include wext.h
+/* TODO: remove this file */
+
 /**
   * This file contains definition for IOCTL call.
   */
--- linux-wl.orig/drivers/net/wireless/libertas/11d.h
+++ linux-wl/drivers/net/wireless/libertas/11d.h
@@ -1,3 +1,6 @@
+#error don't include 11d.h
+/* TODO: remove this file */
+
 /**
   * This header file contains data structures and
   * function declarations of 802.11d
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.h
+++ linux-wl/drivers/net/wireless/libertas/cmd.h
@@ -72,12 +72,14 @@
 				      uint16_t cmd_action, uint16_t *timeout);
 int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
 				struct sleep_params *sp);
+#ifdef TODO
 int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
 			   struct assoc_request *assoc);
 int lbs_cmd_802_11_enable_rsn(struct lbs_private *priv, uint16_t cmd_action,
 			      uint16_t *enable);
 int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
 				struct assoc_request *assoc);
+#endif
 
 int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
 		     s16 *maxlevel);
--- linux-wl.orig/drivers/net/wireless/libertas/debugfs.c
+++ linux-wl/drivers/net/wireless/libertas/debugfs.c
@@ -4,7 +4,9 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <net/iw_handler.h>
+#ifdef TODO
+//#include <net/iw_handler.h>
+#endif
 #include <net/lib80211.h>
 
 #include "dev.h"
@@ -14,10 +16,12 @@
 #include "cmd.h"
 
 static struct dentry *lbs_dir;
+#ifdef TODO
 static char *szStates[] = {
 	"Connected",
 	"Disconnected"
 };
+#endif
 
 #ifdef PROC_DEBUG
 static void lbs_debug_init(struct lbs_private *priv);
@@ -48,8 +52,10 @@
 	if (!buf)
 		return -ENOMEM;
 
+#ifdef TODO
 	pos += snprintf(buf+pos, len-pos, "state = %s\n",
 				szStates[priv->connect_status]);
+#endif
 	pos += snprintf(buf+pos, len-pos, "region_code = %02x\n",
 				(u32) priv->regioncode);
 
@@ -60,6 +66,7 @@
 }
 
 
+#ifdef TODO
 static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
@@ -103,6 +110,7 @@
 	free_page(addr);
 	return res;
 }
+#endif
 
 static ssize_t lbs_sleepparams_write(struct file *file,
 				const char __user *user_buf, size_t count,
@@ -722,8 +730,10 @@
 
 static const struct lbs_debugfs_files debugfs_files[] = {
 	{ "info", 0444, FOPS(lbs_dev_info, write_file_dummy), },
+#ifdef TODO
 	{ "getscantable", 0444, FOPS(lbs_getscantable,
 					write_file_dummy), },
+#endif
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
 };
--- linux-wl.orig/drivers/net/wireless/libertas/hostcmd.h
+++ linux-wl/drivers/net/wireless/libertas/hostcmd.h
@@ -6,8 +6,10 @@
 #define _LBS_HOSTCMD_H
 
 #include <linux/wireless.h>
-#include "11d.h"
 #include "types.h"
+#include "defs.h"
+
+struct lbs_private;
 
 /* 802.11-related definitions */
 
@@ -433,19 +435,12 @@
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_rssi {
-	/* weighting factor */
-	__le16 N;
-
-	__le16 reserved_0;
-	__le16 reserved_1;
-	__le16 reserved_2;
-} __attribute__ ((packed));
+	struct cmd_header hdr;
 
-struct cmd_ds_802_11_rssi_rsp {
-	__le16 SNR;
-	__le16 noisefloor;
-	__le16 avgSNR;
-	__le16 avgnoisefloor;
+	__le16 n_or_snr;
+	__le16 nf;
+	__le16 avg_snr;
+	__le16 avg_nf;
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_mac_address {
@@ -706,7 +701,9 @@
 } __attribute__ ((packed));
 
 struct cmd_tx_rate_query {
-	__le16 txrate;
+	struct cmd_header hdr;
+
+	__le16 tx_rate;
 } __attribute__ ((packed));
 
 struct cmd_ds_get_tsf {
@@ -772,28 +769,27 @@
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_802_11_get_stat gstat;
-		struct cmd_ds_802_3_get_stat gstat_8023;
-		struct cmd_ds_802_11_rf_antenna rant;
 		struct cmd_ds_802_11_monitor_mode monitor;
-		struct cmd_ds_802_11_rssi rssi;
-		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_mac_reg_access macreg;
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
-
-		struct cmd_ds_802_11d_domain_info domaininfo;
-		struct cmd_ds_802_11d_domain_info domaininforesp;
-
 		struct cmd_ds_802_11_tpc_cfg tpccfg;
 		struct cmd_ds_802_11_afc afc;
 		struct cmd_ds_802_11_led_ctrl ledgpio;
-
-		struct cmd_tx_rate_query txrate;
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
 		struct cmd_ds_get_tsf gettsf;
 		struct cmd_ds_802_11_beacon_control bcn_ctrl;
+#ifdef TODO
+		struct cmd_ds_802_11_get_stat gstat;
+		struct cmd_ds_802_3_get_stat gstat_8023;
+		struct cmd_ds_802_11_rf_antenna rant;
+		struct cmd_ds_802_11_rssi rssi;
+		struct cmd_ds_802_11_rssi_rsp rssirsp;
+		struct cmd_ds_802_11d_domain_info domaininfo;
+		struct cmd_ds_802_11d_domain_info domaininforesp;
+		struct cmd_tx_rate_query txrate;
+#endif
 	} params;
 } __attribute__ ((packed));
 
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -46,7 +46,9 @@
 			  int result);
 netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb,
 				struct net_device *dev);
+#ifdef TODO
 int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
+#endif
 
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 

-- 
http://www.holgerschurig.de
