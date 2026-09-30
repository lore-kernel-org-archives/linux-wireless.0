Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46C44534A9
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759901; cv=none; b=t+7zRxqsBBgrc7W62i8a+5GCI0+i8vWQex0hFDwR5xnbnlZCxTmA+Dqcou/tjzqGCbO4uZQKUZgGXSd/AVGZAWqLf+4h5zFHWgk8WyZ75YoFH8xp2G1gQB3bafoKOLnTBbXa/uYa07E6kEDYmWGDgAwzvY0IdvxPshjcZLaSreM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759901; c=relaxed/simple;
	bh=XDy37cPPWekJ9jzQVbbhOpX9umm11VYwMMs/tV4nUAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TMyiX57VjD29xED3973FVqxkDo9YonjwO9xChTBHVYb3JI4HtRlkXcovzmPmCvBEtCINuRFWzb7D0usMiE5yUbKqIl8TjV0yFp+DHOFvLdleo5aToQSJIIAuAaiH8SL7kMnCIFP9JqwUeOfMpY9bATOZWdNye3Yi8KQc43pHdcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kLH8c5ya; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kLH8c5ya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759896; x=1822295896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XDy37cPPWekJ9jzQVbbhOpX9umm11VYwMMs/tV4nUAk=;
  b=kLH8c5yaFh5vZcAjdg2F3RgOaZKWUDCrA0y+4XeIZW5p+1yRfLCUQYq8
   BtFqPiPz3dFUYSkrZilNu5Qlj3vkAuyaVCrg1YtLR6Owh45o3Yjn31kFv
   U7kv3ba7NyCidQJprX+b8uDeEkiOqeggBSrU7YPKUhiDWrZlUmDUTvgoc
   Nl1hz0DD6hg9C0zFKZrPj2CHDewvw7865dPF3euLvmTGA7NnM9xmzbzwe
   ev9axpV6vDvf+n4AeoAY9o7bH/aJeeNndxkj+a/CZVvdiSNcdoWJWo+Yv
   SMmugrBalC5dnOWrF+C9OgXgO5PEwdiFwKoJm/nay6mWqMf1EhkBt4j9M
   g==;
X-CSE-ConnectionGUID: zWlZna15Rie4J7MEviU/5A==
X-CSE-MsgGUID: qj3LPO+CTkyX5hbUxh/4Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447027"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447027"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:15 -0700
X-CSE-ConnectionGUID: MGfK9dVGRhidDHT5ZAlvzA==
X-CSE-MsgGUID: UrCaGxSEQpuN/pfM+X2RTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673570"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 11/15] wifi: iwlwifi: move iwl-io functions to iwl-trans
Date: Wed, 30 Sep 2026 12:19:48 +0300
Message-Id: <20260930121740.28c8b1af4303.I93a06977d9f5affa16c699d32e0e0577e49a534e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
References: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

This commit completes the removal of iwl-io.
Now that all io helpers use the iwl_trans_ prefix, move them to
iwl-trans.h/c.
Includers are updated to pull in iwl-trans.h

No functional change.

Assisted-by: GitHubCopilot:claude-opus-4.8
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile   |  1 -
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  |  1 -
 .../net/wireless/intel/iwlwifi/dvm/devices.c  |  2 +-
 .../net/wireless/intel/iwlwifi/dvm/eeprom.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c  |  1 -
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c  |  2 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |  1 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  2 +-
 .../net/wireless/intel/iwlwifi/dvm/power.c    |  3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   |  1 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c   |  3 +-
 .../net/wireless/intel/iwlwifi/dvm/ucode.c    |  3 +-
 .../net/wireless/intel/iwlwifi/fw/dbg-old.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 99 -------------------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   | 72 --------------
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h  |  1 -
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 89 +++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 60 +++++++++++
 .../net/wireless/intel/iwlwifi/mld/debugfs.c  |  2 +-
 .../intel/iwlwifi/mld/ftm-initiator.c         |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  2 +-
 .../intel/iwlwifi/mvm/ftm-initiator.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c  |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c |  4 +-
 .../wireless/intel/iwlwifi/mvm/time-event.c   |  1 -
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/utils.c   |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/utils.h   |  2 +-
 43 files changed, 181 insertions(+), 214 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-io.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-io.h

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 6746281350e0..504381b4aac7 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # common
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
-iwlwifi-objs		+= iwl-io.o
 iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-debug.o
 iwlwifi-objs		+= iwl-nvm-utils.o
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index ed041710c74f..799599efdd06 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -14,7 +14,6 @@
 
 #include "iwl-debug.h"
 #include "iwl-trans.h"
