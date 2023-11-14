Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD1CC4167B
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Nov 2023 09:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjKNJPI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Nov 2023 04:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjKNJPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2023 04:15:04 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57532DD
        for <linux-wireless@vger.kernel.org>; Tue, 14 Nov 2023 01:15:00 -0800 (PST)
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 3AE9EoQkA814933, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.95/5.92) with ESMTPS id 3AE9EoQkA814933
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 17:14:50 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 14 Nov 2023 17:14:51 +0800
Received: from [127.0.1.1] (172.21.69.94) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Tue, 14 Nov
 2023 17:14:50 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     <kvalo@kernel.org>
CC:     <kevin_yang@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] wifi: rtw89: read country list supporting 6 GHz from BIOS
Date:   Tue, 14 Nov 2023 17:13:56 +0800
Message-ID: <20231114091359.50664-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.94]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A platform might get 6 GHz certifications on certain countries, because
many countries still don't allow 6 GHz channels yet. To prevent having
misbehavior on 6 GHz channels, read white or black country list from BIOS
and configure channels accordingly.

Also, update regulatory map to the latest to support more countries for
6 GHz channels.

Zong-Zhe Yang (3):
  wifi: rtw89: acpi: process 6 GHz band policy from DSM
  wifi: rtw89: regd: handle policy of 6 GHz according to BIOS
  wifi: rtw89: regd: update regulatory map to R65-R44

 drivers/net/wireless/realtek/rtw89/acpi.c  |  81 ++++++++--
 drivers/net/wireless/realtek/rtw89/acpi.h  |  32 +++-
 drivers/net/wireless/realtek/rtw89/core.h  |   3 +
 drivers/net/wireless/realtek/rtw89/debug.h |   1 +
 drivers/net/wireless/realtek/rtw89/regd.c  | 175 ++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/sar.c   |   4 +-
 6 files changed, 272 insertions(+), 24 deletions(-)

-- 
2.25.1

