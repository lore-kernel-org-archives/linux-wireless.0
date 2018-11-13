Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CF1C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 19:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6B5520896
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 19:22:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6B5520896
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbeKNFWG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 00:22:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:12222 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725748AbeKNFWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 00:22:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2018 11:22:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,229,1539673200"; 
   d="scan'208";a="249424370"
Received: from jprestwo.jf.intel.com ([10.54.74.49])
  by orsmga004.jf.intel.com with ESMTP; 13 Nov 2018 11:22:36 -0800
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>
Subject: [PATCH] mac80211_hwsim: fixes kernel crash during mac80211_hwsim init
Date:   Tue, 13 Nov 2018 11:26:42 -0800
Message-Id: <20181113192642.32308-1-james.prestwood@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Creating radios during startup follows a different code path than
HWSIM_CMD_NEW_RADIO. The problem was that param.iftypes was not
being set to the deafult before calling mac80211_hwsim_new_radio

Signed-off-by: James Prestwood <james.prestwood@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4033a800b209..2a5a133f23cf 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3884,6 +3884,7 @@ static int __init init_mac80211_hwsim(void)
 
 		param.p2p_device = support_p2p_device;
 		param.use_chanctx = channels > 1;
+		param.iftypes = HWSIM_IFTYPE_SUPPORT_MASK;
 
 		err = mac80211_hwsim_new_radio(NULL, &param);
 		if (err < 0)
-- 
2.17.1

