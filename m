Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041DEC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 17:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCEED21A4C
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 17:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550339283;
	bh=YoGSCs9FcMfq8yteONgXjXg3ZFMDzedQfUKoRAHJ2h0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XaC6D5Mi6CLCokjwKACyVDVdX7G2GU2pHA07VLE3IuiJOzXyg5Mf0Gwwv0gE/9tEy
	 sNSlKilL75oLohapWJUvWNGsqPGzAIq0z7Iq5x2QjPFUxtzs2n8HRmdy4SqFL1ECsb
	 1McPyHOCeULQJMp6TQO14XZpgHe7wcvIUskq2AOE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbfBPRsC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 12:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfBPRsC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 12:48:02 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC7CD2192B;
        Sat, 16 Feb 2019 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550339282;
        bh=YoGSCs9FcMfq8yteONgXjXg3ZFMDzedQfUKoRAHJ2h0=;
        h=From:To:Cc:Subject:Date:From;
        b=2CeskSFCZaO0DyVW0b9RGOb/tM5+R+n1mugwUMZF40HZNBmPMtP6mxYYozemQe4Of
         m3RU+IaNdqZm7QzWSA7LRqKJMJVbFH8J2K8BPj3BEf0/ZeN2s6o6qxDuk+mfO8VBC7
         a37oppHLnbah7AzQ8lvOHnP2y8/KHSCjK2qGznOU=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 0/2] remove qid dependency from mt76-core code
Date:   Sat, 16 Feb 2019 18:47:32 +0100
Message-Id: <cover.1550336347.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move queue id dependency in driver specific tx queue initialization code
since new chipsets rely on a different tx queue enumeration scheme.
Add the possibility to specify qid in mt76_tx routine

Lorenzo Bianconi (2):
  mt76: add qid parameter to mt76_tx signature
  mt76: move txq qid dependency in driver specific code

 drivers/net/wireless/mediatek/mt76/mac80211.c | 27 +++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76.h     | 14 ++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  8 +++++-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 ++
 drivers/net/wireless/mediatek/mt76/tx.c       | 28 +++++--------------
 5 files changed, 45 insertions(+), 34 deletions(-)

-- 
2.20.1

