Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00CA4A8A13
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368167; cv=none; b=KuBaPl0A1Tn75kY8njQoRHIXTH+uG1Bc5mNbIyfoAGR+1Nkcl3x7y2+E7FPjvye2HF9LSImLLbWfDS3CD1DCdLGNkoJvMz85kMtz9o4gB7O2i08e+J/BBOWBO4vO/+rEk+xav9WSiwacg2vZyGRWzQn9gZmCF1WuydDzfrpxWz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368167; c=relaxed/simple;
	bh=nNM92uGdrE5/I/8acjtOqVyoxLHo1/Rnl+QSvC5qRuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUdlPyuHK1MZPFh6yXlZz2erPVwlng4G0uTibxv2w4S7855+ZlqUJt03c5rLjlX5w9CBQi56/l05c1xV6hnxwxIO6LHRL/bdLDXUEoWjVQ03QT7IFx2VXeD0iAODCBaI/W7bPASVi+O7trv5Abxg3Uo4cYDn/yLj7/RYegcK8x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=psZIDorR; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="psZIDorR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368165; x=1819904165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nNM92uGdrE5/I/8acjtOqVyoxLHo1/Rnl+QSvC5qRuE=;
  b=psZIDorRrPi3UrYGLq9htRO23LU4gR4YViHxJQr6xKcbfD9w2mgcj1wJ
   54RXj9T2EJU6zMeAX6j6BV3YP0Xz+F1ARWa4V8aprdCk53t02HKg7yPcC
   PHrDUmdFJMVo1xJW+KAf7+QVfQ/kLEmjJlfRbu/Xirtk2DqrhCG2dPFNx
   Q=;
X-CSE-ConnectionGUID: VfqL4XLISNGGt2uaKU2s4Q==
X-CSE-MsgGUID: 3v+fKlvhTwWMXmvwGj0YkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="107706049"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="107706049"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:56:03 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:56:02 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:56:00 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 23/25] wifi: inffmac: add debug.c/h
Date: Wed, 2 Sep 2026 16:50:54 +0000
Message-ID: <20260902165057.456447-24-gokulkumar.sivakumar@infineon.com>
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
X-ClientProxiedBy: MUCSE801.infineon.com (172.23.29.27) To
 MUCSE827.infineon.com (172.23.29.20)

Implements the driver debugging infrastructure for sending debug prints to
the user (based on the configured debug level) with the help of helper
functions. These functions are utilized by source files in the driver.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/infineon/inffmac/debug.c |  59 +++++++
 drivers/net/wireless/infineon/inffmac/debug.h | 161 ++++++++++++++++++
 2 files changed, 220 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/debug.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/debug.h

