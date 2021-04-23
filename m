Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1461C43460
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Apr 2021 14:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D1C461463
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Apr 2021 14:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbhDWO1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Apr 2021 10:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231220AbhDWO1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Apr 2021 10:27:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B31E61450;
        Fri, 23 Apr 2021 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619188037;
        bh=x90t5aZYlXw+246UBODxc7/9Mq+jhnaQM29no9QuxiI=;
        h=From:To:Cc:Subject:Date:From;
        b=RJch/YZs99pPxya2UZ1DA/H9/vlBQ1MFMYSPz/geL9AOpkrr8t1R102dwEeKo+tVH
         qc80exuSm537fr3caxyLjDLxQsnpyDKQK37q0nNThqk5m8AO9oWY4fu5Adwfg6O16b
         /j8EB+jzJJoMUWmT2vLc8Q6/f1qsnjluztLWm4yA7yrn8zmzg0LhaaMJ4dnhoplZkl
         UQb0UjOcUWpPYwTeFJ3D2FOYHtIJi4JeIQ5CZkKXIBtoOMYPsDuHYXaJMQSKjGv5CI
         LqCTDazJewlyh5eSXcEJhT5+RQzS0nqSu3x94Y8CZPjJDBnn9LkXK2uBeh9WK6QoqX
         RjYSl0EmCfGdg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, kvalo@codeaurora.org
Subject: [PATCH 0/3] mt7921 runtime-pm fixes 
Date:   Fri, 23 Apr 2021 16:27:08 +0200
Message-Id: <cover.1619187875.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series contains three mt7921 fixes introduce with new runtime-pm rework

Lorenzo Bianconi (3):
  mt76: mt7921: fix possible AOOB issue in mt7921_mcu_tx_rate_report
  mt76: connac: do not schedule wake_work if the runtime-pm is disabled
  mt76: connac: do not schedule mac_work if the device is not running

 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |  5 +++--
 .../net/wireless/mediatek/mt76/mt76_connac.h    |  6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c |  5 +++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 17 ++++++++++-------
 4 files changed, 22 insertions(+), 11 deletions(-)

-- 
2.30.2

