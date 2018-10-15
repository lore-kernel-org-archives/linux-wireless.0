Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C197C7112A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3011420853
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3011420853
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbeJORR6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:17:58 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:50732 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbeJORR5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:17:57 -0400
Received: by mail-wm1-f53.google.com with SMTP id i8-v6so18048230wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7Ke5XmxLroKihdHemAgeFCtKAnMEqqdsFZGTlfuJuM=;
        b=c7adGv35YFVHwVhXeRRDbn53GfeVLP8zY0xa51EHtkbtg6wxFFHb8DTdzlGJYbgTUB
         yK9/UTzz7BICONjzwkIhw1dFE8+Zhj+WBbu0t9iJz+vFhEN2ywovaCxUq0k7mJI20Qjt
         RG2n1TQjtdxEhtwWZPWcDzSHwqowrlt26v+F+pi6i82MqpwKAY96boBYO0RWvkA+WLYi
         lzlsoaU5buYD8whFXDUD7y0I//oYAC0Z22hHl91vbM+FTqac+stKWDDWNB61eIeJPelY
         dTDKd5/7EJOrni72F6DqmdODOLmxTs22oYbQIzeScCIWYgAVds9/gZa2CHIwL4kxXw+c
         Synw==
X-Gm-Message-State: ABuFfogg1vot9//IUOO6DRFuoYB3Us93T1QIOQv+CMrSBF+LWItdyEk4
        FENTvV9o4eVGYztJFC5fHbWmTGsj2B8=
X-Google-Smtp-Source: ACcGV60p4aCR0DQ0UHct51kMc4ImWgGlrobFOYnmrADlVdbqYCxGKLBvFf3zVMo25CZwDDEavSey7w==
X-Received: by 2002:a1c:ee0c:: with SMTP id m12-v6mr13305761wmh.112.1539596008749;
        Mon, 15 Oct 2018 02:33:28 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] unify debugfs code between mt76x0 and mt76x2
Date:   Mon, 15 Oct 2018 11:33:10 +0200
Message-Id: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify debugfs implementation between mt76x0 and mt76x2 drivers.
Add get_survey support to mt76x0e driver
Add mac work support to mt76x2u driver

Lorenzo Bianconi (6):
  mt76x0: pci: add get_survey support
  mt76: move mt76x02_mac_work routine in mt76x02-lib module
  mt76: move mt76x02_debugfs in mt76x02-lib module
  mt76x0: use shared debugfs implementation
  mt76x0: use mt76x02_mac_work as stats handler
  mt76x2u: introduce mac workqueue support

 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 .../wireless/mediatek/mt76/mt76x0/Makefile    |  4 +-
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   | 87 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  5 +-
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 66 --------------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  5 ++
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  5 --
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  | 12 +--
 .../{mt76x2/debugfs.c => mt76x02_debugfs.c}   | 22 ++---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 56 ++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/init.c  |  2 +
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  2 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  5 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  5 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 35 --------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  2 +
 20 files changed, 93 insertions(+), 231 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/debugfs.c => mt76x02_debugfs.c} (86%)

-- 
2.19.0

