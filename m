Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83407C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5159C213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfBJVth (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:49:37 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:36268 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfBJVth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:49:37 -0500
Received: by mail-wm1-f47.google.com with SMTP id p6so13219583wmc.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 13:49:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vh1vjh/uuT1blOCDzsWvAZMAWjwJ16GKjp9aLsjCS84=;
        b=tIP5LB4VbxT4h68gc3NY9boPnFoNW/4/FtVhXemBpDIMkq7wZ975PGQM5eBdS7FHv6
         Kl3KWNdtSre/Tpmv6kogZgE2WSwUehB6GkWebxvfetNqlzw7sDTF4I1YxS9s23HHxdd/
         26d6GfsaVZ5QK4bTQx9M12LaPnsO+w+LTLz8i9LUbfWY7ejS3rTsmk9uWU/9X/uFgQ53
         LCZ6hThXYScmCcxmWlAx+lyE2Se63ajQkhX1yCoq0HOe00vmNFIPgNZKoddc/D6Eu8E1
         rQ7SUeHh7e7pW/KhOTzyQcHbPEpMDh/cuC0Cy6PXw5bpUYVcDOcP3qD6BLn1jUShggi+
         r/dA==
X-Gm-Message-State: AHQUAuanwtCOb2RVV4420oQlyc/CvSW90+v2rz8Zsg4A1GmtrLS9XFgV
        XQtsTt1pFvbkrjpRhWnKaeVvb1pFK6Q=
X-Google-Smtp-Source: AHgI3Ia8KeJrNA6gGjvrsEsHtpuOyCp5q52hD41rXbqgm0T88TRx3PW8aDMVbA4xQsw1MuR6qCeyWA==
X-Received: by 2002:a7b:c04f:: with SMTP id u15mr6661800wmc.49.1549835375077;
        Sun, 10 Feb 2019 13:49:35 -0800 (PST)
Received: from lore-desk.lan ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id q14sm5436323wrw.39.2019.02.10.13.49.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Feb 2019 13:49:34 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name, sgruszka@redhat.com, stefan.wahren@i2se.com
Subject: [PATCH wireless-drivers 0/3] fix multiple issues in mt76u error path
Date:   Sun, 10 Feb 2019 22:49:12 +0100
Message-Id: <cover.1549832428.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix following issues in mt76u initialization error path:
- NULL pointer dereference in mt76u_mcu_deinit
- possible memory leak in mt76u_buf_free
- use-after-free warning since mt76u_queues_deinit is run twice

This series has been tested running mt76x0u driver on rpi3+
(dwc_otg controller does not support SG I/O)

Lorenzo Bianconi (3):
  mt76: usb: fix possible NULL pointer dereference in mt76u_mcu_deinit
  mt76: usb: fix possible memory leak in mt76u_buf_free
  mt76: usb: do not run mt76u_queues_deinit twice

 drivers/net/wireless/mediatek/mt76/usb.c     | 25 ++++++++++----------
 drivers/net/wireless/mediatek/mt76/usb_mcu.c |  8 ++++---
 2 files changed, 17 insertions(+), 16 deletions(-)

-- 
2.20.1

