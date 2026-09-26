Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A821E7660
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442942; cv=none; b=CRBeD9ZFcgE/JpT6FQeNd04QN1VQTJYjqo72Ud2AVON7UjmFcwJZZ06OtQIq/jAqhrsAUWWZt4xxsiLDMOX4j9q8xIYXkLHFyitiJWEJcq6g3h26DO5Gd5EwMtJ4NR5uP8xj9HSaAIjksNJ3tudFYndfOlwK4R0ZTSBfDDq9s7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442942; c=relaxed/simple;
	bh=G3YDxvp54FL/yWTQetjO6agr7VsbIEpIGOIAob0FFc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R8FfUosGVK2cEfvp8ujT576bo9g5N1Fvg+Vs1ua64OBFqUB+wycAp8iGS5ArfSmAU06eSnwW+Muj/XCtRso12g+o9vxnlmQDUO56tZNRJN0YyYwd5r9H9l7OrqyKQqWT3Ga6XpGXwKCCU9nT+J7QWVTTYe8mmf+RDklvf/SHSWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hi+R5Sv1; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hi+R5Sv1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442941; x=1821978941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G3YDxvp54FL/yWTQetjO6agr7VsbIEpIGOIAob0FFc4=;
  b=Hi+R5Sv1VBdHkBMJc4oYt0JLRylUzcqGk8Z6PahMjkT7GE3kBZqa1vmx
   QHRwJhj4eue1GzDK5L2zG0MdLv5x1MKrlVdHl+7wUqwie3+SWgfWQp1dt
   qd9LCHJVEp2OVU43gNQGEpnAIgxKSP8Y1pZTlvoN3U1hPEIIxL0k/f+qt
   UG0yxurdjSpRR5NHZ1e2kxjhmUG/QQ/dbi+DaMNRVoVsbxVEVU2JXgyfc
   9gM6CVotyzdYjUcTbXMal/VLt34jao9WABVQiLm2lq4cmtKqxNQbUDkml
   kSpJAGJ0tgOT7aUYOf6pfGhE/VIb6m0tIduF6TjlVhywX54OQuKKI2lzw
   Q==;
X-CSE-ConnectionGUID: y1VdUD4gQhGnW2dhWRw5fQ==
X-CSE-MsgGUID: OYkeFsY8RT+fM2j5eJH3Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533277"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533277"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:41 -0700
X-CSE-ConnectionGUID: Ogy80a6dRG6y5y05hD89Xw==
X-CSE-MsgGUID: uWxs+cTrRaKOudUAuCjetA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196927"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:40 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 iwlwifi-next 03/15] wifi: iwlwifi: Revert "wifi: iwlwifi: pcie: move generation specific files to a folder"
Date: Sat, 26 Sep 2026 20:17:22 +0300
Message-Id: <20260926201527.91ac209ad70d.I25521996309a25ac779cb31f2c93477b25be9ac3@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
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

