Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397E4C7112A
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8C4F2077C
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 16:38:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8C4F2077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbeJOATy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 20:19:54 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:34592 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOATy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 20:19:54 -0400
Received: by mail-wm1-f43.google.com with SMTP id z25-v6so21372863wmf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 09:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DgVeZi8Ym7xLYMDq3Sk+q1VZqI0nbkmgZQhndiDjEh4=;
        b=GWb+WFD4/XzjbypNRKeGC2g/9lWv/lVl57QgnfImGpLeGaaTkCZaAdA/6zdni208E/
         x3xDFQnbB3ttGzV90BGRwcACXPxpdVjhA8OnHGO6q7O818mbb0IrAB4Ho/vH2EWCf+7S
         HSYQzGJjQ3EtfXMSs8I/iyz0Ni12sCjv3buUTlW16Zac1PifuCgvTw2iY1Y2xXb8Eiym
         2f82aIlhU4ioVuZCxTsxKLlFKUJdhYkMO69gM1AnvXsoHz2ES0Q4g/TB7dMqy6NirnK3
         31tfOH+g3+9DeQh6qoRT3ydbbq13KO3/nFXfCilL05PfRNwu2WTyYxLEsoKvv9jaYxv7
         x/xQ==
X-Gm-Message-State: ABuFfohOZFQsIroMme5rf8NKLq9Zef+4aWS+wabqYwZWIbhQ2Q3KxlgJ
        7zjvmDkNIknxiznY7k+4cQn11G9KdM8=
X-Google-Smtp-Source: ACcGV62ZAcbkqyWv9WOYjcz7CO1z/D63wpwfTcUCz8jS+q3kKmua4qc7XpZQbSRjkso99GoS7zLE/Q==
X-Received: by 2002:a7b:c187:: with SMTP id y7-v6mr10736153wmi.136.1539535097769;
        Sun, 14 Oct 2018 09:38:17 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id m143-v6sm7506910wmd.29.2018.10.14.09.38.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 09:38:16 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] update firmware used on mt76x2u driver
Date:   Sun, 14 Oct 2018 18:38:04 +0200
Message-Id: <cover.1539534731.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Align mt76x2 pcie/usb firmware.
Update vga logic on mt76x2u driver

Lorenzo Bianconi (2):
  mt76x2: align mt76x2 and mt76x2u firmware
  mt76x2u: align channel gain logic to mt76x2 one

 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   |   1 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |  21 ----
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  90 --------------
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 111 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  41 +------
 8 files changed, 118 insertions(+), 158 deletions(-)

-- 
2.19.0

