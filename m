Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:56957 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753485AbdF0PZh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 11:25:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Golan Ben-Ami <golan.ben.ami@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: fix iwl_mvm_sar_find_wifi_pkg corner case
Date: Tue, 27 Jun 2017 17:24:17 +0200
Message-Id: <20170627152458.1103403-1-arnd@arndb.de> (sfid-20170627_172741_443008_CD1C9598)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc warns about what it thinks is an uninitialized variable
access:

drivers/net/wireless/intel/iwlwifi/mvm/fw.c: In function 'iwl_mvm_sar_find_wifi_pkg.isra.14':
drivers/net/wireless/intel/iwlwifi/mvm/fw.c:1102:5: error: 'wifi_pkg' may be used uninitialized in this function [-Werror=maybe-uninitialized]

That problem cannot really happen, as we check data->package.count
to ensure that the loop is entered at least once.
However, something that can indeed happen is returning an incorrect
wifi_pkg pointer in case none of the elements are what we are looking
for.

This modifies the loop again, to only return a correct object, and
to shut up that warning.

Fixes: c386dacb4ed6 ("iwlwifi: mvm: refactor SAR init to prepare for dynamic SAR")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 24cc406d87ef..730c7f68c0b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1094,14 +1094,12 @@ static union acpi_object *iwl_mvm_sar_find_wifi_pkg(struct iwl_mvm *mvm,
 		domain = &wifi_pkg->package.elements[0];
 		if (domain->type == ACPI_TYPE_INTEGER &&
 		    domain->integer.value == ACPI_WIFI_DOMAIN)
-			break;
-
-		wifi_pkg = NULL;
+			goto found;
 	}
 
-	if (!wifi_pkg)
-		return ERR_PTR(-ENOENT);
+	return ERR_PTR(-ENOENT);
 
+found:
 	return wifi_pkg;
 }
 
-- 
2.9.0
