Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0B6C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819EF20857
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696480;
	bh=jAIg06w9+xR2GZDsR8qqSgBZh/2ZC/qPTVHOeoOvnJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KMfa1FwmQobgwrqWok62eKbMhGJBSDSb+SrexJCsaEYW4GrfjdGy3XftVbK5Ag3lL
	 MRl+5hDfvX/Xy41k+aEYCkRJwsL4RlT1cogq0MdfhJ6CAnNRvldQVYJMR5dC5DzMib
	 3gCm16VAhUxvwjfFp8EV+ytr1YvTxfIaBJKSI68I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbfA1QAD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:00:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbfA1QAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:00:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 093532082E;
        Mon, 28 Jan 2019 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691202;
        bh=jAIg06w9+xR2GZDsR8qqSgBZh/2ZC/qPTVHOeoOvnJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPKVCV7+Ae3/oeeMNUAZjSnDyPsdJBmaQwlBSfixTAfRMIW7DDkkrRYpyGELLhSn6
         319q1cTXIiMNSdkxjl8CUltv87EZcHPSpR4ERgoIWh06YOG8HKtKUJ9iUxm9K8j3+w
         Fgd2Q5zFw+2yeNx+7acFkw86TqP7DE8MCpYDLa58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/258] ath10k: assign 'n_cipher_suites' for WCN3990
Date:   Mon, 28 Jan 2019 10:55:19 -0500
Message-Id: <20190128155924.51521-13-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 2bd345cd2bfc0bd44528896313c0b45f087bdf67 ]

Commit 2ea9f12cefe4 ("ath10k: add new cipher suite support") added a new
n_cipher_suites HW param with a fallback value and a warning log. Commit
03a72288c546 ("ath10k: wmi: add hw params entry for wcn3990") later
added WCN3990 HW entries, but it missed the n_cipher_suites.

Rather than seeing this warning every boot

  ath10k_snoc 18800000.wifi: invalid hw_params.n_cipher_suites 0

let's provide the appropriate value.

Cc: Rakesh Pillai <pillair@qti.qualcomm.com>
Cc: Govind Singh <govinds@qti.qualcomm.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c40cd129afe7..5210cffb5344 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -532,6 +532,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_ops = &wcn3990_ops,
 		.decap_align_bytes = 1,
 		.num_peers = TARGET_HL_10_TLV_NUM_PEERS,
+		.n_cipher_suites = 8,
 		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
 		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
-- 
2.19.1

