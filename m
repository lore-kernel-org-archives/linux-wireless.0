Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA264C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9649C2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMVldfCn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733078AbfDQTP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:15:27 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40481 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 15:15:27 -0400
Received: by mail-lf1-f68.google.com with SMTP id a28so19732865lfo.7
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 12:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lAtSC54sP8tBcJOPSyYHc2pdsS1krcRxdXangPf5TEA=;
        b=KMVldfCnSSh5N906LMMj+wI4N9howcyxmfZpSpkGkgMcY3HHERTG8VWGZu1C1LBxsX
         0BireXewiagLSrLowfSJElW3p87ULFAnc+HJSHSs9VBH433DS39E8EBq0jz30PMib0pP
         iNcds5nPLYCW6DERMCWfMGaIjBvao6c3eIOg9fqtUeYTGvzfwl5w+K8q8nfGjhMSj40d
         4qX+sD8TOxjU7HWD66vl8IZnBxLnjJ2067S7da2nRAivYZUEWWNWif+81mdVWXA8gIy1
         Szu4gD7uzDwFMlK5ZFYd7rf37PCbsuieSRxtefPJHcKJRJR+WZEGCllHValBT27Ois9L
         3c1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lAtSC54sP8tBcJOPSyYHc2pdsS1krcRxdXangPf5TEA=;
        b=WbNxsuQssf1zVLobACx8IKqDKemmqlL/9xG8YuWM01bdGXbaHutLXbXEvZwfWwcmBN
         sSfj4ZhSuj8661zNGdQdSnC629/1ArKTy5kklNmhJPo+3tozplJKs/Punresz77Iv87r
         Kdges9Q/IglVFfP5fuCbZByrZERlhTjV4gP0+jMD4LQwZBYvjcbSugdN3Tsp0So/4mUC
         r0YIhohxzC58dXVulRe+F+0W83/jTAGfNIDfvgymg/HuJ9A36pyqoRSztelTks67SEj1
         62wLDDUYNB8qTq54uOOuz/cqCsNAQTWAUPVlePP2ykuL2BuRHOwFuAhvBcAJwaLnTMVE
         ywDQ==
X-Gm-Message-State: APjAAAUdMxt7dlir393ShI8v7b8cG6VztYc2FAq1nMh9u1p15+zV1IUq
        QFKISHQG0raBGgXdbRlBacs=
X-Google-Smtp-Source: APXvYqzJfHatxka27TUWUpRjXp3pXHOodc4IUpkDYYqp3qvXzSKbPW5OEQrOlkINx3cw/3eInltEyw==
X-Received: by 2002:a19:f24c:: with SMTP id d12mr778347lfk.163.1555528525916;
        Wed, 17 Apr 2019 12:15:25 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id j27sm11387203lfk.97.2019.04.17.12.15.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 12:15:25 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 0/5] ath10k: SDIO and high latency patches from Silex
Date:   Wed, 17 Apr 2019 21:14:58 +0200
Message-Id: <20190417191503.18814-1-erik.stromdahl@gmail.com>
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

changes since v1:

Patch "ath10k: use clean packet headers" was renamed to
"ath10k: add initialization of HTC header" and PLL stuff was removed.

Patch "ath10k: sdio: add MSDU ID allocation in HTT TX path"
was removed since it became redundant after I had added Kalle's and
Wen's patches to my tree.

Patch "ath10k: sdio: replace skb_trim with explicit set of skb->len"
was rewritten and renamed to "ath10k: sdio: remove skb_trim in TX path"

Alagu Sankar (3):
  ath10k: add initialization of HTC header
  ath10k: high latency fixes for beacon buffer
  ath10k: sdio: read RX packets in bundles

Erik Stromdahl (2):
  ath10k: sdio: add missing error check
  ath10k: sdio: remove skb_trim in TX path

 drivers/net/wireless/ath/ath10k/htc.c  |   1 +
 drivers/net/wireless/ath/ath10k/mac.c  |  31 ++++++--
 drivers/net/wireless/ath/ath10k/sdio.c | 103 ++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/sdio.h |   4 +
 4 files changed, 112 insertions(+), 27 deletions(-)

-- 
2.19.1

