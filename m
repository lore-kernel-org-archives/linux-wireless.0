Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F2AC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 14:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5566C20834
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 14:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5566C20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbeLCOfv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 09:35:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51280 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeLCOfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 09:35:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id s14so6098375wmh.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2018 06:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9SoN0YKjVr36DuP/AwbUoiYV6F2KG5OTc155HdkWYNU=;
        b=sIdKItloZ+8cDzt6rYhPUcCWH6cADBqv7k7U3Oaycy6qjK/tB5aHpKT0R2TM+mnlrZ
         9Qb+J4mWsfl1sH0YxkgFTtJ03/boKYvtJKDAEQEbusSXOHdf1pJ9+vpq38uwgJpvMtla
         zEWcsG/m9RNyIJutnhprdgECwDZWB41zG+kadHl1vtgUvCfsSmcVoBFXra8rmfO8UKnf
         8aj8zfq21M09dAtT0R9pjniAsqsRQsb4jclTLYFoIzTdyk+ryzdVwroJDh9uuamZdq35
         C3NQfmDYKDrC5zuL2zRpMzad2Z6vR3rkjnozi7RaqtZC8AsNKL+iBzFjs8pXqUHJXE5j
         3g9g==
X-Gm-Message-State: AA+aEWb6w0qTLGgUSo9R7mRFANYjbQw5naFPYrwLbuYlMQeDWCkU42sf
        zf+Cs2pLroJRZVF/tSuGL4tyeOnj8Os=
X-Google-Smtp-Source: AFSGD/Uys3t+f94vnW0lBfVd9LV96L6pHgdP/t8mU8EO9vJu/gsqP+BDDu2J6BDZIcJq3eDgbiukDQ==
X-Received: by 2002:a1c:e287:: with SMTP id z129mr8506214wmg.71.1543847675524;
        Mon, 03 Dec 2018 06:34:35 -0800 (PST)
Received: from localhost.localdomain ([151.66.39.232])
        by smtp.gmail.com with ESMTPSA id c77sm9911023wmh.12.2018.12.03.06.34.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Dec 2018 06:34:34 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] add rx buffer recycle support to mt76x2e/mt76x0e drivers
Date:   Mon,  3 Dec 2018 15:34:23 +0100
Message-Id: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add the capability to recycle rx buffers if they are not consumed by networking
stack.
This series is based on 'mt76: add size check for additional rx fragments' series:
https://patchwork.kernel.org/patch/10709453/

Lorenzo Bianconi (2):
  mt76: dma: do not build skb if reported len does not fit in buf_size
  mt76: dma: add rx buffer recycle support

 drivers/net/wireless/mediatek/mt76/dma.c  | 75 +++++++++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76.h |  3 +
 2 files changed, 67 insertions(+), 11 deletions(-)

-- 
2.19.2

