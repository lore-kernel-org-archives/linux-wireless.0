Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196ECC43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDE5204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCDE5204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbeIYETr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46849 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbeIYETq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:46 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOC012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 02/11] qtnfmac_pcie: move Pearl pcie sources to pcie-specific directory
Date:   Mon, 24 Sep 2018 15:15:05 -0700
Message-Id: <20180924221514.4273-3-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to extract common qtnfmac PCIe driver sources into a
separate file, move existing Pearl-specific pcie driver sources to pcie/
directory.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile                       | 2 +-
 .../wireless/quantenna/qtnfmac/{pearl/pcie.c => pcie/pearl_pcie.c}    | 2 +-
 .../qtnfmac/{pearl/pcie_bus_priv.h => pcie/pearl_pcie_bus_priv.h}     | 4 ++--
 .../quantenna/qtnfmac/{pearl/pcie_ipc.h => pcie/pearl_pcie_ipc.h}     | 0
 .../qtnfmac/{pearl/pcie_regs_pearl.h => pcie/pearl_pcie_regs.h}       | 0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie.c => pcie/pearl_pcie.c} (99%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_bus_priv.h => pcie/pearl_pcie_bus_priv.h} (97%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h => pcie/pearl_pcie_ipc.h} (100%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h => pcie/pearl_pcie_regs.h} (100%)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/wireless/quantenna/qtnfmac/Makefile
index 97f760a..9eeddea 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -23,6 +23,6 @@ obj-$(CONFIG_QTNFMAC_PEARL_PCIE) += qtnfmac_pearl_pcie.o
 
 qtnfmac_pearl_pcie-objs += \
 	shm_ipc.o \
-	pearl/pcie.o
+	pcie/pearl_pcie.o
 
 qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) += debug.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
similarity index 99%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 97cc7f2..269a6e4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -29,7 +29,7 @@
 #include <linux/log2.h>
 
 #include "qtn_hw_ids.h"
-#include "pcie_bus_priv.h"
+#include "pearl_pcie_bus_priv.h"
 #include "core.h"
 #include "bus.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
similarity index 97%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
index 397875a..986b957 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
@@ -20,8 +20,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 
-#include "pcie_regs_pearl.h"
-#include "pcie_ipc.h"
+#include "pearl_pcie_regs.h"
+#include "pearl_pcie_ipc.h"
 #include "shm_ipc.h"
 
 struct bus;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
similarity index 100%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
similarity index 100%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
-- 
2.9.5

