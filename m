Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4C1C49EA7
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jun 2021 21:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC3F60D07
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jun 2021 21:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFWV2J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:28:09 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:42310 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhFWV2I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jun 2021 17:28:08 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d90 with ME
        id LlRm2500721Fzsu03lRmLM; Wed, 23 Jun 2021 23:25:49 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 23 Jun 2021 23:25:49 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath11k: Remove some duplicate code
Date:   Wed, 23 Jun 2021 23:25:44 +0200
Message-Id: <a65952db7f4eb8aaaa654b77dcd4930482f5c49b.1624483438.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

'ATH11K_HE_MCS_MAX' is 11, so these 2 blocks of code are exactly the same.
Remove the one that uses a hard-coded constant.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 603d2f93ac18..9a224817630a 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1406,11 +1406,6 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 	 * Firmware rate's control to be skipped for this?
 	 */
 
-	if (flags == WMI_RATE_PREAMBLE_HE && mcs > 11) {
-		ath11k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
-		return;
-	}
-
 	if (flags == WMI_RATE_PREAMBLE_HE && mcs > ATH11K_HE_MCS_MAX) {
 		ath11k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
 		return;
-- 
2.30.2

