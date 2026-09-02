Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1BC372EE9
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368142; cv=none; b=j8fj/rZR0MzwxH1hll8GtGb9nZ5x9eA0FSvajcYFp6S20zLSHpc5FmZlaV5BfX2Yq39eNaEPYk1cEttjnOyXTq/A3deAa8GQsrCPIBFoXj8FevtDd+5FBDZUpPFkakRhgYJJsAVKLYLWOCrVj7wvXTvSetQTqj9aIjgy8n3fFz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368142; c=relaxed/simple;
	bh=WuzHMJHeDVXcQZHo/tdUR4r4lyQv1Z9vDYLSpbK1GQA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rmMYmTTDymagyoN20ceiMxgx2rnFggGtTeF3rBRkFDe+gwevvRSz5/XhpU22ro0j7Czd5qBVAQOJ+cODrP3wsw3TXol6bj1bzM2tHCOS4BZ9veMTRQG3xMAG76vwwjh3OnI0DxCaAnUH0u7PchoRYUHHQkYsvWs7hWaPFcu50II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=mLs4HBl9; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="mLs4HBl9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368140; x=1819904140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WuzHMJHeDVXcQZHo/tdUR4r4lyQv1Z9vDYLSpbK1GQA=;
  b=mLs4HBl930gWDvuajV6uGeHlKDt5OX5EsT2Sh/DRcgqH98v+1RARa89f
   5CeUlATSM/RCXJ/X0dx/rym08lzJQAX0PGdH1D5uiBlK1m1PRfhPHvRd7
   HSEVRonaG4/FPYxhzXgDEr8ld64mKqpDC5yt+QQpGGSPTJ+hW/rBG/Enr
   A=;
X-CSE-ConnectionGUID: d8X/Zy/CT7SGS9084spCaw==
X-CSE-MsgGUID: z3DSkWYqRjmiAHH9uebGQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="176357133"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="176357133"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:55:38 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:55:37 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:55:35 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 21/25] wifi: inffmac: add scan.c/h
Date: Wed, 2 Sep 2026 16:50:52 +0000
Message-ID: <20260902165057.456447-22-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE812.infineon.com (172.23.29.38) To
 MUCSE827.infineon.com (172.23.29.20)

Driver imeplementation of the SCAN functionality to discover all active BSS
in the medium. Also support collecting the channel survery dump.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/infineon/inffmac/scan.c | 800 +++++++++++++++++++
 drivers/net/wireless/infineon/inffmac/scan.h | 136 ++++
 2 files changed, 936 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/scan.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/scan.h

