Return-Path: <SRS0=0b32=YT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D43CCA9EB9
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Oct 2019 13:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3132721D7F
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Oct 2019 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572095777;
	bh=62QafBCYLVsAzcLcrBb5DjZ9s+goGqXlmmf7CSY/hzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CFKzja8xiDRQgBGJxCOGg7jodJM08gzZ9x7StKJnjocVUJ7hq37hUspmtS6XUZR9x
	 BV7G99GzmrltnKfC8mAv24Rr5LHJjT06ZRJfVeBUq2YfVu4DeJAoyeCFR63hJkce5k
	 W5UCE9Z/XQJP+1OghbgZtCaVyOGCvy6+yx8SQJ7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfJZNQI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Oct 2019 09:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfJZNQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E6521D81;
        Sat, 26 Oct 2019 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095767;
        bh=62QafBCYLVsAzcLcrBb5DjZ9s+goGqXlmmf7CSY/hzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxvO3fwWK9sYx1BO0q8s4J5Q1Aoy7SLaGJF13GBwuCHtNkqcOLGk3RxgyLm0vtydg
         bDFedGa5AcslR2LCze2xvRb50LgSrX13LKHw9bZ7nmZfCN9ZEH7e6CK207kX4jNBjW
         Y35Pb2U9YBdD2f7pVVCiftrxBgWxnqBLfwBiPAcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Jonathan Liu <net147@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 05/99] rt2x00: initialize last_reset
Date:   Sat, 26 Oct 2019 09:14:26 -0400
Message-Id: <20191026131600.2507-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit c91a9cfe9f6d136172a52ff6e01b3f83ba850c19 ]

Initialize last_reset variable to INITIAL_JIFFIES, otherwise it is not
possible to test H/W reset for first 5 minutes of system run.

Fixes: e403fa31ed71 ("rt2x00: add restart hw")
Reported-and-tested-by: Jonathan Liu <net147@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index ef5f515122125..faf588ce7bd5a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -575,7 +575,7 @@ static ssize_t rt2x00debug_write_restart_hw(struct file *file,
 {
 	struct rt2x00debug_intf *intf =	file->private_data;
 	struct rt2x00_dev *rt2x00dev = intf->rt2x00dev;
-	static unsigned long last_reset;
+	static unsigned long last_reset = INITIAL_JIFFIES;
 
 	if (!rt2x00_has_cap_restart_hw(rt2x00dev))
 		return -EOPNOTSUPP;
-- 
2.20.1

