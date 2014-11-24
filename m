Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44556 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaKXOfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:46 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so5951146wiw.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:45 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/75] iwlwifi: mvm: disable beacon filtering escape timer
Date: Mon, 24 Nov 2014 16:34:06 +0200
Message-Id: <1416839691-28533-30-git-send-email-egrumbach@gmail.com> (sfid-20141124_154138_489040_F0D669AC)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

There is no reason to pass every 50th beacon if
nothing was changed.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 2fd8ad4..4300200 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -370,7 +370,7 @@ struct iwl_beacon_filter_cmd {
 #define IWL_BF_DEBUG_FLAG_DEFAULT 0
 #define IWL_BF_DEBUG_FLAG_D0I3 0
 
-#define IWL_BF_ESCAPE_TIMER_DEFAULT 50
+#define IWL_BF_ESCAPE_TIMER_DEFAULT 0
 #define IWL_BF_ESCAPE_TIMER_D0I3 0
 #define IWL_BF_ESCAPE_TIMER_MAX 1024
 #define IWL_BF_ESCAPE_TIMER_MIN 0
-- 
1.9.1

