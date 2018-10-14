Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92D8C7112A
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90A482077C
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90A482077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbeJOAhG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 20:37:06 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35282 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeJOAhG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 20:37:06 -0400
Received: by mail-wr1-f54.google.com with SMTP id w5-v6so18535612wrt.2
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 09:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7zRNh92uB0CFP/y2irYCAQBvptRJ06ZCvyhdc1QC3nQ=;
        b=b6DoYCDyY8CW6eR7fFqmPfh8s4Tr2oigFgATC7tynS31QIQPUR0ijvWhMOAKI9qHSp
         4Y2aSccTdntgH6KcSrq526W2M+rkTcRG05XzaiB9Yul/rsdlxs0w2dXbW0VhgojuKgXY
         fj2NfLSSVHJ//FPqws+seaj6MTtQhDagx5MtDS8JK2Touo04oHyfablZg5b570wq3tgW
         sFVmrMFfFW6yw2YC00RN4WBz5D8GOGbnTz63wO8Pabfyvy/PcLaDVzfO9l3z1n6FqVXf
         DobYZZFWONstG5cTJUoYBsYKMKigFjZMMg1BPm5ajehoAbCcXOuPAeglzbtFBlqT6yy9
         Y0wQ==
X-Gm-Message-State: ABuFfoix5zQnM7SPKBYJ7oXQ4XykWaGxwY7QtrSlI5Pnl8POUYCGfM8N
        LHQu1G5EJsgg522hIWbac+nx7Q==
X-Google-Smtp-Source: ACcGV63HWG1ZtFSFzRvo+UFBy0T+I6dHAvYon6ZKKeFFvmbAxPKr+JSJpdt9iiu5ZSKpw5ueUjyZ8Q==
X-Received: by 2002:adf:c88b:: with SMTP id k11-v6mr11722007wrh.6.1539536126750;
        Sun, 14 Oct 2018 09:55:26 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id k25-v6sm16068279wre.18.2018.10.14.09.55.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 09:55:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mt76x0: simplify rf configuration routines
Date:   Sun, 14 Oct 2018 18:55:17 +0200
Message-Id: <cover.1539535586.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simplify rf configuration using mt76x0_rf_wr, mt76x0_rf_set
and mt76x0_rf_clear routines. Moreover use mt76x0_phy as
prefix for phy routines

Lorenzo Bianconi (3):
  mt76x0: phy: use proper name convention
  mt76x0: phy: simplify rf configuration routines
  mt76x0: phy: improve code readability in initvals_phy.h

 .../net/wireless/mediatek/mt76/mt76x0/init.c  |    2 +-
 .../mediatek/mt76/mt76x0/initvals_phy.h       | 1313 ++++++++---------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |    2 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  375 ++---
 .../net/wireless/mediatek/mt76/mt76x0/phy.h   |   17 +
 5 files changed, 770 insertions(+), 939 deletions(-)

-- 
2.19.0

