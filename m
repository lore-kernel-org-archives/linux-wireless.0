Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCAF4AA009
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368034; cv=none; b=sNblnOJCAYYY72Kmn32uqEi2yYdTIhDC06Cci1V7N4QrxifkGCN/jOCc3fDoE5ID8YBZRex2IrYRPFWm0WvIJrPZF9m7YDuHXcwLYVQ9b5xoX5FS+h9KjBpYATMSsDX7jO7TkXzqJ3FYzh6BTPm+cfnTpqN0m1F6fjSx3cCTFUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368034; c=relaxed/simple;
	bh=g+5UZdJWNOp2zu69WhkpNKmhHEb7kuzrAYV8IoZScAo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oCr6RLBH5FPRP6G6idu8txjTBYagsYgKkKAQ/iqpV+4DGzF/2Yw1RBtLVfP/qVB9T1MSYdgdcRJZAL6QONpd5AfViqc4wXogWh6L8LJG43TSeyvEcnCVqWhcV7N7Aw+5BJFlTOa2DtA4tdaLITPQThDbbGCnjZHE6WhqZCkfl2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=WQSNAMka; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="WQSNAMka"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368030; x=1819904030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g+5UZdJWNOp2zu69WhkpNKmhHEb7kuzrAYV8IoZScAo=;
  b=WQSNAMkaoUmmpfn74aKCO6iN3J3xRpSfbU3aXj2HVY6tidJX9haNoeGC
   m9jw4leewb9ZIMg2Qgqo1gteJoTIaahCI91MhnRtjERBLKveqtbZVuH68
   QprX02yqz3cWE8IbFBfMFyWuT4rjdbsOog+R/943qj7117D96FZduQZs3
   I=;
X-CSE-ConnectionGUID: maZIvzF8TuKx1HIF1UDrCQ==
X-CSE-MsgGUID: 25Q3BKHMTc24MKPqSFDjqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="176356955"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="176356955"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:53:48 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:53:47 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:53:45 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 12/25] wifi: inffmac: add cfg80211.c/h
Date: Wed, 2 Sep 2026 16:50:43 +0000
Message-ID: <20260902165057.456447-13-gokulkumar.sivakumar@infineon.com>
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
X-ClientProxiedBy: MUCSE816.infineon.com (172.23.29.42) To
 MUCSE827.infineon.com (172.23.29.20)

Integrate the driver with cfg80211 subsystem. Also define the cfg80211 ops
and driver functions that utilize the cfg80211 callbacks for notifications.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/cfg80211.c  | 1418 +++++++++++++++++
 .../net/wireless/infineon/inffmac/cfg80211.h  |  309 ++++
 2 files changed, 1727 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/cfg80211.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/cfg80211.h

