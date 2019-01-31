Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C28C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEAB3218EA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbfAaQ4L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:56:11 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:56107 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbfAaQ4K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:56:10 -0500
Received: by mail-wm1-f50.google.com with SMTP id y139so3224526wmc.5
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 08:56:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ft1KNwXOarlnLGCKv0krsIGkFfqPexFHilDx93edfE=;
        b=Np6hpn4QQoCwn4+clT50CNVVHj+9qJyQx8VpPQ90DEysU+cdOxq3/K5A1EtssKo8Pl
         qM9dZ9OfCAr5ULU4XoEYMvPH56FsMH2VCIBX4G7+FjpZSiaiaWAanL7eHjv4bM5bSgyN
         eFm6Fa+FVfGpSRIruTvBinpiq2slmsqiZXX6BmJY9ZIS4K1RrTWh+/AA6QnN25Dq5QdF
         1qA+AwuoJ5Prpvz+ebImCzArpkx+3DHaozTSOT+4KFLPu9YPfG04eom2uD/v8OpiCL7E
         0F5nlQGXLQ+1/WGxnx/CjeLsJSHYgKF3Gb3b6DjsUdW5DzxNGGkZ5LrtTFQTv0UDKbd5
         RW/w==
X-Gm-Message-State: AJcUukeDFw9fkRouvEpG1my1afBP9lavl15m3NU7G0o/3gxPffYEHjhr
        dTGFm7SSoavVIFhKfTsAPKcdqgQQOkc=
X-Google-Smtp-Source: ALg8bN6NN9eyqu5ZPO0+QwzyG6S0mAaTsXxC6dfFV7ECqBcpqcblQAsVnekfWZ2VIGlEUeDfZWNIlg==
X-Received: by 2002:a1c:dc02:: with SMTP id t2mr29515260wmg.78.1548953768508;
        Thu, 31 Jan 2019 08:56:08 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k128sm9502889wmd.37.2019.01.31.08.56.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 31 Jan 2019 08:56:07 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 0/4] mt76x{0,2}: move alloc_device common code in mt76_common module
Date:   Thu, 31 Jan 2019 17:55:53 +0100
Message-Id: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x{0,2} alloc_device common code in mt76_alloc_device and remove
duplicated code

Lorenzo Bianconi (4):
  mt76: move alloc_device common code in mt76_alloc_device
  mt76x2u: remove mt76x2u_alloc_device routine
  mt76x0: remove mt76x0u_alloc_device routine
  mt76x2: remove mt76x2_alloc_device routine

 drivers/net/wireless/mediatek/mt76/mac80211.c |  7 ++++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  5 ++--
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 22 ---------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  4 ---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 17 +++++++-----
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 22 ++++++++-------
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  1 -
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   | 26 +++++++++++++-----
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 27 -------------------
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   | 24 ++++++++++++-----
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  | 24 -----------------
 12 files changed, 71 insertions(+), 109 deletions(-)

-- 
2.20.1

