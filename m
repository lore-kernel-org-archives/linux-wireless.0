Return-Path: <SRS0=dkGe=ZS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75297C432C0
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Nov 2019 21:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392062064B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Nov 2019 21:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="G2yrSlFK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfKZVr7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Nov 2019 16:47:59 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:44002 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfKZVr7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Nov 2019 16:47:59 -0500
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 1271513C35A;
        Tue, 26 Nov 2019 13:47:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1271513C35A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1574804867;
        bh=ExurkfaMQ5hfSBPOhbXi2weT1swS9LXEQjXdQHSp890=;
        h=From:To:Cc:Subject:Date:From;
        b=G2yrSlFKidWr4TUXSLDGUaT8Wb/+Kh6oYcn/8rGh9/9g0elhH90pTLczURyfwd0JT
         JiVtsyoEeuFQrTxwSgsdQ8ue2slaEwzrOQIg9cxiE/dWIRYR0YwaVmTGKU4xfYU1Dw
         F3hBEW5+PE+mKJ8FohmutUs+6UOkCfFXEJU1/1HI=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ax200:  Fix avg-power report.
Date:   Tue, 26 Nov 2019 13:47:44 -0800
Message-Id: <20191126214744.1283-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

On AX200, the average power was showing possitive instead of negative, but
otherwise matched the expected RSSI.  I think that we just need to flip
the value to negative before giving to mac80211.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1bff94c3dd72..2876db1b1d17 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4948,7 +4948,15 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 	if (mvmsta->avg_energy) {
-		sinfo->signal_avg = mvmsta->avg_energy;
+		/* signal_avg is s8, mvsta->avg_energy is u8.  At least on AX200,
+		 * avg_energy is RSSI but missing the minus sign.
+		 */
+		if (mvmsta->avg_energy & 0x80) {
+			sinfo->signal_avg = mvmsta->avg_energy;
+		}
+		else {
+			sinfo->signal_avg = -((s8)(mvmsta->avg_energy));
+		}
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL_AVG);
 	}
 
-- 
2.20.1

