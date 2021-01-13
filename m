Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0790C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Jan 2021 09:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 580882339D
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Jan 2021 09:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbhAMJYj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Jan 2021 04:24:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:45118 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbhAMJYj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jan 2021 04:24:39 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10D9NqSeA010640, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10D9NqSeA010640
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 17:23:52 +0800
Received: from localhost (172.21.69.213) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 13 Jan
 2021 17:23:51 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     <tony0620emma@gmail.com>, <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <phhuang@realtek.com>
Subject: [PATCH 0/5] rtw88: improve TX performance in field
Date:   Wed, 13 Jan 2021 17:23:07 +0800
Message-ID: <20210113092312.13809-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.213]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Improve TX performance in aspects of protocol and software design. Also,
update PHY parameters to fix incorrect RSSI report.

Po-Hao Huang (5):
  rtw88: add dynamic rrsr configuration
  rtw88: add rts condition
  rtw88: add napi support
  rtw88: replace tx tasklet with tx work
  rtw88: 8822c: update phy parameter tables to v60

 drivers/net/wireless/realtek/rtw88/mac80211.c |     2 +-
 drivers/net/wireless/realtek/rtw88/main.c     |    10 +-
 drivers/net/wireless/realtek/rtw88/main.h     |     8 +-
 drivers/net/wireless/realtek/rtw88/pci.c      |   108 +-
 drivers/net/wireless/realtek/rtw88/pci.h      |     5 +
 drivers/net/wireless/realtek/rtw88/phy.c      |    62 +-
 drivers/net/wireless/realtek/rtw88/phy.h      |     3 +
 drivers/net/wireless/realtek/rtw88/reg.h      |     2 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |     2 -
 .../wireless/realtek/rtw88/rtw8822c_table.c   | 32755 ++++++++++++----
 drivers/net/wireless/realtek/rtw88/tx.c       |    11 +-
 drivers/net/wireless/realtek/rtw88/tx.h       |     6 +-
 drivers/net/wireless/realtek/rtw88/util.c     |    20 +
 drivers/net/wireless/realtek/rtw88/util.h     |    54 +
 14 files changed, 24667 insertions(+), 8381 deletions(-)

-- 
2.21.0

