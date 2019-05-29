Return-Path: <SRS0=kjT+=T5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5579FC28CC0
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 12:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C7620673
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 12:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfE2Mwk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 May 2019 08:52:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:33788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727014AbfE2Mwj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 May 2019 08:52:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E19BBB008;
        Wed, 29 May 2019 12:52:37 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-wireless@vger.kernel.org
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, huangwen@venustech.com.cn,
        Solar Designer <solar@openwall.com>,
        Marcus Meissner <meissner@suse.de>
Subject: [PATCH 0/2] Buffer overflow / read checks in mwifiex
Date:   Wed, 29 May 2019 14:52:18 +0200
Message-Id: <20190529125220.17066-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

this is fixes for a few spots that perform memcpy() without checking
the source and the destination size in mwifiex driver, which may lead
to buffer overflows or read over boundary.


Takashi

===

Takashi Iwai (2):
  mwifiex: Fix possible buffer overflows at parsing bss descriptor
  mwifiex: Abort at too short BSS descriptor element

 drivers/net/wireless/marvell/mwifiex/scan.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

-- 
2.16.4