-#include "iwl-io.h"
 #include "dev.h"
 #include "agn.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index c22f68db3e83..b7bd5e6deb5d 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -10,7 +10,7 @@
 /*
  * DVM device-specific data & functions
  */
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "iwl-nvm-utils.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c b/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
index aa532635e414..190e482849ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c
@@ -8,7 +8,7 @@
 
 #include "iwl-drv.h"
 #include "iwl-debug.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 #include "agn.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index 6fa02cd0ab04..17b045ddb910 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -14,7 +14,6 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <linux/unaligned.h>
-#include "iwl-io.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
 #include "dev.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 2e16799818e4..37d6f2cf7efb 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -2,6 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2008 - 2014, 2022 Intel Corporation. All rights reserved.
+ * Copyright (C) 2026 Intel Corporation
  *****************************************************************************/
 #include <linux/etherdevice.h>
 #include <linux/kernel.h>
@@ -9,7 +10,6 @@
 #include <linux/sched.h>
 #include <net/mac80211.h>
 
-#include "iwl-io.h"
 #include "iwl-agn-hw.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 1da59e724054..e83bf615c161 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -23,7 +23,6 @@
 
 #include <asm/div64.h>
 
-#include "iwl-io.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-modparams.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index b3f73c773abe..4bf69f7a35a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -27,8 +27,8 @@
 #include <asm/div64.h>
 
 #include "iwl-nvm-utils.h"
-#include "iwl-io.h"
 #include "iwl-trans.h"
+#include "iwl-devtrace.h"
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.c b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
index e7dbba7134f7..4e19799d15d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.c
@@ -2,7 +2,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright (C) 2019, 2025 Intel Corporation
+ * Copyright (C) 2019, 2025-2026 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
-#include "iwl-io.h"
 #include "iwl-debug.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 77aa7e04854f..fa2aff5bea6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -16,7 +16,6 @@
 #include <linux/unaligned.h>
 
 #include "iwl-trans.h"
-#include "iwl-io.h"
 #include "dev.h"
 #include "calib.h"
 #include "agn.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
index c4ee22876f77..a414eb7c2446 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-modparams.h"
 #include "iwl-debug.h"
 #include "agn.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index 1a0167f67c7b..8dbc52971e7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -3,14 +3,13 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright (C) 2019 Intel Corporation
- * Copyright (C) 2023, 2025 Intel Corporation
+ * Copyright (C) 2023, 2025-2026 Intel Corporation
  *****************************************************************************/
 
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/ieee80211.h>
-#include "iwl-io.h"
 #include "iwl-trans.h"
 #include "iwl-agn-hw.h"
 #include "dev.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
index ac90191a3973..2ab1a32d774e 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
@@ -3,12 +3,11 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Deutschland GmbH
- * Copyright (C) 2025 Intel Corporation
+ * Copyright (C) 2025-2026 Intel Corporation
  *****************************************************************************/
 
 #include <linux/kernel.h>
 
-#include "iwl-io.h"
 #include "iwl-agn-hw.h"
 #include "iwl-trans.h"
 #include "iwl-fh.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
