Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2F6C6783B
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 00:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6F720851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 00:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB6F720851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbeLLAsB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 19:48:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:63450 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbeLLAsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 19:48:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2018 16:48:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,343,1539673200"; 
   d="scan'208";a="118032714"
Received: from jprestwo.jf.intel.com ([10.54.74.49])
  by orsmga001.jf.intel.com with ESMTP; 11 Dec 2018 16:48:00 -0800
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>
Subject: [PATCH] mac80211_hwsim: fix overwriting of if_combination
Date:   Tue, 11 Dec 2018 16:52:14 -0800
Message-Id: <20181212005214.19376-1-james.prestwood@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Moved setting if_combination.num_different_channels/radar_detect_widths
into an else after use_chanctx. In the case of use_chanctx, these two
settings were getting overwritten.

Signed-off-by: James Prestwood <james.prestwood@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2a5a133f23cf..e4db8e2b2b54 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2751,17 +2751,18 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		hw->wiphy->max_remain_on_channel_duration = 1000;
 		data->if_combination.radar_detect_widths = 0;
 		data->if_combination.num_different_channels = data->channels;
-	}
-
-	data->if_combination.n_limits = n_limits;
-	data->if_combination.max_interfaces = 2048;
-	data->if_combination.num_different_channels = 1;
-	data->if_combination.radar_detect_widths =
+	} else {
+		data->if_combination.num_different_channels = 1;
+		data->if_combination.radar_detect_widths =
 					BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20) |
 					BIT(NL80211_CHAN_WIDTH_40) |
 					BIT(NL80211_CHAN_WIDTH_80) |
 					BIT(NL80211_CHAN_WIDTH_160);
+	}
+
+	data->if_combination.n_limits = n_limits;
+	data->if_combination.max_interfaces = 2048;
 	data->if_combination.limits = data->if_limits;
 
 	hw->wiphy->iface_combinations = &data->if_combination;
-- 
2.17.1

