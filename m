Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbbGLRIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 13:08:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/10] iwlwifi: nvm: remove mac address byte swapping in 8000 family
Date: Sun, 12 Jul 2015 20:08:20 +0300
Message-Id: <1436720900-18588-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150712_190850_697436_65D95F66)
In-Reply-To: <1436720814.17999.2.camel@intel.com>
References: <1436720814.17999.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

This fixes the byte order copying in the MAO (Mac Override
Section) section from the PNVM, as the byte swapping is not
required anymore in the 8000 family. Due to the byte
swapping, the driver was reporting an incorrect MAC
adddress.

CC: <stable@vger.kernel.org> [4.1]
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 80fefe7..3b8e85e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -540,13 +540,11 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 		hw_addr = (const u8 *)(mac_override +
 				 MAC_ADDRESS_OVERRIDE_FAMILY_8000);
 
-		/* The byte order is little endian 16 bit, meaning 214365 */
-		data->hw_addr[0] = hw_addr[1];
-		data->hw_addr[1] = hw_addr[0];
-		data->hw_addr[2] = hw_addr[3];
-		data->hw_addr[3] = hw_addr[2];
-		data->hw_addr[4] = hw_addr[5];
-		data->hw_addr[5] = hw_addr[4];
+		/*
+		 * Store the MAC address from MAO section.
+		 * No byte swapping is required in MAO section
+		 */
+		memcpy(data->hw_addr, hw_addr, ETH_ALEN);
 
 		/*
 		 * Force the use of the OTP MAC address in case of reserved MAC
-- 
2.1.4

