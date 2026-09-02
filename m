Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0559344D88
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368069; cv=none; b=CiCxShzeVFw3bUhQYdrgoWx54hg1+iQ0Ne9Ls9Y/2E/rMzx8g5+mBgpaoI4z1LQYE/8kPUH/6b3asHVXJBSz5zJhx1817CfiK+LuDmFagn3mpPC21Bb9MZ6bqgK3U0a8+rdiU1nCpZwOaWyclPChoXmgn3818UKdSdenTLJd5j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368069; c=relaxed/simple;
	bh=fnNkJ00fdnBXo2jiRCkJMA3tsKi3jTrsDTycu67s3zM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLaWhB0pidXdx/HTwqkpzehN5gyi2xqOOtF9FyBGXZIzEGfthTg/9KMwBY8Lt+eq2TN5UD7z7js8KpHxqSm6Nbu6cA4aMe+DZYfmTcSj0PJYPJQl4kOEX9Df8iVE7rFzNFRRRlWcYdiIzfVUMr1vjsqrAE1kS2mZHcYMb9gp69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=IfiPZgG3; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="IfiPZgG3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368066; x=1819904066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fnNkJ00fdnBXo2jiRCkJMA3tsKi3jTrsDTycu67s3zM=;
  b=IfiPZgG3ddwIRO05jUJM28Skakd8W3C7IePH17nECNiAKarorPoQa4gW
   VHLiVslUrm1eOzaAFDMIVf5LlHBvKnBoWhGN4KXyF4CYqKQTW3EjRjB6x
   u46eDFUBNKaQGOBh8zxiP/jlAW0G0OMog2qNJW0Q5jcU9m7+fvd6BRExo
   Q=;
X-CSE-ConnectionGUID: nv9p2zypQsO9HjKelSimfQ==
X-CSE-MsgGUID: fe0yJy9fRdO/DBs6MnG95g==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="159196601"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="159196601"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:54:24 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:54:24 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:54:22 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 15/25] wifi: inffmac: add feature.c/h
Date: Wed, 2 Sep 2026 16:50:46 +0000
Message-ID: <20260902165057.456447-16-gokulkumar.sivakumar@infineon.com>
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
X-ClientProxiedBy: MUCSE821.infineon.com (172.23.29.47) To
 MUCSE827.infineon.com (172.23.29.20)

Driver implementation to detect and maintain the feature capabilities of
the currently loaded Device firmware. All other driver source files
utilizes these firmware feature flags for finding if the firmware is
supporting a specific operation or functionality.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/feature.c   | 264 ++++++++++++++++++
 .../net/wireless/infineon/inffmac/feature.h   | 121 ++++++++
 2 files changed, 385 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/feature.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/feature.h

