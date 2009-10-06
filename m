Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:6122 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbZJFOeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 10:34:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id E681C5000D
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 16:33:23 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OdHXjPIIKill for <linux-wireless@vger.kernel.org>;
	Tue,  6 Oct 2009 16:33:23 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F9373.dip0.t-ipconnect.de [217.95.147.115])
	by mx51.mymxserver.com (Postfix) with ESMTP id 4B03C50006
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 16:33:22 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 9F02F1E0036
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 16:33:11 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [WIP, RFC] libertas: allow scanning via "iw"
Date: Tue, 6 Oct 2009 16:33:08 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910061633.08237.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for "iw eth1 scan trigger" and "iw eth1 scan dump".

Do not apply!

---

There are some open points, all marked as TODO

* signal isn't reported in dBm or mBm. The scan response from
  the firmware tells me some "RSSI" value.
* no real support for active/passive scanning yet
* no integration into the current code, e.g. no usage of the
  scan results in assoc.c and other places. priv->networks is
  completely unrelated (and should ultimatively go away)
* dummy lbs_scan_networks()
* dummy lbs_send_specific_ssid_scan()
* scan.c and scan.h are just disabled, not deleted


Besides all of this, the following is possible:

# iw eth1 scan trigger freq 2412 passive; sleep 0.5; iw eth1 scan dump
BSS 00:1b:d4:44:35:90 (on eth1)
        TSF: 286400000 usec (0d, 00:04:46)
        freq: 2412
        beacon interval: 100
        capability: ESS Privacy (0x0011)
        signal: 57/100
        SSID: MNWPA
        Supported rates: 1.0* 2.0 5.5 11.0
        DS Parameter set: channel 1
        ERP: Use_Protection
        WPA:     * Version: 1
                 * Group cipher: TKIP
                 * Pairwise ciphers: TKIP
                 * Authentication suites: PSK
                 * Capabilities: 4-PTKSA-RC 4-GTKSA-RC (0x0028)
        WMM:    * Parameter version 1
                * u-APSD
                * BE: CW 31-1023, AIFSN 3
                * BK: CW 31-1023, AIFSN 7
                * VI: CW 15-31, AIFSN 2, TXOP 3008 usec
                * VO: CW 7-15, AIFSN 2, TXOP 1504 usec
BSS 00:1b:53:11:dc:40 (on eth1)
        TSF: 286410000 usec (0d, 00:04:46)
        freq: 2412
        beacon interval: 100
        capability: ESS Privacy (0x0011)
        signal: 64/100
        SSID: MNWPA
        Supported rates: 11.0*
        DS Parameter set: channel 1
        ERP: NonERP_Present Use_Protection Barker_Preamble_Mode
        WMM:    * Parameter version 1
                * u-APSD
                * BE: CW 31-1023, AIFSN 3
                * BK: CW 31-1023, AIFSN 7
                * VI: CW 15-31, AIFSN 2, TXOP 3008 usec
                * VO: CW 7-15, AIFSN 2, TXOP 1504 usec

# iw eth1 scan trigger freq 2417 2462
# iw eth1 scan ssid MNWPA

Index: linux-wl/drivers/net/wireless/libertas/cfg.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c	2009-10-06 15:23:34.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/cfg.c	2009-10-06 15:23:48.000000000 +0200
@@ -7,9 +7,34 @@
  */
 
 #include <net/cfg80211.h>
+#include <asm/unaligned.h>
 
 #include "cfg.h"
 #include "cmd.h"
+#include "host.h"
+
+/*
+ * When scanning, the firmware doesn't send a nul packet with the power-safe
+ * bit on to the AP. So we cannot stay away from our current channel too
+ * long, otherwise we loose data. So take a "nap" while scanning every other
+ * while.
+ */
+#define LBS_SCAN_MAX_CHANNELS_BEFORE_NAP 4
+
+/* Memory needed to store a max sized channel List TLV for a firmware scan */
+#define CHAN_TLV_MAX_SIZE  (sizeof(struct mrvl_ie_header)    \
+	+ (MRVDRV_MAX_CHANNELS_PER_SCAN     \
+	* sizeof(struct chanscanparamset)))
+
+/* Memory needed to store a max number/size SSID TLV for a firmware scan */
+#define SSID_TLV_MAX_SIZE  (1 * sizeof(struct mrvl_ie_ssid_param_set))
+
+/* Maximum memory needed for a cmd_ds_802_11_scan with all TLVs at max */
+#define MAX_SCAN_CFG_ALLOC (sizeof(struct cmd_ds_802_11_scan)	\
+	+ CHAN_TLV_MAX_SIZE + SSID_TLV_MAX_SIZE)
+
+/* Scan time specified in the channel TLV for each channel for active scans */
+#define MRVDRV_ACTIVE_SCAN_CHAN_TIME   100
 
 
 #define CHAN2G(_channel, _freq, _flags) {        \