diff --git a/drivers/net/wireless/infineon/inffmac/cfg80211.c b/drivers/net/wireless/infineon/inffmac/cfg80211.c
new file mode 100644
index 000000000000..9ded62905970
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/cfg80211.c
@@ -0,0 +1,1418 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+#include <net/cfg80211.h>
+#include <net/netlink.h>
+
+#include "main.h"
+#include "chip.h"
+#include "net.h"
+#include "cfg80211.h"
+#include "utils.h"
+#include "debug.h"
+#include "bus_proto.h"
+#include "dev_cmd.h"
+#include "interface.h"
+#include "fwsignal.h"
+#include "feature.h"
+#include "he.h"
+
+#define INFF_ASSOC_PARAMS_FIXED_SIZE \
+	(sizeof(struct inff_assoc_params_le) - sizeof(u16))
+
+/* This is to override regulatory domains defined in cfg80211 module (reg.c)
+ * By default world regulatory domain defined in reg.c puts the flags
+ * NL80211_RRF_NO_IR for 5GHz channels (for * 36..48 and 149..165).
+ * With respect to these flags, All the changes in world regulatory
+ * domain are to be done here.
+ */
+static const struct ieee80211_regdomain inff_regdom = {
+	.n_reg_rules = 5,
+	.alpha2 =  "99",
+	.reg_rules = {
+		/* IEEE 802.11b/g, channels 1..11 */
+		REG_RULE(2412 - 10, 2472 + 10, 40, 6, 20, 0),
+		/* If any */
+		/* IEEE 802.11 channel 14 - Only JP enables
+		 * this and for 802.11b only
+		 */
+		REG_RULE(2484 - 10, 2484 + 10, 20, 6, 20, 0),
+		/* IEEE 802.11a, channel 36..64 */
+		REG_RULE(5150 - 10, 5350 + 10, 160, 6, 20, 0),
+		/* IEEE 802.11a, channel 100..165 */
+		REG_RULE(5470 - 10, 5850 + 10, 160, 6, 20, 0),
+		/* IEEE 802.11ax, 6E */
+		REG_RULE(5935 - 10, 7115 + 10, 160, 6, 20, 0),
+	}
+};
+
+s32
+inff_inform_single_bss(struct inff_cfg80211_info *cfg,
+		       struct inff_bss_info_le *bi)
+{
+	struct wiphy *wiphy = cfg->wiphy;
+	struct inff_pub *drvr = cfg->pub;
+	struct cfg80211_bss *bss;
+	enum nl80211_band band;
+	struct inff_chan ch;
+	u16 channel;
+	u32 freq;
+	u16 notify_capability;
+	u16 notify_interval;
+	u8 *notify_ie;
+	size_t notify_ielen;
+	struct cfg80211_inform_bss bss_data = {};
+	const struct inff_tlv *ssid = NULL;
+
+	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
+		iphy_err(drvr, "Bss info is larger than buffer. Discarding\n");
+		return -EINVAL;
+	}
+
+	ch.chspec = le16_to_cpu(bi->chanspec);
+	inff_chan_decchspec(&ch);
+
+	if (!bi->ctl_ch)
+		bi->ctl_ch = ch.control_ch_num;
+
+	channel = bi->ctl_ch;
+	band = inff_chan_band_to_nl80211(ch.band);
+
+	freq = ieee80211_channel_to_frequency(channel, band);
+	if (!freq)
+		return -EINVAL;
+
+	bss_data.chan = ieee80211_get_channel(wiphy, freq);
+	if (!bss_data.chan)
+		return -EINVAL;
+
+	bss_data.boottime_ns = ktime_to_ns(ktime_get_boottime());
+
+	notify_capability = le16_to_cpu(bi->capability);
+	notify_interval = le16_to_cpu(bi->beacon_period);
+	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
+	notify_ielen = le32_to_cpu(bi->ie_length);
+	bss_data.signal = (s16)le16_to_cpu(bi->RSSI) * 100;
+
+	ssid = inff_parse_tlvs(notify_ie, notify_ielen, WLAN_EID_SSID);
+	if (ssid && ssid->data[0] == '\0' && ssid->len == bi->SSID_len) {
+		/* Update SSID for hidden AP */
+		memcpy((u8 *)ssid->data, bi->SSID, bi->SSID_len);
+	}
+
+	inff_dbg(CONN, "bssid: %pM\n", bi->BSSID);
+	inff_dbg(CONN, "Channel: %d(%d)\n", channel, freq);
+	inff_dbg(CONN, "Capability: %X\n", notify_capability);
+	inff_dbg(CONN, "Beacon interval: %d\n", notify_interval);
+	inff_dbg(CONN, "Signal: %d\n", bss_data.signal);
+
+	bss = cfg80211_inform_bss_data(wiphy, &bss_data,
+				       CFG80211_BSS_FTYPE_PRESP,
+				       (const u8 *)bi->BSSID,
+				       0, notify_capability,
+				       notify_interval, notify_ie,
+				       notify_ielen, GFP_KERNEL);
+
+	if (!bss)
+		return -ENOMEM;
+
+	cfg80211_put_bss(wiphy, bss);
+
+	return 0;
+}
+
+static struct inff_bss_info_le *
+next_bss_le(struct inff_scan_results *list, struct inff_bss_info_le *bss)
+{
+	if (!bss)
+		return list->bss_info_le;
+	return (struct inff_bss_info_le *)((unsigned long)bss +
+					    le32_to_cpu(bss->length));
+}
+
+s32
+inff_inform_bss(struct inff_cfg80211_info *cfg)
+{
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_scan_results *bss_list;
+	struct inff_bss_info_le *bi = NULL;     /* must be initialized */
+	s32 err = 0;
+	int i;
+
+	bss_list = (struct inff_scan_results *)cfg->escan_info.escan_buf;
+	if (bss_list->count != 0 &&
+	    (bss_list->version != INFF_BSS_INFO_VER_109 &&
+	     bss_list->version != INFF_BSS_INFO_VER_110)) {
+		iphy_err(drvr, "invalid version %d\n",
+			 bss_list->version);
+		return -EOPNOTSUPP;
+	}
+
+	inff_dbg(SCAN, "scanned AP count (%d)\n", bss_list->count);
+	for (i = 0; i < bss_list->count; i++) {
+		bi = next_bss_le(bss_list, bi);
+		err = inff_inform_single_bss(cfg, bi);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+s32
+inff_compare_update_same_bss(struct inff_cfg80211_info *cfg,
+			     struct inff_bss_info_le *bss,
+			      struct inff_bss_info_le *bss_info_le)
+{
+	struct inff_chan ch_bss, ch_bss_info_le;
+
+	ch_bss.chspec = le16_to_cpu(bss->chanspec);
+	inff_chan_decchspec(&ch_bss);
+	ch_bss_info_le.chspec = le16_to_cpu(bss_info_le->chanspec);
+	inff_chan_decchspec(&ch_bss_info_le);
+
+	if (!memcmp(&bss_info_le->BSSID, &bss->BSSID, ETH_ALEN) &&
+	    ch_bss.band == ch_bss_info_le.band &&
+	    bss_info_le->SSID_len == bss->SSID_len &&
+	    !memcmp(bss_info_le->SSID, bss->SSID, bss_info_le->SSID_len)) {
+		if ((bss->flags & INFF_BSS_RSSI_ON_CHANNEL) ==
+			(bss_info_le->flags & INFF_BSS_RSSI_ON_CHANNEL)) {
+			s16 bss_rssi = le16_to_cpu(bss->RSSI);
+			s16 bss_info_rssi = le16_to_cpu(bss_info_le->RSSI);
+
+			/* preserve max RSSI if the measurements are
+			 * both on-channel or both off-channel
+			 */
+			if (bss_info_rssi > bss_rssi)
+				bss->RSSI = bss_info_le->RSSI;
+		} else if ((bss->flags & INFF_BSS_RSSI_ON_CHANNEL) &&
+			(bss_info_le->flags & INFF_BSS_RSSI_ON_CHANNEL) == 0) {
+			/* preserve the on-channel rssi measurement
+			 * if the new measurement is off channel
+			 */
+			bss->RSSI = bss_info_le->RSSI;
+			bss->flags |= INFF_BSS_RSSI_ON_CHANNEL;
+		}
+		return 1;
+	}
+	return 0;
+}
+
+void
+inff_set_mpc(struct inff_if *ifp, int mpc)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err = 0;
+
+	ifp->drvr->req_mpc = mpc;
+	if (inff_check_vif_up(ifp->vif)) {
+		err = inff_fwcmd_iovar_int_set(ifp, "mpc",
+					       ifp->drvr->req_mpc);
+		if (err) {
+			iphy_err(drvr, "fail to set mpc\n");
+			return;
+		}
+		inff_dbg(INFO, "MPC : %d\n", mpc);
+	}
+}
+
+static void
+inff_ht_update_wiphy_cap(struct inff_if *ifp,
+			 u32 bw_cap[2], u32 nchain)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
+	struct ieee80211_supported_band *band;
+	u32 nmode = 0, sgi_rx = 1;
+	int i = 0;
+
+	/* HT mode */
+	if (inff_fwcmd_iovar_int_get(ifp, "nmode", &nmode))
+		iphy_err(drvr, "nmode error\n");
+
+	if (!nmode)
+		return;
+
+	inff_dbg(INFO, "HT Enabled\n");
+
+	if (inff_fwcmd_iovar_int_get(ifp, "sgi_rx", &sgi_rx))
+		iphy_err(drvr, "sgi_rx error\n");
+
+	/* Update HT Capab for each Band */
+	for (i = 0; i < ARRAY_SIZE(wiphy->bands); i++) {
+		band = wiphy->bands[i];
+		if (!band)
+			continue;
+
+		switch (band->band) {
+		case NL80211_BAND_6GHZ:
+			break;
+
+		case NL80211_BAND_5GHZ:
+			/* Band 5GHz supports HT, so */
+			fallthrough;
+
+		case NL80211_BAND_2GHZ:
+			/* Band 2GHz supports HT */
+			band->ht_cap.ht_supported = true;
+
+			/* Bit 0 represents HT SGI 20MHz */
+			if ((sgi_rx & BIT(0)) &&
+			    (bw_cap[band->band] & WLC_BW_20MHZ_BIT))
+				band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+
+			/* Bit 1 represents HT SGI 40MHz */
+			if ((sgi_rx & BIT(1)) &&
+			    (bw_cap[band->band] & WLC_BW_40MHZ_BIT)) {
+				band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+				band->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			}
+
+			band->ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
+			band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+			band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
+			memset(band->ht_cap.mcs.rx_mask, 0xff, nchain);
+			band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
+static __le16
+inff_vht_get_mcs_map(u32 nchain, enum ieee80211_vht_mcs_support supp)
+{
+	u16 mcs_map;
+	int i;
+
+	for (i = 0, mcs_map = 0xFFFF; i < nchain; i++)
+		mcs_map = (mcs_map << 2) | supp;
+
+	return cpu_to_le16(mcs_map);
+}
+
+static void
+inff_vht_update_wiphy_cap(struct inff_if *ifp,
+			  u32 bw_cap[2], u32 nchain)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
+	struct ieee80211_supported_band *band;
+	u32 vhtmode = 0;
+	u32 txstreams = 0;
+	u32 txbf_bfe_cap = 0;
+	u32 txbf_bfr_cap = 0;
+	__le16 mcs_map;
+	int i = 0;
+
+	/* VHT mode */
+	if (inff_fwcmd_iovar_int_get(ifp, "vhtmode", &vhtmode))
+		iphy_err(drvr, "vhtmode error\n");
+
+	if (!vhtmode)
+		return;
+
+	inff_dbg(INFO, "VHT Enabled\n");
+
+	/* Create a MAP with MCS for each Stream */
+	mcs_map = inff_vht_get_mcs_map(nchain, IEEE80211_VHT_MCS_SUPPORT_0_9);
+
+	if (inff_fwcmd_iovar_int_get(ifp, "txstreams", &txstreams))
+		iphy_err(drvr, "txstreams error\n");
+
+	/* Beamforming support information */
+	if (inff_fwcmd_iovar_int_get(ifp, "txbf_bfe_cap", &txbf_bfe_cap))
+		iphy_err(drvr, "txbf_bfe_cap error\n");
+	if (inff_fwcmd_iovar_int_get(ifp, "txbf_bfr_cap", &txbf_bfr_cap))
+		iphy_err(drvr, "txbf_bfw_cap error\n");
+
+	/* Update VHT Capab for each Band */
+	for (i = 0; i < ARRAY_SIZE(wiphy->bands); i++) {
+		band = wiphy->bands[i];
+		if (!band)
+			continue;
+
+		switch (band->band) {
+		case NL80211_BAND_6GHZ:
+			break;
+
+		case NL80211_BAND_5GHZ:
+			/* Band 5GHz supports VHT */
+			band->vht_cap.vht_supported = true;
+			band->vht_cap.vht_mcs.rx_mcs_map = mcs_map;
+			band->vht_cap.vht_mcs.tx_mcs_map = mcs_map;
+
+			if (bw_cap[band->band] & WLC_BW_80MHZ_BIT)
+				band->vht_cap.cap |= IEEE80211_VHT_CAP_SHORT_GI_80;
+
+			if (txbf_bfe_cap & INFF_TXBF_SU_BFE_CAP)
+				band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+			if (txbf_bfe_cap & INFF_TXBF_MU_BFE_CAP)
+				band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+			if (txbf_bfr_cap & INFF_TXBF_SU_BFR_CAP)
+				band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
+			if (txbf_bfr_cap & INFF_TXBF_MU_BFR_CAP)
+				band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
+
+			if ((txbf_bfe_cap || txbf_bfr_cap) && txstreams > 1) {
+				band->vht_cap.cap |=
+					(2 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
+				band->vht_cap.cap |= ((txstreams - 1) <<
+						IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT);
+				band->vht_cap.cap |=
+					IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB;
+			}
+			break;
+
+		case NL80211_BAND_2GHZ:
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
+static int
+inff_setup_wiphybands(struct inff_cfg80211_info *cfg)
+{
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_if *ifp = inff_get_ifp(drvr, 0);
+	u32 rxchain = 0, nchain = 1;
+	u32 bw_cap[4] = { WLC_BW_20MHZ_BIT,  /* 2GHz  */
+			  WLC_BW_20MHZ_BIT,  /* 5GHz  */
+			  0,                 /* 60GHz */
+			  0 };		     /* 6GHz  */
+	int err;
+
+	inff_nl80211_chan_get_bwcap(ifp, bw_cap);
+	inff_dbg(INFO, "bw_cap=[2G(%d), 5G(%d), 6G(%d)]\n",
+		 bw_cap[NL80211_BAND_2GHZ], bw_cap[NL80211_BAND_5GHZ],
+		 bw_cap[NL80211_BAND_6GHZ]);
+
+	err = inff_fwcmd_iovar_int_get(ifp, "rxchain", &rxchain);
+	if (err)
+		iphy_err(drvr, "rxchain error (%d)\n", err);
+	else
+		for (nchain = 0; rxchain; nchain++)
+			rxchain = rxchain & (rxchain - 1);
+	inff_dbg(INFO, "nchain=%d\n", nchain);
+
+	err = inff_nl80211_chan_populate(cfg, bw_cap);
+	if (err) {
+		iphy_err(drvr, "inff_construct_chaninfo failed (%d)\n", err);
+		return err;
+	}
+
+	/* HT Capability Registration */
+	inff_ht_update_wiphy_cap(ifp, bw_cap, nchain);
+
+	/* VHT Capability Registration */
+	inff_vht_update_wiphy_cap(ifp, bw_cap, nchain);
+
+	/* HE Capability Registration */
+	inff_he_update_wiphy_cap(ifp);
+
+	return 0;
+}
+
+void
+inff_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
+{
+	struct inff_cfg80211_vif *vif;
+	struct inff_if *ifp;
+
+	vif = container_of(wdev, struct inff_cfg80211_vif, wdev);
+	ifp = vif->ifp;
+
+	if (wdev->iftype == NL80211_IFTYPE_AP)
+		inff_proto_configure_addr_mode(ifp->drvr, ifp->ifidx,
+					       ADDR_DIRECT);
+	else
+		inff_proto_configure_addr_mode(ifp->drvr, ifp->ifidx,
+					       ADDR_INDIRECT);
+}
+
+/**
+ * inff_ieee80211_is_dpp_pub_action() - true if dpp public type frame.
+ *
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Determine if action frame is dpp public action type
+ */
+bool
+inff_ieee80211_is_dpp_pub_action(void *frame, u32 frame_len)
+{
+	struct inff_pub_act_frame *pact_frm;
+
+	if (!frame)
+		return false;
+
+	pact_frm = (struct inff_pub_act_frame *)frame;
+	if (frame_len < sizeof(struct inff_pub_act_frame) - 1)
+		return false;
+
+	if (pact_frm->category == WLAN_CATEGORY_PUBLIC &&
+	    pact_frm->action == WLAN_PUB_ACTION_VENDOR_SPECIFIC &&
+	    pact_frm->oui_type == WLAN_OUI_TYPE_WFA_DPP &&
+	    memcmp(pact_frm->oui, WFA_OUI, TLV_OUI_LEN) == 0)
+		return true;
+
+	return false;
+}
+
+/**
+ * inff_ieee80211_is_gas_pub_action() - true if gas public type frame.
+ *
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Determine if action frame is gas public action type
+ */
+bool
+inff_ieee80211_is_gas_pub_action(void *frame, u32 frame_len)
+{
+	struct inff_gas_pub_act_frame *act_frm;
+
+	if (!frame)
+		return false;
+
+	act_frm = (struct inff_gas_pub_act_frame *)frame;
+	if (frame_len < sizeof(*act_frm))
+		return false;
+
+	if (act_frm->category != WLAN_CATEGORY_PUBLIC)
+		return false;
+
+	if (act_frm->action == WLAN_PUB_ACTION_GAS_INITIAL_REQ ||
+	    act_frm->action == WLAN_PUB_ACTION_GAS_INITIAL_RESP ||
+	    act_frm->action == WLAN_PUB_ACTION_GAS_COMEBACK_REQ ||
+	    act_frm->action == WLAN_PUB_ACTION_GAS_COMEBACK_RESP)
+		return true;
+
+	return false;
+}
+
+/**
+ * inff_print_action_frame() - WLAN Action frame type print function.
+ *
+ * @tx: Received or to be transmitted
+ * @frame: action frame data.
+ * @frame_len: length of action frame data.
+ *
+ * Print information about the action frame
+ */
+void inff_print_action_frame(bool tx, void *frame, u32 frame_len)
+{
+	struct inff_gas_pub_act_frame *gas_pub_act_frm;
+
+	if (!frame || frame_len <= 2)
+		return;
+
+	if (inff_ieee80211_is_gas_pub_action(frame, frame_len)) {
+		gas_pub_act_frm = (struct inff_gas_pub_act_frame *)frame;
+		switch (gas_pub_act_frm->action) {
+		case WLAN_PUB_ACTION_GAS_INITIAL_REQ:
+			inff_dbg(TRACE, "%s Public Action GAS Initial Request\n",
+				 (tx) ? "TX" : "RX");
+			break;
+		case WLAN_PUB_ACTION_GAS_INITIAL_RESP:
+			inff_dbg(TRACE, "%s Public Action GAS Initial Response\n",
+				 (tx) ? "TX" : "RX");
+			break;
+		case WLAN_PUB_ACTION_GAS_COMEBACK_REQ:
+			inff_dbg(TRACE, "%s Public Action GAS Comeback Request\n",
+				 (tx) ? "TX" : "RX");
+			break;
+		case WLAN_PUB_ACTION_GAS_COMEBACK_RESP:
+			inff_dbg(TRACE, "%s Public Action GAS Comeback Response\n",
+				 (tx) ? "TX" : "RX");
+			break;
+		default:
+			inff_dbg(TRACE, "%s Unknown Public Action GAS Frame\n",
+				 (tx) ? "TX" : "RX");
+			break;
+		}
+	} else if (inff_ieee80211_is_dpp_pub_action(frame, frame_len)) {
+		inff_dbg(TRACE, "%s Public Action DPP Frame\n",
+			 (tx) ? "TX" : "RX");
+	} else {
+		inff_dbg(TRACE, "%s Unknown Action Frame\n",
+			 (tx) ? "TX" : "RX");
+	}
+}
+
+static s32
+inff_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
+			   enum nl80211_iftype type,
+			   struct vif_params *params)
+{
+	struct inff_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct inff_if *ifp = netdev_priv(ndev);
+	struct inff_cfg80211_vif *vif = ifp->vif;
+	struct inff_pub *drvr = cfg->pub;
+	s32 infra = 0;
+	s32 ap = 0;
+	s32 err = 0;
+
+	inff_dbg(TRACE, "bsscfgidx=%d, type=%d\n", ifp->bsscfgidx,
+		 type);
+
+	err = inff_vif_change_validate(wiphy_to_cfg(wiphy), vif, type);
+	if (err) {
+		iphy_err(drvr, "iface validation failed: err=%d\n", err);
+		return err;
+	}
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+		infra = 1;
+		break;
+	case NL80211_IFTYPE_AP:
+		ap = 1;
+		break;
+	default:
+		err = -EINVAL;
+		goto done;
+	}
+
+	if (!ap) {
+		err = inff_fwcmd_int_set(ifp, INFF_C_SET_INFRA, infra);
+		if (err) {
+			iphy_err(drvr, "WLC_SET_INFRA error (%d)\n", err);
+			err = -EAGAIN;
+			goto done;
+		}
+		inff_dbg(INFO, "IF Type = Infra\n");
+	}
+	ndev->ieee80211_ptr->iftype = type;
+
+	inff_cfg80211_update_proto_addr_mode(&vif->wdev);
+	inff_setup_wiphybands(cfg);
+done:
+	return err;
+}
+
+int
+inff_cfg80211_get_channel(struct wiphy *wiphy,
+			  struct wireless_dev *wdev,
+			  unsigned int link_id,
+			  struct cfg80211_chan_def *chandef)
+{
+	struct inff_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct inff_cfg80211_vif *vif;
+	struct net_device *ndev = wdev->netdev;
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_chan ch;
+	enum nl80211_band band = 0;
+	enum nl80211_chan_width width = 0;
+	u32 chanspec = 0;
+	int freq, err;
+
+	if (!ndev || drvr->bus_if->state != INFF_BUS_UP)
+		return -ENODEV;
+
+	vif = container_of(wdev, struct inff_cfg80211_vif, wdev);
+	if (!inff_check_vif_up(vif))
+		return -EIO;
+
+	err = inff_fwcmd_iovar_int_get(netdev_priv(ndev), "chanspec", &chanspec);
+	if (err) {
+		iphy_err(drvr, "chanspec failed (%d)\n", err);
+		return err;
+	}
+
+	ch.chspec = chanspec;
+	inff_chan_decchspec(&ch);
+	band = inff_chan_band_to_nl80211(ch.band);
+
+	switch (ch.bw) {
+	case INFF_CHAN_BW_80:
+		width = NL80211_CHAN_WIDTH_80;
+		break;
+	case INFF_CHAN_BW_40:
+		width = NL80211_CHAN_WIDTH_40;
+		break;
+	case INFF_CHAN_BW_20:
+		width = NL80211_CHAN_WIDTH_20;
+		break;
+	case INFF_CHAN_BW_80P80:
+		width = NL80211_CHAN_WIDTH_80P80;
+		break;
+	case INFF_CHAN_BW_160:
+		width = NL80211_CHAN_WIDTH_160;
+		break;
+	}
+
+	freq = ieee80211_channel_to_frequency(ch.control_ch_num, band);
+	if (!freq)
+		return -EINVAL;
+	chandef->chan = ieee80211_get_channel(wiphy, freq);
+	if (!chandef->chan)
+		return -EINVAL;
+	chandef->width = width;
+	chandef->center_freq1 = ieee80211_channel_to_frequency(ch.chnum, band);
+	chandef->center_freq2 = 0;
+
+	return 0;
+}
+
+static struct cfg80211_ops inff_cfg80211_ops = {
+	.scan = inff_cfg80211_scan,
+	.get_channel = inff_cfg80211_get_channel,
+};
+
+struct cfg80211_ops *
+inff_cfg80211_get_ops(struct inff_mp_device *settings)
+{
+	struct cfg80211_ops *ops;
+
+	ops = kmemdup(&inff_cfg80211_ops, sizeof(inff_cfg80211_ops),
+		      GFP_KERNEL);
+
+	return ops;
+}
+
+void
+inff_cfg80211_free_netdev_priv(struct net_device *ndev)
+{
+	struct inff_cfg80211_vif *vif;
+	struct inff_if *ifp;
+
+	ifp = netdev_priv(ndev);
+	vif = ifp->vif;
+
+	if (vif) {
+		inff_free_vif(vif);
+		ifp->vif = NULL;
+	}
+}
+
+u8
+inff_map_prio_to_prec(void *config, u8 prio)
+{
+	struct inff_cfg80211_info *cfg = (struct inff_cfg80211_info *)config;
+
+	if (!cfg)
+		return (prio == PRIO_8021D_NONE || prio == PRIO_8021D_BE) ?
+		       (prio ^ 2) : prio;
+
+	/* For those AC(s) with ACM flag set to 1, convert its 4-level priority
+	 * to an 8-level precedence which is the same as BE's
+	 */
+	if (prio > PRIO_8021D_EE &&
+	    cfg->ac_priority[prio] == cfg->ac_priority[PRIO_8021D_BE])
+		return cfg->ac_priority[prio] * 2;
+
+	/* Conversion of 4-level priority to 8-level precedence */
+	if (prio == PRIO_8021D_BE || prio == PRIO_8021D_BK ||
+	    prio == PRIO_8021D_CL || prio == PRIO_8021D_VO)
+		return cfg->ac_priority[prio] * 2;
+	else
+		return cfg->ac_priority[prio] * 2 + 1;
+}
+
+u8
+inff_map_prio_to_aci(void *config, u8 prio)
+{
+	/* Prio here refers to the 802.1d priority in range of 0 to 7.
+	 * ACI here refers to the WLAN AC Index in range of 0 to 3.
+	 * This function will return ACI corresponding to input prio.
+	 */
+	struct inff_cfg80211_info *cfg = (struct inff_cfg80211_info *)config;
+
+	if (cfg)
+		return cfg->ac_priority[prio];
+
+	return prio;
+}
+
+static void
+inff_init_wmm_prio(u8 *priority)
+{
+	/* Initialize AC priority array to default
+	 * 802.1d priority as per following table:
+	 * 802.1d prio 0,3 maps to BE
+	 * 802.1d prio 1,2 maps to BK
+	 * 802.1d prio 4,5 maps to VI
+	 * 802.1d prio 6,7 maps to VO
+	 */
+	priority[0] = INFF_FWS_FIFO_AC_BE;
+	priority[3] = INFF_FWS_FIFO_AC_BE;
+	priority[1] = INFF_FWS_FIFO_AC_BK;
+	priority[2] = INFF_FWS_FIFO_AC_BK;
+	priority[4] = INFF_FWS_FIFO_AC_VI;
+	priority[5] = INFF_FWS_FIFO_AC_VI;
+	priority[6] = INFF_FWS_FIFO_AC_VO;
+	priority[7] = INFF_FWS_FIFO_AC_VO;
+}
+
+void
+inff_wifi_prioritize_acparams(const struct inff_cfg80211_edcf_acparam *acp,
+			      u8 *priority)
+{
+	u8 aci;
+	u8 aifsn;
+	u8 ecwmin;
+	u8 ecwmax;
+	u8 acm;
+	u8 ranking_basis[EDCF_AC_COUNT];
+	u8 aci_prio[EDCF_AC_COUNT]; /* AC_BE, AC_BK, AC_VI, AC_VO */
+	u8 index;
+
+	for (aci = 0; aci < EDCF_AC_COUNT; aci++, acp++) {
+		aifsn  = acp->ACI & EDCF_AIFSN_MASK;
+		acm = (acp->ACI & EDCF_ACM_MASK) ? 1 : 0;
+		ecwmin = acp->ECW & EDCF_ECWMIN_MASK;
+		ecwmax = (acp->ECW & EDCF_ECWMAX_MASK) >> EDCF_ECWMAX_SHIFT;
+		inff_dbg(CONN, "ACI %d aifsn %d acm %d ecwmin %d ecwmax %d\n",
+			 aci, aifsn, acm, ecwmin, ecwmax);
+		/* Default AC_VO will be the lowest ranking value */
+		ranking_basis[aci] = aifsn + ecwmin + ecwmax;
+		/* Initialise priority starting at 0 (AC_BE) */
+		aci_prio[aci] = 0;
+
+		/* If ACM is set, STA can't use this AC as per 802.11.
+		 * Change the ranking to BE
+		 */
+		if (aci != AC_BE && aci != AC_BK && acm == 1)
+			ranking_basis[aci] = ranking_basis[AC_BE];
+	}
+
+	/* Ranking method which works for AC priority
+	 * swapping when values for cwmin, cwmax and aifsn are varied
+	 * Compare each aci_prio against each other aci_prio
+	 */
+	for (aci = 0; aci < EDCF_AC_COUNT; aci++) {
+		for (index = 0; index < EDCF_AC_COUNT; index++) {
+			if (index != aci) {
+				/* Smaller ranking value has higher priority,
+				 * so increment priority for each ACI which has
+				 * a higher ranking value
+				 */
+				if (ranking_basis[aci] < ranking_basis[index])
+					aci_prio[aci]++;
+			}
+		}
+	}
+
+	/* By now, aci_prio[] will be in range of 0 to 3.
+	 * Use ACI prio to get the new priority value for
+	 * each 802.1d traffic type, in this range.
+	 */
+	if (!(aci_prio[AC_BE] == aci_prio[AC_BK] &&
+	      aci_prio[AC_BK] == aci_prio[AC_VI] &&
+	      aci_prio[AC_VI] == aci_prio[AC_VO])) {
+		/* 802.1d 0,3 maps to BE */
+		priority[0] = aci_prio[AC_BE];
+		priority[3] = aci_prio[AC_BE];
+
+		/* 802.1d 1,2 maps to BK */
+		priority[1] = aci_prio[AC_BK];
+		priority[2] = aci_prio[AC_BK];
+
+		/* 802.1d 4,5 maps to VO */
+		priority[4] = aci_prio[AC_VI];
+		priority[5] = aci_prio[AC_VI];
+
+		/* 802.1d 6,7 maps to VO */
+		priority[6] = aci_prio[AC_VO];
+		priority[7] = aci_prio[AC_VO];
+	} else {
+		/* Initialize to default priority */
+		inff_init_wmm_prio(priority);
+	}
+
+	inff_dbg(CONN, "Adj prio BE 0->%d, BK 1->%d, BK 2->%d, BE 3->%d\n",
+		 priority[0], priority[1], priority[2], priority[3]);
+
+	inff_dbg(CONN, "Adj prio VI 4->%d, VI 5->%d, VO 6->%d, VO 7->%d\n",
+		 priority[4], priority[5], priority[6], priority[7]);
+}
+
+static s32
+inff_dongle_roam(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	__le32 roamtrigger[2];
+	__le32 roam_delta[2];
+	__le32 bandlist[4];
+	u32 n_bands;
+	int i;
+
+	/* Use the firmware roaming engine with a conservative beacon timeout */
+	err = inff_fwcmd_iovar_int_set(ifp, "bcn_timeout",
+				       INFF_DEFAULT_BCN_TIMEOUT_ROAM_ON);
+	if (err) {
+		iphy_err(drvr, "bcn_timeout error (%d)\n", err);
+		goto roam_setup_done;
+	}
+
+	err = inff_fwcmd_iovar_int_set(ifp, "roam_off", 0);
+	if (err) {
+		iphy_err(drvr, "roam_off error (%d)\n", err);
+		goto roam_setup_done;
+	}
+
+	err = inff_fwcmd_data_get(ifp, INFF_C_GET_BANDLIST, &bandlist,
+				  sizeof(bandlist));
+	if (err) {
+		iphy_err(drvr, "could not obtain band info: err=%d\n", err);
+		goto roam_setup_done;
+	}
+	/* To enhance compatibility set each band's roam properties instead of
+	 * using all band. BAND_5G is 1, BAND_2G is 2 and BAND_6G is 3.
+	 */
+	n_bands = le32_to_cpu(bandlist[0]);
+	for (i = 1; i <= n_bands; i++) {
+		roamtrigger[0] = cpu_to_le32(WL_ROAM_TRIGGER_LEVEL);
+		roamtrigger[1] = bandlist[i];
+		err = inff_fwcmd_data_set(ifp, INFF_C_SET_ROAM_TRIGGER,
+					  (void *)roamtrigger, sizeof(roamtrigger));
+		if (err)
+			iphy_err(drvr, "WLC_SET_ROAM_TRIGGER error (%d), band %d\n",
+				 err, bandlist[i]);
+
+		roam_delta[0] = cpu_to_le32(WL_ROAM_DELTA);
+		roam_delta[1] = bandlist[i];
+		err = inff_fwcmd_data_set(ifp, INFF_C_SET_ROAM_DELTA,
+					  (void *)roam_delta, sizeof(roam_delta));
+		if (err)
+			iphy_err(drvr, "WLC_SET_ROAM_DELTA error (%d), band %d\n",
+				 err, bandlist[i]);
+	}
+
+	return 0;
+
+roam_setup_done:
+	return err;
+}
+
+s32
+inff_cfg80211_up(struct net_device *ndev)
+{
+	struct inff_if *pri_ifp, *ifp = netdev_priv(ndev);
+	struct inff_cfg80211_info *cfg = ifp->drvr->config;
+	struct inff_pub *drvr = cfg->pub;
+	struct net_device *pri_ndev;
+	struct wireless_dev *pri_wdev;
+	s32 power_mode;
+	s32 err = 0;
+
+	lockdep_assert_held(cfg->wiphy);
+
+	set_bit(INFF_VIF_STATUS_READY, &ifp->vif->sme_state);
+
+	if (cfg->dongle_up ||
+	    inff_socitype_is_cp(drvr->bus_if))
+		goto exit;
+
+	pri_ndev = cfg_to_ndev(cfg);
+	pri_ifp = netdev_priv(pri_ndev);
+
+	/* make sure RF is ready for work */
+	inff_fwcmd_int_set(pri_ifp, INFF_C_UP, 0);
+
+	inff_dongle_scantime(pri_ifp);
+
+	power_mode = cfg->pwr_save ? INFF_PM_FAST : INFF_PM_OFF;
+	err = inff_fwcmd_int_set(pri_ifp, INFF_C_SET_PM, power_mode);
+	if (err)
+		goto exit;
+	inff_dbg(INFO, "power save set to %s\n",
+		 (power_mode ? "enabled" : "disabled"));
+
+	err = inff_dongle_roam(pri_ifp);
+	if (err)
+		goto exit;
+
+	pri_wdev = pri_ndev->ieee80211_ptr;
+	err = inff_cfg80211_change_iface(pri_wdev->wiphy, pri_ndev,
+					 pri_wdev->iftype, NULL);
+	if (err)
+		goto exit;
+
+	err = inff_fwcmd_int_set(pri_ifp, INFF_C_SET_FAKEFRAG, 1);
+	if (err) {
+		iphy_err(drvr, "failed to set frameburst mode\n");
+		goto exit;
+	}
+
+	cfg->dongle_up = true;
+exit:
+	return err;
+}
+
+s32
+inff_cfg80211_down(struct net_device *ndev)
+{
+	struct inff_if *ifp = netdev_priv(ndev);
+	struct inff_cfg80211_info *cfg = ifp->drvr->config;
+
+	lockdep_assert_held(cfg->wiphy);
+
+	/*
+	 * While going down, if associated with AP disassociate
+	 * from AP to save power
+	 */
+	if (inff_check_vif_up(ifp->vif)) {
+		inff_link_down(ifp->vif, WLAN_REASON_UNSPECIFIED, true);
+
+		/* Make sure WPA_Supplicant receives all the event
+		 * generated due to DISASSOC call to the fw to keep
+		 * the state fw and WPA_Supplicant state consistent
+		 */
+		inff_delay(500);
+		cfg->dongle_up = false;
+	}
+
+	inff_abort_scanning(cfg);
+	clear_bit(INFF_VIF_STATUS_READY, &ifp->vif->sme_state);
+
+	return 0;
+}
+
+static const struct ieee80211_txrx_stypes
+inff_txrx_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4) |
+		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+		      BIT(IEEE80211_STYPE_ACTION >> 4)
+	}
+};
+
+static int
+inff_setup_wiphy_params(struct wiphy *wiphy, struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	const struct ieee80211_iface_combination *combo;
+	u16 max_interfaces = 0;
+	int err, i;
+	enum nl80211_band band;
+
+	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
+	wiphy->max_scan_ie_len = INFF_SCAN_IE_LEN_MAX;
+	wiphy->max_num_pmkids = INFF_MAXPMKID;
+
+	err = inff_setup_ifmodes(wiphy, ifp);
+	if (err)
+		return err;
+
+	for (i = 0, combo = wiphy->iface_combinations;
+	     i < wiphy->n_iface_combinations; i++, combo++) {
+		max_interfaces = max(max_interfaces, combo->max_interfaces);
+	}
+
+	for (i = 0; i < max_interfaces && i < ARRAY_SIZE(drvr->addresses);
+	     i++) {
+		u8 *addr = drvr->addresses[i].addr;
+
+		memcpy(addr, drvr->mac, ETH_ALEN);
+		if (i) {
+			addr[0] |= BIT(1);
+			addr[ETH_ALEN - 1] ^= i;
+		}
+	}
+	wiphy->addresses = drvr->addresses;
+	wiphy->n_addresses = i;
+
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	wiphy->bss_select_support = BIT(NL80211_BSS_SELECT_ATTR_RSSI) |
+				    BIT(NL80211_BSS_SELECT_ATTR_BAND_PREF) |
+				    BIT(NL80211_BSS_SELECT_ATTR_RSSI_ADJUST);
+
+	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
+			WIPHY_FLAG_PS_ON_BY_DEFAULT |
+			WIPHY_FLAG_OFFCHAN_TX |
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			WIPHY_FLAG_SPLIT_SCAN_6GHZ;
+
+	wiphy->mgmt_stypes = inff_txrx_stypes;
+	wiphy->max_remain_on_channel_duration = 5000;
+
+	/* first entry in bandlist is number of bands */
+	for (band = 0; band < NUM_NL80211_BANDS; band++)
+		wiphy->bands[band] = NULL;
+
+	wiphy_read_of_freq_limits(wiphy);
+	return 0;
+}
+
+static void
+inff_free_wiphy_params(struct wiphy *wiphy)
+{
+	int i;
+
+	if (!wiphy)
+		return;
+
+	if (wiphy->iface_combinations) {
+		for (i = 0; i < wiphy->n_iface_combinations; i++)
+			kfree(wiphy->iface_combinations[i].limits);
+	}
+	kfree(wiphy->iface_combinations);
+	if (wiphy->bands[NL80211_BAND_2GHZ]) {
+		kfree(wiphy->bands[NL80211_BAND_2GHZ]->channels);
+		kfree(wiphy->bands[NL80211_BAND_2GHZ]);
+	}
+	if (wiphy->bands[NL80211_BAND_5GHZ]) {
+		kfree(wiphy->bands[NL80211_BAND_5GHZ]->channels);
+		kfree(wiphy->bands[NL80211_BAND_5GHZ]);
+	}
+	if (wiphy->bands[NL80211_BAND_6GHZ]) {
+		kfree(wiphy->bands[NL80211_BAND_6GHZ]->channels);
+		kfree(wiphy->bands[NL80211_BAND_6GHZ]);
+	}
+}
+
+int
+inff_alloc_wiphy(struct device *dev, struct inff_mp_device *settings)
+{
+	struct wiphy *wiphy;
+	struct cfg80211_ops *ops;
+	struct inff_pub *drvr = NULL;
+
+	ops = inff_cfg80211_get_ops(settings);
+	if (!ops)
+		return -ENOMEM;
+
+	wiphy = wiphy_new(ops, sizeof(*drvr));
+	if (!wiphy) {
+		kfree(ops);
+		return -ENOMEM;
+	}
+
+	set_wiphy_dev(wiphy, dev);
+	drvr = wiphy_priv(wiphy);
+	drvr->wiphy = wiphy;
+	drvr->ops = ops;
+	drvr->bus_if = dev_get_drvdata(dev);
+	drvr->bus_if->drvr = drvr;
+	drvr->settings = settings;
+
+	return 0;
+}
+
+void
+inff_free_wiphy(struct device *dev)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(dev);
+	struct inff_pub *drvr = bus_if->drvr;
+
+	if (!drvr)
+		return;
+
+	bus_if->drvr = NULL;
+
+	kfree(drvr->ops);
+
+	wiphy_free(drvr->wiphy);
+}
+
+static void
+inff_cfg80211_reg_notifier(struct wiphy *wiphy,
+			   struct regulatory_request *req)
+{
+	struct inff_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct inff_if *ifp = inff_get_ifp(cfg->pub, 0);
+	struct inff_pub *drvr = cfg->pub;
+	struct inff_fwcmd_country_le ccreq;
+	s32 err;
+	int i;
+
+	/* The country code gets set to "00" by default at boot, ignore */
+	if (req->alpha2[0] == '0' && req->alpha2[1] == '0')
+		return;
+
+	/* ignore non-ISO3166 country codes */
+	for (i = 0; i < 2; i++)
+		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
+			iphy_err(drvr, "not an ISO3166 code (0x%02x 0x%02x)\n",
+				 req->alpha2[0], req->alpha2[1]);
+			return;
+		}
+
+	inff_dbg(INFO, "initiator=%d, alpha=%c%c\n", req->initiator,
+		 req->alpha2[0], req->alpha2[1]);
+
+	err = inff_fwcmd_iovar_data_get(ifp, "country", &ccreq, sizeof(ccreq));
+	if (err) {
+		iphy_err(drvr, "Country code iovar returned err = %d\n", err);
+		return;
+	}
+
+	if (req->alpha2[0] == ccreq.country_abbrev[0] &&
+	    req->alpha2[1] == ccreq.country_abbrev[1]) {
+		inff_dbg(INFO, "Country code already set\n");
+		return;
+	}
+
+	inff_dbg(INFO, "For Country code, using ISO3166 code and 0 rev\n");
+	memset(&ccreq, 0, sizeof(ccreq));
+	ccreq.country_abbrev[0] = req->alpha2[0];
+	ccreq.country_abbrev[1] = req->alpha2[1];
+	ccreq.ccode[0] = req->alpha2[0];
+	ccreq.ccode[1] = req->alpha2[1];
+
+	/* Abort on-going scan before changing ccode */
+	inff_abort_scanning(cfg);
+
+	err = inff_fwcmd_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq));
+	if (err) {
+		iphy_err(drvr, "Firmware rejected country setting\n");
+		return;
+	}
+
+	drvr->config->bands_reset_required = true;
+	inff_dbg(TRACE, "Marking bands for reset due to country change\n");
+	err = inff_setup_wiphybands(cfg);
+	if (err)
+		drvr->config->bands_reset_required = false;
+}
+
+struct inff_cfg80211_info *
+inff_cfg80211_attach(struct inff_pub *drvr,
+		     struct cfg80211_ops *ops)
+{
+	struct wiphy *wiphy = drvr->wiphy;
+	struct inff_cfg80211_info *cfg;
+	struct net_device *ndev = NULL;
+	struct inff_cfg80211_vif *vif = NULL;
+	struct inff_if *ifp;
+	struct inff_cfg80211_vif *vif_ap = NULL;
+	struct inff_if *ifp_ap;
+	struct net_device *ndev_ap = NULL;
+	s32 err = 0;
+	u16 *cap = NULL;
+
+	ndev = inff_get_ifp(drvr, INFF_INTERFACE_PRI_IFIDX)->ndev;
+
+	if (!ndev) {
+		iphy_err(drvr, "ndev is invalid\n");
+		return NULL;
+	}
+
+	cfg = kzalloc_obj(*cfg);
+	if (!cfg)
+		return NULL;
+
+	cfg->wiphy = wiphy;
+	cfg->pub = drvr;
+	cfg->pm_state = INFF_CFG80211_PM_STATE_RESUMED;
+	cfg->num_softap = 0;
+	cfg->mchan_conf = INFF_MCHAN_CONF_DEFAULT;
+	cfg->pwr_save = true;
+	cfg->dongle_up = false;		/* dongle is not up yet */
+	cfg->conf.frag_threshold = (u32)-1;
+	cfg->conf.rts_threshold =  (u32)-1;
+	cfg->conf.retry_short = (u32)-1;
+	cfg->conf.retry_long = (u32)-1;
+
+	init_waitqueue_head(&cfg->vif_event.vif_wq);
+	spin_lock_init(&cfg->vif_event.vif_event_lock);
+	INIT_LIST_HEAD(&cfg->vif_list);
+
+	cfg->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
+	if (!cfg->extra_buf)
+		goto cfg_out;
+
+	/* allocate primary vif */
+	vif = inff_alloc_vif(cfg, NL80211_IFTYPE_STATION);
+	if (IS_ERR(vif))
+		goto cfg_extra_buf_out;
+
+	ifp = netdev_priv(ndev);
+	ifp->vif = vif;
+	vif->ifp = ifp;
+	vif->wdev.netdev = ndev;
+	ndev->ieee80211_ptr = &vif->wdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(cfg->wiphy));
+	init_completion(&cfg->vif_disabled);
+
+	if (inff_socitype_is_cp(drvr->bus_if)) {
+		/* allocate vif for SoftAP */
+		vif_ap = inff_alloc_vif(cfg, NL80211_IFTYPE_AP);
+		if (IS_ERR(vif_ap))
+			goto vif_out;
+
+		ndev_ap = inff_get_ifp(drvr, INFF_INTERFACE_SEC_IFIDX)->ndev;
+		ifp_ap = netdev_priv(ndev_ap);
+		ifp_ap->vif = vif_ap;
+		vif_ap->ifp = ifp_ap;
+		vif_ap->wdev.netdev = ndev_ap;
+		ndev_ap->ieee80211_ptr = &vif_ap->wdev;
+		SET_NETDEV_DEV(ndev_ap, wiphy_dev(cfg->wiphy));
+
+		err = inff_cp_scan_init(cfg);
+		if (err) {
+			inff_err("Failed to init the priv (%d)\n", err);
+			kfree(cfg->scan.bss_buf);
+			cfg->scan.bss_buf = NULL;
+			goto vif_ap_out;
+		}
+	} else if (inff_socitype_is_ai(drvr->bus_if)) {
+		inff_fwevt_register_handlers(cfg);
+
+		err = inff_init_escan(cfg);
+		if (err)
+			goto vif_out;
+
+		inff_init_wmm_prio(cfg->ac_priority);
+	}
+
+	/* regulatory notifier below needs access to cfg so
+	 * assign it now.
+	 */
+	drvr->config = cfg;
+
+	err = inff_setup_wiphy_params(wiphy, ifp);
+	if (err < 0)
+		goto scan_out;
+
+	err = inff_setup_wiphybands(cfg);
+	if (err) {
+		iphy_err(drvr, "Setting wiphy bands failed (%d)\n", err);
+		goto wiphy_params_out;
+	}
+
+	inff_dbg(INFO, "Registering custom regulatory\n");
+	wiphy->reg_notifier = inff_cfg80211_reg_notifier;
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_IGNORE;
+	wiphy_apply_custom_regulatory(wiphy, &inff_regdom);
+
+	if (inff_socitype_is_ai(drvr->bus_if)) {
+		/* firmware defaults to 40MHz disabled in 2G band. We signal
+		 * cfg80211 here that we do and have it decide we can enable
+		 * it. But first check if device does support 2G operation.
+		 */
+		if (wiphy->bands[NL80211_BAND_2GHZ]) {
+			cap = &wiphy->bands[NL80211_BAND_2GHZ]->ht_cap.cap;
+			*cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		}
+	}
+
+	err = wiphy_register(wiphy);
+	if (err < 0) {
+		iphy_err(drvr, "Could not register wiphy device (%d)\n", err);
+		goto wiphy_params_out;
+	}
+
+	if (inff_socitype_is_cp(drvr->bus_if))
+		return cfg;
+
+	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
+	 * setup 40MHz in 2GHz band and enable OBSS scanning.
+	 */
+	if (cap && (*cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)) {
+		err = inff_chan_enable_bw40_2g(cfg);
+		if (!err) {
+			err = inff_fwcmd_iovar_int_set(ifp, "obss_coex",
+						       INFF_OBSS_COEX_AUTO);
+			if (err)
+				iphy_err(drvr,
+					 "Failed to configure OBSS coex: (%d)\n",
+					 err);
+		} else {
+			*cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		}
+	}
+
+	/* activate FWEH event handling */
+	err = inff_fwevt_activate_events(ifp);
+	if (err) {
+		iphy_err(drvr, "FWEH activation failed (%d)\n", err);
+		goto wiphy_unreg_out;
+	}
+
+	/* (re-) activate FWEH event handling */
+	err = inff_fwevt_activate_events(ifp);
+	if (err) {
+		iphy_err(drvr, "FWEH activation failed (%d)\n", err);
+		goto wiphy_unreg_out;
+	}
+
+	/* Fill in some of the advertised nl80211 supported features */
+	if (inff_feat_is_enabled(ifp, INFF_FEAT_SCAN_RANDOM_MAC))
+		wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR;
+
+	return cfg;
+
+wiphy_unreg_out:
+	wiphy_unregister(cfg->wiphy);
+wiphy_params_out:
+	inff_free_wiphy_params(wiphy);
+scan_out:
+	if (inff_socitype_is_ai(drvr->bus_if)) {
+		inff_deinit_escan(cfg);
+		kfree(cfg->scan.bss_buf);
+		cfg->scan.bss_buf = NULL;
+	}
+vif_ap_out:
+	/* Free AP vif if it was allocated */
+	if (inff_socitype_is_cp(drvr->bus_if)) {
+		inff_free_vif(vif_ap);
+		if (ifp_ap)
+			ifp_ap->vif = NULL;
+	}
+vif_out:
+	/* Always free primary vif */
+	inff_free_vif(vif);
+	if (ifp)
+		ifp->vif = NULL;
+cfg_extra_buf_out:
+	kfree(cfg->extra_buf);
+	cfg->extra_buf = NULL;
+cfg_out:
+	kfree(cfg);
+	return NULL;
+}
+
+void
+inff_cfg80211_detach(struct inff_cfg80211_info *cfg)
+{
+	if (!cfg)
+		return;
+
+	if (inff_socitype_is_ai(cfg->pub->bus_if))
+		inff_deinit_escan(cfg);
+	else if (inff_socitype_is_cp(cfg->pub->bus_if))
+		inff_cp_scan_abort(cfg->pub->bus_if->drvr);
+
+	wiphy_unregister(cfg->wiphy);
+	cfg->dongle_up = false;	/* dongle down */
+
+	kfree(cfg->scan.bss_buf);
+	cfg->scan.bss_buf = NULL;
+	kfree(cfg->extra_buf);
+	cfg->extra_buf = NULL;
+
+	inff_clear_assoc_ies(cfg);
+	inff_free_wiphy_params(cfg->wiphy);
+
+	kfree(cfg);
+}
diff --git a/drivers/net/wireless/infineon/inffmac/cfg80211.h b/drivers/net/wireless/infineon/inffmac/cfg80211.h
new file mode 100644
index 000000000000..1df540c28cee
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/cfg80211.h
@@ -0,0 +1,309 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_CFG80211_H
+#define INFF_CFG80211_H
+
+#include "main.h"
+#include "dev_cmd.h"
+#include "scan.h"
+#include "ie.h"
+#include "chan.h"
+
+#define WL_NUM_SCAN_MAX			10
+#define WL_TLV_INFO_MAX			1024
+#define WL_BSS_INFO_MAX			2048
+#define WL_ASSOC_INFO_MAX		512	/* assoc related fil max buf */
+#define WL_EXTRA_BUF_MAX		2048
+#define WL_ROAM_TRIGGER_LEVEL		-75
+#define WL_ROAM_DELTA			20
+
+/* WME Access Category Indices (ACIs) */
+#define AC_BE			0	/* Best Effort */
+#define AC_BK			1	/* Background */
+#define AC_VI			2	/* Video */
+#define AC_VO			3	/* Voice */
+
+#define EDCF_AC_COUNT		4
+#define MAX_8021D_PRIO		8
+
+#define EDCF_ACI_MASK			0x60
+#define EDCF_ACI_SHIFT			5
+#define EDCF_ACM_MASK                  0x10
+#define EDCF_ECWMIN_MASK		0x0f
+#define EDCF_ECWMAX_SHIFT		4
+#define EDCF_AIFSN_MASK			0x0f
+#define EDCF_AIFSN_MAX			15
+#define EDCF_ECWMAX_MASK		0xf0
+
+/* beacon loss timeout defaults */
+#define INFF_DEFAULT_BCN_TIMEOUT_ROAM_ON	2
+
+#define INFF_PM_WAIT_MAXRETRY			100
+
+#define WFA_OUI                        "\x50\x6F\x9A"  /* WFA OUI */
+
+/* dongle configuration */
+struct inff_cfg80211_conf {
+	u32 frag_threshold;
+	u32 rts_threshold;
+	u32 retry_short;
+	u32 retry_long;
+};
+
+/* security information with currently associated ap */
+struct inff_cfg80211_security {
+	u32 wpa_versions;
+	u32 auth_type;
+	u32 cipher_pairwise;
+	u32 cipher_group;
+};
+
+enum inff_profile_fwsup {
+	INFF_PROFILE_FWSUP_NONE,
+	INFF_PROFILE_FWSUP_PSK,
+	INFF_PROFILE_FWSUP_1X,
+	INFF_PROFILE_FWSUP_SAE,
+	INFF_PROFILE_FWSUP_ROAM,
+	INFF_PROFILE_FWSUP_CP
+};
+
+/**
+ * enum inff_profile_fwauth - firmware authenticator profile
+ *
+ * @INFF_PROFILE_FWAUTH_NONE: no firmware authenticator
+ * @INFF_PROFILE_FWAUTH_PSK: authenticator for WPA/WPA2-PSK
+ * @INFF_PROFILE_FWAUTH_SAE: authenticator for SAE
+ */
+enum inff_profile_fwauth {
+	INFF_PROFILE_FWAUTH_NONE,
+	INFF_PROFILE_FWAUTH_PSK,
+	INFF_PROFILE_FWAUTH_SAE
+};
+
+enum inff_cfg80211_pm_state {
+	INFF_CFG80211_PM_STATE_RESUMED,
+	INFF_CFG80211_PM_STATE_RESUMING,
+	INFF_CFG80211_PM_STATE_SUSPENDED,
+	INFF_CFG80211_PM_STATE_SUSPENDING,
+};
+
+/**
+ * enum inff_mgmt_tx_status - mgmt frame tx status
+ *
+ * @INFF_MGMT_TX_ACK: mgmt frame acked
+ * @INFF_MGMT_TX_NOACK: mgmt frame not acked
+ * @INFF_MGMT_TX_OFF_CHAN_COMPLETED: off-channel complete
+ * @INFF_MGMT_TX_SEND_FRAME: mgmt frame tx is in progress
+ */
+enum inff_mgmt_tx_status {
+	INFF_MGMT_TX_ACK,
+	INFF_MGMT_TX_NOACK,
+	INFF_MGMT_TX_OFF_CHAN_COMPLETED,
+	INFF_MGMT_TX_SEND_FRAME
+};
+
+/* association inform */
+struct inff_cfg80211_connect_info {
+	u8 *req_ie;
+	s32 req_ie_len;
+	u8 *resp_ie;
+	s32 resp_ie_len;
+};
+
+/* assoc ie length */
+struct inff_cfg80211_assoc_ielen_le {
+	__le32 req_len;
+	__le32 resp_len;
+	__le32 flags;
+};
+
+/* Action Frame Constants */
+#define DOT11_ACTION_HDR_LEN	2	/* action frame category + action */
+#define DOT11_ACTION_CAT_OFF	0	/* category offset */
+#define DOT11_ACTION_ACT_OFF	1	/* action offset */
+
+#define IEEE80211_AF_DWELL_TIME			200
+#define IEEE80211_AF_MIN_DWELL_TIME		100
+#define IEEE80211_AF_MED_DWELL_TIME		400
+#define IEEE80211_AF_LONG_DWELL_TIME		1000
+#define IEEE80211_AF_TX_MAX_RETRY		5
+#define IEEE80211_AF_MAX_WAIT_TIME		msecs_to_jiffies(2000)
+
+/**
+ * struct inff_pub_act_frame - WLAN MGMT Public Action Frame
+ *
+ * @category: Category Code
+ * @action: Action Code
+ * @oui: Action frame OUI
+ * @oui_type: Action frame OUI type
+ * @subtype: Action frame subtype
+ * @dialog_token: nonzero, identifies req/rsp transaction
+ * @elts: Variable length information elements
+ */
+struct inff_pub_act_frame {
+	u8	category;
+	u8	action;
+	u8	oui[3];
+	u8	oui_type;
+	u8	subtype;
+	u8	dialog_token;
+	u8	elts[];
+};
+
+/**
+ * struct inff_gas_pub_act_frame - WLAN MGMT GAS Public Action Frame
+ *
+ * @category: 0x04 Public Action Frame
+ * @action: 0x6c Advertisement Protocol
+ * @dialog_token: nonzero, identifies req/rsp transaction
+ * @query_data: Query Data. SD gas ireq SD gas iresp
+ */
+struct inff_gas_pub_act_frame {
+	u8	category;
+	u8	action;
+	u8	dialog_token;
+	u8	query_data[];
+};
+
+struct inff_cfg80211_edcf_acparam {
+	u8 ACI;
+	u8 ECW;
+	u16 TXOP;        /* stored in network order (ls octet first) */
+};
+
+/**
+ * struct inff_cfg80211_vif_event - virtual interface event information.
+ *
+ * @vif_wq: waitqueue awaiting interface event from firmware.
+ * @vif_event_lock: protects other members in this structure.
+ * @action: either add, change, or delete.
+ * @vif: virtual interface object related to the event.
+ */
+struct inff_cfg80211_vif_event {
+	wait_queue_head_t vif_wq;
+	spinlock_t vif_event_lock;	/* protects other members in this structure */
+	u8 action;
+	struct inff_cfg80211_vif *vif;
+};
+
+/**
+ * struct inff_cfg80211_info - dongle private data of cfg80211 interface
+ *
+ * @wiphy: wiphy object for cfg80211 interface.
+ * @conf: dongle configuration.
+ * @scan_request: cfg80211 scan request object.
+ * @conn_info: association info.
+ * @scan_status: scan activity on the dongle.
+ * @pub: common driver information.
+ * @channel: current channel.
+ * @int_escan_map: bucket map for which internal e-scan is done.
+ * @pwr_save: indicate whether dongle to support power save mode.
+ * @dongle_up: indicate whether dongle up or not.
+ * @roam_on: on/off switch for dongle self-roaming.
+ * @scan_tried: indicates if first scan attempted.
+ * @dcmd_buf: dcmd buffer.
+ * @extra_buf: mainly to grab assoc information.
+ * @debugfsdir: debugfs folder for this device.
+ * @escan_info: escan information.
+ * @escan_timeout_work: scan timeout delayed work.
+ * @vif_list: linked list of vif instances.
+ * @vif_cnt: number of vif instances.
+ * @vif_event: vif event signalling.
+ */
+struct inff_cfg80211_info {
+	struct wiphy *wiphy;
+	struct inff_cfg80211_conf conf;
+	struct cfg80211_scan_request *scan_request;
+	struct inff_cfg80211_connect_info conn_info;
+	unsigned long scan_status;
+	struct inff_pub *pub;
+	u32 channel;
+	u32 int_escan_map;
+	bool pwr_save;
+	bool dongle_up;
+	bool scan_tried;
+	u8 *dcmd_buf;
+	u8 *extra_buf;
+	struct dentry *debugfsdir;
+	struct escan_info escan_info;
+	struct wiphy_delayed_work escan_timeout_work;
+	struct list_head vif_list;
+	struct inff_cfg80211_vif_event vif_event;
+	struct completion vif_disabled;
+	u8 ac_priority[MAX_8021D_PRIO];
+	u8 pm_state;
+	u8 num_softap;
+	u8 mchan_conf;
+	struct inff_scan_info scan;
+	bool bands_reset_required;
+};
+
+static inline struct inff_cfg80211_info *
+wiphy_to_cfg(struct wiphy *wiphy)
+{
+	struct inff_pub *drvr = wiphy_priv(wiphy);
+
+	return drvr->config;
+}
+
+static inline struct inff_cfg80211_info *
+wdev_to_cfg(struct wireless_dev *wdev)
+{
+	return wiphy_to_cfg(wdev->wiphy);
+}
+
+static inline struct net_device *
+cfg_to_ndev(struct inff_cfg80211_info *cfg)
+{
+	return inff_get_ifp(cfg->pub, 0)->ndev;
+}
+
+static inline struct inff_cfg80211_info *
+ndev_to_cfg(struct net_device *ndev)
+{
+	return wdev_to_cfg(ndev->ieee80211_ptr);
+}
+
+static inline struct inff_cfg80211_vif *
+ndev_to_vif(struct net_device *ndev)
+{
+	struct inff_if *ifp = netdev_priv(ndev);
+
+	return ifp->vif;
+}
+
+s32 inff_inform_single_bss(struct inff_cfg80211_info *cfg,
+			   struct inff_bss_info_le *bi);
+s32 inff_inform_bss(struct inff_cfg80211_info *cfg);
+s32 inff_compare_update_same_bss(struct inff_cfg80211_info *cfg,
+				 struct inff_bss_info_le *bss,
+				 struct inff_bss_info_le *bss_info_le);
+void inff_set_mpc(struct inff_if *ndev, int mpc);
+void inff_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev);
+bool inff_ieee80211_is_dpp_pub_action(void *frame, u32 frame_len);
+bool inff_ieee80211_is_gas_pub_action(void *frame, u32 frame_len);
+void inff_print_action_frame(bool tx, void *frame, u32 frame_len);
+int inff_cfg80211_get_channel(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
+			      unsigned int link_id,
+			      struct cfg80211_chan_def *chandef);
+struct cfg80211_ops *inff_cfg80211_get_ops(struct inff_mp_device *settings);
+void inff_cfg80211_free_netdev_priv(struct net_device *ndev);
+u8 inff_map_prio_to_prec(void *config, u8 prio);
+u8 inff_map_prio_to_aci(void *config, u8 prio);
+void inff_wifi_prioritize_acparams(const struct inff_cfg80211_edcf_acparam *acp,
+				   u8 *priority);
+s32 inff_cfg80211_up(struct net_device *ndev);
+s32 inff_cfg80211_down(struct net_device *ndev);
+int inff_alloc_wiphy(struct device *dev, struct inff_mp_device *settings);
+void inff_free_wiphy(struct device *dev);
+struct inff_cfg80211_info *inff_cfg80211_attach(struct inff_pub *drvr,
+						struct cfg80211_ops *ops);
+void inff_cfg80211_detach(struct inff_cfg80211_info *cfg);
+#endif /* INFF_CFG80211_H */
-- 
2.43.0

