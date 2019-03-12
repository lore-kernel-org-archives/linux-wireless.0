Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D043C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 07:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2456214AF
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 07:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Rrwb3kUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfCLH4n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:56:43 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:55874 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfCLH4m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 03:56:42 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 2CC12A99
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 07:56:41 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WX-DGblfPM3Q for <linux-wireless@vger.kernel.org>;
        Tue, 12 Mar 2019 02:56:41 -0500 (CDT)
Received: from mail-it1-f198.google.com (mail-it1-f198.google.com [209.85.166.198])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id F277AA98
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 02:56:40 -0500 (CDT)
Received: by mail-it1-f198.google.com with SMTP id 190so1459638itl.7
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 00:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GHwL4zBqlKlQckqtsDRpff1AB+Nxp6P8f5kwUycKt+I=;
        b=Rrwb3kUuQTLkon4rAku7XQ7Jg4lHHS8eKfKk7+CJayAofX14LiY/ADR2yL+fzWKzy/
         yQFxzC1Xd9tahI3szGNNGQbqD6645mJg5E4tgzoql2LTQnvsAfobz/okxbkAuaRPZkTq
         aEG1wFcTtu2t+15pLdM1RroMNIf4veY2WFEyp0H+FXiGgL74CxcrdfI5v06AQn6VCEAF
         ZRE8j7dkwzGExBmRsLKH1Y2rhBezbVfJ6BQFfqGf2PbMHY2WSW5gvaUlitFQUKRxoJE+
         zz2ze4xC5Ipl6ISpL1fqAEG5KH+mWcvBP7H0HR5MBqoEJZEcWONUYUTbJd+PwFP8h5FP
         tTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GHwL4zBqlKlQckqtsDRpff1AB+Nxp6P8f5kwUycKt+I=;
        b=Z3jlljXBbozgjNiOOkMt/izMFePm+iC3mFBnv133l2UvwldNoEnG1i4kf4J02mmVWV
         VQGUV+LW5vOhEa4JuVtYUWC6AxjnI8pctGokt/92kPNsR+Hp/vZiJ5Zn/R4ddqj0YtZ0
         keABco03ZuNIKHHyoHCwvINtlvSLxFabw3zU/vUkPqDzxHJIovBMF86RdH8gI+axu7mg
         1sEw5iJBjuJnupKAAsnUugXvbEQp3HzdZIoabq3oP8lk+KTTAHeuyodFBTeR0M40AtGB
         /nXzXB7O0aLUY3IrAnwS4f24SRG/AiLP+D3PisibQtuPXuFs7vBfSB3lJFIODKiQbpoW
         MQTw==
X-Gm-Message-State: APjAAAVY7Gahbgt/5X4KmuZE9zjfMBDI2xT2B78H2JEUTfo9p3ZJ49Ic
        EMkbpbzZDLSMSY0W4vyj5FwqA0S6R6Q6e3rZR2zJ5YXN2O/NVp5geponBT8hU/JWQwrCq3h5N7c
        CcAysxywO17BOVH5hMKb5aChKn704JHc=
X-Received: by 2002:a6b:7219:: with SMTP id n25mr10363256ioc.117.1552377400154;
        Tue, 12 Mar 2019 00:56:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwCOLy0p/Zx9y/3ip/ZQBpQCX4CLC4JCn7dfHgj8FIju2Odvfqkl6BklClOE5Sd+YohY31Vig==
X-Received: by 2002:a6b:7219:: with SMTP id n25mr10363242ioc.117.1552377399938;
        Tue, 12 Mar 2019 00:56:39 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id s10sm2669419ioc.54.2019.03.12.00.56.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 00:56:38 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: rtlwifi: fix a potential NULL pointer dereference
Date:   Tue, 12 Mar 2019 02:56:33 -0500
Message-Id: <20190312075633.573-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case alloc_workqueue fails, the fix reports the error and
returns to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 217d2a7a43c7..ac746c322554 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -448,6 +448,11 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
 	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	if (unlikely(!rtlpriv->works.rtl_wq)) {
+		pr_err("Failed to allocate work queue\n");
+		return;
+	}
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
-- 
2.17.1

