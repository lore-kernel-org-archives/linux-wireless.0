Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54827 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaCROpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:45 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so5377056eek.22
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/35] iwlwifi: pcie: suppress ACPI related error message
Date: Tue, 18 Mar 2014 16:45:06 +0200
Message-Id: <1395153939-23897-2-git-send-email-egrumbach@gmail.com> (sfid-20140318_154549_119760_E8D28D42)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This message triggers on systems that don't support the API,
so suppress them when not debugging as it's not useful to
see it there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 0f52e96..22b6b7e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -448,7 +448,8 @@ static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
 
 	pxsx_handle = ACPI_HANDLE(&pdev->dev);
 	if (!pxsx_handle) {
-		IWL_ERR(trans, "Could not retrieve root port ACPI handle");
+		IWL_DEBUG_INFO(trans,
+			       "Could not retrieve root port ACPI handle");
 		return;
 	}
 
-- 
1.8.3.2

