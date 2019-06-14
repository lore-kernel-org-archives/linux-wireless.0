Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244A1C31E44
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 07:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F142D2073F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 07:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfFNHYZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 03:24:25 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48160 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfFNHYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 03:24:24 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x5E7OJKo024900, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x5E7OJKo024900
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 14 Jun 2019 15:24:19 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.439.0; Fri, 14 Jun 2019 15:24:18 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/11] rtw88: regular driver upgrade with minor changes
Date:   Fri, 14 Jun 2019 15:24:04 +0800
Message-ID: <1560497055-17197-1-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

These patch set are mostly minor fixes.

Some of them are adjustments for 8822c's phy setting.

DACK reload is to speed up hardware power on.

Beacon function setting make sure the hardware to sync the TSF
for the beacon intervals (station mode). For other modes, disable
TSF sync to avoid beacon interval getting violated.

And two of them make rtw88 has two new features "fast_xmit" and
"random mac scan"


v1 -> v2

 - reduce magic numbers
 - DACK reload still has many magic numbers, the calibration
   routines is consisted with hardware registers, and those
   registers do not have specific name or function


Chien-Hsun Liao (2):
  rtw88: 8822c: add rf write protection when switching channel
  rtw88: 8822c: update channel and bandwidth BB setting

Chin-Yen Lee (1):
  rtw88: add beacon function setting

Tzu-En Huang (1):
  rtw88: fix typo rtw_writ16_set

Yan-Hsuan Chuang (7):
  rtw88: add fast xmit support
  rtw88: add support for random mac scan
  rtw88: 8822c: disable rx clock gating before counter reset
  rtw88: 8822c: use more accurate ofdm fa counting
  rtw88: power on again if it was already on
  rtw88: restore DACK results to save time
  rtw88: rsvd page should go though management queue

 drivers/net/wireless/realtek/rtw88/hci.h      |   2 +-
 drivers/net/wireless/realtek/rtw88/mac.c      |   8 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c |  32 ++
 drivers/net/wireless/realtek/rtw88/main.c     |   8 +
 drivers/net/wireless/realtek/rtw88/main.h     |  11 +
 drivers/net/wireless/realtek/rtw88/phy.c      |  13 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 436 ++++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |  23 ++
 drivers/net/wireless/realtek/rtw88/tx.c       |   2 +-
 9 files changed, 504 insertions(+), 31 deletions(-)

-- 
2.7.4

