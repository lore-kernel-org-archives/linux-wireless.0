Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CA7C432BE
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Aug 2021 10:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8C4610FB
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Aug 2021 10:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhHXKXj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Aug 2021 06:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236104AbhHXKXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Aug 2021 06:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6516127B;
        Tue, 24 Aug 2021 10:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629800575;
        bh=ECBCoUS2CDhZUwPBLz31g1DbxEATvf2+bA+eK8JJ2wE=;
        h=From:To:Cc:Subject:Date:From;
        b=ol86pxjG+S8hUszTvQry+/LqeEKE8eJZIn+/82x+ExtmBFtJLs7tSF37Out0TELrV
         pYiicxVcwPZJaXSs9ldudSbdoG23p+DwvNHuftBkQ7y6l4at1dqZOG1aNcXxQQUDCr
         PND0RmkI4oVRhmW90XSwhk+3Ws4gg3bN1fAKLoj2GT6gmBOgn0mUKMiDzPLXn2+HHi
         jQyDIL+TUPvnhPLdVtD8X7vS4cOmCH8a7a5g24LntHTrFlv0QdzXaoB94uFbAd6kuQ
         HVV9r+55ZGsdOlCKFG5s7ou7do448X+uAp2Uu3h89SZ3oRkWdR+NtLK9zftADCBCVJ
         PcLmCtvQopYsQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, Deren.Wu@mediatek.com
Subject: [PATCH 0/9] introduce 6GHz support to mt7921 driver
Date:   Tue, 24 Aug 2021 12:22:18 +0200
Message-Id: <cover.1629799385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi (9):
  mt76: connac: set 6G phymode in mt76_connac_get_phy_mode{,v2}
  mt76: connac: enable 6GHz band for hw scan
  mt76: connac: add 6GHz support to mt76_connac_mcu_set_channel_domain
  mt76: connac: set 6G phymode in single-sku support
  mt76: connac: add 6GHz support to mt76_connac_mcu_sta_tlv
  mt76: connac: add 6GHz support to mt76_connac_mcu_uni_add_bss
  mt76: connac: enable hw amsdu @ 6GHz
  mt76: add 6GHz support
  mt76: mt7921: add 6GHz support

 drivers/net/wireless/mediatek/mt76/eeprom.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mac80211.c | 128 +++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 139 +++++++++++++++---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  19 ++-
 .../net/wireless/mediatek/mt76/mt7921/mac.c   |  33 +++--
 .../net/wireless/mediatek/mt76/mt7921/main.c  |  39 ++++-
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |   6 +-
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |   2 +-
 9 files changed, 324 insertions(+), 46 deletions(-)

-- 
2.31.1

