Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC18EC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 897C32084F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552307736;
	bh=kaqFsca8UM8Vk1ukikAcdmgTD6PhPgwG+UevE2hc5Hw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=lhFXKWztbakmHJeyfb3KDnaf6IW90hpnjkjSgIxMXulvVd21ika0xWw/e+rvZHMUD
	 wjR/WZ+Ief+bPzctKJSKFKOAk4d1idyi+igNUTNFrPxP4OwQaCpVPJTfhjGgjT4QHv
	 Z3aXXQXtQrOAXeNwE+KpKq6yEqPPhSVU0Y83Vn3o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfCKMff (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfCKMff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 08:35:35 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003B720657;
        Mon, 11 Mar 2019 12:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552307734;
        bh=kaqFsca8UM8Vk1ukikAcdmgTD6PhPgwG+UevE2hc5Hw=;
        h=From:To:Cc:Subject:Date:From;
        b=nwqfFO0g7sN7PYtzrOSZ3ie2bBpjfIy4ZgNNCvprkDBRqrcCWoP60fToDm3GRQNdS
         jWYDtiGKx0ezuBWBCnJRvEY+pT+Jr7v7YPCjFFbcqUZbDAZiZgeX44n4viJQlmnLIQ
         Oa3MbjiKP05oVFjKozZPt8PJgNYhGlyIzVh8rN+E=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH 0/4] move skb mapping before configuring txwi
Date:   Mon, 11 Mar 2019 13:35:22 +0100
Message-Id: <cover.1552306908.git.lorenzo@kernel.org>
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

Lorenzo Bianconi (4):
  mt76: move mt76x02_insert_hdr_pad in mt76-core module
  mt76: mmio: move mt76_insert_hdr_pad in mt76_dma_tx_queue_skb
  mt76: move skb dma mapping before running tx_prepare_skb
  mt76: introduce mt76_tx_info data structure

 drivers/net/wireless/mediatek/mt76/dma.c      | 55 +++++++++----------
 drivers/net/wireless/mediatek/mt76/mt76.h     | 25 ++++++++-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 21 +++----
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 16 ------
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
 11 files changed, 68 insertions(+), 64 deletions(-)

-- 
2.20.1

