Return-Path: <SRS0=PXnU=XH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D4FC5ACAE
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 09:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C75220CC7
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Sep 2019 09:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568279210;
	bh=fZOJ2Kl0ZYjvKJA1CR34MEzzz3UcLv5pZOn5vtN+q48=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=0JFtT58a4Zd5Gyp/c4azWYWVp2EFmzR5e6cVHkViXif/pT3Vq4Lp7mAuULFBxYcVU
	 RS8Lq2i+QLCFAc9Hc96m35Z9Q7PZ9N/sXffrKUxMpHd94y8WDJMyPxAo9DaMkJoV/p
	 CiD3HHZMCkqvKHR8N5ZZGV4ysiQ7PJ6/KBLqgBTI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfILJGt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Sep 2019 05:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730327AbfILJGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Sep 2019 05:06:49 -0400
Received: from localhost.localdomain (unknown [151.66.2.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4944208C2;
        Thu, 12 Sep 2019 09:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568279208;
        bh=fZOJ2Kl0ZYjvKJA1CR34MEzzz3UcLv5pZOn5vtN+q48=;
        h=From:To:Cc:Subject:Date:From;
        b=169gd4eVjfBA6jvXkFxWI3dWD4W2ry1bVQZ5L1fAKVo84qRVCaZqz/abb+zqNelHr
         YVopykdW1rXIfleVp8KH0H15zDBuLTEid3644/Fr0WmiH1mQgkNMZwuazLM/xqn79B
         JaZYWfcBtMXcx2vrEVsnIZY7yxc1d8rbODTS5m8Y=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com
Subject: [PATCH 0/4] mt76x02: tidy up mib counters
Date:   Thu, 12 Sep 2019 11:06:34 +0200
Message-Id: <cover.1568278771.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move shared mib counter code in common code.
Reset aggregation statistics restarting the device for mt76x02u and mt76x0e
drivers.
Unify mt76x02u_mac_start for mt76x2u and mt76x0u drivers

Lorenzo Bianconi (4):
  mt76: mt76x02: move mac_reset_counter in mt76x02_lib module
  mt76: mt76x2: move mt76x02_mac_reset_counters in mt76x02_mac_start
  mt76: mt76x0u: reset counter starting the device
  mt76: mt76x02u: move mt76x02u_mac_start in mt76x02-usb moudle

 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 27 -------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 21 +++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  1 +
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 21 +++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  1 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 21 ++-------------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  6 ++---
 .../wireless/mediatek/mt76/mt76x2/usb_mac.c   | 27 -------------------
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  3 ++-
 14 files changed, 52 insertions(+), 82 deletions(-)

-- 
2.21.0