@@ -77,6 +102,10 @@ static const u32 cipher_suites[] = {
 
 
 
+/***************************************************************************
+ * Set Channel
+ */
+
 static int lbs_cfg_set_channel(struct wiphy *wiphy,
 	struct ieee80211_channel *chan,
 	enum nl80211_channel_type channel_type)
@@ -97,10 +126,374 @@ static int lbs_cfg_set_channel(struct wi
 }
 
 
+/***************************************************************************
+ * Scanning
+ */
+
+static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
+	struct cmd_header *resp)
+{
+	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
+	int bsssize;
+	u8 *pos;
+	uint16_t nr_sets;
+	u8 *tsfdesc;
+	int tsfsize;
+	int i;
+	int ret = -EILSEQ;
+
+	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
+	nr_sets = le16_to_cpu(resp->size);
+
+	/* The general layout of the scan response is described in
+	 * chapter 5.7.1. Basically we have common part, then
+	 * one data section for each returned BSS, and then again
+	 * one data section containing TSFs. Sample:
+	 *
+	 * cmd_ds_802_11_scan_rsp
+	 *   cmd_header
+	 *   pos_size
+	 *   nr_sets
+	 *   bssdesc 1
+	 *     bssid
+	 *     rssi
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
+	/* Validity check: we expect a Marvell-Local IE */
+	i = get_unaligned_le16(tsfdesc);
+	tsfdesc += 2;
+	if (i != 0x0113)
+		goto done;
+	/* Validity check: the IE holds TSF values with 8 bytes each,
+	 * so the size in the IE must match the nr_sets value */
+	i = get_unaligned_le16(tsfdesc);
+	tsfdesc += 2;
+	if (i / 8 != scanresp->nr_sets)
+		goto done;
+
+	for (i = 0; i < scanresp->nr_sets; i++) {
+		u8 *bssid;
+		u8 *ie;
+		int left;
+		int ielen;
+		u8 rssi;
+		uint16_t intvl;
+		uint16_t capa;
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
+			    !channel->flags & IEEE80211_CHAN_DISABLED)
+				cfg80211_inform_bss(wiphy, channel,
+					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
+					capa, intvl, ie, ielen, rssi,
+					GFP_KERNEL);
+		}
+
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
+ * Add SSID TLV of the form:
+ *
+ * TLV-ID SSID     00 00
+ * length          06 00
+ * ssid            4d 4e 54 45 53 54
+ */
+static int lbs_scan_add_ssid_tlv(struct lbs_private *priv, u8 *tlv)
+{
+	struct mrvl_ie_ssid_param_set *ssid_tlv = (void *)tlv;
+
+	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
+	ssid_tlv->header.len = cpu_to_le16(priv->scan_req->ssids[0].ssid_len);
+	memcpy(ssid_tlv->ssid, priv->scan_req->ssids[0].ssid,
+		priv->scan_req->ssids[0].ssid_len);
+	return sizeof(ssid_tlv->header) + priv->scan_req->ssids[0].ssid_len;
+}
+
+
+/*
+ * Add CHANLIST TLV of the form:
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
+ * data comes from priv->wiphy->channels.
+ */
+static int lbs_scan_add_channel_tlv(struct lbs_private *priv, u8 *tlv,
+	int last_channel)
+{
+	int chanscanparamsize = sizeof(struct chanscanparamset) *
+			(last_channel - priv->scan_channel);
+
+	struct mrvl_ie_header *header = (void *) tlv;
+
+	header->type = cpu_to_le16(TLV_TYPE_CHANLIST);
+	header->len  = cpu_to_le16(chanscanparamsize);
+	tlv += sizeof(struct mrvl_ie_header);
+
+	lbs_deb_scan("scan from %d to %d, size %d\n", priv->scan_channel,
+		last_channel, chanscanparamsize);
+	memset(tlv, 0, chanscanparamsize);
+
+	while (priv->scan_channel < last_channel) {
+		struct chanscanparamset *param = (void *) tlv;
+
+		param->radiotype = CMD_SCAN_RADIO_TYPE_BG;
+		param->channumber =
+			priv->scan_req->channels[priv->scan_channel]->hw_value;
+		/* TODO param->.chanscanmode.passivescan = 1; */
+		param->maxscantime = cpu_to_le16(MRVDRV_ACTIVE_SCAN_CHAN_TIME);
+		tlv += sizeof(struct chanscanparamset);
+		priv->scan_channel++;
+	}
+	return sizeof(struct mrvl_ie_header) + chanscanparamsize;
+}
+
+
+/*
+ * Add RATES TLV of the form
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
+static int lbs_scan_add_rates_tlv(u8 *tlv)
+{
+	int i;
+	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
+
+	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	tlv += sizeof(rate_tlv->header);
+	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
+		*tlv = lbs_rates[i].hw_value;
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
+/*
+ * Assumes priv->scan_req is initialized and valid
+ * Assumes priv->scan_channel is initialized
+ */
+void lbs_cfg_scan_worker(struct work_struct *work)
+{
+	struct lbs_private *priv =
+		container_of(work, struct lbs_private, scan_work.work);
+	struct cmd_ds_802_11_scan *scan_cmd;
+	u8 *tlv;	/* pointer into our current, growing TLV storage area */
+	int last_channel;
+
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	/* create the fixed part for scan command */
+	scan_cmd = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
+	if (scan_cmd == NULL)
+		goto out_no_scan_cmd;
+	tlv = scan_cmd->tlvbuffer;
+
+	netif_stop_queue(priv->dev);
+	netif_carrier_off(priv->dev);
+	if (priv->mesh_dev) {
+		netif_stop_queue(priv->mesh_dev);
+		netif_carrier_off(priv->mesh_dev);
+	}
+
+	scan_cmd->bsstype = CMD_BSS_TYPE_ANY;
+
+	/* add SSID TLV */
+	if (priv->scan_req->n_ssids)
+		tlv += lbs_scan_add_ssid_tlv(priv, tlv);
+
+	/* add channel TLVs */
+	last_channel = priv->scan_channel + LBS_SCAN_MAX_CHANNELS_BEFORE_NAP;
+	if (last_channel > priv->scan_req->n_channels)
+		last_channel = priv->scan_req->n_channels;
+	tlv += lbs_scan_add_channel_tlv(priv, tlv, last_channel);
+
+	/* add rates TLV */
+	tlv += lbs_scan_add_rates_tlv(tlv);
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
+	if (priv->connect_status == LBS_CONNECTED) {
+		netif_carrier_on(priv->dev);
+		if (!priv->tx_pending_len)
+			netif_wake_queue(priv->dev);
+	}
+	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
+		netif_carrier_on(priv->mesh_dev);
+		if (!priv->tx_pending_len)
+			netif_wake_queue(priv->mesh_dev);
+	}
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
+int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
+	u8 ssid_len)
+{
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	/* TODO */
+	return -ENOTSUPP;
+}
+
+
+int lbs_scan_networks(struct lbs_private *priv, int full_scan)
+{
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	/* TODO */
+	return -ENOTSUPP;
+
+}
+
 
