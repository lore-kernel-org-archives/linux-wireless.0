Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E25C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA020222DA
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553434290;
	bh=h/Xmg4F9Wpf0raWl08QBsAxXt4NmHs8v+vr9aWqVGBs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vY08SzWQgjHRwbDf3uV1ODppHwHTKS6g+3bpyEssu6X1cd2EPSUgAPZTbNrfKjY90
	 6NT8ZclmogCCGEmKlmzzAOUeQ0nlM1Dqv5ExfnV7euD5EJuQy3f0psHV4KqkszAYm/
	 ZHq3DvV35Q62hkKifzMz1auUQqLZM2onne1kbNMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfCXNb3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 09:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfCXNb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 09:31:29 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3349A222D6;
        Sun, 24 Mar 2019 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553434288;
        bh=h/Xmg4F9Wpf0raWl08QBsAxXt4NmHs8v+vr9aWqVGBs=;
        h=From:To:Cc:Subject:Date:From;
        b=mis2pQjv0FtbKDdRHJoKyx21cwoSyFS2ReqiZ6Lhnp+b2nhQDd2mVKfG87e5LIVGs
         LTlqTdsgjsZ9z7cnUePhFG6JFIiQzxZTGAWhLl0fHsYclJA6iv+4w0+RREcvR5uwBk
         wWkQPzyrjSboM0XTAqZcPlRgLeGD/hNMhZnQuE4w=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] add missing bits for mt7615 support
Date:   Sun, 24 Mar 2019 14:31:07 +0100
Message-Id: <cover.1553425942.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a preliminary series to add support for mt7615.
Dynamically allocate txwi descriptor.
Add missing bit in dma error data path.
This series is based on https://patchwork.kernel.org/patch/10856027/

Lorenzo Bianconi (4):
  mt76: set txwi_size according to the driver value
  mt76: add skb pointer to mt76_tx_info
  mt76: dma: introduce skb and flags fields in mt76_txwi_cache
  mt76: dma: add skb check for dummy pointer

 drivers/net/wireless/mediatek/mt76/dma.c      | 29 +++++++++++--------
 drivers/net/wireless/mediatek/mt76/dma.h      |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 19 ++++++++----
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 11 +++----
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  4 +--
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  4 +--
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  4 ++-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  1 -
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 12 ++++----
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  4 +--
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 18 ++++++------
 drivers/net/wireless/mediatek/mt76/tx.c       | 14 +++++----
 drivers/net/wireless/mediatek/mt76/usb.c      | 14 +++++----
 13 files changed, 80 insertions(+), 56 deletions(-)

-- 
2.20.1

