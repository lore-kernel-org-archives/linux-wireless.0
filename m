Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:44634 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031338AbeCAOVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:11 -0500
Received: by mail-qk0-f194.google.com with SMTP id v124so7672854qkh.11
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:11 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 17/52] ath: Add regulatory mapping for APL13_WORLD
Date: Thu,  1 Mar 2018 15:18:27 +0100
Message-Id: <20180301141902.24824-18-sven.eckelmann@openmesh.com> (sfid-20180301_152119_608421_0493F731)
In-Reply-To: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdomain code is used to select the correct the correct conformance
test limits (CTL) for a country. If the regdomain code isn't available and
it is still programmed in the EEPROM then it will cause an error and stop
the initialization with:

  Invalid EEPROM contents

The current CTL mappings for this regdomain code are:

* 2.4GHz: ETSI
* 5GHz: ETSI

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 44e3831c13b1..14332b84443b 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -68,6 +68,7 @@ enum EnumRd {
 	APL1_ETSIC = 0x55,
 	APL2_ETSIC = 0x56,
 	APL5_WORLD = 0x58,
+	APL13_WORLD = 0x5A,
 	APL6_WORLD = 0x5B,
 	APL7_FCCA = 0x5C,
 	APL8_WORLD = 0x5D,
@@ -195,6 +196,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{APL3_WORLD, CTL_FCC, CTL_ETSI},
 	{APL4_WORLD, CTL_FCC, CTL_ETSI},
 	{APL5_WORLD, CTL_FCC, CTL_ETSI},
+	{APL13_WORLD, CTL_ETSI, CTL_ETSI},
 	{APL6_WORLD, CTL_ETSI, CTL_ETSI},
 	{APL8_WORLD, CTL_ETSI, CTL_ETSI},
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
-- 
2.11.0
