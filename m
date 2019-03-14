Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC844C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF1D2184E
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552571675;
	bh=9PC9RwMTVChq1QQdQ+ECl8ULYeqJFvRH+E8KDlJg3nI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vH8cICzhtPOfVkdwLLX+yjZYuEX1SB0MrAaSw7j/ziq6NnUwh66YGWGAgzJo7UeS+
	 KBC8VWd/GJgxccRZKbWepvIeuDWN/PsfRWlXd8lKSXTXv2wa9Q3Wdaf60hK0fpFH37
	 9RBnEVUkvkSCmoc87800TcLwrW/KghlWW3Fi2ewE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfCNNye (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfCNNye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:54:34 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D70D62184C;
        Thu, 14 Mar 2019 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552571674;
        bh=9PC9RwMTVChq1QQdQ+ECl8ULYeqJFvRH+E8KDlJg3nI=;
        h=From:To:Cc:Subject:Date:From;
        b=gb5/qwXV5jEnES4ybjFC2PIzW2K/GwIF5z1/7mjbbCwefn+vfB8mwoea94YLNIi1n
         L+v7Ql4etE3BCs6gAHNCl7XDja3ME1F4klw8AuszxFTNcxcBRKE4CXWqwPfVG8r6Kh
         IFs/7hnWRFfjdo42E6EAKABhHALyGMvO1TBDcisE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 0/4] move skb mapping before configuring txwi
Date:   Thu, 14 Mar 2019 14:54:08 +0100
Message-Id: <cover.1552570806.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move skb dma mapping before configuring txwi since new chipsets
(e.g. mt7615) will need dma addresses to properly configure txwi.
Introduce temporary tx_aligned4_skbs variable in order to tell mt76 layer
if it is necessary to align the 802.11 header (it will be removed as soon
as mac80211 will take care of it)

Changes since v1:
- move queue depth check after tx_prepare_skb pointer
- make mt76_inser_hdr_pad() return void

Lorenzo Bianconi (4):
  mt76: move mt76x02_insert_hdr_pad in mt76-core module
  mt76: mmio: move mt76_insert_hdr_pad in mt76_dma_tx_queue_skb
  mt76: move skb dma mapping before running tx_prepare_skb
  mt76: introduce mt76_tx_info data structure

 drivers/net/wireless/mediatek/mt76/dma.c      | 59 ++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt76.h     | 24 +++++++-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 21 +++----
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 16 -----
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
 11 files changed, 70 insertions(+), 65 deletions(-)

-- 
2.20.1

