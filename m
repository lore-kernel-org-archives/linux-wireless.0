Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7FEC1B08C
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Jul 2021 07:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 254736128D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Jul 2021 07:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbhGOHLI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Jul 2021 03:11:08 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11741 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239044AbhGOHLH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jul 2021 03:11:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1626332895; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: To: From: Sender;
 bh=kIULp/RNKUD7riG2pNoNJMee4HHcTwYm3+YjPMMBKns=; b=SQf5bvgx7FR2CwuqVl1p6sk9gbztpj/Iq3p/TO5mXqtBWliR//9xeboBW9KCZzq886i/oC+g
 QZUhw11ikOVqo9vt5s846mnWkl3h7+Y6FcIVQSym2slcY8kzxSoXmJeLj0gzd0KLD85PpKH/
 CiJjWWqP/WD8jfvKdZFTDu1Np88=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60efdecc17c2b4047d967a7c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 15 Jul 2021 07:07:56
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 40212C4360C; Thu, 15 Jul 2021 07:07:55 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 70006C433D3;
        Thu, 15 Jul 2021 07:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 70006C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: [PATCH v11 4/4] mac80211: channel switch for non-transmitting interfaces
Date:   Thu, 15 Jul 2021 00:07:45 -0700
Message-Id: <20210715070745.5033-5-alokad@codeaurora.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210715070745.5033-1-alokad@codeaurora.org>
References: <20210715070745.5033-1-alokad@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: John Crispin <john@phrozen.org>

Trigger ieee80211_csa_finish() on the non-transmitting interfaces
when channel switch concludes on the transmitting interface.

Signed-off-by: John Crispin <john@phrozen.org>
Co-developed-by: Aloka Dixit <alokad@codeaurora.org>
Signed-off-by: Aloka Dixit <alokad@codeaurora.org>
---
v11: Reverted changes from v10.
v10: Used iflist_mtx instead of rcu_read_lock() as most other
     accesses to sdata->local->interfaces do so.
     
 net/mac80211/cfg.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c95c5aacfbfa..6e1d525bf736 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3244,8 +3244,19 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	ieee80211_queue_work(&sdata->local->hw,
-			     &sdata->csa_finalize_work);
+	if (vif->mbssid_tx_vif == vif) {
+		struct ieee80211_sub_if_data *child, *tmp;
+
+		list_for_each_entry_safe(child, tmp,
+					 &sdata->local->interfaces, list)
+			if (child != sdata && child->vif.mbssid_tx_vif == vif &&
+			    ieee80211_sdata_running(child)) {
+				ieee80211_queue_work(&child->local->hw,
+						     &child->csa_finalize_work);
+			}
+	}
+
+	ieee80211_queue_work(&sdata->local->hw, &sdata->csa_finalize_work);
 }
 EXPORT_SYMBOL(ieee80211_csa_finish);
 
-- 
2.31.1

