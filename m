Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED7CC33CB3
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E56206D7
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579199684;
	bh=zh/nQzK4rhPcEdCNNJRcqVr+AghfOqS52DMQnXrB+/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fs7ECq7wn3Xkqko6CW5rwSjRbYIj/Q3bA3eedS/ATkvFfI+gnLAeTkve0skbg2wWY
	 vP5tn2ldsIuvoIB27B+k5aGfCpfZE42i7E0BwK5WxZBJdYfMW5xNcKikRwp1q6d+JT
	 yEglD4010cFHyCVQP7BuxM+iraVizyVaLERtxHo8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436786AbgAPSeg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391666AbgAPRYf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A367D2469F;
        Thu, 16 Jan 2020 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195474;
        bh=zh/nQzK4rhPcEdCNNJRcqVr+AghfOqS52DMQnXrB+/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKiXJwlymw/XHq0A6bXcbwKrFJAqBs2xBiugKixCluE/NDhSGQKXmw+9ZWy+gDzUL
         FJkvevy+/lkZKJQ0L51AqasUyt1IO74y644FbZPVBLUmRHtC4uHkZKhfi+CQHjzYZp
         L5R7zFvspa090R3GY9nRYU5m6ry96pitJLVPTFig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 080/371] iwlwifi: mvm: fix RSS config command
Date:   Thu, 16 Jan 2020 12:19:12 -0500
Message-Id: <20200116172403.18149-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index 78228f870f8f..754dcc1c1f40 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -107,12 +107,12 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
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