diff --git a/drivers/net/wireless/infineon/inffmac/debug.c b/drivers/net/wireless/infineon/inffmac/debug.c
new file mode 100644
index 000000000000..2c199beb014c
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/debug.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+#include <linux/debugfs.h>
+#include <linux/netdevice.h>
+#include <linux/module.h>
+
+#include "main.h"
+#include "bus_proto.h"
+#include "debug.h"
+
+void __inff_dbg(u32 level, const char *func, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	if (inff_msg_level & level)
+		pr_debug("%s %pV", func, &vaf);
+	va_end(args);
+}
+
+void __inff_dbg_hex_dump(const void *data, size_t size,
+			 const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_debug("%pV", &vaf);
+
+	va_end(args);
+
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data, size);
+}
+
+struct dentry *inff_debugfs_get_devdir(struct inff_pub *drvr)
+{
+	return drvr->wiphy->debugfsdir;
+}
+
+void inff_debugfs_add_entry(struct inff_pub *drvr, const char *fn,
+			    int (*read_fn)(struct seq_file *seq, void *data))
+{
+	WARN(!drvr->wiphy->debugfsdir, "wiphy not (yet) registered\n");
+	debugfs_create_devm_seqfile(drvr->bus_if->dev, fn,
+				    drvr->wiphy->debugfsdir, read_fn);
+}
diff --git a/drivers/net/wireless/infineon/inffmac/debug.h b/drivers/net/wireless/infineon/inffmac/debug.h
new file mode 100644
index 000000000000..3e4ca31fd8be
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/debug.h
@@ -0,0 +1,161 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_DEBUG_H
+#define INFF_DEBUG_H
+
+#include <linux/net.h>	/* net_ratelimit() */
+#include <linux/device.h>
+
+/* message levels */
+enum inff_msglvl {
+	INFF_MSGLVL_TRACE	= BIT(1),
+	INFF_MSGLVL_INFO	= BIT(2),
+	INFF_MSGLVL_DATA	= BIT(3),
+	INFF_MSGLVL_CTL		= BIT(4),
+	INFF_MSGLVL_TIMER	= BIT(5),
+	INFF_MSGLVL_HDRS	= BIT(6),
+	INFF_MSGLVL_BYTES	= BIT(7),
+	INFF_MSGLVL_INTR	= BIT(8),
+	INFF_MSGLVL_GLOM	= BIT(9),
+	INFF_MSGLVL_DEVEVT	= BIT(10),
+	INFF_MSGLVL_BTA		= BIT(11),
+	INFF_MSGLVL_DEVCMD	= BIT(12),
+	INFF_MSGLVL_USB		= BIT(13),
+	INFF_MSGLVL_SCAN	= BIT(14),
+	INFF_MSGLVL_CONN	= BIT(15),
+	INFF_MSGLVL_BCDC	= BIT(16),
+	INFF_MSGLVL_SDIO	= BIT(17),
+	INFF_MSGLVL_RSV18	= BIT(18),
+	INFF_MSGLVL_RSV19	= BIT(19),
+	INFF_MSGLVL_FWCON	= BIT(20),
+	INFF_MSGLVL_RSV21	= BIT(21),
+	INFF_MSGLVL_RSV22	= BIT(22),
+	INFF_MSGLVL_SDIOEXT	= BIT(24),
+	INFF_MSGLVL_ICDC	= BIT(25),
+	INFF_MSGLVL_CPUSS_ON    = BIT(26),
+};
+
+#ifdef DEBUG
+#define INFF_MSGLVL_ON(level) (inff_msg_level & INFF_MSGLVL_##level)
+#else /* DEBUG */
+#define INFF_MSGLVL_ON(LVL)	0
+#endif /* DEBUG */
+
+/* set default print format */
+#undef pr_fmt
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+
+struct inff_bus;
+
+__printf(3, 4)
+void __inff_err(struct device *dev, const char *func, const char *fmt, ...);
+/* Macro for error messages. When debugging / tracing the driver all error
+ * messages are important to us.
+ */
+#define inff_err(fmt, ...)						\
+	do {								\
+		if (IS_ENABLED(CONFIG_INF_DEBUG) ||			\
+		    net_ratelimit())					\
+			__inff_err(NULL, __func__, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+#define iphy_err(drvr, fmt, ...)					\
+	do {								\
+		if (IS_ENABLED(CONFIG_INF_DEBUG) ||			\
+		    net_ratelimit())					\
+			wiphy_err((drvr)->wiphy, "%s: " fmt, __func__,	\
+				  ##__VA_ARGS__);			\
+	} while (0)
+
+#define iphy_info_once(drvr, fmt, ...)					\
+	wiphy_info_once((drvr)->wiphy, "%s: " fmt, __func__,		\
+			##__VA_ARGS__)
+
+#ifdef DEBUG
+
+/* For debug purposes treat info messages as errors */
+#define inff_info inff_err
+
+__printf(3, 4)
+void __inff_dbg(u32 level, const char *func, const char *fmt, ...);
+#define inff_dbg(level, fmt, ...)				\
+do {								\
+	if (IS_ENABLED(CONFIG_INF_DEBUG))			\
+		__inff_dbg(INFF_MSGLVL_##level, __func__,	\
+			fmt, ##__VA_ARGS__);			\
+} while (0)
+
+__printf(3, 4)
+void __inff_dbg_hex_dump(const void *data, size_t size,
+			 const char *fmt, ...);
+#define inff_dbg_hex_dump(test, data, len, fmt, ...) \
+do { \
+	if (test) \
+		__inff_dbg_hex_dump(data, len, fmt, ##__VA_ARGS__); \
+} while (0)
+
+#else /* DEBUG */
+
+#define inff_info(fmt, ...)						\
+	pr_info("%s: " fmt, __func__, ##__VA_ARGS__)
+
+#define inff_dbg(level, fmt, ...)					\
+	do {								\
+		(void)(INFF_MSGLVL_ ## level);				\
+		no_printk(fmt, ##__VA_ARGS__);				\
+	} while (0)
+
+#define inff_dbg_hex_dump(test, data, len, fmt, ...)			\
+	do {								\
+		(void)(test);						\
+		(void)(data);						\
+		(void)(len);						\
+		no_printk(fmt, ##__VA_ARGS__);				\
+	} while (0)
+
+#endif /* DEBUG */
+
+extern int inff_msg_level;
+struct inff_pub;
+
+#ifdef DEBUG
+struct dentry *inff_debugfs_get_devdir(struct inff_pub *drvr);
+void inff_debugfs_add_entry(struct inff_pub *drvr, const char *fn,
+			    int (*read_fn)(struct seq_file *seq, void *data));
+#else
+static inline struct dentry *inff_debugfs_get_devdir(struct inff_pub *drvr)
+{
+	return ERR_PTR(-ENOENT);
+}
+
+static inline
+void inff_debugfs_add_entry(struct inff_pub *drvr, const char *fn,
+			    int (*read_fn)(struct seq_file *seq, void *data))
+{ }
+#endif /* DEBUG */
+
+#define MSGTRACE_VERSION 1
+#define MSGTRACE_HDR_TYPE_MSG 0
+#define MSGTRACE_HDR_TYPE_LOG 1
+
+/* Message trace header */
+struct msgtrace_hdr {
+	u8	version;
+	u8	trace_type;
+	u16	len;    /* Len of the trace */
+	u32	seqnum; /* Sequence number of message */
+	/* Number of discarded bytes because of trace overflow  */
+	u32	discarded_bytes;
+	/* Number of discarded printf because of trace overflow */
+	u32	discarded_printf;
+};
+
+#define MSGTRACE_HDRLEN		sizeof(struct msgtrace_hdr)
+
+#endif /* INFF_DEBUG_H */
-- 
2.43.0

