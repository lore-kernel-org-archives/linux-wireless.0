Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66E46982B
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246378; cv=none; b=kUZXFh0Ljr+jDhlSjSK8qoD6QfBhzq0e/ps4awwEK8PINdSYvbrAaMMgYv8tGC5p6h6Kgj31FhaczIiNhkCtUt79pbgSfy2MJibeWNxi8oThG41yBwen5z4HYpowFawqyHsw08B1lwWdqLB3j//UffyxDhKUJ38e29ek8C8bPyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246378; c=relaxed/simple;
	bh=G3YDxvp54FL/yWTQetjO6agr7VsbIEpIGOIAob0FFc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mT3pyS3MIvZ1YYlyOQ8jQDh49e7JS8FJv1mZR0FpXn7zkqOytPEvwQNISSJSEBYxytSBdqb6vQt4StEjr7RhLO23XkYlXQFiFzG/tKJ63l5PcXC8pUpTsoUcjPiEFYwWJRXTpuAj5R25TABRulhchUc5ZW4lZJpjotWqm4aV8hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOVmi2UD; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOVmi2UD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246377; x=1821782377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G3YDxvp54FL/yWTQetjO6agr7VsbIEpIGOIAob0FFc4=;
  b=dOVmi2UDPQrDrWmwO3ycbnYTgtEJwylS3IRPBPKOlYY3sarw/ptPrjCG
   I8SmkZk1Wj3Wvn3J4wOUBvdvVqjiLbmg2hIUM+lHb9hxexZytqnP1NJp+
   DXD0lcutZaEd/OBza89NNgvXXtcf2myTPceA+cOyjeIy3mB27/yYq7LHb
   Bbl0turrVtagzTYsrgcr7C/iNfn8//bL52GuCIFV4+Qb5lmMlmI+ybYML
   /Z1oNmJSWr47UN1B+CjH88Sc637UqZ09DoaejnfvCBcr5vARlNGndVSsO
   mwkS8vE6eYOA2kjslA6iJ27rd4+mXqeofej0wJ2HXZZvQh202tvbFsFdf
   A==;
X-CSE-ConnectionGUID: 15IpDh6FS6CR0rhQTMf8Jg==
X-CSE-MsgGUID: DmkMo5F+SkmRcNF8ehD3Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134870"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134870"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:36 -0700
X-CSE-ConnectionGUID: BHORdJv3Qx6HSAb2ZKvI3A==
X-CSE-MsgGUID: bc5OP+I7R8K2UgxvU7VRKA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:35 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: Revert "wifi: iwlwifi: pcie: move generation specific files to a folder"
Date: Thu, 24 Sep 2026 13:41:17 +0300
Message-Id: <20260924133942.77abfd661413.I25521996309a25ac779cb31f2c93477b25be9ac3@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

This reverts commit a6fafaedb5d6 ("wifi: iwlwifi: pcie: move generation
specific files to a folder").

The pcie/gen1_2/ subfolder was introduced to prepare for a future
pcie-transport, which will not happen eventually.
Move all the files back to the pcie folder and remove the gen1_2 folder.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile                 | 6 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c              | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c               | 2 +-
 .../net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/internal.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/rx.c   | 2 +-
 .../wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans-gen2.c   | 4 ++--
 .../net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans.c    | 2 +-
 .../net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx-gen2.c  | 0
 drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx.c   | 0
 11 files changed, 12 insertions(+), 12 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/internal.h (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/rx.c (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans-gen2.c (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans.c (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx-gen2.c (100%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx.c (100%)

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 2a74efe09cf0..6746281350e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -9,9 +9,9 @@ iwlwifi-objs		+= iwl-utils.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 
 # Bus
-iwlwifi-objs		+= pcie/ctxt-info.o pcie/ctxt-info-v2.o pcie/drv.o pcie/utils.o
-iwlwifi-objs		+= pcie/gen1_2/rx.o pcie/gen1_2/tx.o pcie/gen1_2/trans.o
-iwlwifi-objs		+= pcie/gen1_2/trans-gen2.o pcie/gen1_2/tx-gen2.o
+iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
+iwlwifi-objs		+= pcie/ctxt-info.o pcie/ctxt-info-v2.o pcie/trans-gen2.o pcie/tx-gen2.o
+iwlwifi-objs		+= pcie/utils.o
 
 CFLAGS_pcie/drv.o += -Wno-override-init
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 8cc8f6c4e934..24bf45f06746 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -12,7 +12,7 @@
 #include "iwl-drv.h"
 #include <linux/dmapool.h>
 #include "fw/api/commands.h"
-#include "pcie/gen1_2/internal.h"
+#include "pcie/internal.h"
 #include "pcie/iwl-context-info-v2.h"
 
 struct iwl_trans_dev_restart_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index 1ea23d297713..c75210829ec9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -6,7 +6,7 @@
 #include "iwl-trans.h"
 #include "iwl-fh.h"
 #include "iwl-context-info-v2.h"
-#include "gen1_2/internal.h"
+#include "internal.h"
 #include "iwl-prph.h"
 
 static const struct dmi_system_id dmi_force_scu_active_approved_list[] = {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 7f886200d693..23ec968577bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -6,7 +6,7 @@
 #include "iwl-trans.h"
 #include "iwl-fh.h"
 #include "iwl-context-info.h"
-#include "gen1_2/internal.h"
+#include "internal.h"
 #include "iwl-prph.h"
 
 static void *_iwl_pcie_ctxt_info_dma_alloc_coherent(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 4fa514ba9975..905482419a9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -15,7 +15,7 @@
 #include "iwl-trans.h"
 #include "iwl-drv.h"
 #include "iwl-prph.h"
-#include "gen1_2/internal.h"
+#include "internal.h"
 
 #define _IS_A(cfg, _struct) __builtin_types_compatible_p(typeof(cfg),	\
 							 struct _struct)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
similarity index 99%
rename from drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
rename to drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index cff02afa4e26..e10aa8e7e061 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -22,7 +22,7 @@
 #include "iwl-io.h"
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
-#include "pcie/iwl-context-info.h"
+#include "iwl-context-info.h"
 
 /*
  * RX related structures and functions
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
similarity index 99%
rename from drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c
rename to drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 4631e11f2a96..eb70922cf516 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -12,7 +12,7 @@
 #include "iwl-io.h"
 #include "internal.h"
 #include "iwl-op-mode.h"
-#include "pcie/iwl-context-info-v2.h"
+#include "iwl-context-info-v2.h"
 #include "fw/dbg.h"
 
 /******************************************************************************
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
similarity index 99%
rename from drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans-gen2.c
rename to drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index f41cbe62e7aa..39dd963920b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -5,8 +5,8 @@
  */
 #include "iwl-trans.h"
 #include "iwl-prph.h"
-#include "pcie/iwl-context-info.h"
-#include "pcie/iwl-context-info-v2.h"
+#include "iwl-context-info.h"
+#include "iwl-context-info-v2.h"
 #include "internal.h"
 #include "fw/dbg.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
similarity index 99%
rename from drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
rename to drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index db92c5c954e6..4771cf3b3e11 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -28,7 +28,7 @@
 #include "mei/iwl-mei.h"
 #include "internal.h"
 #include "iwl-fh.h"
-#include "pcie/iwl-context-info-v2.h"
+#include "iwl-context-info-v2.h"
 #include "pcie/utils.h"
 
 #define IWL_HOST_MON_BLOCK_PEMON	0x00
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx-gen2.c
rename to drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
rename to drivers/net/wireless/intel/iwlwifi/pcie/tx.c
-- 
2.34.1

