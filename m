Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1115BC3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 16:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0A0622DD6
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566318047;
	bh=jSmhanjxopelC1YifYJft6uqU7jj/C7V9CPn+BZtfBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mh6bT0LhVmpmxv39EieAV7LdZ3nUfp6YkLwFX332W4Ire+VDBwOtODsMkOKTLMwi5
	 p3wpgEla5x6aptINPEpu1TyWKLl9sam8hE1++EpJqLDt439wJgzrXA6LG0UuKDBqou
	 Z7zWKUh8Nc5iR+C2NzhkW9HXcdbaV1ccTdqSgTLA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfHTQUr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfHTQUq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 12:20:46 -0400
Received: from localhost.localdomain (unknown [151.66.62.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FCA230F2;
        Tue, 20 Aug 2019 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318046;
        bh=jSmhanjxopelC1YifYJft6uqU7jj/C7V9CPn+BZtfBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HftfuISYH6K+SUZ6oQQ8zb4JLQ81b0ZoIBivb+J0qh6jcGCUv3t8ravT14guqsd9P
         1OqtSlJUK2TKZydE+38j4kwQNYk/JApi6SZ441UICE8ZolYu8UxNY2ZjTtML+PgfKA
         sAEo4VBh9Mmq2ouPsxiWaWpvm39/fvzoVF+Z1Wt0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        koen.vandeputte@ncentric.com
Subject: [PATCH 2/4] ath9k: dynack: properly set last timeout timestamp in ath_dynack_reset
Date:   Tue, 20 Aug 2019 18:20:20 +0200
Message-Id: <faa939860a66f860cfcea8fce5b009ec1be08d60.1566317488.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1566317488.git.lorenzo@kernel.org>
References: <cover.1566317488.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add compute timeout to last computation timestamp in
ath_dynack_reset in order to not run ath_dynack_compute_ackto
immediately

Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index c244dd15dce4..5d5809d160af 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -338,7 +338,7 @@ void ath_dynack_reset(struct ath_hw *ah)
 	u32 ackto = 9 + 16 + 64;
 	struct ath_dynack *da = &ah->dynack;
 
-	da->lto = jiffies;
+	da->lto = jiffies + COMPUTE_TO;
 	da->ackto = ackto;
 
 	da->st_rbf.t_rb = 0;
-- 
2.21.0

