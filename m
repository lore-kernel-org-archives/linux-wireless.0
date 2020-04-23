Return-Path: <SRS0=d7P/=6H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53543C55186
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 13:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 327402076C
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587649686;
	bh=D8S/kaPUet1jtroDZoG5jlkLcoT7q3H268hed4qYzag=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=kdxp6huy32aKKyprLpjhl9Rc3t8I4XfiK8PiIxCHgTLW9DNmhbWx1I3WSwaWkkc8N
	 uIpOq2nr8oIMBgyIHi1xoNCWarVpi04Qu0KhnD3dZNkELHgAHxjxCBSFTJsbcJz3He
	 PJA89tza0xZCy6/Zj21C6JUl08mMjkS1OEmLijtI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgDWNsF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Apr 2020 09:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgDWNsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Apr 2020 09:48:05 -0400
Received: from localhost.localdomain.com (unknown [151.66.196.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDD6020728;
        Thu, 23 Apr 2020 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587649685;
        bh=D8S/kaPUet1jtroDZoG5jlkLcoT7q3H268hed4qYzag=;
        h=From:To:Cc:Subject:Date:From;
        b=JSe7NVeOGu4ZItf1MTE63NMwPkzUG2IDMGsZ6T+gweEqCHIxDpAX7EvsLqqcKxwAj
         258xkme171oClv/VarOXjX648QcbFR86/iYKQ8FWWlO61CBV9bGq0VKKF+Z3ch30tk
         bjcy8u2kw5C9djv6v20AddylAZ3UlRb/EqOa3AwA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH 0/2] mt7615_mcu_add_bss_info fixes
Date:   Thu, 23 Apr 2020 15:47:53 +0200
Message-Id: <cover.1587649519.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix mt7615_mcu_add_bss_info for 7663 chipset
Avoid sta lookup for mt7615 devices

Lorenzo Bianconi (1):
  mt76: mt7615: add sta pointer to mt7615_mcu_add_bss_info signature

Sean Wang (1):
  mt76: mt7663: fix up BMC entry indicated to unicmd firmware

 .../net/wireless/mediatek/mt76/mt7615/main.c  |  6 +--
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 43 ++++---------------
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  2 +-
 3 files changed, 13 insertions(+), 38 deletions(-)

-- 
2.25.3

