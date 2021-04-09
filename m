Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F6CC433ED
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 22:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E12E61181
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 22:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhDIWwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Apr 2021 18:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234602AbhDIWwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Apr 2021 18:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4277D6102A;
        Fri,  9 Apr 2021 22:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618008719;
        bh=FLMVc0bTxf59YK5kjP4QaW2IICeR9O0zBZ84HO59h1w=;
        h=From:To:Cc:Subject:Date:From;
        b=BsngRLvR3xZi/jpvzG+8w2A6KnGxfDxVXXe79GRdCsTUN+TIqaJRD2ve7f4qOP0z7
         b2DrRDH294svGlEBWerC7Aih5y7xtDrbDHcUtZzJxB/ND3t2XqjPC9lnvhSwqS3gir
         zXzXJWJZBlOLmMi24tHPpZgOqX0yVjcNPo5UKprFTNfQgNqEJcSzfqGpDIvuZeVS8Z
         JLwk9BBBw0Hb9Ck+DkPmqGflOm+UewnVWFBpKDRPpFlM1ill0toyxEfnVkRPvgccYU
         J0qujsADbvElI60IydQ4P2JA67Uk9Z8s5ZCljhMqYsJHDIADPY0kdtijgeJ3LW+epH
         OEW39xX86Bwgw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH v2 0/7] introduce single-sku support for mt7663/mt7921 drivers
Date:   Sat, 10 Apr 2021 00:51:45 +0200
Message-Id: <cover.1618008449.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add per-rate power limitations for 802.11n/802.11ac/802.11ax rates to
mt7663/mt7921 drivers.
Introduce per-rate power limit dts parsing/binding.

Changes since v1:
- drop patch 1/8 and move regdomain property in mt76.yaml
- various power-limits property fixes in mt76.yaml

Felix Fietkau (2):
  mt76: add functions for parsing rate power limits from DT
  mt76: mt7615: implement support for using DT rate power limits

Lorenzo Bianconi (3):
  dt-bindings:net:wireless:mediatek,mt76: introduce power-limits node
  mt76: mt7615: do not use mt7615 single-sku values for mt7663
  mt76: introduce single-sku support for mt7663/mt7921

Sean Wang (1):
  mt76: mt7921: add dumping Tx power table

Shayne Chen (1):
  mt76: extend DT rate power limits to support 11ax devices

 .../bindings/net/wireless/mediatek,mt76.yaml  |  96 ++++++++
 drivers/net/wireless/mediatek/mt76/eeprom.c   | 220 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  13 ++
 .../net/wireless/mediatek/mt76/mt7615/init.c  |  15 +-
 .../net/wireless/mediatek/mt76/mt7615/main.c  |   4 +
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   |  66 +++++-
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 133 +++++++++++
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  24 ++
 .../wireless/mediatek/mt76/mt7921/debugfs.c   |  79 +++++++
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   2 +
 .../net/wireless/mediatek/mt76/mt7921/main.c  |   4 +
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  23 ++
 .../net/wireless/mediatek/mt76/mt7921/mcu.h   |  17 ++
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  31 +++
 14 files changed, 724 insertions(+), 3 deletions(-)

-- 
2.30.2

