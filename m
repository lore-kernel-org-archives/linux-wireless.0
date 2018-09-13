Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from grunblatt.org ([148.251.48.246]:60218 "EHLO grunblatt.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbeIMQXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 12:23:22 -0400
From: =?UTF-8?Q?R=c3=a9my_Gr=c3=bcnblatt?= <remy@grunblatt.org>
Subject: [PATCH] Minor corrections of comments in the iwlwifi mvm rate scaling
 source
To: linux-wireless@vger.kernel.org
Cc: linuxwifi@intel.com
Message-ID: <b403d919-57dd-aa2a-24f2-09d857cada5b@grunblatt.org> (sfid-20180913_131425_639216_3699924E)
Date: Thu, 13 Sep 2018 13:07:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I believe some comments in the rate scaling source of the iwlwifi mvm
are wrong, as we have #define RATE_MCS_SGI_POS  13 and #define
RATE_MCS_SGI_MSK  (1 << RATE_MCS_SGI_POS)

Thanks,

Rémy


Signed-off-by: Rémy Grünblatt <remy@grunblatt.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 30cfd7d50bc9..4a3acfd0ad5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3320,12 +3320,12 @@ static void rs_fill_rates_for_column(struct
iwl_mvm *mvm,
 /* Building the rate table is non trivial. When we're in
MIMO2/VHT/80Mhz/SGI
  * column the rate table should look like this:
  *
- * rate[0] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
- * rate[1] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
- * rate[2] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
- * rate[3] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
- * rate[4] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
- * rate[5] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[0] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 NGI
+ * rate[1] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 NGI
+ * rate[2] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 NGI
+ * rate[3] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 NGI
+ * rate[4] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 NGI
+ * rate[5] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 NGI
  * rate[6] 0x4005007 VHT | ANT: A BW: 80Mhz MCS: 7 NSS: 1 NGI
  * rate[7] 0x4009006 VHT | ANT: B BW: 80Mhz MCS: 6 NSS: 1 NGI
  * rate[8] 0x4005005 VHT | ANT: A BW: 80Mhz MCS: 5 NSS: 1 NGI
-- 
2.19.0