index 320e891b3b03..09c798d2eba3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c
@@ -9,7 +9,7 @@
 #include "runtime.h"
 #include "dbg.h"
 #include "debugfs.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 #include "iwl-fh.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8827e4f317f1..8be5202dba94 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -9,7 +9,7 @@
 #include "runtime.h"
 #include "dbg.h"
 #include "debugfs.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 #include "iwl-fh.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index fc962a320583..70134d8f03c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -10,7 +10,7 @@
 #include <net/cfg80211.h>
 #include "runtime.h"
 #include "iwl-prph.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "file.h"
 #include "error-dump.h"
 #include "api/commands.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index deb7af465746..b76abc77f495 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -9,7 +9,7 @@
 #include "runtime.h"
 #include "dbg.h"
 #include "debugfs.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 #include "pnvm.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 6e863059ffa7..ccd190ab8a55 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -6,7 +6,7 @@
 #include "iwl-drv.h"
 #include "pnvm.h"
 #include "iwl-prph.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "fw/api/commands.h"
 #include "fw/api/nvm-reg.h"
 #include "fw/api/alive.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index dffd5e68f41d..89a0f722cad9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -6,7 +6,7 @@
 #include "iwl-drv.h"
 #include "pnvm.h"
 #include "iwl-prph.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 
 #include "fw/uefi.h"
 #include "fw/api/alive.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
deleted file mode 100644
index 09965fb39fb6..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ /dev/null
@@ -1,99 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
-/*
- * Copyright (C) 2003-2014, 2018-2022, 2024-2026 Intel Corporation
- * Copyright (C) 2015-2016 Intel Deutschland GmbH
- */
-#include <linux/device.h>
-#include <linux/export.h>
-
-#include "iwl-drv.h"
-#include "iwl-io.h"
-#include "iwl-csr.h"
-#include "iwl-debug.h"
-
-#define IWL_POLL_INTERVAL 10	/* microseconds */
-
-int iwl_trans_poll_bits_mask(struct iwl_trans *trans, u32 addr,
-			     u32 bits, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((iwl_trans_read32(trans, addr) & mask) == (bits & mask))
-			return 0;
-		udelay(IWL_POLL_INTERVAL);
-		t += IWL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-IWL_EXPORT_SYMBOL(iwl_trans_poll_bits_mask);
-
-void iwl_trans_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_trans_write32(trans, reg, value);
-		iwl_trans_release_nic_access(trans);
-	}
-}
-IWL_EXPORT_SYMBOL(iwl_trans_write_direct32);
-
-u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		u32 val = iwl_trans_read_prph_no_grab(trans, ofs);
-
-		iwl_trans_release_nic_access(trans);
-
-		return val;
-	}
-
-	/* return as if we have a HW timeout/failure */
-	return 0x5a5a5a5a;
-}
-IWL_EXPORT_SYMBOL(iwl_trans_read_prph);
-
-void iwl_trans_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val, u32 delay_ms)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		mdelay(delay_ms);
-		iwl_trans_write_prph_no_grab(trans, ofs, val);
-		iwl_trans_release_nic_access(trans);
-	}
-}
-IWL_EXPORT_SYMBOL(iwl_trans_write_prph_delay);
-
-void iwl_trans_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_trans_write_prph_no_grab(trans, ofs,
-					     iwl_trans_read_prph_no_grab(trans, ofs) |
-					     mask);
-		iwl_trans_release_nic_access(trans);
-	}
-}
-IWL_EXPORT_SYMBOL(iwl_trans_set_bits_prph);
-
-void iwl_trans_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
-				  u32 bits, u32 mask)
-{
-	if (iwl_trans_grab_nic_access(trans)) {
-		iwl_trans_write_prph_no_grab(trans, ofs,
-					     (iwl_trans_read_prph_no_grab(trans, ofs) &
-					      mask) | bits);
-		iwl_trans_release_nic_access(trans);
-	}
-}
-IWL_EXPORT_SYMBOL(iwl_trans_set_bits_mask_prph);
-
-void iwl_trans_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
-{
-	u32 val;
-
-	if (iwl_trans_grab_nic_access(trans)) {
-		val = iwl_trans_read_prph_no_grab(trans, ofs);
-		iwl_trans_write_prph_no_grab(trans, ofs, (val & ~mask));
-		iwl_trans_release_nic_access(trans);
-	}
-}
-IWL_EXPORT_SYMBOL(iwl_trans_clear_bits_prph);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
deleted file mode 100644
index 5cb422a4d9de..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ /dev/null
@@ -1,72 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
-/*
- * Copyright (C) 2018-2021, 2025-2026 Intel Corporation
- */
-#ifndef __iwl_io_h__
-#define __iwl_io_h__
-
-#include "iwl-devtrace.h"
-#include "iwl-trans.h"
-
-static inline void iwl_trans_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
-{
-	iwl_trans_set_bits_mask(trans, reg, mask, mask);
-}
-
-static inline void iwl_trans_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
-{
-	iwl_trans_set_bits_mask(trans, reg, mask, 0);
-}
-
-int iwl_trans_poll_bits_mask(struct iwl_trans *trans, u32 addr,
-			     u32 bits, u32 mask, int timeout);
-static inline int iwl_trans_poll_bits(struct iwl_trans *trans, u32 addr, u32 bits,
-				      int timeout)
-{
-	return iwl_trans_poll_bits_mask(trans, addr, bits, bits, timeout);
-}
-
-void iwl_trans_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
-
-
-u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs);
-void iwl_trans_write_prph_delay(struct iwl_trans *trans, u32 ofs,
-				u32 val, u32 delay_ms);
-static inline void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
-{
-	iwl_trans_write_prph_delay(trans, ofs, val, 0);
-}
-
-void iwl_trans_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
-void iwl_trans_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
-				  u32 bits, u32 mask);
-void iwl_trans_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
-
-/*
- * UMAC periphery address space changed from 0xA00000 to 0xD00000 starting from
- * device family AX200. So peripheries used in families above and below AX200
- * should go through iwl_trans_..._umac_..._prph.
- */
-static inline u32 iwl_trans_umac_prph(struct iwl_trans *trans, u32 ofs)
-{
-	return ofs + trans->mac_cfg->umac_prph_offset;
-}
-
-static inline u32 iwl_trans_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
-{
-	return iwl_trans_read_prph_no_grab(trans, ofs +
-					   trans->mac_cfg->umac_prph_offset);
-}
-
-static inline u32 iwl_trans_read_umac_prph(struct iwl_trans *trans, u32 ofs)
-{
-	return iwl_trans_read_prph(trans, ofs + trans->mac_cfg->umac_prph_offset);
-}
-
-static inline void iwl_trans_write_umac_prph(struct iwl_trans *trans, u32 ofs,
-					     u32 val)
-{
-	iwl_trans_write_prph(trans,  ofs + trans->mac_cfg->umac_prph_offset, val);
-}
-
-#endif
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 9a8355514c4f..ed2b094c1ad7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -16,7 +16,7 @@
 #include "iwl-modparams.h"
 #include "iwl-nvm-parse.h"
 #include "iwl-prph.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "fw/api/nvm-reg.h"
 #include "fw/api/commands.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
