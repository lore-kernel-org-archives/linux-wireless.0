Return-Path: <SRS0=oNpL=5Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0D3C3A5A0
	for <linux-wireless@archiver.kernel.org>; Thu,  9 Apr 2020 08:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6813622203
	for <linux-wireless@archiver.kernel.org>; Thu,  9 Apr 2020 08:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586422009;
	bh=jUfOmsLoGW71+bDFRzM3/lCI73zV3FaDo2M0AMpwE9E=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ONJNZCzKBRMQ5zfRNWRi7iy5k+MEJG01pouXsObXut+sdoRa1ru+KIbyevV4W5+xj
	 SKCXXQyWaXwS5q4bHcc4FZ4t96PRCbse2Lnt26tqD6Pv2PCoenY/KkJX6ThJIiKXPk
	 ixfCF1L39tBMi9qEJVu90tbR8CdRvhPUwvc1ArdQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgDIIqs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 9 Apr 2020 04:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgDIIqs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Apr 2020 04:46:48 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.151.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC72722202;
        Thu,  9 Apr 2020 08:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586422008;
        bh=jUfOmsLoGW71+bDFRzM3/lCI73zV3FaDo2M0AMpwE9E=;
        h=From:To:Cc:Subject:Date:From;
        b=J9cqC0piK2BIhOYYuXh5X0RUcjG9/HL/qaPq1ieiFVa//UN/eutlFBehlVPLCiZ8j
         AoYhYxwz7z0otj9BKCXZrZ7BTY1BlfnvOWEMmHzxTci7deXX0WjJhPDjneOZrxpl1z
         tqu0WcGt2m/ucCx5epCo7Yb/5RI9S8pGtNrlFWJ4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        soul.huang@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH 0/2] fix TXP DMA unmap for mt7622/mt7623
Date:   Thu,  9 Apr 2020 10:46:37 +0200
Message-Id: <cover.1586421673.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix a possible data corruption unmapping hw txp from DMA engine

Lorenzo Bianconi (2):
  mt76: mt7622: fix DMA unmap length
  mt76: mt7663: fix DMA unmap length

 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 17 +++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h |  3 +++
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c | 16 ++++++++++++----
 3 files changed, 28 insertions(+), 8 deletions(-)

-- 
2.25.2

