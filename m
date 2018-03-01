Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:46629 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031161AbeCAOVI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:08 -0500
Received: by mail-qt0-f195.google.com with SMTP id m13so7661359qtg.13
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:08 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 16/52] ath: Add regulatory mapping for APL10_MKKC
Date: Thu,  1 Mar 2018 15:18:26 +0100
Message-Id: <20180301141902.24824-17-sven.eckelmann@openmesh.com> (sfid-20180301_152112_123649_549D6C53)
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

* 2.4GHz: MKK
* 5GHz: ETSI

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 07c966ad7a67..44e3831c13b1 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -72,6 +72,7 @@ enum EnumRd {
 	APL7_FCCA = 0x5C,
 	APL8_WORLD = 0x5D,
 	APL9_WORLD = 0x5E,
+	APL10_MKKC = 0x5F,
 
 	WOR0_WORLD = 0x60,
 	WOR1_WORLD = 0x61,
@@ -198,6 +199,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{APL8_WORLD, CTL_ETSI, CTL_ETSI},
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
 
+	{APL10_MKKC, CTL_ETSI, CTL_MKK},
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
 	{APL7_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_ETSIC, CTL_FCC, CTL_ETSI},
-- 
2.11.0
