Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87166C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520B92084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EajAsTBO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfDITNJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:09 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36096 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfDITNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:09 -0400
Received: by mail-lj1-f195.google.com with SMTP id r24so3765494ljg.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0TzgM4Ss5cnuZmuSTqOyUmgMUpi0hPf77e3I52aslDg=;
        b=EajAsTBOZtILT3MbwKQ1fU5oC3NlWmsrXeNsQxXyLL3OcFr1YeWA3e72xPOpafvH89
         P1HlyqNZs5EQG+QRJPjy0Ghf4wAZnxAcIJpmzbjgow4wkaYwIxu0arwfRJohnj4Aoja9
         QK+TZrUgMPgGvhiJ1dUcTPGDK/9h6vmeokmfVPlhxVzhucIzsl1dnWnEOLH1uZIzKLHu
         AFTKZ9jT0IYa6QBRgCMWrGwjsJZOip1DTNl4kFTZn+yEIm+cLTFbmRUcTQufN5JqyxRx
         vNFrrPjV80Rt02k/Z9bUHVoDPd3faK8zeivMA7giqGrW/i8aHVH9PPhDlVZ2DQwcBlH+
         JPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0TzgM4Ss5cnuZmuSTqOyUmgMUpi0hPf77e3I52aslDg=;
        b=X+nZfi8hOobkOyNPES0NdiiPWZVQwu3x9ibUIIhXxzxBrz2GGTvADOQozC1o9rbNcj
         xqCYfsXR/5MQPO2MGnAjLE8QEPwLHy2jyfnVrHQ9tAP6PTzvfr9AN01JkEXzUPOf0iTt
         c/jl6UyL8O2n80ua9+tgo+aD/0eGsovHa0ICwXCK2v2j0C48Z+D3kKFiAv7Ij3CPv45V
         YHGB2of+OurFIxGvVxwHDfaUy9c6OT6TGgwHid90tlDBrKX+rZrGB/kvA66OCkf1ahUu
         yAsIN4bP10DFK8SrlCJBd4k38wADzxevHazVfLR85+x9uB9waf3723MoHDRt9sYnj+4q
         5cZQ==
X-Gm-Message-State: APjAAAUUO/HDzOgkFn1gBrqzhH84rs5cd/2nMBeqRJPWz5Tw8uUa0hso
        YerxkUnYN90GJAYa112rWobm6uPR
X-Google-Smtp-Source: APXvYqwkmhoHuVehMV6P95D96HLmNLmuWz0IjrH7UXqrOVGrm4ufBd/tcMeU9/MtkeX1RmSGFcxZZg==
X-Received: by 2002:a2e:9194:: with SMTP id f20mr20547146ljg.10.1554837187108;
        Tue, 09 Apr 2019 12:13:07 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:06 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 0/6] ath10k: SDIO and high latency patches from Silex
Date:   Tue,  9 Apr 2019 21:08:45 +0200
Message-Id: <20190409190851.4557-1-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series adds a few more fixes for SDIO and high latency devices.

I have had these on my private tree for quite some time now so they
should be considered fairly well tested.

4 out of 6 patches are from Alagu Sankar at Silex.
I have made some adjustments to some of them in order to make them
smaller and easier to review.

Alagu Sankar (4):
  ath10k: use clean packet headers
  ath10k: high latency fixes for beacon buffer
  ath10k: sdio: read RX packets in bundles
  ath10k: sdio: add MSDU ID allocation in HTT TX path

Erik Stromdahl (2):
  ath10k: sdio: add missing error check
  ath10k: sdio: replace skb_trim with explicit set of skb->len

 drivers/net/wireless/ath/ath10k/htc.c    |  1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 16 ++++-
 drivers/net/wireless/ath/ath10k/hw.c     |  2 +
 drivers/net/wireless/ath/ath10k/mac.c    | 31 +++++++---
 drivers/net/wireless/ath/ath10k/sdio.c   | 78 +++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/sdio.h   |  2 +
 7 files changed, 109 insertions(+), 25 deletions(-)

-- 
2.19.1

