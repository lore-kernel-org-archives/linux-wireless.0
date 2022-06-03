Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17A8C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  3 Jun 2022 09:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbiFCJhK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 3 Jun 2022 05:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243089AbiFCJhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Jun 2022 05:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452F4DF54
        for <linux-wireless@vger.kernel.org>; Fri,  3 Jun 2022 02:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B61F8619A2
        for <linux-wireless@vger.kernel.org>; Fri,  3 Jun 2022 09:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA30DC385A9;
        Fri,  3 Jun 2022 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654249025;
        bh=uGtzFjt+v4uOCLRZI3h81OqZxftOX5C27ZOUwk4GJP0=;
        h=From:To:Cc:Subject:Date:From;
        b=IBBWe35CwPvksbdwHI00s0FHTVp48sxsZh8oIZT85QAI+dYweuaX3vNwlS/cyUWwd
         hoJO9qHCzXMj8ClblgQmcm7/X0GBDaj5lQu9GViIDnzvaMubQ2dp4vF45lL4I2ilKB
         edV06cqLT7ec4QnBCmrjAPnPBTPZSdcMxOCJJq55v98SVHig9jEOEoAoEr/QwKnAJ0
         KjiWhumBc9FaHNDMa6jl9WqB+8eWPZCgW1wLN7kEeHuaIiibeR4K1tT5fkt7calGEt
         W4VB7KHrBiB8L1+tB38hUw7ZUllddiUp7X2PkcRxy8+3YJOOZGCOmciy/zW6ZROB1W
         CSmRRf0Z8ajzw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, sean.wang@mediatek.com
Subject: [PATCH 0/5] mt76: connac: move shared connac2 fw loading in connac module
Date:   Fri,  3 Jun 2022 11:36:41 +0200
Message-Id: <cover.1654248715.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi (5):
  mt76: connac: move shared fw structures in connac module
  mt76: mt7921: move fw toggle in mt7921_load_firmware
  mt76: connac: move mt76_connac2_load_ram in connac module
  mt76: connac: move mt76_connac2_load_patch in connac module
  mt76: mt7663: rely on mt76_connac2_fw_trailer

 .../net/wireless/mediatek/mt76/mt7615/mcu.c   |  18 +-
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 224 ++++++++++++++
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  66 ++++
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 259 +---------------
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 288 +-----------------
 5 files changed, 304 insertions(+), 551 deletions(-)

-- 
2.35.3

