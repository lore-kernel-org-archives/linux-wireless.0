Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:39848 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031343AbeCAOVQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:21:16 -0500
Received: by mail-qk0-f196.google.com with SMTP id z197so7701242qkb.6
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:21:15 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 19/52] ath: Add regulatory mapping for ETSI9_WORLD
Date: Thu,  1 Mar 2018 15:18:29 +0100
Message-Id: <20180301141902.24824-20-sven.eckelmann@openmesh.com> (sfid-20180301_152121_002926_52B29696)
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
index 88913c67fed2..f1735ac67c52 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -45,6 +45,7 @@ enum EnumRd {
 	ETSI5_WORLD = 0x39,
 	ETSI6_WORLD = 0x34,
 	ETSI8_WORLD = 0x3D,
+	ETSI9_WORLD = 0x3E,
 	ETSI_RESERVED = 0x33,
 
 	MKK1_MKKA = 0x40,
@@ -185,6 +186,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{ETSI5_WORLD, CTL_ETSI, CTL_ETSI},
 	{ETSI6_WORLD, CTL_ETSI, CTL_ETSI},
 	{ETSI8_WORLD, CTL_ETSI, CTL_ETSI},
+	{ETSI9_WORLD, CTL_ETSI, CTL_ETSI},
 
 	/* XXX: For ETSI3_ETSIA, Was NO_CTL meant for the 2 GHz band ? */
 	{ETSI3_ETSIA, CTL_ETSI, CTL_ETSI},
-- 
2.11.0
