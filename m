Return-Path: <SRS0=BEmV=76=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE02C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 21:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3409D2166E
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 21:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFQVZN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jun 2020 17:25:13 -0400
Received: from muru.com ([72.249.23.125]:58160 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFQVZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jun 2020 17:25:13 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id F3F298005;
        Wed, 17 Jun 2020 21:26:03 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/4] Improvments for wlcore irq and resume for v5.9
Date:   Wed, 17 Jun 2020 14:25:01 -0700
Message-Id: <20200617212505.62519-1-tony@atomide.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Here are few improvments for wlcore interrupt handling and resume ELP
handling for v5.9.

Regards,

Tony


Tony Lindgren (4):
  wlcore: Use spin_trylock in wlcore_irq_locked() for running the queue
  wlcore: Use spin_trylock in wlcore_irq() to see if we need to queue tx
  wlcore: Simplify runtime resume ELP path
  wlcore: Remove pointless spinlock

 drivers/net/wireless/ti/wlcore/main.c | 84 +++++++++++++--------------
 1 file changed, 39 insertions(+), 45 deletions(-)

-- 
2.27.0
