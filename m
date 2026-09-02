Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC5830E0CC
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368056; cv=none; b=P4mKRcuu9IUWstRQ/lzoWZ74wdvZn/UelkKEVDHQya4HA7PQPfnghn1K/5GIAPuvoOeLJcPoTZPo69BTvW/cLsXMPi6PlFSnZBGwW6uzS2feysZSMOJD3yrKkpw4wXMzBtq4/3ZbaQ4XSVOnjVDfW8P49OyL5+3i9mBHB0EZfXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368056; c=relaxed/simple;
	bh=CG5iudXAY4sDnnpRMxCgDMPUyD0gQDsDK79PWbj9HWA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7GrncpzxSE6sR0ZUMiUXPn1jhm8t+dmVxbMUy1LWnEV/4k6dhFquAhGnnYvOVpuV5tp31lbieB/2rx+IDqeATDqP5EzDc9chBWSjONMdp40KMJJwSS4fUbypazF4SiNGn3JLKwe6UcLf6jxpgFwAd+WUtDSckI3T03goIbDYLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=pseKWgri; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="pseKWgri"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368055; x=1819904055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CG5iudXAY4sDnnpRMxCgDMPUyD0gQDsDK79PWbj9HWA=;
  b=pseKWgriUQOQBnyJ5qdWOrRGVZwk0Xm3QmByu5XxfWiwaRUsyjJLTKqt
   wmrUrg+f1vMM8yCNm1x+3YDFVQQUVKLmS0NgoUaOTQNkuzsqr5F2Wdxqv
   LIk4K1kEjNarnpn+xJTJAd2QySkGBN035jq7IIdvZEa67DbP3mVqHGBvl
   E=;
X-CSE-ConnectionGUID: r1T1GpXDTvasXcZXH3hIsw==
X-CSE-MsgGUID: Sb9UtfZmTS+kj//WeThgvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="107705898"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="107705898"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:54:11 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:54:10 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:54:09 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 14/25] wifi: inffmac: add he.c/h
Date: Wed, 2 Sep 2026 16:50:45 +0000
Message-ID: <20260902165057.456447-15-gokulkumar.sivakumar@infineon.com>
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
X-ClientProxiedBy: MUCSE819.infineon.com (172.23.29.45) To
 MUCSE827.infineon.com (172.23.29.20)

Collect the 802.11ax HE capabilities of the Device and register it as part
of the wiphy capabilities in the cfg80211 driver.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/infineon/inffmac/he.c | 112 +++++++++++++++++++++
 drivers/net/wireless/infineon/inffmac/he.h |  27 +++++
 2 files changed, 139 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/he.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/he.h

