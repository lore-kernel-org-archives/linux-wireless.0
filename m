Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36044C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F23EB2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F23EB2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389359AbeKGC0M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:26:12 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:45421 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:26:12 -0500
Received: by mail-wr1-f46.google.com with SMTP id k15-v6so11380419wre.12
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 09:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wfqo611yr7UUij4kzn2874ewIpMjheK5uAyc76xxg4o=;
        b=SVHOPlEWpIdXaWs9TvXkm/o6bFmpiZBzuljEn24FJDc4VJgdjXZnyjzdCmnmHnG8ee
         e0fMW9MzC+HS+s6jSmWQ+qbPnWFdV7TpXyU6VlGNShvAEz/Qy1SCy0KPADHNOoUqbg+U
         r1Hz+E1Xmq8mgxVMah6B9H3mLRZhm850p4sga6Q8dm0uslek6KVipDd0dFg6WGjOKUt8
         O7H4hyEWAKl71TABX7qylwhlho+wde6bjr3HiGKPa6NVVJuyo+/5cHF1ea6j01fP5CLM
         OSkIivnJEnQzv+HJzoU2yCfLCDtp5l2h9WtUiclcKL5pH7DaHr7T+Zal7OVm0Qj7za5k
         W2QA==
X-Gm-Message-State: AGRZ1gIQU6PWe0m8OU9lEgjklhva3C6ihBvXD367Eg7I/iRQJwP3M4IM
        yuMqa/XBNXdBCPA2rsD03TKePA==
X-Google-Smtp-Source: AJdET5cQOIeKq2Cz04ae9AbFCJcJs19VzMhbM8+35iQY7YgaLqatBSdiYlnMyP5SE1ur7bmevFx5Cg==
X-Received: by 2002:a05:6000:12d0:: with SMTP id l16mr20120998wrx.27.1541523603218;
        Tue, 06 Nov 2018 09:00:03 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x142-v6sm649271wmd.20.2018.11.06.09.00.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Nov 2018 09:00:02 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] unify drv_bss_info_changed between mt76x0u and mt76x2u
Date:   Tue,  6 Nov 2018 17:59:44 +0100
Message-Id: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Perform channel calibration after each channel switch and not only after
connection establishment.
Enable MCU_CAL_TX_SHAPING phy calibration.
Moreover remove remove beacon offset configuration since the driver
supports just client mode

Lorenzo Bianconi (4):
  mt76x2u: phy: add TX_SHAPING calibration
  mt76x2u: phy: run phy_channel_calibrate after channel switch
  mt76x2u: main: use mt76x02_bss_info_changed utility routine
  mt76x2u: init: remove mt76x2u_init_beacon_offsets routine

 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  1 -
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  | 10 -------
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 28 ++-----------------
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   | 19 +++++++++++--
 4 files changed, 19 insertions(+), 39 deletions(-)

-- 
2.17.2

