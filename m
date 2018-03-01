Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35247 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031353AbeCAOVS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:18 -0500
Received: by mail-qk0-f196.google.com with SMTP id s188so7707440qkb.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:18 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 20/52] ath: Add regulatory mapping for FCC3_ETSIC
Date: Thu,  1 Mar 2018 15:18:30 +0100
Message-Id: <20180301141902.24824-21-sven.eckelmann@openmesh.com> (sfid-20180301_152123_140580_4724056A)
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
* 5GHz: FCC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 drivers/net/wireless/ath/regd_common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index f1735ac67c52..447547c25093 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -35,6 +35,7 @@ enum EnumRd {
 	FRANCE_RES = 0x31,
 	FCC3_FCCA = 0x3A,
 	FCC3_WORLD = 0x3B,
+	FCC3_ETSIC = 0x3F,
 
 	ETSI1_WORLD = 0x37,
 	ETSI3_ETSIA = 0x32,
@@ -174,6 +175,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{FCC2_ETSIC, CTL_FCC, CTL_ETSI},
 	{FCC3_FCCA, CTL_FCC, CTL_FCC},
 	{FCC3_WORLD, CTL_FCC, CTL_ETSI},
+	{FCC3_ETSIC, CTL_FCC, CTL_ETSI},
 	{FCC4_FCCA, CTL_FCC, CTL_FCC},
 	{FCC5_FCCA, CTL_FCC, CTL_FCC},
 	{FCC6_FCCA, CTL_FCC, CTL_FCC},
-- 
2.11.0
