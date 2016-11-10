Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yes.iam.tj ([109.74.197.121]:33932 "EHLO iam.tj"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755881AbcKJWLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 17:11:53 -0500
From: Tj <linux@iam.tj>
Subject: [PATCH] iwlwifi: fix undefined 6000G2B firmware MAX API version
To: "open list:INTEL WIRELESS WIFI LINK (iwlwifi)"
        <linux-wireless@vger.kernel.org>
Cc: "Intel Linux Wireless (supporter:INTEL WIRELESS WIFI LINK (iwlwifi))"
        <linuxwifi@intel.com>
Message-ID: <78f29b89-eb19-920f-f576-5009383c55e1@iam.tj> (sfid-20161110_231156_851738_0F2FD314)
Date: Thu, 10 Nov 2016 22:04:24 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  $ modinfo -F firmware iwlwifi | grep API
  iwlwifi-6000g2b-IWL6000G2B_UCODE_API_MAX.ucode
  $ modinfo -F vermagic iwlwifi
  4.9.0-040900rc4-lowlatency SMP preempt mod_unload modversions

Change-Id: Ie21a4be0b12b520844c1da4a8bef9e8a0097d919
Signed-off-by: TJ <linux@iam.tj>
---
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 0b9f6a7..19b85e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -34,6 +34,7 @@
 #define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
+#define IWL6000G2B_UCODE_API_MAX 6
 #define IWL6035_UCODE_API_MAX 6
  /* Lowest firmware API version supported */
-- 
2.7.4
