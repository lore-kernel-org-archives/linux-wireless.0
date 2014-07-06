Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64865 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGFJg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:58 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so1345368wgg.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/40] iwlwifi: 8000: drop a print when the address is invalid
Date: Sun,  6 Jul 2014 12:35:59 +0300
Message-Id: <1404639376-3792-23-git-send-email-egrumbach@gmail.com> (sfid-20140706_115951_898388_F0FFC6A0)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

when driver takes the MAC address from the HW section and
it isn't valid - print an error.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index dd76ed2..018af29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -549,6 +549,9 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 			data->hw_addr[1] = hw_addr[2];
 			data->hw_addr[0] = hw_addr[3];
 		}
+		if (!is_valid_ether_addr(data->hw_addr))
+			IWL_ERR_DEV(dev,
+				    "mac address from hw section is not valid\n");
 
 		return;
 	}
-- 
1.8.3.2

