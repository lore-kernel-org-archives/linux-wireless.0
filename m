Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B50C4361A
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Dec 2020 10:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F58E22DFA
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Dec 2020 10:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgLEKjw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Dec 2020 05:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbgLEKgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Dec 2020 05:36:31 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] remove wake queue tx logic for usb/sdio
Date:   Sat,  5 Dec 2020 11:35:24 +0100
Message-Id: <cover.1607164041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Similar to mmio, remove queue wake logic for sdio and usb code path

Lorenzo Bianconi (2):
  mt76: usb: remove wake logic in mt76u_status_worker
  mt76: sdio: remove wake logic in mt76s_process_tx_queue

 drivers/net/wireless/mediatek/mt76/sdio.c | 15 +++------------
 drivers/net/wireless/mediatek/mt76/usb.c  |  7 -------
 2 files changed, 3 insertions(+), 19 deletions(-)

-- 
2.28.0

