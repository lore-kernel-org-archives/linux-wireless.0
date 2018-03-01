Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:41416 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031274AbeCAOVG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:06 -0500
Received: by mail-qt0-f196.google.com with SMTP id j4so7673322qth.8
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:06 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 15/52] ath: Add regulatory mapping for APL2_FCCA
Date: Thu,  1 Mar 2018 15:18:25 +0100
Message-Id: <20180301141902.24824-16-sven.eckelmann@openmesh.com> (sfid-20180301_152110_031058_AF8B653E)
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

* 2.4GHz: FCC
* 5GHz: FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 5cbd76235248..07c966ad7a67 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -59,6 +59,7 @@ enum EnumRd {
 	MKK1_MKKA1 = 0x4A,
 	MKK1_MKKA2 = 0x4B,
 	MKK1_MKKC = 0x4C,
+	APL2_FCCA = 0x4D,
 
 	APL3_FCCA = 0x50,
 	APL1_WORLD = 0x52,
@@ -189,6 +190,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{FCC1_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_WORLD, CTL_FCC, CTL_ETSI},
 	{APL2_WORLD, CTL_FCC, CTL_ETSI},
+	{APL2_FCCA, CTL_FCC, CTL_FCC},
 	{APL3_WORLD, CTL_FCC, CTL_ETSI},
 	{APL4_WORLD, CTL_FCC, CTL_ETSI},
 	{APL5_WORLD, CTL_FCC, CTL_ETSI},
-- 
2.11.0