diff --git a/drivers/net/wireless/infineon/inffmac/feature.c b/drivers/net/wireless/infineon/inffmac/feature.c
new file mode 100644
index 000000000000..e748ef02b558
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/feature.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/module.h>
+
+#include "main.h"
+#include "debug.h"
+#include "dev_cmd.h"
+#include "feature.h"
+#include "bus_proto.h"
+
+static const char * const inff_feat_names[] = {
+	"MBSS",
+	"MCHAN",
+	"RSV2",
+	"RSV3",
+	"RSV4",
+	"RSDB",
+	"RSV6",
+	"SCAN_RANDOM_MAC",
+	"RSV8",
+	"RSV9",
+	"RSV10",
+	"MFP",
+	"GSCAN",
+	"FWSUP",
+	"RSV14",
+	"RSV15",
+	"RSV16",
+	"RSV17",
+	"DOT11H",
+	"SAE",
+	"FWAUTH",
+	"RSV21",
+	"SCAN_V2",
+	"RSV23",
+	"RSV24",
+	"RSV25",
+	"SAE_EXT",
+	"FBT",
+	"OKC",
+	"GCMP",
+	"RSV30",
+	"RSV31",
+	"RSV32",
+	"PROPTXSTATUS",
+	"OWE",
+	"RSV35",
+	"RSV36",
+	"GTKO",
+	"MCHAN_CONFIG",
+	"RSV39",
+	"LAST"
+};
+
+struct inff_feat_fwcap {
+	enum inff_feat_id feature;
+	const char * const fwcap_id;
+};
+
+static const struct inff_feat_fwcap inff_fwcap_map[] = {
+	{ INFF_FEAT_MBSS, "mbss" },
+	{ INFF_FEAT_MCHAN, "mchan" },
+	{ INFF_FEAT_DOT11H, "802.11h" },
+	{ INFF_FEAT_SAE, "sae " },
+	{ INFF_FEAT_FWAUTH, "idauth" },
+	{ INFF_FEAT_SAE_EXT, "sae_ext " },
+	{ INFF_FEAT_FBT, "fbt " },
+	{ INFF_FEAT_OKC, "okc" },
+	{ INFF_FEAT_GCMP, "gcmp" },
+	{ INFF_FEAT_PROPTXSTATUS, "proptxstatus" },
+	{ INFF_FEAT_OWE, "owe" },
+	{ INFF_FEAT_GTKO, "gtko" },
+	{ INFF_FEAT_MCHAN_CONFIG, "mchan_config" },
+};
+
+#ifdef DEBUG
+static const char * const inff_quirk_names[] = {
+	"QUIRK_AUTO_AUTH",
+	"QUIRK_NEED_MPC",
+	"QUIRK_LAST"
+};
+
+/**
+ * inff_feat_debugfs_read() - expose feature info to debugfs.
+ *
+ * @seq: sequence for debugfs entry.
+ * @data: raw data pointer.
+ */
+static int inff_feat_debugfs_read(struct seq_file *seq, void *data)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(seq->private);
+	u8 feats[DIV_ROUND_UP(INFF_FEAT_LAST, 8)] = {0};
+	u32 quirks = bus_if->drvr->chip_quirks;
+	int id, i;
+	u8 size = INFF_FEAT_LAST / 8;
+
+	memcpy(feats, bus_if->drvr->feat_flags, sizeof(feats));
+
+	seq_puts(seq, "Features: ");
+	for (i = 0; i < size; i++)
+		seq_printf(seq, "%02x", feats[i]);
+	seq_puts(seq, "\n");
+
+	for (id = 0; id < INFF_FEAT_LAST; id++)
+		if (feats[id / 8] & BIT(id % 8))
+			seq_printf(seq, "\t%s\n", inff_feat_names[id]);
+
+	seq_printf(seq, "\nQuirks:   %08x\n", quirks);
+	for (id = 0; id < INFF_FEAT_QUIRK_LAST; id++)
+		if (quirks & BIT(id))
+			seq_printf(seq, "\t%s\n", inff_quirk_names[id]);
+	return 0;
+}
+#else
+static int inff_feat_debugfs_read(struct seq_file *seq, void *data)
+{
+	return 0;
+}
+#endif /* DEBUG */
+
+static void inff_feat_wlc_version_overrides(struct inff_pub *drv)
+{
+	struct inff_if *ifp = inff_get_ifp(drv, 0);
+	struct inff_wlc_version_le ver;
+	int err, major, minor;
+
+	err = inff_fwcmd_iovar_data_get(ifp, "wlc_ver", &ver, sizeof(ver));
+	if (err)
+		return;
+
+	major = le16_to_cpu(ver.wlc_ver_major);
+	minor = le16_to_cpu(ver.wlc_ver_minor);
+
+	inff_dbg(INFO, "WLC version: %d.%d\n", major, minor);
+}
+
+/**
+ * inff_feat_iovar_int_get() - determine feature through iovar query.
+ *
+ * @ifp: interface to query.
+ * @id: feature id.
+ * @name: iovar name.
+ */
+static void inff_feat_iovar_int_get(struct inff_if *ifp,
+				    enum inff_feat_id id, char *name)
+{
+	u32 data = 0;
+	int err;
+
+	/* we need to know firmware error */
+	ifp->fwil_fwerr = true;
+
+	err = inff_fwcmd_iovar_int_get(ifp, name, &data);
+	if (err != -INFF_FW_UNSUPPORTED) {
+		inff_dbg(INFO, "enabling feature: %s\n", inff_feat_names[id]);
+		ifp->drvr->feat_flags[id / 8] |= BIT(id % 8);
+	} else {
+		inff_dbg(TRACE, "%s feature check failed: %d\n",
+			 inff_feat_names[id], err);
+	}
+
+	ifp->fwil_fwerr = false;
+}
+
+#define MAX_CAPS_BUFFER_SIZE	768
+static void inff_feat_firmware_capabilities(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	char caps[MAX_CAPS_BUFFER_SIZE];
+	enum inff_feat_id id;
+	int i, err;
+
+	memset(caps, 0, MAX_CAPS_BUFFER_SIZE);
+	err = inff_fwcmd_iovar_data_get(ifp, "cap", caps, sizeof(caps));
+	if (err) {
+		iphy_err(drvr, "could not get firmware cap (%d)\n", err);
+		return;
+	}
+
+	inff_dbg(INFO, "[ %s]\n", caps);
+
+	for (i = 0; i < ARRAY_SIZE(inff_fwcap_map); i++) {
+		if (strnstr(caps, inff_fwcap_map[i].fwcap_id, sizeof(caps))) {
+			id = inff_fwcap_map[i].feature;
+			inff_dbg(INFO, "enabling feature: %s\n",
+				 inff_feat_names[id]);
+			ifp->drvr->feat_flags[id / 8] |= BIT(id % 8);
+		}
+	}
+}
+
+/**
+ * inff_feat_fwcap_debugfs_read() - expose firmware capabilities to debugfs.
+ *
+ * @seq: sequence for debugfs entry.
+ * @data: raw data pointer.
+ */
+static int inff_feat_fwcap_debugfs_read(struct seq_file *seq, void *data)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(seq->private);
+	struct inff_pub *drvr = bus_if->drvr;
+	struct inff_if *ifp = inff_get_ifp(drvr, 0);
+	char caps[MAX_CAPS_BUFFER_SIZE + 1] = { };
+	char *tmp;
+	int err;
+
+	err = inff_fwcmd_iovar_data_get(ifp, "cap", caps, sizeof(caps));
+	if (err) {
+		iphy_err(drvr, "could not get firmware cap (%d)\n", err);
+		return err;
+	}
+
+	/* Put every capability in a new line */
+	for (tmp = caps; *tmp; tmp++) {
+		if (*tmp == ' ')
+			*tmp = '\n';
+	}
+
+	/* Usually there is a space at the end of capabilities string */
+	seq_printf(seq, "%s", caps);
+	/* So make sure we don't print two line breaks */
+	if (tmp > caps && *(tmp - 1) != '\n')
+		seq_puts(seq, "\n");
+
+	return 0;
+}
+
+void inff_feat_attach(struct inff_pub *drvr)
+{
+	struct inff_if *ifp = inff_get_ifp(drvr, 0);
+
+	inff_feat_firmware_capabilities(ifp);
+
+	inff_feat_iovar_int_get(ifp, INFF_FEAT_RSDB, "rsdb_mode");
+	inff_feat_iovar_int_get(ifp, INFF_FEAT_MFP, "mfp");
+	inff_feat_iovar_int_get(ifp, INFF_FEAT_FWSUP, "sup_wpa");
+	inff_feat_iovar_int_get(ifp, INFF_FEAT_SCAN_V2, "scan_ver");
+
+	inff_feat_wlc_version_overrides(drvr);
+}
+
+void inff_feat_debugfs_create(struct inff_pub *drvr)
+{
+	inff_debugfs_add_entry(drvr, "features", inff_feat_debugfs_read);
+	inff_debugfs_add_entry(drvr, "fwcap", inff_feat_fwcap_debugfs_read);
+}
+
+bool inff_feat_is_enabled(struct inff_if *ifp, enum inff_feat_id id)
+{
+	return (ifp->drvr->feat_flags[id / 8] & BIT(id % 8));
+}
+
+bool inff_feat_is_quirk_enabled(struct inff_if *ifp,
+				enum inff_feat_quirk quirk)
+{
+	return (ifp->drvr->chip_quirks & BIT(quirk));
+}
diff --git a/drivers/net/wireless/infineon/inffmac/feature.h b/drivers/net/wireless/infineon/inffmac/feature.h
new file mode 100644
index 000000000000..56ac69a0c940
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/feature.h
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_FEATURE_H
+#define INFF_FEATURE_H
+
+/*
+ * Features:
+ *
+ * MBSS: multiple BSSID support (eg. guest network in AP mode).
+ * MCHAN: multi-channel for concurrent interface
+ * RSDB: Real Simultaneous Dual Band
+ * SCAN_RANDOM_MAC: Random MAC during (net detect) scheduled scan.
+ * MFP: 802.11w Management Frame Protection.
+ * GSCAN: enhanced scan offload feature.
+ * FWSUP: Firmware supplicant.
+ * DOT11H: firmware supports 802.11h
+ * SAE: simultaneous authentication of equals
+ * FWAUTH: Firmware authenticator
+ * SCAN_V2: Version 2 scan params
+ * SAE_EXT: SAE be handled by userspace supplicant
+ * GCMP: firmware has defined GCMP or not.
+ * GTKO: GTK rekey offload.
+ */
+enum inff_feat_id {
+	INFF_FEAT_MBSS,
+	INFF_FEAT_MCHAN,
+	INFF_FEAT_RSV2,
+	INFF_FEAT_RSV3,
+	INFF_FEAT_RSV4,
+	INFF_FEAT_RSDB,
+	INFF_FEAT_RSV6,
+	INFF_FEAT_SCAN_RANDOM_MAC,
+	INFF_FEAT_RSV8,
+	INFF_FEAT_RSV9,
+	INFF_FEAT_RSV10,
+	INFF_FEAT_MFP,
+	INFF_FEAT_GSCAN,
+	INFF_FEAT_FWSUP,
+	INFF_FEAT_RSV14,
+	INFF_FEAT_RSV15,
+	INFF_FEAT_RSV16,
+	INFF_FEAT_RSV17,
+	INFF_FEAT_DOT11H,
+	INFF_FEAT_SAE,
+	INFF_FEAT_FWAUTH,
+	INFF_FEAT_RSV21,
+	INFF_FEAT_SCAN_V2,
+	INFF_FEAT_RSV23,
+	INFF_FEAT_RSV24,
+	INFF_FEAT_RSV25,
+	INFF_FEAT_SAE_EXT,
+	INFF_FEAT_FBT,
+	INFF_FEAT_OKC,
+	INFF_FEAT_GCMP,
+	INFF_FEAT_RSV30,
+	INFF_FEAT_RSV31,
+	INFF_FEAT_RSV32,
+	INFF_FEAT_PROPTXSTATUS,
+	INFF_FEAT_OWE,
+	INFF_FEAT_RSV35,
+	INFF_FEAT_RSV36,
+	INFF_FEAT_GTKO,
+	INFF_FEAT_MCHAN_CONFIG,
+	INFF_FEAT_RSV39,
+	INFF_FEAT_LAST
+};
+
+/*
+ * Quirks:
+ *
+ * AUTO_AUTH: workaround needed for automatic authentication type.
+ * NEED_MPC: driver needs to disable MPC during scanning operation.
+ */
+enum inff_feat_quirk {
+	INFF_FEAT_QUIRK_AUTO_AUTH,
+	INFF_FEAT_QUIRK_NEED_MPC,
+	INFF_FEAT_QUIRK_LAST
+};
+
+/**
+ * inff_feat_attach() - determine features and quirks.
+ *
+ * @drvr: driver instance.
+ */
+void inff_feat_attach(struct inff_pub *drvr);
+
+/**
+ * inff_feat_debugfs_create() - create debugfs entries.
+ *
+ * @drvr: driver instance.
+ */
+void inff_feat_debugfs_create(struct inff_pub *drvr);
+
+/**
+ * inff_feat_is_enabled() - query feature.
+ *
+ * @ifp: interface instance.
+ * @id: feature id to check.
+ *
+ * Return: true is feature is enabled; otherwise false.
+ */
+bool inff_feat_is_enabled(struct inff_if *ifp, enum inff_feat_id id);
+
+/**
+ * inff_feat_is_quirk_enabled() - query chip quirk.
+ *
+ * @ifp: interface instance.
+ * @quirk: quirk id to check.
+ *
+ * Return: true is quirk is enabled; otherwise false.
+ */
+bool inff_feat_is_quirk_enabled(struct inff_if *ifp,
+				enum inff_feat_quirk quirk);
+
+#endif /* INFF_FEATURE_H */
-- 
2.43.0

