Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaFXTxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:02 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so6592555wib.11
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:53:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/27] iwlwifi: mvm: disable beacon filtering escape timer in d0i3
Date: Tue, 24 Jun 2014 22:52:17 +0300
Message-Id: <1403639541-4621-23-git-send-email-egrumbach@gmail.com> (sfid-20140624_215309_224322_3F28DCA7)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The beacon filtering configuration in d0i3 currently uses
the max value defined as 1024. However, with beacon interval
of 100ms we end up with too-frequent wakeups.

Instead, configure the escape timer to 0, asking the fw
to disable it altogether.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index cbbcd8e..c3a8c86 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -336,7 +336,7 @@ struct iwl_beacon_filter_cmd {
 #define IWL_BF_DEBUG_FLAG_D0I3 0
 
 #define IWL_BF_ESCAPE_TIMER_DEFAULT 50
-#define IWL_BF_ESCAPE_TIMER_D0I3 1024
+#define IWL_BF_ESCAPE_TIMER_D0I3 0
 #define IWL_BF_ESCAPE_TIMER_MAX 1024
 #define IWL_BF_ESCAPE_TIMER_MIN 0
 
-- 
1.8.3.2

