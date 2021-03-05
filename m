Return-Path: <SRS0=uWm6=ID=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A76C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Mar 2021 14:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFD3650A2
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Mar 2021 14:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhCEOdk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:33:40 -0500
Received: from m12-18.163.com ([220.181.12.18]:49358 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhCEOd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Mar 2021 09:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/TvjH
        SOBEYRh+T/8Euv4d9A0dOXu0DIoSSJDBhPEbaQ=; b=YKCdad2nA56r4ZUcWli5x
        wjWb+boEgCjJPJgFYRqWAMqUvWhopqxvEg8mZG1kq/C1qSO2UFSPkCNeeq3O+X3q
        xAsxJPreIDCkcrgWojxklUcGnOpqJpVt56Bl7tSg4aPchB0oIcVpfadpn4MWUzPA
        IXH6mcijfha4NotHUXL4oM=
Received: from yangjunlin.ccdomain.com (unknown [119.137.55.151])
        by smtp14 (Coremail) with SMTP id EsCowABHTeWkQEJgqqbQXA--.15120S2;
        Fri, 05 Mar 2021 22:31:02 +0800 (CST)
From:   angkery <angkery@163.com>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, gregory.greenman@intel.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junlin Yang <yangjunlin@yulong.com>
Subject: [PATCH] iwlwifi: mvm: Use kmemdup instead of kzalloc and memcpy
Date:   Fri,  5 Mar 2021 22:29:56 +0800
Message-Id: <20210305142956.3074-1-angkery@163.com>
X-Mailer: git-send-email 2.24.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABHTeWkQEJgqqbQXA--.15120S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1kCFWDGF4rKrWrtw1xAFb_yoWDKwc_C3
        4SqF17GrZ8GwnY9rW3Aay2v34Fyr1UKasa9Fy3trW3A3WjkrWDXr93Zr1Yq39Fgryj9F97
        AwsrCFyfAr9xZjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0c_-PUUUUU==
X-Originating-IP: [119.137.55.151]
X-CM-SenderInfo: 5dqjyvlu16il2tof0z/xtbBRgZMI13l+zRphQAAs0
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Junlin Yang <yangjunlin@yulong.com>

Fixes coccicheck warnings:
./drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:110:8-15:
WARNING opportunity for kmemdup

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
index 8739190..f665045 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -107,12 +107,10 @@ struct iwl_rfi_freq_table_resp_cmd *iwl_rfi_get_freq_table(struct iwl_mvm *mvm)
 	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(cmd.resp_pkt) != resp_size))
 		return ERR_PTR(-EIO);
 
-	resp = kzalloc(resp_size, GFP_KERNEL);
+	resp = kmemdup(cmd.resp_pkt->data, resp_size, GFP_KERNEL);
 	if (!resp)
 		return ERR_PTR(-ENOMEM);
 
-	memcpy(resp, cmd.resp_pkt->data, resp_size);
-
 	iwl_free_resp(&cmd);
 	return resp;
 }
-- 
1.9.1


