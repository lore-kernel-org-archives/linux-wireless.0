Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14016 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbZLXHbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 02:31:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: remove generated/utsrelease.h dependency
Date: Thu, 24 Dec 2009 15:31:10 +0800
Message-Id: <1261639870-17469-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 900bb717424e5df12b1ef7ebb017be2a8915b806 uses UTS_RELEASE
as the the in-tree iwlwifi driver version. However the inclusion
of generated/utsrelease.h makes it a unpleasant behaviour to
recompile the driver everytime when utsrelease.h is updated. In
fact, the driver module is already built with the UTS_RELEASE
information via vermagic of modinfo. Mark the in-tree driver
with the version string "in-tree" to distinguish with those old
out-of-tree drivers.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 308f679..375226b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,8 +63,6 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
-#include <generated/utsrelease.h>
-
 /************************
  * forward declarations *
  ************************/
@@ -72,7 +70,7 @@ struct iwl_host_cmd;
 struct iwl_cmd;
 
 
-#define IWLWIFI_VERSION UTS_RELEASE "-k"
+#define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
-- 
1.6.3.3

