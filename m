Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC971C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88AA320882
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554198489;
	bh=QbYgWBCBo01RAshNG8iLRlylBXeEBWV8wU//zoMdP7Q=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=AutHzx6jOzF3UWn1vlJO7c25W1gAnA+WoqKYPv3uGfl+iqXlPAPSZGEmCsGhBUNDa
	 4ASsxChL9BmRD1BMnhze8h+eEhDmR1RJWxjFONrdH2+TnfTDRBgHgxNwRbgBPIDmwU
	 /m4t/SglkPSvmADigGp7mB9N3QzRtGH3Py3mPeVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfDBJsI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfDBJsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 05:48:08 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6CC3207E0;
        Tue,  2 Apr 2019 09:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554198487;
        bh=QbYgWBCBo01RAshNG8iLRlylBXeEBWV8wU//zoMdP7Q=;
        h=From:To:Cc:Subject:Date:From;
        b=B8KpJVBmPhan5IvjCbZlM9L8UyMi6CXrHzcjtuiIGk0JD1LAjiL2IK1hyXHXXuF33
         Lx0sewZvKAL1xM2+LzyW/RaDDFZCuomHji/PJUOCGU9n8PlsNEWk/cY7K8hxfl/MzA
         PjoHE5DLcpjhI4YnuHkcwemW0WO3r52ZjUVKe/2Y=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/4] add missing bits for mt7615 support
Date:   Tue,  2 Apr 2019 11:47:55 +0200
Message-Id: <cover.1554194917.git.lorenzo@kernel.org>
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

Changes since v1:
- remove flags from mt76_txwi_cache

Lorenzo Bianconi (4):
  mt76: set txwi_size according to the driver value
  mt76: add skb pointer to mt76_tx_info
  mt76: dma: introduce skb field in mt76_txwi_cache
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
 drivers/net/wireless/mediatek/mt76/tx.c       | 13 +++++----
 drivers/net/wireless/mediatek/mt76/usb.c      | 14 +++++----
 13 files changed, 79 insertions(+), 56 deletions(-)

-- 
2.20.1

