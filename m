Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6541BC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 04:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31FC92171F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 04:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ej7jDSVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfDDEBi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 00:01:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40072 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfDDEBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 00:01:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id u9so526168pgo.7
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 21:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBdWnyJ80XlwOcK+67cANMr9xP/H3nCIWrNH+V/VDSg=;
        b=ej7jDSVGJ7ktRxej/aB9sBwU8ImWS81Q1fjb+O9nxZP6vUjTL0HmP4y5b+SEgI2Z2n
         PZojXxG+FotPQkMujlVL5JsYFFiKQq6XDHvziA1fDKvU6nJM10TTWA8uzkYhNr+mBKJy
         d5T1H2cFdaGp72pye7X5u+5H04nMlSIuIBCUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBdWnyJ80XlwOcK+67cANMr9xP/H3nCIWrNH+V/VDSg=;
        b=NP8PXgvM4OGaLe3bVT7YqVU6ddb6L3nLMTk9jfiK52ONCi0ZWU97f1IZHbhVuosUMX
         XvKVaKIUB/2OdyqRBzCiUfvu6xSDHzXFroAcb11u6SHnJFx9terSUtudR9DkJ08Mlqvv
         GTiUesOkINoyC5WrX66XIZLXZNs8tKAdhiIp8D3PaGer/WRKYRoZ5Y3hqGfua8D0PUlb
         STSMNPVgcsFbXaK8ZeBAHx0fXvmXyK7hPmGhK175ZWsdDfGzN76diEbL+hnKtTZQCUNT
         AQRlUJVvapBtDdZpBkyXcWebT6LlsSUZrajozOqhGIUETj/ylyAA7OwsGg2QNzUE8F0h
         vggQ==
X-Gm-Message-State: APjAAAUufxAPKOcnFJeJPLquOFvND25Tq4VjGP0twhzkoUAPy5D+qdws
        /9lieJPf0FKxeHcwg+vNvSA+YQ==
X-Google-Smtp-Source: APXvYqxMunYRB8wRWGeUy8YgBn6+zIC8XeTwPFCjwS/xQwMGGkfukhYjw8BpBMfsQOxKBopCoiR5ig==
X-Received: by 2002:a63:614c:: with SMTP id v73mr3436250pgb.395.1554350492893;
        Wed, 03 Apr 2019 21:01:32 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id u7sm17717581pgp.26.2019.04.03.21.01.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Apr 2019 21:01:32 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-rockchip@lists.infradead.org, briannorris@chromium.org,
        mka@chromium.org, ryandcase@chromium.org, heiko@sntech.de,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Xinming Hu <huxinming820@gmail.com>
Subject: [PATCH] mwifiex: Make resume actually do something useful again on SDIO cards
Date:   Wed,  3 Apr 2019 21:01:06 -0700
Message-Id: <20190404040106.40519-1-dianders@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The commit fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
adapter status variables") had a fairly straightforward bug in it.  It
contained this bit of diff:

 - if (!adapter->is_suspended) {
 + if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {

As you can see the patch missed the "!" when converting to the atomic
bitops.  This meant that the resume hasn't done anything at all since
that commit landed and suspend/resume for mwifiex SDIO cards has been
totally broken.

After fixing this mwifiex suspend/resume appears to work again, at
least with the simple testing I've done.

Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent adapter status variables")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a85648342d15..d5a70340a945 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -181,7 +181,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 	adapter = card->adapter;
 
-	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+	if (!test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, WARN,
 			    "device already resumed\n");
 		return 0;
-- 
2.21.0.392.gf8f6787159e-goog