+/***************************************************************************
+ * Initialization
+ */
 
 static struct cfg80211_ops lbs_cfg80211_ops = {
 	.set_channel = lbs_cfg_set_channel,
+	.scan = lbs_cfg_scan,
 };
 
 
@@ -153,7 +546,8 @@ int lbs_cfg_register(struct lbs_private 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	wdev->wiphy->max_scan_ssids = 1;
-	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
+	/* TODO: convert to CFG80211_SIGNAL_TYPE_MBM; */
 
 	/* TODO: BIT(NL80211_IFTYPE_ADHOC); */
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
Index: linux-wl/drivers/net/wireless/libertas/dev.h
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/dev.h	2009-10-06 15:23:48.000000000 +0200
@@ -10,6 +10,7 @@
 #include <linux/wireless.h>
 #include <linux/ethtool.h>
 #include <linux/debugfs.h>
+#include <net/cfg80211.h>
 
 #include "defs.h"
 #include "hostcmd.h"
@@ -101,6 +102,7 @@ struct lbs_mesh_stats {
 /** Private structure for the MV device */
 struct lbs_private {
 	struct wireless_dev *wdev;
+	struct cfg80211_scan_request *scan_req;
 	int mesh_open;
 	int mesh_fw_ver;
 	int infra_open;
Index: linux-wl/drivers/net/wireless/libertas/wext.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/wext.c	2009-10-06 15:23:48.000000000 +0200
@@ -17,7 +17,6 @@
 #include "defs.h"
 #include "dev.h"
 #include "wext.h"
-#include "scan.h"
 #include "assoc.h"
 #include "cmd.h"
 
@@ -2346,8 +2345,8 @@ static const iw_handler lbs_handler[] = 
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
@@ -2404,8 +2403,8 @@ static const iw_handler mesh_wlan_handle
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
Index: linux-wl/drivers/net/wireless/libertas/Makefile
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/Makefile	2009-10-06 15:23:48.000000000 +0200
@@ -8,7 +8,8 @@ libertas-y += ethtool.o
 libertas-y += main.o
 libertas-y += persistcfg.o
 libertas-y += rx.o
-libertas-y += scan.o
+# TODO
+#libertas-y += scan.o
 libertas-y += tx.o
 libertas-y += wext.o
 
Index: linux-wl/drivers/net/wireless/libertas/assoc.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/assoc.c	2009-10-06 15:23:48.000000000 +0200
@@ -9,7 +9,7 @@
 #include "assoc.h"
 #include "decl.h"
 #include "host.h"
-#include "scan.h"
+#include "cfg.h"
 #include "cmd.h"
 
 static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
@@ -495,6 +495,23 @@ done:
 }
 
 /**
+ *  @brief Compare two SSIDs
+ *
+ *  @param ssid1    A pointer to ssid to compare
+ *  @param ssid2    A pointer to ssid to compare
+ *
+ *  @return         0: ssid is same, otherwise is different
+ */
+static int lbs_ssid_cmp(uint8_t *ssid1, uint8_t ssid1_len, uint8_t *ssid2,
+		 uint8_t ssid2_len)
+{
+	if (ssid1_len != ssid2_len)
+		return -1;
+
+	return memcmp(ssid1, ssid2, ssid1_len);
+}
+
+/**
  *  @brief Join an adhoc network found in a previous scan
  *
  *  @param priv         A pointer to struct lbs_private structure
Index: linux-wl/drivers/net/wireless/libertas/main.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/main.c	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/main.c	2009-10-06 15:23:48.000000000 +0200
@@ -22,7 +22,7 @@
 #include "wext.h"
 #include "cfg.h"
 #include "debugfs.h"
-#include "scan.h"
+#include "cfg.h"
 #include "assoc.h"
 #include "cmd.h"
 
@@ -1133,7 +1133,8 @@ static void lbs_sync_channel_worker(stru
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
-
+/* TODO */
+#define MAX_NETWORK_COUNT 128
 static int lbs_init_adapter(struct lbs_private *priv)
 {
 	size_t bufsize;
@@ -1313,7 +1314,7 @@ struct lbs_private *lbs_add_card(void *c
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
-	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
+	INIT_DELAYED_WORK(&priv->scan_work, lbs_cfg_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
Index: linux-wl/drivers/net/wireless/libertas/persistcfg.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/persistcfg.c	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/persistcfg.c	2009-10-06 15:23:48.000000000 +0200
@@ -11,7 +11,6 @@
 #include "dev.h"
 #include "wext.h"
 #include "debugfs.h"
-#include "scan.h"
 #include "assoc.h"
 #include "cmd.h"
 
Index: linux-wl/drivers/net/wireless/libertas/scan.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/scan.c	2009-10-06 15:23:48.000000000 +0200
@@ -3,6 +3,8 @@
   *
   * IOCTL handlers as well as command preperation and response routines
   *  for sending scan commands to the firmware.
+  *
+  * TODO: remove this file
   */
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -90,23 +92,6 @@ static inline void clear_bss_descriptor(
 	memset(bss, 0, offsetof(struct bss_descriptor, list));
 }
 
-/**
- *  @brief Compare two SSIDs
- *
- *  @param ssid1    A pointer to ssid to compare
- *  @param ssid2    A pointer to ssid to compare
- *
- *  @return         0: ssid is same, otherwise is different
- */
-int lbs_ssid_cmp(uint8_t *ssid1, uint8_t ssid1_len, uint8_t *ssid2,
-		 uint8_t ssid2_len)
-{
-	if (ssid1_len != ssid2_len)
-		return -1;
-
-	return memcmp(ssid1, ssid2, ssid1_len);
-}
-
 static inline int is_same_network(struct bss_descriptor *src,
 				  struct bss_descriptor *dst)
 {
Index: linux-wl/drivers/net/wireless/libertas/scan.h
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/scan.h	2009-10-06 15:22:40.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/scan.h	2009-10-06 15:23:48.000000000 +0200
@@ -1,3 +1,6 @@
+#error don't include scan.h
+/* TODO: remove this file */
+
 /**
   * Interface for the wlan network scan routines
   *

-- 
http://www.holgerschurig.de
