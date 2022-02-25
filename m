Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7F1C433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Feb 2022 03:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbiBYDKF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Feb 2022 22:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBYDKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Feb 2022 22:10:04 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9311E2C032D
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2022 19:09:32 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 21P39On24000860, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 21P39On24000860
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Feb 2022 11:09:24 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Feb 2022 11:09:24 +0800
Received: from localhost (172.21.69.188) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 25 Feb
 2022 11:09:23 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     <kvalo@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <timlee@realtek.com>,
        <phhuang@realtek.com>
Subject: [PATCH 0/2] rtw89: support hw_scan and tx_wake firmware features 
Date:   Fri, 25 Feb 2022 11:08:49 +0800
Message-ID: <20220225030851.13327-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.188]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/25/2022 02:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzIvMjUgpFekyCAwMToyMTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The 8852A firmware 0.13.35.0 can support two new firmware features --
hw_scan and tx_wake. The hw_scan is as rtw88. The tx_wake is to tell
firmware to wake to transmit packets if hardware stays in deep power saving
mode. Without tx_wake, packets can possibly get stuck in this mode.

Since previous patch "rtw89: get channel parameters of 160MHz bandwidth"
changes something overlap with this patchset, the one should be merged
ahead. Though there is no functional dependency.

Chin-Yen Lee (1):
  rtw89: add tx_wake notify for low ps mode

Po Hao Huang (1):
  rtw89: 8852a: add ieee80211_ops::hw_scan

 drivers/net/wireless/realtek/rtw89/core.c     |  93 ++++
 drivers/net/wireless/realtek/rtw89/core.h     |  24 +
 drivers/net/wireless/realtek/rtw89/debug.h    |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c       | 519 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h       | 351 ++++++++++++
 drivers/net/wireless/realtek/rtw89/mac.c      |  86 ++-
 drivers/net/wireless/realtek/rtw89/mac.h      |   2 +
 drivers/net/wireless/realtek/rtw89/mac80211.c |  67 ++-
 drivers/net/wireless/realtek/rtw89/reg.h      |   1 +
 9 files changed, 1122 insertions(+), 22 deletions(-)

-- 
2.25.1

