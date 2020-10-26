Return-Path: <SRS0=xhmE=EB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A212AC4363A
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Oct 2020 21:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A9F207F7
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Oct 2020 21:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603747881;
	bh=p5uj4RGvyoKHE87/45mHPImVbf4as4DA9p8vyIS1yT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xupnNRhr1gxTsmsqZlhAe7ATchwej+dcet6zdiBTIcioZdppa1gi2zY86MpcNkY5Y
	 q2ja8Ps5n8NV6evqU1AC1EVWKD4Q4QnyB9cMHwhI35lrSKGsooXUYp3L712n31idZX
	 Bi8RVIcmE48kGOLgF47r5XinIFM6x6EOnBPAJ5R4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbgJZVbQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387801AbgJZVbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Oct 2020 17:31:16 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C81C207F7;
        Mon, 26 Oct 2020 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603747875;
        bh=p5uj4RGvyoKHE87/45mHPImVbf4as4DA9p8vyIS1yT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2krs2xxVmoA1jSTDR/S6RMZKD+bJI25pQuu/lG1B6B2VCUe1Wh/veJH/cFKoXjhXu
         d4SUonCybAW8BJ0F7i31jUsyf6N5H9dlHWOlHJt9OjRdk3igsW8ynXzyibt6XjEr11
         LRg9H1N3q6/NRY/31oXgANuLJaYw1uJxAny5vvUc=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/11] net: hostap: fix function cast warning
Date:   Mon, 26 Oct 2020 22:29:49 +0100
Message-Id: <20201026213040.3889546-2-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc -Wextra complains about the function type cast:

drivers/net/wireless/intersil/hostap/hostap_hw.c:3173:48: warning: cast between incompatible function types from ‘void (*)(struct tasklet_struct *)’ to ‘void (*)(long unsigned int)’ [-Wcast-function-type]

Avoid this by just using the regular tasklet_setup() function instead
of the incorrect homegrown version.

Fixes: 7433c9690318 ("intersil: convert tasklets to use new tasklet_setup() API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/wireless/intersil/hostap/hostap_hw.c    | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 22cfb6452644..9a19046217df 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -3169,22 +3169,15 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 
 	/* Initialize tasklets for handling hardware IRQ related operations
 	 * outside hw IRQ handler */
-#define HOSTAP_TASKLET_INIT(q, f, d) \
-do { memset((q), 0, sizeof(*(q))); (q)->func = (void(*)(unsigned long))(f); } \
-while (0)
-	HOSTAP_TASKLET_INIT(&local->bap_tasklet, hostap_bap_tasklet,
-			    (unsigned long) local);
-
-	HOSTAP_TASKLET_INIT(&local->info_tasklet, hostap_info_tasklet,
-			    (unsigned long) local);
+	tasklet_setup(&local->bap_tasklet, hostap_bap_tasklet);
+	tasklet_setup(&local->info_tasklet, hostap_info_tasklet);
 	hostap_info_init(local);
 
-	HOSTAP_TASKLET_INIT(&local->rx_tasklet,
-			    hostap_rx_tasklet, (unsigned long) local);
+	tasklet_setup(&local->rx_tasklet, hostap_rx_tasklet);
 	skb_queue_head_init(&local->rx_list);
 
-	HOSTAP_TASKLET_INIT(&local->sta_tx_exc_tasklet,
-			    hostap_sta_tx_exc_tasklet, (unsigned long) local);
+	tasklet_setup(&local->sta_tx_exc_tasklet,
+			    hostap_sta_tx_exc_tasklet);
 	skb_queue_head_init(&local->sta_tx_exc_list);
 
 	INIT_LIST_HEAD(&local->cmd_queue);
-- 
2.27.0

