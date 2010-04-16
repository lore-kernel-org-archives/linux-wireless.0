Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0DPB22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 21:28:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/2] iwmc3200wifi: check sparse endianness annotations
Date: Fri, 16 Apr 2010 09:28:44 +0800
Message-Id: <1271381324-21044-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
References: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

Add -D__CHECK_ENDIAN__ to driver ccflags so that sparse will
always check endianness by default.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Makefile b/drivers/net/wireless/iwmc3200wifi/Makefile
index aeed5cd..cdc7e07 100644
--- a/drivers/net/wireless/iwmc3200wifi/Makefile
+++ b/drivers/net/wireless/iwmc3200wifi/Makefile
@@ -6,3 +6,5 @@ iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
 iwmc3200wifi-$(CONFIG_IWM_TRACING) += trace.o
 
 CFLAGS_trace.o := -I$(src)
+
+ccflags-y += -D__CHECK_ENDIAN__
-- 
1.6.3.3