index 22a7da73a918..f13568d3094b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-scd.h
@@ -7,7 +7,6 @@
 #define __iwl_scd_h__
 
 #include "iwl-trans.h"
-#include "iwl-io.h"
 #include "iwl-prph.h"
 
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 59b4e180825f..09e5b606df26 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -6,6 +6,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
+#include <linux/delay.h>
 #include <linux/list.h>
 
 #include "iwl-trans.h"
@@ -450,6 +451,94 @@ void iwl_trans_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 	return iwl_pcie_write_prph_no_grab(trans, ofs, val);
 }
 
+#define IWL_POLL_INTERVAL 10	/* microseconds */
+
+int iwl_trans_poll_bits_mask(struct iwl_trans *trans, u32 addr,
+			     u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_trans_read32(trans, addr) & mask) == (bits & mask))
+			return 0;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+IWL_EXPORT_SYMBOL(iwl_trans_poll_bits_mask);
+
+void iwl_trans_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		iwl_trans_write32(trans, reg, value);
+		iwl_trans_release_nic_access(trans);
+	}
+}
+IWL_EXPORT_SYMBOL(iwl_trans_write_direct32);
+
+u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		u32 val = iwl_trans_read_prph_no_grab(trans, ofs);
+
+		iwl_trans_release_nic_access(trans);
+
+		return val;
+	}
+
+	/* return as if we have a HW timeout/failure */
+	return 0x5a5a5a5a;
+}
+IWL_EXPORT_SYMBOL(iwl_trans_read_prph);
+
+void iwl_trans_write_prph_delay(struct iwl_trans *trans, u32 ofs, u32 val,
+				u32 delay_ms)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		mdelay(delay_ms);
+		iwl_trans_write_prph_no_grab(trans, ofs, val);
+		iwl_trans_release_nic_access(trans);
+	}
+}
+IWL_EXPORT_SYMBOL(iwl_trans_write_prph_delay);
+
+void iwl_trans_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		iwl_trans_write_prph_no_grab(trans, ofs,
+					     iwl_trans_read_prph_no_grab(trans, ofs) |
+					     mask);
+		iwl_trans_release_nic_access(trans);
+	}
+}
+IWL_EXPORT_SYMBOL(iwl_trans_set_bits_prph);
+
+void iwl_trans_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
+				  u32 bits, u32 mask)
+{
+	if (iwl_trans_grab_nic_access(trans)) {
+		iwl_trans_write_prph_no_grab(trans, ofs,
+					     (iwl_trans_read_prph_no_grab(trans, ofs) &
+					      mask) | bits);
+		iwl_trans_release_nic_access(trans);
+	}
+}
+IWL_EXPORT_SYMBOL(iwl_trans_set_bits_mask_prph);
+
+void iwl_trans_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
+{
+	u32 val;
+
+	if (iwl_trans_grab_nic_access(trans)) {
+		val = iwl_trans_read_prph_no_grab(trans, ofs);
+		iwl_trans_write_prph_no_grab(trans, ofs, (val & ~mask));
+		iwl_trans_release_nic_access(trans);
+	}
+}
+IWL_EXPORT_SYMBOL(iwl_trans_clear_bits_prph);
+
 void iwl_trans_force_nmi(struct iwl_trans *trans)
 {
 	if (trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_9000)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 18c1c46c11ce..a32b03f19c3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -977,6 +977,66 @@ int iwl_trans_sw_reset(struct iwl_trans *trans);
 void iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg,
 			     u32 mask, u32 value);
 
