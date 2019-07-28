Return-Path: <SRS0=e+Sd=VZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAC9C433FF
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Jul 2019 19:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03512075C
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Jul 2019 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564340610;
	bh=7AnHIZ2osYDpMp8j9Xs2dM8DizB6AdRDdHxwAMPjiSs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=e4wdQsawtrxCJIAeLEdumnos9HPHEvPvfcA10x6M9wjRC8NSEHk8LRriGW2rxVM/6
	 CP5FunSXP4vkQu9asCKizg++ckHcgo6Igx1u27A8yYDxF9SBgn5UZ86t6ocjglgMbX
	 0FPQkonLKOXOOtYU0gB1943FVOp6KhvLVs2I18Uo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfG1TD3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Jul 2019 15:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfG1TD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jul 2019 15:03:28 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.36.246])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D33092075B;
        Sun, 28 Jul 2019 19:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564340608;
        bh=7AnHIZ2osYDpMp8j9Xs2dM8DizB6AdRDdHxwAMPjiSs=;
        h=From:To:Cc:Subject:Date:From;
        b=pEETWCI3Sgh38ushMHjvzhOTwzgxBy9aGY446AKRPm93r3Z8N2G8UYuCkwgK+Ijw5
         S1Vaa5hfr2IwkC5FSE0z5gB6jY8vLpqJFNJCgIwq9B27PUdgoR1LkKRgefuCQGSdXd
         KQHGUgr2P7wu5waW7wIsARATP0PqmMmgxmzimgAM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH 0/2] mt7615: add Smart Carrier Sense support
Date:   Sun, 28 Jul 2019 21:03:16 +0200
Message-Id: <cover.1564340063.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add Smart Carrier Sense (SCS) algorithm in order to tune device
sensitivity to track long-range clients and cut-off possible
interferences using RTS error rate and False CCA reported by the
radio

Lorenzo Bianconi (2):
  mt76: mt7615: rework locking scheme for mt7615_set_channel
  mt76: mt7615: add Smart Carrier Sense support

 drivers/net/wireless/mediatek/mt76/mt76.h     |   9 +-
 .../wireless/mediatek/mt76/mt7615/debugfs.c   |  39 ++++
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   1 +
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 176 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  15 +-
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  14 ++
 .../net/wireless/mediatek/mt76/mt7615/regs.h  |  36 ++++
 7 files changed, 281 insertions(+), 9 deletions(-)

-- 
2.21.0

