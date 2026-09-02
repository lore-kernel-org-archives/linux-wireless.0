Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280B463B91
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368189; cv=none; b=rl0nCutiPmvitkiqhEPGX2zBA/zO75Ia8TOFcQo/I4ySl4DOQI4mY4p8hfaI+y9gZdEJTQhBblGOZy5QdHcTR68PqyjVJIWeeHz+m6N9gVMBO3l6hYmGJ0FQN76UmeliOxlArhVJa//gsM6+oc8qmntVFFR+yEYmh5iqeIgrb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368189; c=relaxed/simple;
	bh=nzNUHKG1pSCx+3YBUxyGMecwzpH4qM5zqc9+Mk6Fqrw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q27rjIsVhV61t6rjol6sSatR+yC0QPO/vwh1FIumPrMmDHEai96zmGIVfHKkhEUafi/oAYk/pIhkJmDkVKZp3dFVh3m6qLGBugf+iBdDjc6sGisM5JZcNM8SyMCE/6ToIjkCyLJnGRDEC4kc3iwTP8SDfLgnKhxAUIGK6Ht0ysw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=eo6fQTis; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="eo6fQTis"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788368187; x=1819904187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nzNUHKG1pSCx+3YBUxyGMecwzpH4qM5zqc9+Mk6Fqrw=;
  b=eo6fQTisBJEFKhQIxlxR/S9N3GL7ETDfKZ09AP1mdScAISpNeh3qjlDL
   R87qkVDC+KA1zRjbFCRO80nYIxzF1UVB+v3gkE5yJImD42YepbXXVFgVW
   fc5qGeD5iz5xVjdtod5PIRsjmS6mC3GMgn1GVr5Llpgd8FWuRQb2Scnwu
   E=;
X-CSE-ConnectionGUID: LDGBUu6PSueVSGjOaasA8A==
X-CSE-MsgGUID: 3Kd3sjtaTImNSLCGMTKb+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="145161437"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="145161437"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:56:25 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:56:24 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:56:23 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 25/25] wifi: inffmac: add Kconfig, Makefile
Date: Wed, 2 Sep 2026 16:50:56 +0000
Message-ID: <20260902165057.456447-26-gokulkumar.sivakumar@infineon.com>
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
X-ClientProxiedBy: MUCSE810.infineon.com (172.23.29.36) To
 MUCSE827.infineon.com (172.23.29.20)

Introduce a new Kconfig and Makefile for the inffmac driver sub-directory.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/infineon/inffmac/Kconfig | 13 +++++++
 .../net/wireless/infineon/inffmac/Makefile    | 36 +++++++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/Kconfig
 create mode 100644 drivers/net/wireless/infineon/inffmac/Makefile

diff --git a/drivers/net/wireless/infineon/inffmac/Kconfig b/drivers/net/wireless/infineon/inffmac/Kconfig
new file mode 100644
index 000000000000..036ef2421f32
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: ISC
+
+config INFFMAC
+	tristate "Infineon FullMAC WLAN driver"
+	depends on CFG80211 && MMC
+	select FW_LOADER
+	select FW_UPLOAD
+	default y
+	help
+	  This module adds support for wireless adapters based on Infineon
+	  FullMAC chipsets. It has to work with at least one of the bus
+	  interface support. If you choose to build a module, it'll be called
+	  inffmac.ko.
diff --git a/drivers/net/wireless/infineon/inffmac/Makefile b/drivers/net/wireless/infineon/inffmac/Makefile
new file mode 100644
index 000000000000..1e13c2b2e5ec
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/Makefile
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: ISC
+#
+# Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+# All rights reserved.
+#
+# Makefile fragment for Infineon 802.11 Networking Device Driver
+#
+
+ccflags-y += -I $(src)
+
+obj-$(CONFIG_INFFMAC) += inffmac.o
+inffmac-objs += \
+		bcdc.o \
+		bus_proto.o \
+		cfg80211.o \
+		chan.o \
+		chip.o \
+		chip_acw74xx.o \
+		chip_cyw5591x.o \
+		dev_cmd.o \
+		dev_evt.o \
+		dfu.o \
+		feature.o \
+		firmware.o \
+		fwsignal.o \
+		he.o \
+		icdc.o \
+		ie.o \
+		interface.o \
+		main.o \
+		net.o \
+		scan.o \
+		sdio.o \
+		utils.o
+inffmac-$(CONFIG_INF_DEBUG) += \
+		debug.o
-- 
2.43.0