+static inline void iwl_trans_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+{
+	iwl_trans_set_bits_mask(trans, reg, mask, mask);
+}
+
+static inline void iwl_trans_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
+{
+	iwl_trans_set_bits_mask(trans, reg, mask, 0);
+}
+
+int iwl_trans_poll_bits_mask(struct iwl_trans *trans, u32 addr,
+			     u32 bits, u32 mask, int timeout);
+static inline int iwl_trans_poll_bits(struct iwl_trans *trans, u32 addr, u32 bits,
+				      int timeout)
+{
+	return iwl_trans_poll_bits_mask(trans, addr, bits, bits, timeout);
+}
+
+void iwl_trans_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
+
+u32 iwl_trans_read_prph(struct iwl_trans *trans, u32 ofs);
+void iwl_trans_write_prph_delay(struct iwl_trans *trans, u32 ofs,
+				u32 val, u32 delay_ms);
+static inline void iwl_trans_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
+{
+	iwl_trans_write_prph_delay(trans, ofs, val, 0);
+}
+
+void iwl_trans_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
+void iwl_trans_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
+				  u32 bits, u32 mask);
+void iwl_trans_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
+
+/*
+ * UMAC periphery address space changed from 0xA00000 to 0xD00000 starting from
+ * device family AX200. So peripheries used in families above and below AX200
+ * should go through iwl_trans_..._umac_..._prph.
+ */
+static inline u32 iwl_trans_umac_prph(struct iwl_trans *trans, u32 ofs)
+{
+	return ofs + trans->mac_cfg->umac_prph_offset;
+}
+
+static inline u32 iwl_trans_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
+{
+	return iwl_trans_read_prph_no_grab(trans, ofs +
+					   trans->mac_cfg->umac_prph_offset);
+}
+
+static inline u32 iwl_trans_read_umac_prph(struct iwl_trans *trans, u32 ofs)
+{
+	return iwl_trans_read_prph(trans, ofs + trans->mac_cfg->umac_prph_offset);
+}
+
+static inline void iwl_trans_write_umac_prph(struct iwl_trans *trans, u32 ofs,
+					     u32 val)
+{
+	iwl_trans_write_prph(trans, ofs + trans->mac_cfg->umac_prph_offset, val);
+}
+
 bool iwl_trans_grab_nic_access(struct iwl_trans *trans);
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
index dd4bf7cb6a79..b8793b71494d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/debugfs.c
@@ -5,7 +5,7 @@
 
 #include "mld.h"
 #include "debugfs.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "hcmd.h"
 #include "iface.h"
 #include "sta.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
