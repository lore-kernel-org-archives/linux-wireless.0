Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E64C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 16:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE65218CD
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 16:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551372897;
	bh=o3K+lb3IC7bs7ds9WvCj10TLKX1n89el3yGxxadP/gs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=SmDifiW+B7t8nYSzMItwyGGklR4pQrwsyjVEOOqZgcoFEFtgZgzgmrJKfuvnMU8k6
	 tml0pWC6P9wobIo3U5L8ht9A4SfjKNqzaOL8aBQoKcWUwXs1COaM9X8jrC3XlGelH4
	 h8fDIcUiGfb9sWVfqT2aF4FTCNHWX2mQSz1LibIU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbfB1Qy4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbfB1Qy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 11:54:56 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F672184A;
        Thu, 28 Feb 2019 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551372895;
        bh=o3K+lb3IC7bs7ds9WvCj10TLKX1n89el3yGxxadP/gs=;
        h=From:To:Cc:Subject:Date:From;
        b=VSVymuNf1x1LzQtWWVpJVCXIy0aKi+aXLOiW5Jk3Jy73SB29zmRKCx5QAlfei2Aat
         QlWdnETXKONs+H4TUgOPZgTqEpiB6oDJ5ZUEAMGS6xDstZHVSfsx+smc1sXdNKPUYL
         y8DhJ2H86z8O9owfKOQCkafGNPgcSStsG4stAiiU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v3 0/2] move dma shared code in mt76 module
Date:   Thu, 28 Feb 2019 17:54:30 +0100
Message-Id: <cover.1551370209.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02/mt7603 dma shared code in mmio.c/dma.c in order to be
reused adding support for mt7603 driver

Changes since v2:
- squash mt7603 changes

Changes since v1:
- remove mt76_irq_enable/mt76_irq_disable
- move dma queue initialization in mt76_dma_alloc_queue
- move mt76_irq_enable call into the driver specific
  inline functions

Lorenzo Bianconi (2):
  mt76: mmio: move mt76x02_set_irq_mask in mt76 module
  mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module

 drivers/net/wireless/mediatek/mt76/dma.c      |  9 ++++-
 drivers/net/wireless/mediatek/mt76/mmio.c     | 13 +++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  6 ++-
 .../net/wireless/mediatek/mt76/mt7603/core.c  | 11 ------
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 26 +++++--------
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  6 +--
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  5 +--
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 38 +++++--------------
 8 files changed, 50 insertions(+), 64 deletions(-)

-- 
2.20.1

