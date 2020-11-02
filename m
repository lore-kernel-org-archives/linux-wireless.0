Return-Path: <SRS0=EpEU=EI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CE4C00A89
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 11:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D16322275
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 11:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QStDp87E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgKBL1z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Nov 2020 06:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbgKBLYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Nov 2020 06:24:42 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3AC061A48
        for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2020 03:24:41 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id a9so14113026wrg.12
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2020 03:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qpDdLuf0XmFXhoeCc8tXmAL5epac8Q54EhVeHTK2ADw=;
        b=QStDp87EefLAQ0xGJp3v1XG9HoP6I2H/6oI26lKpv0EUN4GRH2LcnNrukE05yCl0jp
         WRCbr02WX3ag4/XpO5So+3kxDEXlavNHMcaCVzy1xxT9isEburuXPrJw4fSCbuqJx+m6
         BFJbVQgtoYKKs8EYPOxauS4uCH6Xwxh3rnHz4XDOkjUWXGl00sxJTQtIrxSBuL/j61zY
         FmsZlE8JC6H4CSOUfkFpCgNpJ8fQG1rVBiRwGlYlCLiSS2iDMD0vILqn44ZJEF0JcF6Y
         S8pz+FOjpFn8lVkphoFj1R27oN+YghlqDmQNRq9ewmXDpXogxFWgB/1p3pUKgDvuP0li
         J8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qpDdLuf0XmFXhoeCc8tXmAL5epac8Q54EhVeHTK2ADw=;
        b=q/BuM1K4TU38JCCdenLY8sE2xZSvjU1MZvXXSDlyhFWvFKP/bG6jb2y5Z7v6xOTX+F
         pVwDvBTzLOFVZ6GlPyCHZpOAD2vhPBLl9jxTtCBbcsTjSfogTkNWRZEhNAg4tzoGIgEt
         UbO+p75BhCZW5yWKfs/SwQVnmcI6/GefXyfj7+AdgMCbjucCArFTGj2jTp4hMFIWwgw/
         8d2plfK49P/jSDnKOKmDzHVA5oFnNLKcteZh8HxDSVJm/EZEDEcLkJgc5qtRkWSGLWOL
         hVMgNC1BYBD3KOankYbqWv5OWi3kaBWM3m6DVFeOswWlK8ZrUoo1I7OA0s29AWKHINhl
         EzCA==
X-Gm-Message-State: AOAM5323mkSqJrXC2bbQGuQeqRVpiow4K3fwu5yycb1e52AmcOVn5ths
        GHEsW40dB411X7l9G6GCBleoWQ==
X-Google-Smtp-Source: ABdhPJw3NvquUovDiM9NpuyGkN81PEgqbBFf/hSnyh+5ZVhWq0aZtZb3MOCJzu17flNBgogtpH4Tzw==
X-Received: by 2002:adf:e64e:: with SMTP id b14mr19582007wrn.68.1604316279996;
        Mon, 02 Nov 2020 03:24:39 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:39 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jouni Malinen <j@w1.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/41] intersil: hostap_hw: Prevent incompatible function type cast
Date:   Mon,  2 Nov 2020 11:23:46 +0000
Message-Id: <20201102112410.1049272-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intersil/hostap/hostap_hw.c: In function ‘prism2_init_local_data’:
 drivers/net/wireless/intersil/hostap/hostap_hw.c:3173:48: warning: cast between incompatible function types from ‘void (*)(struct tasklet_struct *)’ to ‘void (*)(long unsigned int)’ [-Wcast-function-type]
 drivers/net/wireless/intersil/hostap/hostap_hw.c:3175:2: note: in expansion of macro ‘HOSTAP_TASKLET_INIT’

 NB: Repeats lots of times - snipped for brevity

Cc: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/intersil/hostap/hostap_hw.c  | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 22cfb64526448..c877b677505ed 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -36,6 +36,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/if_arp.h>
+#include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/random.h>
 #include <linux/wait.h>
@@ -3169,22 +3170,16 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 
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
+
+	tasklet_setup(&local->bap_tasklet, hostap_bap_tasklet);
+
+	tasklet_setup(&local->info_tasklet, hostap_info_tasklet);
 	hostap_info_init(local);
 
-	HOSTAP_TASKLET_INIT(&local->rx_tasklet,
-			    hostap_rx_tasklet, (unsigned long) local);
+	tasklet_setup(&local->rx_tasklet, hostap_rx_tasklet);
 	skb_queue_head_init(&local->rx_list);
 
-	HOSTAP_TASKLET_INIT(&local->sta_tx_exc_tasklet,
-			    hostap_sta_tx_exc_tasklet, (unsigned long) local);
+	tasklet_setup(&local->sta_tx_exc_tasklet, hostap_sta_tx_exc_tasklet);
 	skb_queue_head_init(&local->sta_tx_exc_list);
 
 	INIT_LIST_HEAD(&local->cmd_queue);
-- 
2.25.1