index a4b8037b5c76..a6a4f9672e4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
@@ -8,7 +8,7 @@
 #include "mld.h"
 #include "iface.h"
 #include "phy.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "constants.h"
 #include "fw/api/location.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 48f8bab4dc85..90175307a7db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -13,7 +13,7 @@
 
 #include "mvm.h"
 #include "sta.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "debugfs.h"
 #include "iwl-modparams.h"
 #include "iwl-drv.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 8d7f60dcd027..4c39a452564d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -7,7 +7,7 @@
 #include <linux/math64.h>
 #include <net/cfg80211.h>
 #include "mvm.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "constants.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index 264423943b60..ac238c963855 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
 #include <linux/leds.h>
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "mvm.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b2c5be22c293..509e80fa0df5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -7,7 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/crc32.h>
 #include <net/mac80211.h>
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "fw-api.h"
 #include "mvm.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a4f3d3c2bd35..daa05339e3fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -19,7 +19,7 @@
 
 #include "iwl-drv.h"
 #include "iwl-op-mode.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "mvm.h"
 #include "sta.h"
 #include "time-event.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 653c620361d5..183251457361 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -20,7 +20,6 @@
 #include "iwl-phy-db.h"
 #include "iwl-nvm-utils.h"
 #include "iwl-csr.h"
-#include "iwl-io.h"
 #include "iwl-prph.h"
 #include "rs.h"
 #include "fw/api/scan.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index a94eaca0b3ed..c12eda75317d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -10,7 +10,7 @@
 
 #include "mvm.h"
 #include "fw/api/scan.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-utils.h"
 
 #define IWL_DENSE_EBS_SCAN_RATIO 5
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index a7cd2e4ba1ae..6aac71cfccb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -2,12 +2,12 @@
 /*
  * Copyright (C) 2014 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020, 2022-2025 Intel Corporation
+ * Copyright (C) 2018-2020, 2022-2026 Intel Corporation
  */
 #include <linux/etherdevice.h>
 #include "mvm.h"
 #include "time-event.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 
 #define TU_TO_US(x) (x * 1024)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 93b46c9e2333..5a800d3f2a98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -12,7 +12,6 @@
 #include "fw-api.h"
 #include "time-event.h"
 #include "mvm.h"
-#include "iwl-io.h"
 #include "iwl-prph.h"
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index cd0d89feecea..e97ab2c9e5ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -7,7 +7,7 @@
 #include <net/mac80211.h>
 
 #include "iwl-debug.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
 #include "mvm.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index d74742df2fe5..e0ac9f2e6526 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -18,8 +18,8 @@
 #include "iwl-fh.h"
 #include "iwl-csr.h"
 #include "iwl-trans.h"
+#include "iwl-devtrace.h"
 #include "iwl-debug.h"
-#include "iwl-io.h"
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
 #include "iwl-context-info.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index e3fe5a912a8b..f033bb51dcca 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -9,7 +9,7 @@
 #include <linux/gfp.h>
 
 #include "iwl-prph.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "internal.h"
 #include "pcie/utils.h"
 #include "iwl-op-mode.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index abdb2548827f..e6bebd37417f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -8,7 +8,7 @@
 
 #include "iwl-debug.h"
 #include "iwl-csr.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "internal.h"
 #include "fw/api/tx.h"
 #include "fw/api/commands.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index c217e5189df4..d612678ae122 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -20,7 +20,7 @@
 #include "iwl-debug.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "iwl-scd.h"
 #include "iwl-op-mode.h"
 #include "internal.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
index eb54b5da1d25..8aa43e5ac0e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.c
@@ -6,7 +6,7 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "pcie/utils.h"
 
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
index 74c23ec199e2..ece1caaa4948 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/utils.h
@@ -6,7 +6,7 @@
 #ifndef __iwl_pcie_utils_h__
 #define __iwl_pcie_utils_h__
 
-#include "iwl-io.h"
+#include "iwl-trans.h"
 #include "internal.h"
 
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans, struct pci_dev *pdev);
-- 
2.34.1

