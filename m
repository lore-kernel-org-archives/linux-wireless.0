Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FD8C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6850D222DA
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550163038;
	bh=OBKEOCxiprc2SUDsyJKhAXR7iKvqNALR20mkRQeLFTg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2FtWzXTObB3bVDoYTyWEgJV9jpsmhdDQNGdbm84vPuBdJgjo6vEONQhdolRV9GMrg
	 wjfJvXc0CP8fc7nnt3qFB2tvP9CeYBC5mA/Kd3Sago8k+MgkT7RniwNRt4csOD6BT4
	 EJDCjG29uvDUgoQuOqYrl58xaaDrgpylOVnQ7JyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbfBNQuh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbfBNQuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 11:50:37 -0500
Received: from localhost.localdomain (unknown [151.66.10.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 041B921928;
        Thu, 14 Feb 2019 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550163037;
        bh=OBKEOCxiprc2SUDsyJKhAXR7iKvqNALR20mkRQeLFTg=;
        h=From:To:Cc:Subject:Date:From;
        b=Te/7nBHRTnxuQ1cArtdr9opSsMUHoI/REc5D3Bkd9EHzwjHDnqFfW3OHiRn7sZHij
         CRqHt2RZTyuzJ++g8bnr5t+i9AYQuC5AP28QjOs+5QVVnxe14Xz1mc92+WgxSQ84s8
         DNWggrMEApDld/A5a/4fxwYx3DsHeekRAPo3qCD8=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 0/2] move dma shared code in mt76 module
Date:   Thu, 14 Feb 2019 17:50:18 +0100
Message-Id: <cover.1550162430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move mt76x02/mt7603 dma shared code in mmio.c/dma.c in order to be
reused adding support for mt7603 driver

Changes since v1:
- remove mt76_irq_enable/mt76_irq_disable
- move dma queue initialization in mt76_dma_alloc_queue
- move mt76_irq_enable call into the driver specific
  inline functions

Lorenzo Bianconi (2):
  mt76: mmio: move mt76x02_set_irq_mask in mt76 module
  mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module

 drivers/net/wireless/mediatek/mt76/dma.c      |  9 +++-
 drivers/net/wireless/mediatek/mt76/mmio.c     | 13 +++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  6 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  | 37 ++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 50 -------------------
 5 files changed, 60 insertions(+), 55 deletions(-)

-- 
2.20.1