diff --git a/drivers/net/wireless/infineon/inffmac/scan.c b/drivers/net/wireless/infineon/inffmac/scan.c
new file mode 100644
index 000000000000..f71dcc60386a
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/scan.c
@@ -0,0 +1,800 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <net/cfg80211.h>
+#include <net/netlink.h>
+
+#include "main.h"
+#include "utils.h"
+#include "chan.h"
+#include "debug.h"
+#include "fwsignal.h"
+#include "cfg80211.h"
+#include "interface.h"
+#include "feature.h"
+#include "dev_cmd.h"
+
+s32
+inff_dongle_scantime(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err = 0;
+
+	err = inff_fwcmd_int_set(ifp, INFF_C_SET_SCAN_CHANNEL_TIME,
+				 INFF_SCAN_CHANNEL_TIME);
+	if (err) {
+		iphy_err(drvr, "Scan assoc time error (%d)\n", err);
+		goto dongle_scantime_out;
+	}
+	err = inff_fwcmd_int_set(ifp, INFF_C_SET_SCAN_UNASSOC_TIME,
+				 INFF_SCAN_UNASSOC_TIME);
+	if (err) {
+		iphy_err(drvr, "Scan unassoc time error (%d)\n", err);
+		goto dongle_scantime_out;
+	}
+
+	err = inff_fwcmd_int_set(ifp, INFF_C_SET_SCAN_PASSIVE_TIME,
+				 INFF_SCAN_PASSIVE_TIME);
+	if (err) {
+		iphy_err(drvr, "Scan passive time error (%d)\n", err);
+		goto dongle_scantime_out;
+	}
+
+dongle_scantime_out:
+	return err;
+}
+
+static void
+inff_cp_scan_reset(struct inff_scan_info *scan)
+{
+	scan->request = NULL;
+	scan->bss_count = 0;
+	scan->used_buf_len = 0;
+
+	if (scan->bss_buf)
+		memset(scan->bss_buf, 0, INFF_SCAN_BUF_SIZE);
+}
+
+static void
+inff_cp_scan_complete(struct inff_pub *drvr, bool aborted)
+{
+	struct inff_cfg80211_info *cfg = drvr->config;
+	struct inff_scan_info *scan = &drvr->config->scan;
+	struct cfg80211_scan_info info = {
+		.aborted = aborted,
+	};
+
+	if (aborted)
+		set_bit(INFF_SCAN_STATUS_ABORT, &cfg->scan_status);
+
+	if (!scan || !scan->request)
+		return;
+
+	inff_dbg(SCAN, "%s\n", aborted ? "aborted" : "done");
+	cfg80211_scan_done(scan->request, &info);
+
+	if (!test_and_clear_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status))
+		inff_dbg(SCAN, "Scan complete complete/abort\n");
+
+	inff_cp_scan_reset(scan);
+
+	if (aborted)
+		clear_bit(INFF_SCAN_STATUS_ABORT, &cfg->scan_status);
+}
+
+void
+inff_cp_scan_abort(struct inff_pub *drvr)
+{
+	inff_cp_scan_complete(drvr, true);
+}
+
+static s32
+inff_cp_scan_inform_single_bss(struct inff_scan_info *scan,
+			       struct inff_cp_bss_info *bss)
+{
+	struct wiphy *wiphy = scan->wiphy;
+	struct cfg80211_bss *cfg80211_bss;
+	struct cfg80211_inform_bss bss_data = {};
+	enum nl80211_band band;
+	u16 channel;
+	u32 freq;
+	u8 *ie;
+
+	inff_dbg(SCAN, "SSID: %s\n", bss->ssid);
+	inff_dbg(SCAN, "BSSID: %pM\n", bss->macaddr);
+
+	channel = bss->channel;
+	band = inff_cp_chan_band_to_nl80211(bss->band);
+
+	freq = ieee80211_channel_to_frequency(channel, band);
+	if (!freq) {
+		inff_err("failed to get frequency from channel %d and band %d\n",
+			 channel, band);
+		return -EINVAL;
+	}
+
+	bss_data.chan = ieee80211_get_channel(wiphy, freq);
+	if (!bss_data.chan) {
+		inff_err("failed to get channel from freq %d\n", freq);
+		return -EINVAL;
+	}
+
+	bss_data.boottime_ns = ktime_to_ns(ktime_get_boottime());
+	bss_data.signal = bss->signal_strength * 100;
+
+	inff_dbg(SCAN, "Channel: %d(%d)\n", channel, freq);
+	inff_dbg(SCAN, "Capability: %X\n", bss->capability);
+	inff_dbg(SCAN, "Beacon interval: %d\n", bss->beacon_period);
+	inff_dbg(SCAN, "Signal: %d\n", bss->signal_strength);
+
+	ie = (unsigned char *)bss + sizeof(*bss);
+
+	cfg80211_bss = cfg80211_inform_bss_data(wiphy, &bss_data,
+						CFG80211_BSS_FTYPE_UNKNOWN,
+						(const u8 *)bss->macaddr,
+						0, bss->capability,
+						bss->beacon_period, ie,
+						bss->ie_len, GFP_KERNEL);
+	if (!cfg80211_bss)
+		return -ENOMEM;
+
+	cfg80211_put_bss(wiphy, cfg80211_bss);
+
+	return 0;
+}
+
+static void
+inff_cp_scan_inform_bss(struct inff_scan_info *scan)
+{
+	struct inff_cp_bss_info *bss = (struct inff_cp_bss_info *)scan->bss_buf;
+	s32 err = 0;
+	int i;
+
+	inff_dbg(SCAN, "scanned AP count (%d)\n", scan->bss_count);
+	for (i = 0; i < scan->bss_count; i++) {
+		err = inff_cp_scan_inform_single_bss(scan, bss);
+		if (err == -ENOMEM)
+			break;
+
+		bss = (struct inff_cp_bss_info *)
+			((unsigned char *)bss + bss->length);
+	}
+}
+
+static void
+inff_cp_scan_save_bss(struct inff_scan_info *scan, struct inff_cpevt_scan *new_bss)
+{
+	struct inff_cp_bss_info *bss = (struct inff_cp_bss_info *)scan->bss_buf;
+	u32 new_bss_len;
+	u8 i;
+
+	new_bss_len = sizeof(*bss) + new_bss->ie_len;
+
+	for (i = 0; i < scan->bss_count; i++) {
+		if (!memcmp(&bss->macaddr, &new_bss->macaddr, ETH_ALEN))
+			return;
+
+		bss = (struct inff_cp_bss_info *)((unsigned char *)bss + bss->length);
+	}
+
+	if (scan->used_buf_len + new_bss_len > INFF_SCAN_BUF_SIZE) {
+		inff_err("scan buffer is not enough\n");
+		return;
+	}
+
+	bss->length = new_bss_len;
+	bss->ssid_length = new_bss->ssid_length;
+	memcpy(bss->ssid, new_bss->ssid, new_bss->ssid_length);
+	memcpy(bss->macaddr, new_bss->macaddr, ETH_ALEN);
+	bss->signal_strength = new_bss->signal_strength;
+	bss->channel = new_bss->channel;
+	bss->band = new_bss->band;
+	bss->beacon_period = new_bss->beacon_period;
+	bss->capability = new_bss->capability;
+	bss->ie_len = new_bss->ie_len;
+
+	memcpy((u8 *)bss + sizeof(*bss), new_bss->ie, new_bss->ie_len);
+
+	inff_dbg(SCAN, "BSS Idx %d\n", scan->bss_count);
+	inff_dbg(SCAN, "SSID: %s\n", bss->ssid);
+	inff_dbg(SCAN, "BSSID: %pM\n", bss->macaddr);
+
+	scan->bss_count++;
+	scan->used_buf_len += new_bss_len;
+	inff_dbg(SCAN, "used_buf_len: %d\n", scan->used_buf_len);
+}
+
+/*
+ * inff_cp_scan_event_handler() - handle scan event.
+ *
+ * @scan: scan info context.
+ * @event: scan event.
+ */
+int
+inff_cp_scan_event_handler(struct inff_pub *drvr,
+			   struct inff_cpevt_scan *scan_event)
+{
+	int ret = 0;
+	struct inff_scan_info *scan = &drvr->config->scan;
+
+	if (!scan->request)
+		return 0;
+
+	if (scan_event->scan_complete) {
+		inff_cp_scan_inform_bss(scan);
+		inff_cp_scan_complete(drvr, false);
+	} else {
+		inff_cp_scan_save_bss(scan, scan_event);
+	}
+
+	return ret;
+}
+
+int
+inff_cp_scan_init(struct inff_cfg80211_info *cfg)
+{
+	struct inff_scan_info *scan = &cfg->scan;
+
+	scan->wiphy = cfg->wiphy;
+
+	scan->bss_buf = kzalloc(INFF_SCAN_BUF_SIZE, GFP_KERNEL);
+	if (!scan->bss_buf)
+		return -ENOMEM;
+
+	inff_cp_scan_reset(scan);
+
+	return 0;
+}
+
+int
+inff_cp_scan_start(struct inff_cfg80211_info *cfg, struct cfg80211_scan_request *request)
+{
+	struct inff_cfg80211_vif *vif = NULL;
+	struct inff_scan_info *scan = &cfg->scan;
+	int err;
+
+	if (test_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		inff_err("Scan in-progress\n");
+		return -EAGAIN;
+	}
+
+	vif = container_of(request->wdev, struct inff_cfg80211_vif, wdev);
+
+	scan->request = request;
+
+	err = inff_cpcmd_data_set(vif->ifp, INFF_CP_C_SCAN, NULL, 0);
+	if (err) {
+		inff_err("scan failed %d\n", err);
+		clear_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status);
+		return -EINVAL;
+	}
+
+	set_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status);
+	return 0;
+}
+
+s32
+inff_run_escan(struct inff_cfg80211_info *cfg, struct inff_if *ifp,
+	       struct cfg80211_scan_request *request)
+{
+	s32 params_size = INFF_SCAN_PARAMS_V2_FIXED_SIZE +
+			  offsetof(struct inff_escan_params_le, params_v2_le);
+	struct inff_escan_params_le *params;
+	s32 err = 0;
+
+	inff_dbg(SCAN, "E-SCAN START\n");
+
+	if (request) {
+		/* Allocate space for populating ssids in struct */
+		params_size += sizeof(u32) * ((request->n_channels + 1) / 2);
+
+		/* Allocate space for populating ssids in struct */
+		params_size += sizeof(struct inff_ssid_le) * request->n_ssids;
+	}
+
+	params = kzalloc(params_size, GFP_KERNEL);
+	if (!params) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	WARN_ON_ONCE(params_size + sizeof("escan") >= INFF_DCMD_MEDLEN);
+	inff_escan_prep(cfg, &params->params_v2_le, request);
+
+	params->version = cpu_to_le32(INFF_ESCAN_REQ_VERSION_V2);
+
+	if (!inff_feat_is_enabled(ifp, INFF_FEAT_SCAN_V2)) {
+		struct inff_escan_params_le *params_v1;
+
+		params_size -= INFF_SCAN_PARAMS_V2_FIXED_SIZE;
+		params_size += INFF_SCAN_PARAMS_FIXED_SIZE;
+		params_v1 = kzalloc(params_size, GFP_KERNEL);
+		if (!params_v1) {
+			err = -ENOMEM;
+			goto exit_params;
+		}
+		params_v1->version = cpu_to_le32(INFF_ESCAN_REQ_VERSION);
+		inff_scan_params_v2_to_v1(&params->params_v2_le, &params_v1->params_le);
+		kfree(params);
+		params = params_v1;
+	}
+
+	params->action = cpu_to_le16(WL_ESCAN_ACTION_START);
+	params->sync_id = cpu_to_le16(0x1234);
+
+	err = inff_fwcmd_iovar_data_set(ifp, "escan", params, params_size);
+	if (err) {
+		if (err == -EBUSY)
+			inff_dbg(INFO, "system busy : escan canceled\n");
+		else
+			iphy_err(ifp->drvr, "error (%d)\n", err);
+	}
+
+exit_params:
+	kfree(params);
+exit:
+	return err;
+}
+
+static s32
+inff_do_escan(struct inff_if *ifp, struct cfg80211_scan_request *request)
+{
+	struct inff_cfg80211_info *cfg = ifp->drvr->config;
+	s32 err;
+	struct inff_scan_results *results;
+	struct escan_info *escan = &cfg->escan_info;
+
+	escan->ifp = ifp;
+	escan->wiphy = cfg->wiphy;
+	escan->escan_state = WL_ESCAN_STATE_SCANNING;
+
+	inff_scan_config_mpc(ifp, 0);
+	results = (struct inff_scan_results *)cfg->escan_info.escan_buf;
+	results->version = 0;
+	results->count = 0;
+	results->buflen = WL_ESCAN_RESULTS_FIXED_SIZE;
+
+	err = escan->run(cfg, ifp, request);
+	if (err)
+		inff_scan_config_mpc(ifp, 1);
+	return err;
+}
+
+void inff_abort_scanning(struct inff_cfg80211_info *cfg)
+{
+	struct escan_info *escan = &cfg->escan_info;
+
+	set_bit(INFF_SCAN_STATUS_ABORT, &cfg->scan_status);
+	if (cfg->int_escan_map || cfg->scan_request) {
+		escan->escan_state = WL_ESCAN_STATE_IDLE;
+		inff_notify_escan_complete(cfg, escan->ifp, true, true);
+	}
+	clear_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status);
+	clear_bit(INFF_SCAN_STATUS_ABORT, &cfg->scan_status);
+}
+
+void inff_escan_prep(struct inff_cfg80211_info *cfg,
+		     struct inff_scan_params_v2_le *params_le,
+		     struct cfg80211_scan_request *request)
+{
+	u32 n_ssids;
+	u32 n_channels;
+	s32 i;
+	s32 offset;
+	u16 chanspec;
+	char *ptr;
+	int length;
+	struct inff_ssid_le ssid_le;
+
+	eth_broadcast_addr(params_le->bssid);
+
+	length = INFF_SCAN_PARAMS_V2_FIXED_SIZE;
+
+	params_le->version = cpu_to_le16(INFF_SCAN_PARAMS_VERSION_V2);
+	params_le->bss_type = DOT11_BSSTYPE_ANY;
+	params_le->scan_type = cpu_to_le32(INFF_SCANTYPE_ACTIVE);
+	params_le->channel_num = 0;
+	params_le->nprobes = cpu_to_le32(-1);
+	params_le->active_time = cpu_to_le32(-1);
+	params_le->passive_time = cpu_to_le32(-1);
+	params_le->home_time = cpu_to_le32(-1);
+	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
+
+	/* Scan abort */
+	if (!request) {
+		length += sizeof(u16);
+		params_le->channel_num = cpu_to_le32(1);
+		params_le->channel_list[0] = cpu_to_le16(-1);
+		params_le->length = cpu_to_le16(length);
+		return;
+	}
+
+	n_ssids = request->n_ssids;
+	n_channels = request->n_channels;
+
+	/* Copy channel array if applicable */
+	inff_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
+		 n_channels);
+	if (n_channels > 0) {
+		length += roundup(sizeof(u16) * n_channels, sizeof(u32));
+		for (i = 0; i < n_channels; i++) {
+			chanspec = inff_nl80211_chan_to_chanspec(request->channels[i]);
+			inff_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
+				 request->channels[i]->hw_value, chanspec);
+			params_le->channel_list[i] = cpu_to_le16(chanspec);
+		}
+	} else {
+		inff_dbg(SCAN, "Scanning all channels\n");
+	}
+
+	/* Copy ssid array if applicable */
+	inff_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
+	if (n_ssids > 0) {
+		offset = offsetof(struct inff_scan_params_v2_le, channel_list) +
+				n_channels * sizeof(u16);
+		offset = roundup(offset, sizeof(u32));
+		length += sizeof(ssid_le) * n_ssids;
+		ptr = (char *)params_le + offset;
+		for (i = 0; i < n_ssids; i++) {
+			memset(&ssid_le, 0, sizeof(ssid_le));
+			ssid_le.SSID_len =
+					cpu_to_le32(request->ssids[i].ssid_len);
+			memcpy(ssid_le.SSID, request->ssids[i].ssid,
+			       request->ssids[i].ssid_len);
+			if (!ssid_le.SSID_len)
+				inff_dbg(SCAN, "%d: Broadcast scan\n", i);
+			else
+				inff_dbg(SCAN, "%d: scan for  %.32s size=%d\n",
+					 i, ssid_le.SSID, ssid_le.SSID_len);
+			memcpy(ptr, &ssid_le, sizeof(ssid_le));
+			ptr += sizeof(ssid_le);
+		}
+	} else {
+		inff_dbg(SCAN, "Performing passive scan\n");
+		params_le->scan_type = cpu_to_le32(INFF_SCANTYPE_PASSIVE);
+	}
+	params_le->length = cpu_to_le16(length);
+	/* Adding mask to channel numbers */
+	params_le->channel_num =
+		cpu_to_le32((n_ssids << INFF_SCAN_PARAMS_NSSID_SHIFT) |
+			(n_channels & INFF_SCAN_PARAMS_COUNT_MASK));
+}
+
+s32
+inff_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
+{
+	struct inff_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_cfg80211_vif *vif;
+	s32 err = 0;
+	struct inff_tlv *interworking_ie = NULL;
+
+	vif = container_of(request->wdev, struct inff_cfg80211_vif, wdev);
+	if (!inff_check_vif_up(vif))
+		return -EIO;
+
+	if (inff_socitype_is_cp(drvr->bus_if)) {
+		err = inff_cp_scan_start(cfg, request);
+		if (err)
+			goto scan_out;
+		else
+			return 0;
+	}
+
+	if (test_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		iphy_err(drvr, "Scanning already: status (%lu)\n",
+			 cfg->scan_status);
+		return -EAGAIN;
+	}
+	if (test_bit(INFF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
+		iphy_err(drvr, "Scanning being aborted: status (%lu)\n",
+			 cfg->scan_status);
+		return -EAGAIN;
+	}
+	if (test_bit(INFF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
+		iphy_err(drvr, "Scanning suppressed: status (%lu)\n",
+			 cfg->scan_status);
+		return -EAGAIN;
+	}
+	if (test_bit(INFF_VIF_STATUS_CONNECTING, &vif->sme_state)) {
+		iphy_err(drvr, "Connecting: status (%lu)\n", vif->sme_state);
+		return -EAGAIN;
+	}
+
+	inff_dbg(SCAN, "START ESCAN\n");
+
+	cfg->scan_request = request;
+	set_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status);
+
+	interworking_ie = inff_find_iwie(request->ie, request->ie_len);
+	if (interworking_ie) {
+		err = inff_add_iwie(cfg, vif->ifp,
+				    INFF_VNDR_IE_CUSTOM_FLAG,
+				    interworking_ie->id,
+				    interworking_ie->data,
+				    interworking_ie->len);
+		if (err)
+			inff_err("Failed to add interworking IE");
+	} else {
+		/* we have to clear IW IE  */
+		inff_clear_iwie(cfg, vif->ifp);
+	}
+
+	cfg->escan_info.run = inff_run_escan;
+
+	err = inff_do_escan(vif->ifp, request);
+	if (err)
+		goto scan_out;
+
+	/* Arm scan timeout timer */
+	wiphy_delayed_work_queue(cfg->wiphy, &cfg->escan_timeout_work,
+				 msecs_to_jiffies(INFF_ESCAN_TIMER_INTERVAL_MS));
+
+	return 0;
+
+scan_out:
+	iphy_err(drvr, "scan error (%d)\n", err);
+	clear_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status);
+	cfg->scan_request = NULL;
+	return err;
+}
+
+static s32
+inff_cfg80211_escan_handler(struct inff_if *ifp,
+			    const struct inff_event_msg *e, void *data)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct inff_cfg80211_info *cfg = drvr->config;
+	s32 status;
+	struct inff_escan_result_le *escan_result_le;
+	u32 escan_buflen;
+	struct inff_bss_info_le *bss_info_le;
+	struct inff_bss_info_le *bss = NULL;
+	u32 bi_length;
+	struct inff_scan_results *list;
+	u32 i;
+	bool aborted;
+
+	status = e->status;
+
+	if (status == INFF_E_STATUS_ABORT)
+		goto exit;
+
+	if (!test_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		iphy_err(drvr, "scan not ready, bsscfgidx=%d\n",
+			 ifp->bsscfgidx);
+		return -EPERM;
+	}
+
+	if (status == INFF_E_STATUS_PARTIAL) {
+		inff_dbg(SCAN, "ESCAN Partial result\n");
+		if (e->datalen < sizeof(*escan_result_le)) {
+			iphy_err(drvr, "invalid event data length\n");
+			goto exit;
+		}
+		escan_result_le = (struct inff_escan_result_le *)data;
+		if (!escan_result_le) {
+			iphy_err(drvr, "Invalid escan result (NULL pointer)\n");
+			goto exit;
+		}
+		escan_buflen = le32_to_cpu(escan_result_le->buflen);
+		if (escan_buflen > INFF_ESCAN_BUF_SIZE ||
+		    escan_buflen > e->datalen ||
+		    escan_buflen < sizeof(*escan_result_le)) {
+			iphy_err(drvr, "Invalid escan buffer length: %d\n",
+				 escan_buflen);
+			goto exit;
+		}
+		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
+			iphy_err(drvr, "Invalid bss_count %d: ignoring\n",
+				 escan_result_le->bss_count);
+			goto exit;
+		}
+		bss_info_le = &escan_result_le->bss_info_le;
+
+		if (!cfg->int_escan_map && !cfg->scan_request) {
+			inff_dbg(SCAN, "result without cfg80211 request\n");
+			goto exit;
+		}
+
+		bi_length = le32_to_cpu(bss_info_le->length);
+		if (bi_length != escan_buflen -	WL_ESCAN_RESULTS_FIXED_SIZE) {
+			iphy_err(drvr, "Ignoring invalid bss_info length: %d\n",
+				 bi_length);
+			goto exit;
+		}
+
+		if (!(cfg->wiphy->interface_modes &
+		      BIT(NL80211_IFTYPE_ADHOC))) {
+			if (le16_to_cpu(bss_info_le->capability) &
+						WLAN_CAPABILITY_IBSS) {
+				iphy_err(drvr, "Ignoring IBSS result\n");
+				goto exit;
+			}
+		}
+
+		list = (struct inff_scan_results *)
+				cfg->escan_info.escan_buf;
+
+		if (bi_length > INFF_ESCAN_BUF_SIZE - list->buflen) {
+			iphy_err(drvr, "Buffer is too small: ignoring\n");
+			goto exit;
+		}
+
+		for (i = 0; i < list->count; i++) {
+			bss = bss ? (struct inff_bss_info_le *)
+				((unsigned char *)bss +
+				le32_to_cpu(bss->length)) : list->bss_info_le;
+			if (inff_compare_update_same_bss(cfg, bss,
+							 bss_info_le))
+				goto exit;
+		}
+		memcpy(&cfg->escan_info.escan_buf[list->buflen], bss_info_le,
+		       bi_length);
+		list->version = le32_to_cpu(bss_info_le->version);
+		list->buflen += bi_length;
+		list->count++;
+	} else {
+		cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+		if (cfg->int_escan_map || cfg->scan_request) {
+			inff_inform_bss(cfg);
+			aborted = status != INFF_E_STATUS_SUCCESS;
+			inff_notify_escan_complete(cfg, ifp, aborted, false);
+		} else {
+			inff_dbg(SCAN, "Ignored scan complete result 0x%x\n",
+				 status);
+		}
+	}
+exit:	return 0;
+}
+
+static void inff_cfg80211_escan_timeout_worker(struct wiphy *wiphy,
+					       struct wiphy_work *work)
+{
+	struct inff_cfg80211_info *cfg =
+			container_of(work, struct inff_cfg80211_info,
+				     escan_timeout_work.work);
+
+	lockdep_assert_wiphy(wiphy);
+
+	if (cfg->int_escan_map || cfg->scan_request) {
+		iphy_err(cfg->pub, "ESCAN Request timed out\n");
+		inff_inform_bss(cfg);
+		inff_notify_escan_complete(cfg, cfg->escan_info.ifp, true, true);
+	}
+}
+
+int inff_init_escan(struct inff_cfg80211_info *cfg)
+{
+	cfg->scan_request = NULL;
+
+	cfg->escan_info.escan_buf = kzalloc(INFF_ESCAN_BUF_SIZE, GFP_KERNEL);
+	if (!cfg->escan_info.escan_buf)
+		return -ENOMEM;
+
+	inff_fwevt_register(cfg->pub, INFF_E_ESCAN_RESULT,
+			    inff_cfg80211_escan_handler);
+	cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+
+	/* Init scan timeout delayed work */
+	wiphy_delayed_work_init(&cfg->escan_timeout_work,
+				inff_cfg80211_escan_timeout_worker);
+
+	return 0;
+}
+
+void inff_deinit_escan(struct inff_cfg80211_info *cfg)
+{
+	kfree(cfg->escan_info.escan_buf);
+	cfg->escan_info.escan_buf = NULL;
+
+	inff_abort_scanning(cfg);
+
+	wiphy_delayed_work_cancel(cfg->wiphy, &cfg->escan_timeout_work);
+}
+
+void inff_scan_params_v2_to_v1(struct inff_scan_params_v2_le *params_v2_le,
+			       struct inff_scan_params_le *params_le)
+{
+	size_t params_size;
+	u32 ch;
+	int n_channels, n_ssids;
+
+	memcpy(&params_le->ssid_le, &params_v2_le->ssid_le,
+	       sizeof(params_le->ssid_le));
+	memcpy(&params_le->bssid, &params_v2_le->bssid,
+	       sizeof(params_le->bssid));
+
+	params_le->bss_type = params_v2_le->bss_type;
+	params_le->scan_type = le32_to_cpu(params_v2_le->scan_type);
+	params_le->nprobes = params_v2_le->nprobes;
+	params_le->active_time = params_v2_le->active_time;
+	params_le->passive_time = params_v2_le->passive_time;
+	params_le->home_time = params_v2_le->home_time;
+	params_le->channel_num = params_v2_le->channel_num;
+
+	ch = le32_to_cpu(params_v2_le->channel_num);
+	n_channels = ch & INFF_SCAN_PARAMS_COUNT_MASK;
+	n_ssids = ch >> INFF_SCAN_PARAMS_NSSID_SHIFT;
+
+	params_size = sizeof(u16) * n_channels;
+	if (n_ssids > 0) {
+		params_size = roundup(params_size, sizeof(u32));
+		params_size += sizeof(struct inff_ssid_le) * n_ssids;
+	}
+
+	memcpy(&params_le->channel_list[0],
+	       &params_v2_le->channel_list[0], params_size);
+}
+
+void inff_scan_config_mpc(struct inff_if *ifp, int mpc)
+{
+	if (inff_feat_is_quirk_enabled(ifp, INFF_FEAT_QUIRK_NEED_MPC))
+		inff_set_mpc(ifp, mpc);
+}
+
+s32 inff_notify_escan_complete(struct inff_cfg80211_info *cfg,
+			       struct inff_if *ifp, bool aborted,
+				bool fw_abort)
+{
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_scan_params_v2_le params_v2_le;
+	struct cfg80211_scan_request *scan_request;
+	s32 err = 0;
+
+	/* clear scan request, because the FW abort can cause a second call */
+	/* to this functon and might cause a double cfg80211_scan_done      */
+	scan_request = cfg->scan_request;
+	cfg->scan_request = NULL;
+
+	wiphy_delayed_work_cancel(cfg->wiphy, &cfg->escan_timeout_work);
+
+	if (fw_abort) {
+		/* Do a scan abort to stop the driver's scan engine */
+		inff_dbg(SCAN, "ABORT scan in firmware\n");
+
+		inff_escan_prep(cfg, &params_v2_le, NULL);
+
+		/* E-Scan (or anyother type) can be aborted by SCAN */
+		if (inff_feat_is_enabled(ifp, INFF_FEAT_SCAN_V2)) {
+			err = inff_fwcmd_data_set(ifp, INFF_C_SCAN,
+						  &params_v2_le,
+						  sizeof(params_v2_le));
+		} else {
+			struct inff_scan_params_le params_le;
+
+			inff_scan_params_v2_to_v1(&params_v2_le, &params_le);
+			err = inff_fwcmd_data_set(ifp, INFF_C_SCAN,
+						  &params_le,
+						  sizeof(params_le));
+		}
+
+		if (err)
+			iphy_err(drvr, "Scan abort failed\n");
+	}
+
+	inff_scan_config_mpc(ifp, 1);
+
+	if (scan_request) {
+		struct cfg80211_scan_info info = {
+			.aborted = aborted,
+		};
+
+		inff_dbg(SCAN, "ESCAN Completed scan: %s\n",
+			 aborted ? "Aborted" : "Done");
+		cfg80211_scan_done(scan_request, &info);
+	}
+	if (!test_and_clear_bit(INFF_SCAN_STATUS_BUSY, &cfg->scan_status))
+		inff_dbg(SCAN, "Scan complete\n");
+
+	return err;
+}
diff --git a/drivers/net/wireless/infineon/inffmac/scan.h b/drivers/net/wireless/infineon/inffmac/scan.h
new file mode 100644
index 000000000000..2303a959ea1c
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/scan.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_SCAN_H
+#define INFF_SCAN_H
+
+#define INFF_SCAN_IE_LEN_MAX            2048
+
+#define INFF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS             320
+#define INFF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS            400
+#define INFF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS_6E          80
+#define INFF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS_6E 130
+#define INFF_SCAN_JOIN_PROBE_INTERVAL_MS        20
+
+#define INFF_SCAN_CHANNEL_TIME          40
+#define INFF_SCAN_UNASSOC_TIME          40
+#define INFF_SCAN_PASSIVE_TIME          120
+
+/* Keep SCAN_BUF_SIZE below 64K (65536). Allocing over 64K can be
+ * problematic on some systems and should be avoided.
+ */
+#define INFF_SCAN_BUF_SIZE		65000
+#define INFF_ESCAN_BUF_SIZE		65000
+#define INFF_ESCAN_TIMER_INTERVAL_MS	10000	/* E-Scan timeout */
+
+#define WL_ESCAN_ACTION_START		1
+#define WL_ESCAN_ACTION_CONTINUE	2
+#define WL_ESCAN_ACTION_ABORT		3
+
+/**
+ * enum inff_scan_status - scan engine status
+ *
+ * @INFF_SCAN_STATUS_BUSY: scanning in progress on dongle.
+ * @INFF_SCAN_STATUS_ABORT: scan being aborted on dongle.
+ * @INFF_SCAN_STATUS_SUPPRESS: scanning is suppressed in driver.
+ */
+enum inff_scan_status {
+	INFF_SCAN_STATUS_BUSY,
+	INFF_SCAN_STATUS_ABORT,
+	INFF_SCAN_STATUS_SUPPRESS,
+};
+
+/* dongle escan state */
+enum wl_escan_state {
+	WL_ESCAN_STATE_IDLE,
+	WL_ESCAN_STATE_SCANNING
+};
+
+/**
+ * BSS info structure
+ * Applications MUST CHECK ie_offset field and length field to access IEs and
+ * next bss_info structure in a vector (in struct inff_scan_results)
+ */
+struct inff_cp_bss_info {
+	/* byte length of data in this record, starting at version and including IEs */
+	u32    length;
+	/* SSID length */
+	u8     ssid_length;
+	/* SSID of the access point */
+	char   ssid[IEEE80211_MAX_SSID_LEN + 1];
+	/* MAC Address of the access point */
+	u8     macaddr[ETH_ALEN];
+	/* signal strength */
+	s16    signal_strength;
+	/* channel number */
+	u8     channel;
+	/* WiFi band of access point */
+	u8     band;
+	/* Interval b/w two consecutive beacon frames. Units are Kusec */
+	u16    beacon_period;
+	/* Capability information */
+	u16    capability;
+	/* Length of the IE.  */
+	u32    ie_len;
+};
+
+struct inff_scan_info {
+	struct wiphy *wiphy;
+	struct cfg80211_scan_request *request;
+	u32 bss_count;
+	u8 *bss_buf;
+	u32 used_buf_len;
+};
+
+struct escan_info {
+	u32 escan_state;
+	u8 *escan_buf;
+	struct wiphy *wiphy;
+	struct inff_if *ifp;
+	s32 (*run)(struct inff_cfg80211_info *cfg, struct inff_if *ifp,
+		   struct cfg80211_scan_request *request);
+};
+
+s32 inff_dongle_scantime(struct inff_if *ifp);
+
+s32 inff_run_escan(struct inff_cfg80211_info *cfg, struct inff_if *ifp,
+		   struct cfg80211_scan_request *request);
+
+s32 inff_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request);
+
+void inff_escan_prep(struct inff_cfg80211_info *cfg,
+		     struct inff_scan_params_v2_le *params_le,
+		     struct cfg80211_scan_request *request);
+
+int inff_init_escan(struct inff_cfg80211_info *cfg);
+void inff_deinit_escan(struct inff_cfg80211_info *cfg);
+
+int inff_cfg80211_sched_scan_stop(struct wiphy *wiphy,
+				  struct net_device *ndev, u64 reqid);
+
+int inff_cfg80211_sched_scan_start(struct wiphy *wiphy,
+				   struct net_device *ndev,
+				   struct cfg80211_sched_scan_request *req);
+
+void inff_scan_params_v2_to_v1(struct inff_scan_params_v2_le *params_v2_le,
+			       struct inff_scan_params_le *params_le);
+
+s32 inff_notify_escan_complete(struct inff_cfg80211_info *cfg,
+			       struct inff_if *ifp, bool aborted,
+			       bool fw_abort);
+void inff_scan_config_mpc(struct inff_if *ifp, int mpc);
+void inff_abort_scanning(struct inff_cfg80211_info *cfg);
+
+int
+inff_cp_scan_init(struct inff_cfg80211_info *cfg);
+int
+inff_cp_scan_start(struct inff_cfg80211_info *cfg, struct cfg80211_scan_request *request);
+int
+inff_cp_scan_event_handler(struct inff_pub *drvr, struct inff_cpevt_scan *result);
+void inff_cp_scan_abort(struct inff_pub *drvr);
+#endif /* INFF_SCAN_H */
-- 
2.43.0

