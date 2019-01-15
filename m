Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDF6C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B42420657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbfAOMdz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:33:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36563 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729494AbfAOMdy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 07:33:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so2782379wrp.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 04:33:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DpAN6WLQwNZU7B0utfyl0xaL1wG0IVu70tVRgRK1NNI=;
        b=asktHSiF7UjSCfF8JvBOkY45BA23MdjO7GEvoGY2fTU5pxH6babcIsXErCEhd6F4wD
         r/SGm53jm03fKm8s0MaD2LTHtRkcZ5mFjqXpx9yxB2tkHiasn5zhQeamXtWFYIitlkDq
         dxayC1LLpJx4kDQjQD/r57GiODXkCoJG0vHjGR2ykEpThF6NUkJoY7nc1ZNmSP0N0m5K
         h0SeM9jS8vW/wdEBxN7QHYFWXV6YMPfC+blipjvGljosQReg3HWxviArmjK9z39IiIcz
         lHp4P8JEG+Cy6romzvyO8epejJjkoJrB4/IsODFeb0DnMKS+S2ffgyjVGHguJN9i6PUp
         bi1A==
X-Gm-Message-State: AJcUukeFQzX6lzbV0hfeWCGPcZ1gSuJYOfMLr2GX3ay5BRdPdbAOCzI4
        4uwj8l623MRom5RlwoHUbYq5DA==
X-Google-Smtp-Source: ALg8bN5T8aWAroz9AWMZ/rqJ1m9Tk2690kuN9Smewe2zTZbXZU7eRQhiKBU66gONyS5VFOGv//luCQ==
X-Received: by 2002:adf:f691:: with SMTP id v17mr2888719wrp.114.1547555632049;
        Tue, 15 Jan 2019 04:33:52 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a6sm28218186wmh.10.2019.01.15.04.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 04:33:51 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, rosenp@gmail.com,
        sgruszka@redhat.com
Subject: [RFC 0/4] do not use sg if not properly supported by usb controller
Date:   Tue, 15 Jan 2019 13:33:41 +0100
Message-Id: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use linear fragment and not a single usb scatter-gather buffer in mt76u
{tx,rx} datapath if the usb controller has sg data length constraints.
Moreover add disable_usb_sg module parameter in order to explicitly
disable scatter-gather. Some users have reported sg issues on AMD IOMMU

Lorenzo Bianconi (4):
  mt76: usb: move mt76u_check_sg in usb.c
  mt76: usb: do not use sg buffer for fw upload
  mt76: usb: use a linear buffer for tx/rx datapath if sg is not
    supported
  mt76: usb: introduce disable_usb_sg parameter

 drivers/net/wireless/mediatek/mt76/mt76.h     |  14 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |   9 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 132 +++++++++++++-----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  |   5 +-
 6 files changed, 107 insertions(+), 57 deletions(-)

-- 
2.20.1

