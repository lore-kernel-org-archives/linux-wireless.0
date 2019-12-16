Return-Path: <SRS0=mHGl=2G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF24C43603
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 13:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C54320717
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576502407;
	bh=4S31E7c3YFrAVQlSlYC6IelzuWjUFYPDZL1zcK1xuHw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=REqRkioZ2LwW4D/jLDWp+b7Vz9AecgooGj+Jw6uqeunJF8WiymQ6YQ63c5KISQgEx
	 0ofQ19YT0ku5whpgIHXNKJlKzGshQV3JmPaGN68dYeE2dGy4LNLvoZ11CNddnQzo1S
	 bgt2miPOKnt3AmXMZoETudAFRhKiGmXNDcdaRt60=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfLPNUG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Dec 2019 08:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfLPNUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Dec 2019 08:20:06 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE0A20684;
        Mon, 16 Dec 2019 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576502406;
        bh=4S31E7c3YFrAVQlSlYC6IelzuWjUFYPDZL1zcK1xuHw=;
        h=From:To:Cc:Subject:Date:From;
        b=IJdarKqIay6ewWe6EFSdc9lNyYRrmrTuW5m1VwNqrXzaZsa78r4ZseUDq3eNFdC8p
         xYeZZUaZdeY7Pdnk2uXVnflhvbykqii1qKf/McwnTSES85GnHli4h3RByw0f6s1TCL
         uzwGMhmZO9QdfSfrThsS5Rk/NAckh7tQGIsMHDNc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 0/2] improve mt76 led code readability
Date:   Mon, 16 Dec 2019 14:19:57 +0100
Message-Id: <cover.1576502217.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Improve code readability relying on FIELD_PREP macro for led register
definitions and remove open coding

Changes since v1:
- remove _MASK suffix from register definitions and move the
  code in *_init.c

Lorenzo Bianconi (2):
  mt76: mt76x02: simplify led reg definitions
  mt76: mt7603: simplify led reg definitions

 drivers/net/wireless/mediatek/mt76/mt7603/init.c  |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h  | 15 +++------------
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h | 12 +++---------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  6 +++---
 4 files changed, 12 insertions(+), 27 deletions(-)

-- 
2.21.0

