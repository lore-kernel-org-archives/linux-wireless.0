Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF2EC282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEA62084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfAUHug (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49034 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727882AbfAUHuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULp-0006cr-T5; Mon, 21 Jan 2019 09:50:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        =?UTF-8?q?R=C3=A9my=20Gr=C3=BCnblatt?= <remy@grunblatt.org>
Date:   Mon, 21 Jan 2019 09:50:12 +0200
Message-Id: <20190121075026.25059-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/16] iwlwifi: mvm: fix values in the table example
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We erroneously had some values for NGI in the table we give as an
example in rs_fill_rates_for_column(), when they should be SGI.
Change them so that they match what we say.

Reported-by: Rémy Grünblatt <remy@grunblatt.org>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 9b5682ce4b39..09866f50857a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3346,12 +3346,12 @@ static void rs_fill_rates_for_column(struct iwl_mvm *mvm,
 /* Building the rate table is non trivial. When we're in MIMO2/VHT/80Mhz/SGI
  * column the rate table should look like this:
  *
- * rate[0] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
- * rate[1] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
- * rate[2] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
- * rate[3] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
- * rate[4] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
- * rate[5] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[0] 0x400F019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
+ * rate[1] 0x400F019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
+ * rate[2] 0x400F018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
+ * rate[3] 0x400F018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
+ * rate[4] 0x400F017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[5] 0x400F017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
  * rate[6] 0x4005007 VHT | ANT: A BW: 80Mhz MCS: 7 NSS: 1 NGI
  * rate[7] 0x4009006 VHT | ANT: B BW: 80Mhz MCS: 6 NSS: 1 NGI
  * rate[8] 0x4005005 VHT | ANT: A BW: 80Mhz MCS: 5 NSS: 1 NGI
-- 
2.20.1

