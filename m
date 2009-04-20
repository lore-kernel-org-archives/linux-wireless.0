Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbZDTVbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:02 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.30 and w-t 01/11] iwlwifi: fix EEPROM validation mask to include OTP only devices
Date: Mon, 20 Apr 2009 14:36:54 -0700
Message-Id: <1240263424-8495-2-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233112_733765_DD21B507)
In-Reply-To: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

Fix the bug where some revisions of 6000 series hardware cannot
be used. Later versions of 6000 series have the EEPROM replaced by
OTP. For these devices to be used we need to expand valid EEPROM mask.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Please apply this patch to 2.6.30 also.

 drivers/net/wireless/iwlwifi/iwl-csr.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 2f12424..6e98314 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -223,7 +223,7 @@
 #define CSR_EEPROM_REG_MSK_DATA		(0xFFFF0000)
 
 /* EEPROM GP */
-#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
+#define CSR_EEPROM_GP_VALID_MSK		(0x00000007)
 #define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
 #define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
 
-- 
1.5.6.3

