Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D715367B9C
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367968; cv=none; b=HmtKVLkTXkKy0UDXhgAge3xx3fNvPIOzy6gO2KGx+nmjsDwILvw3SnmmFGgm9Bku/5PtxVMmTNSEdoU1n4U5SsF8j828LZwaVhAdN7aQBSv9AzTbIZas4p0Ue0CWwQk/GPrj/8U/MIb3CPHPHRfD9YFRDootkMDFXuYPBMG0crc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367968; c=relaxed/simple;
	bh=9F0ch2OoOFp4FVE0aWnGaKUmATAbQcoC/uMuu9EZEno=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYoyo1LxRb+umkadUAH8vBqOLBFC2TrC049rJI3LMXs7wVykeHy0FX/Jg6QNdlBk+1CAAQlmTEwX1dWQuUpdDwOn+8Q6b7Gv8mmJG0SJ7Znt4lyrnTCciJ63B80xiP7QYvNyylpbuvEBh5L1/TPejOE9u25wDkboR5N+u4VQr7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=QDrXRMSF; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="QDrXRMSF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367967; x=1819903967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9F0ch2OoOFp4FVE0aWnGaKUmATAbQcoC/uMuu9EZEno=;
  b=QDrXRMSFzwL2LhDYyzdQ7axsGxgZ0lPIdFTBmolG1KlFHa7EM+CtdPWx
   saKQooKM0L3uwLOKYO1UyldunuOML8eRwMlHhC9c8Ar/UMzxfyhhhM0gA
   6zhPUhHrZhSUi9Yb91cmNqwChB8a6DyvBvtydLzDqnbIRnyWTYIXY6nCZ
   Y=;
X-CSE-ConnectionGUID: f7F2PHLbSz6yefjdj9/FDQ==
X-CSE-MsgGUID: LeTb02c0ThW7M6ilm5qO3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="159196404"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="159196404"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:51:36 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:51:35 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:51:33 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 01/25] wifi: inffmac: add a new driver directory for infineon WLAN vendor
Date: Wed, 2 Sep 2026 16:50:32 +0000
Message-ID: <20260902165057.456447-2-gokulkumar.sivakumar@infineon.com>
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
X-ClientProxiedBy: MUCSE806.infineon.com (172.23.29.32) To
 MUCSE827.infineon.com (172.23.29.20)

Update the wireless driver common Kconfig and Makefile to include the
new WLAN vendor directory for Infineon(Cypress).

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/Kconfig           |  1 +
 drivers/net/wireless/Makefile          |  1 +
 drivers/net/wireless/infineon/Kconfig  | 25 +++++++++++++++++++++++++
 drivers/net/wireless/infineon/Makefile | 12 ++++++++++++
 4 files changed, 39 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/Kconfig
 create mode 100644 drivers/net/wireless/infineon/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f4f969fdbc02..0e3feb3de3e0 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -22,6 +22,7 @@ source "drivers/net/wireless/admtek/Kconfig"
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/atmel/Kconfig"
 source "drivers/net/wireless/broadcom/Kconfig"
+source "drivers/net/wireless/infineon/Kconfig"
 source "drivers/net/wireless/intel/Kconfig"
 source "drivers/net/wireless/intersil/Kconfig"
 source "drivers/net/wireless/marvell/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index fa3100ff3bf7..796ee7d658e4 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_WLAN_VENDOR_ADMTEK) += admtek/
 obj-$(CONFIG_WLAN_VENDOR_ATH) += ath/
 obj-$(CONFIG_WLAN_VENDOR_ATMEL) += atmel/
 obj-$(CONFIG_WLAN_VENDOR_BROADCOM) += broadcom/
+obj-$(CONFIG_WLAN_VENDOR_INFINEON) += infineon/
 obj-$(CONFIG_WLAN_VENDOR_INTEL) += intel/
 obj-$(CONFIG_WLAN_VENDOR_INTERSIL) += intersil/
 obj-$(CONFIG_WLAN_VENDOR_MARVELL) += marvell/
diff --git a/drivers/net/wireless/infineon/Kconfig b/drivers/net/wireless/infineon/Kconfig
new file mode 100644
index 000000000000..7eeeb5935361
--- /dev/null
+++ b/drivers/net/wireless/infineon/Kconfig
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: ISC
+
+config WLAN_VENDOR_INFINEON
+       bool "Infineon devices"
+       default y
+       help
+         If you have a wireless card belonging to this class, say Y.
+
+         Note that the answer to this question doesn't directly affect the
+         kernel: saying N will just cause the configurator to skip all the
+         questions about these cards. If you say Y, you will be asked for
+         your specific card in the following questions.
+
+if WLAN_VENDOR_INFINEON
+
+source "drivers/net/wireless/infineon/inffmac/Kconfig"
+
+config INF_DEBUG
+	bool "Infineon driver debug functions"
+	depends on INFFMAC
+	select WANT_DEV_COREDUMP
+	help
+	  Selecting this enables additional code for debug purposes.
+
+endif # WLAN_VENDOR_INFINEON
diff --git a/drivers/net/wireless/infineon/Makefile b/drivers/net/wireless/infineon/Makefile
new file mode 100644
index 000000000000..25c8d9b701b0
--- /dev/null
+++ b/drivers/net/wireless/infineon/Makefile
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: ISC
+#
+# Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+# All rights reserved.
+#
+# Makefile fragment for Infineon 802.11 Networking Device Driver
+#
+
+# common flags
+subdir-ccflags-$(CONFIG_INF_DEBUG)	+= -DDEBUG
+
+obj-$(CONFIG_INFFMAC)	+= inffmac/
-- 
2.43.0

