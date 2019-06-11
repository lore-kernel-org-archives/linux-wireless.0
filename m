Return-Path: <SRS0=ropy=UK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362A8C43218
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Jun 2019 06:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05CDC208E3
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Jun 2019 06:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560235142;
	bh=GGXM3SZmdTjhKTjDtww6bhbDVxk7YucB7AQVgYMLpy0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=R8QJlgxx3S3/TVrWkVXqQjwyWTuhpZvCC7GEdzi2mxNTL7W+/TwtPYZrQBhjrA0K3
	 2BKFPXq5R6u/9nKxAOqEJ4DqKizDLwXvybDNM9MaCtkbWQoAGee8WLDYGU3JGm71n+
	 qnBbSdEm48x/uIFIC1HELi9NAQVFlkpEh0peAzOU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391272AbfFKGjB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Jun 2019 02:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390485AbfFKGjB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jun 2019 02:39:01 -0400
Received: from localhost.localdomain (unknown [151.66.40.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72F6E20896;
        Tue, 11 Jun 2019 06:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560235140;
        bh=GGXM3SZmdTjhKTjDtww6bhbDVxk7YucB7AQVgYMLpy0=;
        h=From:To:Cc:Subject:Date:From;
        b=IN4TJXi5dVBNFK2OKxubNpDydmzU18+e1do0AeUPQETVWkTpQrITUhZrdEiDOzoWr
         edjOVNrSNS9hpJQDL6Mt8JZg0GBpugVBAijfGG01hJlXmHvAOhpw9ZDM9WkIqqghCU
         R1ln8ezZIytN2dbj1pHsYWrJLnPWQfyNt4KEu+to=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH 0/2] take into account external PA when configuring tx power
Date:   Tue, 11 Jun 2019 08:38:51 +0200
Message-Id: <cover.1560234876.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Refer to proper eeprom fields configuring tx power when TSSI calibration is
disabled. Moreover initialize per-channel tx power

Lorenzo Bianconi (2):
  mt76: mt7615: init per-channel target power
  mt76: mt7615: take into account extPA when configuring tx power

 .../wireless/mediatek/mt76/mt7615/eeprom.c    | 12 ++++-
 .../wireless/mediatek/mt76/mt7615/eeprom.h    | 17 +++++++
 .../net/wireless/mediatek/mt76/mt7615/init.c  | 46 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 10 ++--
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  3 +-
 5 files changed, 82 insertions(+), 6 deletions(-)

-- 
2.21.0