diff --git a/drivers/net/wireless/infineon/inffmac/he.c b/drivers/net/wireless/infineon/inffmac/he.c
new file mode 100644
index 000000000000..334c12f5a49c
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/he.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/bitfield.h>
+#include "he.h"
+#include "dev_cmd.h"
+#include "cfg80211.h"
+#include "debug.h"
+
+static struct ieee80211_sband_iftype_data sdata[NUM_NL80211_BANDS];
+
+int
+inff_he_get_enable(struct inff_if *ifp, u8 *param, int param_len)
+{
+	s32 ret = 0;
+
+	ret = inff_fwcmd_xtlv_data_get(ifp, "he", INFF_HE_CMD_ENAB, param, param_len);
+	if (unlikely(ret))
+		iphy_err(ifp->drvr, "failed to check if HE is enabled");
+
+	return ret;
+}
+
+void
+inff_he_update_wiphy_cap(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
+	struct ieee80211_supported_band *band;
+	struct ieee80211_sband_iftype_data *data;
+	struct ieee80211_sta_he_cap *he_cap;
+	struct ieee80211_he_cap_elem *he_cap_elem;
+	struct ieee80211_he_mcs_nss_supp *he_mcs;
+	u8 mac_cap_info[HE_MAC_CAP_INFO_SIZE] = { 0 };
+	u8 phy_cap_info[HE_PHY_CAP_INFO_SIZE] = { 0 };
+	u16 capa = 0;
+	u8 hemode = 0;
+	int idx = 1, i = 0, j = 0;
+
+	/* HE mode */
+	inff_he_get_enable(ifp, &hemode, sizeof(hemode));
+	if (!hemode)
+		return;
+
+	inff_dbg(INFO, "HE Enabled\n");
+
+	/* HE MAC Capabilities Information */
+	if (inff_fwcmd_xtlv_data_get(ifp, "he", INFF_HE_CMD_MACCAP, mac_cap_info,
+				     HE_MAC_CAP_INFO_SIZE))
+		iphy_err(drvr, "HE MACCAP error\n");
+
+	/* HE PHY Capabilities Information */
+	if (inff_fwcmd_xtlv_data_get(ifp, "he", INFF_HE_CMD_PHYCAP, phy_cap_info,
+				     HE_PHY_CAP_INFO_SIZE))
+		iphy_err(drvr, "HE PHYCAP error\n");
+
+	/* Update HE Capab for each Band */
+	for (i = 0; i < ARRAY_SIZE(wiphy->bands); i++) {
+		band = wiphy->bands[i];
+		if (!band)
+			continue;
+
+		data = &sdata[band->band];
+		he_cap = &data->he_cap;
+		he_cap_elem = &he_cap->he_cap_elem;
+		he_mcs = &he_cap->he_mcs_nss_supp;
+
+		switch (band->band) {
+		case NL80211_BAND_6GHZ:
+			/* HE 6 GHz band capabilities */
+			capa = (FIELD_PREP(IEEE80211_HE_6GHZ_CAP_MIN_MPDU_START,
+					   IEEE80211_HT_MPDU_DENSITY_8) |
+				FIELD_PREP(IEEE80211_HE_6GHZ_CAP_MAX_AMPDU_LEN_EXP,
+					   IEEE80211_VHT_MAX_AMPDU_1024K) |
+				FIELD_PREP(IEEE80211_HE_6GHZ_CAP_MAX_MPDU_LEN,
+					   IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454));
+			data->he_6ghz_capa.capa = cpu_to_le16(capa);
+
+			/* Band 6GHz supports HE, so */
+			fallthrough;
+
+		case NL80211_BAND_5GHZ:
+			/* Band 5GHz supports HE, so */
+			fallthrough;
+
+		case NL80211_BAND_2GHZ:
+			/* Band 2GHz supports HE */
+			data->types_mask = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
+			data->he_cap.has_he = true;
+
+			for (j = 0; j < HE_MAC_CAP_INFO_SIZE; j++)
+				he_cap_elem->mac_cap_info[j] = mac_cap_info[j];
+
+			for (j = 0; j < HE_PHY_CAP_INFO_SIZE; j++)
+				he_cap_elem->phy_cap_info[j] = phy_cap_info[j];
+
+			/* HE Supported MCS and NSS Set */
+			he_mcs->rx_mcs_80 = cpu_to_le16(0xfffa);
+			he_mcs->tx_mcs_80 = cpu_to_le16(0xfffa);
+
+			_ieee80211_set_sband_iftype_data(band, data, idx);
+
+			break;
+
+		default:
+			break;
+		}
+	}
+}
diff --git a/drivers/net/wireless/infineon/inffmac/he.h b/drivers/net/wireless/infineon/inffmac/he.h
new file mode 100644
index 000000000000..643814a1bc42
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/he.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_HE_H
+#define INFF_HE_H
+
+#include "main.h"
+
+#define HE_MAC_CAP_INFO_SIZE	6
+#define HE_PHY_CAP_INFO_SIZE	11
+
+/**
+ * enum inff_he_cmd - HE iovar subcmds handled by firmware HE module
+ */
+enum inff_he_cmd {
+	INFF_HE_CMD_ENAB = 0,
+	INFF_HE_CMD_MACCAP = 16,
+	INFF_HE_CMD_PHYCAP = 17,
+};
+
+int inff_he_get_enable(struct inff_if *ifp, u8 *param, int param_len);
+void inff_he_update_wiphy_cap(struct inff_if *ifp);
+
+#endif /* INFF_HE_H */
-- 
2.43.0

