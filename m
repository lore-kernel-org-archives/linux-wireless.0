Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab3FXNTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:19:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9 3/4] iwlwifi: bump required firmware API version
Date: Mon, 24 Jun 2013 16:19:04 +0300
Message-Id: <1372079945-7445-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130624_152234_361183_F1CE2FB5)
In-Reply-To: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit a2d0909a687b4d250cc2b7481072e361678745ba upstream.

As the firmware API has changed significantly and we don't
have support code for the old APIs, bump the version to be
able to release the version 7 API firmware. Unfortunately
this means that the driver in 3.9 and 3.10 can't work, but
that's still better than crashing the device/driver there.

3.9 note: this allows support for the new devices in 3.9.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/7000.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/7000.c b/drivers/net/wireless/iwlwifi/pcie/7000.c
index 6e35b2b..25c33b0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/7000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/7000.c
@@ -31,16 +31,16 @@
 #include "cfg.h"
 
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

