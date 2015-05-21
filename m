Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422790AbbEUTxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/10] iwlwifi: nvm: force mac from otp in case nvm mac is reserved
Date: Thu, 21 May 2015 22:53:06 +0300
Message-Id: <1432237990-5890-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215411_397492_80964C93)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Take the MAC address from the OTP even if one is present in
the NVM, if that MAC address happens to be a reserved one.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index cf86f3c..75e96db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -533,6 +533,10 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 	const u8 *hw_addr;
 
 	if (mac_override) {
+		static const u8 reserved_mac[] = {
+			0x02, 0xcc, 0xaa, 0xff, 0xee, 0x00
+		};
+
 		hw_addr = (const u8 *)(mac_override +
 				 MAC_ADDRESS_OVERRIDE_FAMILY_8000);
 
@@ -544,7 +548,12 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 		data->hw_addr[4] = hw_addr[5];
 		data->hw_addr[5] = hw_addr[4];
 
-		if (is_valid_ether_addr(data->hw_addr))
+		/*
+		 * Force the use of the OTP MAC address in case of reserved MAC
+		 * address in the NVM, or if address is given but invalid.
+		 */
+		if (is_valid_ether_addr(data->hw_addr) &&
+		    memcmp(reserved_mac, hw_addr, ETH_ALEN) != 0)
 			return;
 
 		IWL_ERR_DEV(dev,
-- 
2.1.4

