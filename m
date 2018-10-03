Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9B2C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8413120835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8413120835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbeJCRkg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:40:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55261 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbeJCRkg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:40:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id r63-v6so5249321wma.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 03:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ywcLLs1qG7hl1Cc4SA5IT7VmEdNpSEhPoN0SR7GM2SE=;
        b=cc3QXzGuHdmFkODlO/UResjSI9o0mizx5ELCIAbHU3tSMfVr6fJZkm5nGGC06wgywu
         WZ2Pwjss/j8C5rwqVU9RI73R5q5kolDI3zz21jFgfkmKdk1oJJcl9lMStWBKnVvC4Baj
         yRAHD3ezJ0kDx41wZZxGG/DX3D1/RFrQUGVMREq0bsXUv6l8+u/jHBAqL1bpncEAyfvQ
         KRDrfo8jHsQjrA0VJVh0+Nk5yOgnKZ1uBkefVNVuccN4fAFWOaGhLo7c7Gwyjltz1RQH
         VxAEkQH/gl3PiHeMEGQJdLmRiorbqK5s0sKFSPNMC1IHmlXFma0oY5Oho1lYRt4axtjC
         mPjg==
X-Gm-Message-State: ABuFfohQTFAFOjkfJKxx+LdkHpk1a7Tzo9v1nfcpiGPV/BmI6/LtTbYH
        lysDkq+z6A0oOAR41DB/0dy1zw==
X-Google-Smtp-Source: ACcGV63jjix04PMcwwlyEjGjRV41H9TLRmz/N+W61yCGofRRtGIW03/5Nvv0uNQbeS6kRa/6yq323w==
X-Received: by 2002:a1c:7dd5:: with SMTP id y204-v6mr1116806wmc.63.1538563963676;
        Wed, 03 Oct 2018 03:52:43 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e67-v6sm1782486wmd.41.2018.10.03.03.52.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 03:52:42 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] fix mt76x0u driver hw stop sequence
Date:   Wed,  3 Oct 2018 12:52:23 +0200
Message-Id: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix two issue introduced in mt76x0u driver with latest rework to
share hw initialization between mt760 and mt76x2 drivers

Lorenzo Bianconi (2):
  mt76: usb: fix hw initialization sequence
  mt76x0: usb: stop cal/mac workqueues at hw stop

Stanislaw Gruszka (1):
  mt76: fix frag length allocation for usb

 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 24 +++++++++----------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c      |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.17.1

