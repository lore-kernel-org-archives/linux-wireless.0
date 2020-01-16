Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F428C33CAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B3A20684
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198379;
	bh=5Qy8pOOL9asVjdrhdxH5PsKggFw8QxFaaQF4AxmRH5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HrUYKFbAVvCtVlzAHiwBx/sdBYSRHt+z6jRNfSgFQ6tQXLDTQsjux1/FB9+RkSlCC
	 fC4QOWHXmRCR9l1SOXr0g8xmorSZrBxwQxd/CJcXgkXYDYICTzfClMujHnxmrLAoVp
	 0WpJLmq/vC8v6fZL+q7GxlQTGzO2dkx8mndQrb5c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404836AbgAPSM7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405266AbgAPRhB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:37:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB927207FF;
        Thu, 16 Jan 2020 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196220;
        bh=5Qy8pOOL9asVjdrhdxH5PsKggFw8QxFaaQF4AxmRH5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty557IvZVUPKxM/APDyHBdpbtlIcjYa52aNrRfdJ1LSOqBLGkVJY5bdkV/kaaNJa4
         9agtlXJDtJ+hPlhxGWMEwDbxYfOZ5r6PDBohdp8KL/YXJmtsdvZ0l5oHNOwUS2+HBV
         zDm57HIjrRVEuTGaDb1ONSBmOZA7J/fAW9Pqp0T8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 055/251] iwlwifi: mvm: fix RSS config command
Date:   Thu, 16 Jan 2020 12:33:24 -0500
Message-Id: <20200116173641.22137-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 608dce95db10b8ee1a26dbce3f60204bb69812a5 ]

The hash mask is a bitmap, so we should use BIT() on
the enum values.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 43413a975d06 ("iwlwifi: mvm: support rss queues configuration command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2ec3a91a0f6b..bba7ace1a744 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -106,12 +106,12 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 	int i;
 	struct iwl_rss_config_cmd cmd = {
 		.flags = cpu_to_le32(IWL_RSS_ENABLE),
-		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
-			     IWL_RSS_HASH_TYPE_IPV4_UDP |
-			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
-			     IWL_RSS_HASH_TYPE_IPV6_TCP |
-			     IWL_RSS_HASH_TYPE_IPV6_UDP |
-			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
+		.hash_mask = BIT(IWL_RSS_HASH_TYPE_IPV4_TCP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV4_UDP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV4_PAYLOAD) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV6_TCP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV6_UDP) |
+			     BIT(IWL_RSS_HASH_TYPE_IPV6_PAYLOAD),
 	};
 
 	if (mvm->trans->num_rx_queues == 1)
-- 
2.20.1

