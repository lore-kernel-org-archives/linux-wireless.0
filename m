Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22170 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3HUGEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 7/8] iwlwifi: bump required firmware API version for 3160/7260
Date: Wed, 21 Aug 2013 09:04:25 +0300
Message-Id: <1377065066-13030-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080457_680243_6413C46F)
In-Reply-To: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit a2d0909a687b4d250cc2b7481072e361678745ba upstream.

As the firmware API has changed significantly and we don't
have support code for the old APIs, bump the version to be
able to release the version 7 API firmware. Unfortunately
this means that the driver in 3.9 and 3.10 can't work, but
that's still better than crashing the device/driver there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 50263e8..dc94d44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,16 +67,16 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	6
-#define IWL3160_UCODE_API_MAX	6
+#define IWL7260_UCODE_API_MAX	7
+#define IWL3160_UCODE_API_MAX	7
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	6
-#define IWL3160_UCODE_API_OK	6
+#define IWL7260_UCODE_API_OK	7
+#define IWL3160_UCODE_API_OK	7
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	6
-#define IWL3160_UCODE_API_MIN	6
+#define IWL7260_UCODE_API_MIN	7
+#define IWL3160_UCODE_API_MIN	7
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
-- 
1.7.10.4

