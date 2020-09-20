Return-Path: <SRS0=Ix9G=C5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71989C43466
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Sep 2020 13:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42DAD21531
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Sep 2020 13:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgITN0Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Sep 2020 09:26:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:35474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgITN0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Sep 2020 09:26:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 14E0EAD32;
        Sun, 20 Sep 2020 13:26:59 +0000 (UTC)
From:   =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc:     Chin-Yen Lee <timlee@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-realtek-soc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH 0/2] net: wireless: rtw88: Fix oops on probe errors
Date:   Sun, 20 Sep 2020 15:26:19 +0200
Message-Id: <20200920132621.26468-1-afaerber@suse.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

This mini-series fixes oopses in rtw88 device probe error handling,
resulting from asynchronous firmware loading.

Since there does not appear to be a public kernel API for canceling
scheduled or ongoing firmware loads, it seems we need to wait with
teardown until rtw88's callback was invoked and signals completion.

Found on RTD1296 arm64 SoC with experimental PCI host bridge driver
(https://github.com/afaerber/linux/commits/rtd1295-next) with a 4K
physical bar window, resulting in rtw_pci_setup_resource() failing,
or with non-implemented 4K remapping resulting in rtw_pci_read32()
returning 0xffffffff values and causing rtw_mac_power_on() to fail.

Cheers,
Andreas

Andreas Färber (2):
  rtw88: Fix probe error handling race with firmware loading
  rtw88: Fix potential probe error handling race with wow firmware
    loading

 drivers/net/wireless/realtek/rtw88/main.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.28.0

